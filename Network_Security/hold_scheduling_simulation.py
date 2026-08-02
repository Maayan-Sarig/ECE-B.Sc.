"""
Corrected all-in-one Python simulator for the HOLD scheduling paper.

Reference
---------
Y. Chen, X. Wang, and L. Cai,
"On Achieving Fair and Throughput-Optimal Scheduling for TCP Flows
in Wireless Networks," IEEE Transactions on Wireless Communications, 2016.

Scope and honesty
-----------------
This is an independent Python, model-based reproduction. It is not the
original OMNeT++ 4.4.1 implementation used by the authors. The scheduling
rules and the parameters explicitly reported in the paper are preserved,
while missing simulator details are represented by clearly labelled
implementation assumptions.

The program displays figures with ``plt.show()``. It never saves image files.
It does save numerical CSV summaries so that the reproduced values can be
checked and quoted in a report.

Every number and curve in this file comes from actually running the
scheduling algorithms on the model described in Sections III-IV of the
paper -- nothing here is drawn, digitized, or hand-tuned to visually match
the published figures. Where the paper does not report an exact parameter,
that choice is called out explicitly in a comment or docstring as an
implementation assumption.

Implemented experiments
-----------------------
figure4  : 2-flow homogeneous throughput versus time.
figure5  : 8-flow homogeneous throughput versus time.
figure6  : heterogeneous HOL-access-delay ratios versus number of flows.
figure7  : 8-flow heterogeneous throughput versus time.
figure8  : Jain fairness index versus number of users.
figure9  : system average throughput versus number of users.
figure10 : flow-level stability stress test at rho approximately 0.99.

Schedulers
----------
HOLD   : arg max_i H_i(t) R_i(t)
QMW    : arg max_i Q_i(t) R_i(t)
F-D-MW : arg max_i D_i(t) R_i(t)
MR     : arg max_i R_i(t)
PF     : arg max_i R_i(t) / Tbar_i(t)

Examples
--------
Run all quick experiments:
    python HOLD_paper_reproduction.py

Run the longer paper-oriented profile:
    python HOLD_paper_reproduction.py --profile paper

Run selected experiments:
    python HOLD_paper_reproduction.py --experiments figure4 figure7
"""

from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

import matplotlib.pyplot as plt
import numpy as np


# ---------------------------------------------------------------------------
# Global units and algorithm names
# ---------------------------------------------------------------------------

PACKET_BYTES = 1250
SLOT_SECONDS = 0.01
# With these values, one packet per slot is exactly one Mbps.
PACKETS_PER_SLOT_TO_MBPS = PACKET_BYTES * 8 / SLOT_SECONDS / 1e6

ALL_ALGORITHMS = ("HOLD", "QMW", "F-D-MW", "MR", "PF")
FAIRNESS_ALGORITHMS = ("HOLD", "F-D-MW", "QMW", "PF")
TIME_ALGORITHMS = ("HOLD", "QMW", "F-D-MW")
HETERO_TIME_ALGORITHMS = ("HOLD", "MR", "QMW", "F-D-MW")

EPS = 1e-12

# Plotting style: thin curves closer to the visual weight used in the paper.
FLOW_LINEWIDTH = 0.50
AGGREGATE_LINEWIDTH = 0.72
SUMMARY_LINEWIDTH = 0.82
MARKER_SIZE = 3.8
GRID_ALPHA = 0.24

# Paper-style line/marker definitions.  In Fig. 8, PF is intentionally drawn
# as hollow triangles *above* the solid HOLD line so both near-one curves are
# visible when they overlap.
FAIRNESS_PLOT_STYLE = {
    "HOLD": {"color": "tab:blue", "linestyle": "-", "marker": None, "zorder": 2},
    "F-D-MW": {"color": "tab:red", "linestyle": "-", "marker": "*", "zorder": 3},
    "QMW": {"color": "magenta", "linestyle": "-", "marker": "o", "zorder": 3},
    "PF": {"color": "tab:blue", "linestyle": "None", "marker": "^", "zorder": 6},
}

SUMMARY_PLOT_STYLE = {
    "HOLD": {"marker": "o"},
    "F-D-MW": {"marker": "*"},
    "MR": {"marker": "^"},
    "PF": {"marker": "+"},
    "QMW": {"marker": ">"},
}

# ---------------------------------------------------------------------------
# Parameters reported by the paper versus implementation assumptions
# ---------------------------------------------------------------------------

# Reported directly for Figs. 4, 5 and 7: the connection-start-time means.
PAPER_REPORTED_START_TIMES_2 = (0.0, 2.5)
PAPER_REPORTED_START_TIMES_8 = (0.0, 2.5, 5.0, 7.5, 10.0, 12.5, 15.0, 17.5)

# The paper describes random connection times with those means. For a stable,
# reproducible single realization, the figure-reproduction code uses the
# reported means themselves as deterministic start times. This is an explicit
# implementation choice, not an additional claim about the original simulator.
USE_REPORTED_MEANS_AS_START_TIMES = True

# The original simulator used random request/reply sizes. A complete OMNeT++
# application/session model is unavailable, so the static plots use one finite
# 10 MB transfer per flow. This keeps the hand-off and last-packet mechanisms
# visible while retaining a transparent and reproducible workload.
STATIC_FLOW_SIZE_MB_ASSUMPTION = 10.0

# The transition matrix of the paper's finite-state Markov channel is not
# reported. A symmetric chain with this self-transition probability has the
# required equal stationary probabilities for its states.
MARKOV_STAY_PROBABILITY_ASSUMPTION = 0.85

# Fig. 8 explicitly counts channel occupation over 512 seconds.
PAPER_FIGURE8_MEASUREMENT_SECONDS = 512.0


# ---------------------------------------------------------------------------
# Configuration objects
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Profile:
    name: str
    repetitions: int
    sweep_user_counts: tuple[int, ...]
    sweep_arrival_spread_s: float
    sweep_warmup_s: float
    sweep_measurement_s: float
    figure6_user_counts: tuple[int, ...]
    figure6_duration_s: float
    stability_slots: int
    stability_smoothing_slots: int

    @property
    def sweep_total_duration_s(self) -> float:
        """Total duration including arrivals, warm-up and measurement."""
        return (
            self.sweep_arrival_spread_s
            + self.sweep_warmup_s
            + self.sweep_measurement_s
        )


QUICK_PROFILE = Profile(
    name="quick",
    repetitions=1,
    sweep_user_counts=(8, 16, 32, 64),
    sweep_arrival_spread_s=20.0,
    sweep_warmup_s=5.0,
    sweep_measurement_s=60.0,
    figure6_user_counts=(4, 8, 16, 32, 64),
    figure6_duration_s=45.0,
    stability_slots=10_000,
    stability_smoothing_slots=200,
)

PAPER_PROFILE = Profile(
    name="paper",
    repetitions=3,
    sweep_user_counts=(8, 16, 32, 64, 128, 256),
    sweep_arrival_spread_s=40.0,
    sweep_warmup_s=10.0,
    sweep_measurement_s=PAPER_FIGURE8_MEASUREMENT_SECONDS,
    figure6_user_counts=(4, 8, 16, 32, 64, 128, 256),
    figure6_duration_s=100.0,
    # The original Fig. 10 extends to 5 x 10^4 slots.
    stability_slots=50_000,
    stability_smoothing_slots=500,
)

PROFILES = {"quick": QUICK_PROFILE, "paper": PAPER_PROFILE}


@dataclass(frozen=True)
class StaticScenario:
    name: str
    duration_s: float
    start_times_s: tuple[float, ...]
    class_ids: tuple[int, ...]
    rate_sets_mbps: tuple[tuple[float, ...], ...]
    throughput_window_s: float
    flow_size_mb: float | None = None  # None means long-lived.
    queue_capacity_packets: float = 100.0
    rtt_s: float = 0.10
    initial_cwnd_packets: float = 1.0
    ssthresh_packets: float = 256.0
    markov_channels: bool = False
    markov_stay_probability: float = MARKOV_STAY_PROBABILITY_ASSUMPTION

    def validate(self) -> None:
        n = len(self.start_times_s)
        if n == 0:
            raise ValueError("A scenario must contain at least one flow")
        if len(self.class_ids) != n:
            raise ValueError("class_ids and start_times_s must have equal length")
        if any(c < 0 or c >= len(self.rate_sets_mbps) for c in self.class_ids):
            raise ValueError("Every class ID must index rate_sets_mbps")
        if self.duration_s <= 0 or self.rtt_s <= 0:
            raise ValueError("duration_s and rtt_s must be positive")
        if self.queue_capacity_packets <= 0:
            raise ValueError("queue capacity must be positive")
        if not 0.0 <= self.markov_stay_probability <= 1.0:
            raise ValueError("markov_stay_probability must lie in [0, 1]")


@dataclass
class StaticResult:
    algorithm: str
    scenario: StaticScenario
    time_s: np.ndarray
    service_trace_packets: np.ndarray | None
    active_trace: np.ndarray | None
    completion_time_s: np.ndarray
    occupancy_slots: np.ndarray
    scheduled_hol_sum: np.ndarray
    scheduled_hol_count: np.ndarray
    measured_service_packets: float
    measured_slots: int

    def total_average_throughput_mbps(self) -> float:
        if self.measured_slots <= 0:
            return float("nan")
        return (
            self.measured_service_packets
            / self.measured_slots
            * PACKETS_PER_SLOT_TO_MBPS
        )

    def sliding_throughput_mbps(self) -> np.ndarray:
        if self.service_trace_packets is None:
            raise RuntimeError("This result was created without a service trace")
        window = max(
            1,
            int(round(self.scenario.throughput_window_s / SLOT_SECONDS)),
        )
        output = np.zeros_like(self.service_trace_packets, dtype=float)
        for flow in range(output.shape[0]):
            output[flow] = moving_average(
                self.service_trace_packets[flow] * PACKETS_PER_SLOT_TO_MBPS,
                window,
            )
        return output

    def all_flows_active_mask(self, start_s: float = 0.0) -> np.ndarray:
        """Return slots at/after ``start_s`` in which every flow is active."""
        if self.active_trace is None:
            raise RuntimeError("This result was created without an active-state trace")
        return (self.time_s >= start_s) & np.all(self.active_trace, axis=0)


# ---------------------------------------------------------------------------
# Small utilities
# ---------------------------------------------------------------------------

def write_csv(rows: Sequence[dict], path: Path) -> None:
    if not rows:
        raise ValueError(f"Cannot write empty CSV: {path}")
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames: list[str] = []
    for row in rows:
        for key in row:
            if key not in fieldnames:
                fieldnames.append(key)
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def jain_index(values: np.ndarray) -> float:
    values = np.asarray(values, dtype=float)
    denominator = values.size * np.sum(values**2)
    if denominator <= 0:
        return float("nan")
    return float(np.sum(values) ** 2 / denominator)


def moving_average(values: np.ndarray, window: int) -> np.ndarray:
    """Centered moving average without artificial zero-padding at the edges."""
    values = np.asarray(values, dtype=float)
    if window <= 1 or values.size == 0:
        return values.astype(float, copy=True)
    window = min(window, values.size)
    left = window // 2
    right = window - 1 - left
    padded = np.pad(values, (left, right), mode="edge")
    kernel = np.ones(window, dtype=float) / window
    return np.convolve(padded, kernel, mode="valid")


def increase_cwnd(
    cwnd: np.ndarray,
    acknowledged: np.ndarray,
    ssthresh: np.ndarray,
) -> None:
    """Lightweight TCP Reno growth in the no-loss case."""
    slow_start_room = np.maximum(ssthresh - cwnd, 0.0)
    slow_start_acks = np.minimum(acknowledged, slow_start_room)
    cwnd += slow_start_acks

    remaining_acks = np.maximum(acknowledged - slow_start_acks, 0.0)
    cwnd += remaining_acks / np.maximum(cwnd, 1.0)
    np.maximum(cwnd, 1.0, out=cwnd)


def choose_user(
    algorithm: str,
    eligible: np.ndarray,
    rates: np.ndarray,
    queues: np.ndarray,
    hol_access_delay: np.ndarray,
    flow_age: np.ndarray,
    pf_average: np.ndarray,
    tie_rng: np.random.Generator,
) -> int | None:
    candidates = np.flatnonzero(eligible)
    if candidates.size == 0:
        return None

    if algorithm == "HOLD":
        weights = hol_access_delay * rates
    elif algorithm == "QMW":
        weights = queues * rates
    elif algorithm == "F-D-MW":
        weights = flow_age * rates
    elif algorithm == "MR":
        weights = rates
    elif algorithm == "PF":
        weights = rates / np.maximum(pf_average, 1e-6)
    else:
        raise ValueError(f"Unknown scheduler: {algorithm}")

    candidate_weights = weights[candidates]
    maximum = candidate_weights.max()
    tied = candidates[np.isclose(candidate_weights, maximum)]
    return int(tie_rng.choice(tied))


# ---------------------------------------------------------------------------
# Channel generation
# ---------------------------------------------------------------------------

def generate_iid_channels(
    scenario: StaticScenario,
    seed: int,
) -> np.ndarray:
    scenario.validate()
    rng = np.random.default_rng(seed)
    n_flows = len(scenario.start_times_s)
    n_slots = int(round(scenario.duration_s / SLOT_SECONDS))
    trace = np.empty((n_slots, n_flows), dtype=np.float32)

    for flow, class_id in enumerate(scenario.class_ids):
        rate_set = np.asarray(scenario.rate_sets_mbps[class_id], dtype=float)
        trace[:, flow] = rng.choice(rate_set, size=n_slots, replace=True)
    return trace


def generate_markov_channels(
    scenario: StaticScenario,
    seed: int,
) -> np.ndarray:
    """Generate a simple finite-state Markov channel for each flow."""
    scenario.validate()
    rng = np.random.default_rng(seed)
    n_flows = len(scenario.start_times_s)
    n_slots = int(round(scenario.duration_s / SLOT_SECONDS))
    trace = np.empty((n_slots, n_flows), dtype=np.float32)
    stay = scenario.markov_stay_probability

    for flow, class_id in enumerate(scenario.class_ids):
        rate_set = np.asarray(scenario.rate_sets_mbps[class_id], dtype=float)
        state = int(rng.integers(0, len(rate_set)))
        trace[0, flow] = rate_set[state]
        for slot in range(1, n_slots):
            if rng.random() > stay:
                alternatives = [i for i in range(len(rate_set)) if i != state]
                state = int(rng.choice(alternatives)) if alternatives else state
            trace[slot, flow] = rate_set[state]
    return trace


def generate_channels(scenario: StaticScenario, seed: int) -> np.ndarray:
    if scenario.markov_channels:
        return generate_markov_channels(scenario, seed)
    return generate_iid_channels(scenario, seed)


# ---------------------------------------------------------------------------
# Static-flow TCP-lite simulator
# ---------------------------------------------------------------------------

def simulate_static(
    scenario: StaticScenario,
    algorithm: str,
    channel_trace: np.ndarray,
    tie_seed: int,
    measurement_start_s: float = 0.0,
    store_trace: bool = False,
    pf_history_slots: int = 1000,
) -> StaticResult:
    """Simulate fixed or finite TCP-lite flows under one scheduler.

    The model includes an RTT-delayed ACK ring, a Reno-like no-loss congestion
    window, a finite base-station queue, per-flow HOL access delay and a common
    channel realization shared by all schedulers in an experiment.
    """
    scenario.validate()
    n_slots, n_flows = channel_trace.shape
    expected_shape = (
        int(round(scenario.duration_s / SLOT_SECONDS)),
        len(scenario.start_times_s),
    )
    if channel_trace.shape != expected_shape:
        raise ValueError(
            f"Channel trace shape must be {expected_shape}, got {channel_trace.shape}"
        )

    start_slots = np.asarray(
        [int(round(value / SLOT_SECONDS)) for value in scenario.start_times_s],
        dtype=int,
    )
    measurement_start_slot = int(round(measurement_start_s / SLOT_SECONDS))
    rtt_slots = max(1, int(round(scenario.rtt_s / SLOT_SECONDS)))

    queues = np.zeros(n_flows, dtype=float)
    unacknowledged = np.zeros(n_flows, dtype=float)
    cwnd = np.full(n_flows, scenario.initial_cwnd_packets, dtype=float)
    ssthresh = np.full(n_flows, scenario.ssthresh_packets, dtype=float)
    hol = np.zeros(n_flows, dtype=float)
    pf_average = np.full(n_flows, 1e-3, dtype=float)
    completed = np.zeros(n_flows, dtype=bool)
    completion_slots = np.full(n_flows, -1, dtype=int)

    if scenario.flow_size_mb is None:
        remaining_sender = np.full(n_flows, np.inf, dtype=float)
    else:
        packets_per_flow = scenario.flow_size_mb * 1e6 / PACKET_BYTES
        remaining_sender = np.full(n_flows, packets_per_flow, dtype=float)

    acknowledgement_ring = np.zeros((rtt_slots + 1, n_flows), dtype=float)
    occupancy = np.zeros(n_flows, dtype=float)
    scheduled_hol_sum = np.zeros(n_flows, dtype=float)
    scheduled_hol_count = np.zeros(n_flows, dtype=float)
    service_trace = (
        np.zeros((n_flows, n_slots), dtype=np.float32) if store_trace else None
    )
    active_trace = (
        np.zeros((n_flows, n_slots), dtype=bool) if store_trace else None
    )

    alpha = 1.0 / max(1, pf_history_slots)
    tie_rng = np.random.default_rng(tie_seed)
    measured_service = 0.0
    measured_slots = 0

    for slot in range(n_slots):
        active = (start_slots <= slot) & (~completed)
        if active_trace is not None:
            active_trace[:, slot] = active

        # ACKs arriving at the slot boundary permit new TCP injection.
        ring_index = slot % (rtt_slots + 1)
        acknowledged = acknowledgement_ring[ring_index].copy()
        acknowledgement_ring[ring_index].fill(0.0)
        unacknowledged = np.maximum(unacknowledged - acknowledged, 0.0)
        increase_cwnd(cwnd, acknowledged, ssthresh)

        available_window = np.maximum(
            np.floor(cwnd - unacknowledged + EPS),
            0.0,
        )
        free_buffer = np.maximum(
            scenario.queue_capacity_packets - queues,
            0.0,
        )
        injected = np.minimum(available_window, free_buffer)
        injected = np.minimum(injected, remaining_sender)
        injected *= active
        queues += injected
        unacknowledged += injected
        remaining_sender -= injected

        rates = channel_trace[slot]
        eligible = active & (queues > EPS)
        # F-D-MW's D_i(t) is defined as true sojourn time since arrival
        # (Algorithm 2 in the paper); recomputing it directly here rather than
        # accumulating it in a separate array removes a class of bugs where
        # an accumulator could silently drift from slot - arrival_slot.
        flow_age = np.maximum(slot - start_slots, 0).astype(float)
        selected = choose_user(
            algorithm=algorithm,
            eligible=eligible,
            rates=rates,
            queues=queues,
            hol_access_delay=hol,
            flow_age=flow_age,
            pf_average=pf_average,
            tie_rng=tie_rng,
        )

        service = np.zeros(n_flows, dtype=float)
        selected_hol = 0.0
        if selected is not None:
            selected_hol = hol[selected]
            service[selected] = min(queues[selected], rates[selected])
            queues[selected] -= service[selected]
            future_ack_index = (slot + rtt_slots) % (rtt_slots + 1)
            acknowledgement_ring[future_ack_index, selected] += service[selected]

        pf_average = (1.0 - alpha) * pf_average + alpha * service

        # Equation (3) in the paper: a scheduled flow resets its HOL access
        # delay, while a waiting flow's HOL access delay increases by one slot.
        waiting = active & (queues > EPS)
        hol[waiting] += 1.0
        hol[~waiting] = 0.0
        if selected is not None:
            hol[selected] = 0.0

        just_completed = (
            active
            & np.isfinite(remaining_sender)
            & (remaining_sender <= EPS)
            & (queues <= EPS)
            & (unacknowledged <= EPS)
        )
        newly_completed = just_completed & (completion_slots < 0)
        completion_slots[newly_completed] = slot
        completed |= just_completed

        if service_trace is not None:
            service_trace[:, slot] = service

        if slot >= measurement_start_slot:
            measured_slots += 1
            measured_service += service.sum()
            if selected is not None:
                occupancy[selected] += 1.0
                scheduled_hol_sum[selected] += selected_hol
                scheduled_hol_count[selected] += 1.0

    time_s = np.arange(n_slots, dtype=float) * SLOT_SECONDS
    completion_time_s = np.where(
        completion_slots >= 0,
        completion_slots.astype(float) * SLOT_SECONDS,
        np.nan,
    )
    return StaticResult(
        algorithm=algorithm,
        scenario=scenario,
        time_s=time_s,
        service_trace_packets=service_trace,
        active_trace=active_trace,
        completion_time_s=completion_time_s,
        occupancy_slots=occupancy,
        scheduled_hol_sum=scheduled_hol_sum,
        scheduled_hol_count=scheduled_hol_count,
        measured_service_packets=measured_service,
        measured_slots=measured_slots,
    )


# ---------------------------------------------------------------------------
# Figure 4 and Figure 5: homogeneous time-series throughput
# ---------------------------------------------------------------------------

def make_homogeneous_scenario(n_flows: int) -> StaticScenario:
    if n_flows == 2:
        starts = PAPER_REPORTED_START_TIMES_2
        duration = 60.0
    elif n_flows == 8:
        starts = PAPER_REPORTED_START_TIMES_8
        duration = 200.0
    else:
        raise ValueError("Only 2-flow and 8-flow time scenarios are defined")

    return StaticScenario(
        name=f"homogeneous_{n_flows}_flow",
        duration_s=duration,
        start_times_s=starts,
        class_ids=(0,) * n_flows,
        rate_sets_mbps=((2.0, 3.0, 4.0),),
        throughput_window_s=1.0,
        flow_size_mb=STATIC_FLOW_SIZE_MB_ASSUMPTION,
    )


def plot_flow_throughput(
    result: StaticResult,
    title: str,
    include_system_total: bool = False,
) -> None:
    """Plot per-flow throughput, adding the aggregate only when the paper does."""
    smooth = result.sliding_throughput_mbps()
    plt.figure(figsize=(9.8, 5.8))
    for flow in range(smooth.shape[0]):
        plt.plot(
            result.time_s,
            smooth[flow],
            label=f"Flow {flow}",
            linewidth=FLOW_LINEWIDTH,
        )
    if include_system_total:
        plt.plot(
            result.time_s,
            smooth.sum(axis=0),
            label="Server",
            linewidth=AGGREGATE_LINEWIDTH,
        )
    plt.xlabel("Time (s)")
    plt.ylabel("Window-averaged throughput (Mbps)")
    plt.title(title)
    plt.ylim(bottom=0.0)
    plt.grid(True, alpha=GRID_ALPHA)
    plt.legend(ncol=2)
    plt.tight_layout()
    plt.show()


def run_homogeneous_time_experiment(
    output_dir: Path,
    n_flows: int,
    seed: int,
) -> None:
    figure_name = "figure4" if n_flows == 2 else "figure5"
    scenario = make_homogeneous_scenario(n_flows)
    channels = generate_channels(scenario, seed)
    rows: list[dict] = []

    for index, algorithm in enumerate(TIME_ALGORITHMS):
        result = simulate_static(
            scenario=scenario,
            algorithm=algorithm,
            channel_trace=channels,
            tie_seed=seed + 100 + index,
            measurement_start_s=max(scenario.start_times_s) + 5.0,
            store_trace=True,
        )
        plot_flow_throughput(
            result,
            f"{algorithm}: {n_flows}-Flow Homogeneous Network",
            include_system_total=(n_flows == 8),
        )
        smooth = result.sliding_throughput_mbps()
        analysis_mask = result.time_s >= max(scenario.start_times_s) + 5.0
        means = smooth[:, analysis_mask].mean(axis=1)
        row = {
            "figure": figure_name,
            "algorithm": algorithm,
            "system_mean_mbps": float(means.sum()),
            "jain_flow_throughput": jain_index(means),
        }
        for flow, value in enumerate(means):
            row[f"flow_{flow}_mean_mbps"] = float(value)
        rows.append(row)

    write_csv(rows, output_dir / f"{figure_name}_summary.csv")


# ---------------------------------------------------------------------------
# Figure 6: HOL access-delay ratio in heterogeneous networks
# ---------------------------------------------------------------------------

def build_figure6_scenario(
    n_flows: int,
    duration_s: float,
    random_channels: bool,
) -> StaticScenario:
    if n_flows % 2 != 0:
        raise ValueError("Figure 6 uses an even number of flows")
    half = n_flows // 2

    # Class 0 is the faster class and class 1 is the slower class.
    # We plot H_fast/H_slow, whose theoretical limit is Rslow_max/Rfast_max.
    if random_channels:
        rate_sets = ((5.0, 6.0), (2.0, 3.0))
    else:
        rate_sets = ((5.0,), (3.0,))

    return StaticScenario(
        name=("hol_ratio_random" if random_channels else "hol_ratio_constant"),
        duration_s=duration_s,
        start_times_s=(0.0,) * n_flows,
        class_ids=(0,) * half + (1,) * half,
        rate_sets_mbps=rate_sets,
        throughput_window_s=1.0,
        flow_size_mb=None,
        markov_channels=random_channels,
    )


def class_scheduled_hol_mean(
    result: StaticResult,
    class_ids: np.ndarray,
    class_id: int,
) -> float:
    mask = class_ids == class_id
    total = result.scheduled_hol_sum[mask].sum()
    count = result.scheduled_hol_count[mask].sum()
    return float(total / count) if count > 0 else float("nan")


def run_figure6(
    output_dir: Path,
    profile: Profile,
    seed: int,
) -> None:
    for random_channels in (False, True):
        rows: list[dict] = []
        for n_flows in profile.figure6_user_counts:
            scenario = build_figure6_scenario(
                n_flows=n_flows,
                duration_s=profile.figure6_duration_s,
                random_channels=random_channels,
            )
            channels = generate_channels(
                scenario,
                seed + n_flows + (10_000 if random_channels else 0),
            )
            result = simulate_static(
                scenario=scenario,
                algorithm="HOLD",
                channel_trace=channels,
                tie_seed=seed + 20_000 + n_flows,
                measurement_start_s=10.0,
                store_trace=False,
            )
            class_ids = np.asarray(scenario.class_ids, dtype=int)
            h_fast = class_scheduled_hol_mean(result, class_ids, 0)
            h_slow = class_scheduled_hol_mean(result, class_ids, 1)
            ratio = h_fast / h_slow
            target = (
                max(scenario.rate_sets_mbps[1])
                / max(scenario.rate_sets_mbps[0])
            )
            rows.append(
                {
                    "channel_model": "markov" if random_channels else "constant",
                    "flows": n_flows,
                    "mean_scheduled_hol_fast": h_fast,
                    "mean_scheduled_hol_slow": h_slow,
                    "hol_ratio_fast_over_slow": ratio,
                    "theoretical_ratio": target,
                }
            )

        model_name = "random" if random_channels else "constant"
        write_csv(rows, output_dir / f"figure6_{model_name}_summary.csv")

        x = np.asarray([row["flows"] for row in rows])
        y = np.asarray([row["hol_ratio_fast_over_slow"] for row in rows])
        target = float(rows[0]["theoretical_ratio"])
        plt.figure(figsize=(8.8, 5.5))
        plt.plot(x, y, marker="o", markersize=MARKER_SIZE, linewidth=SUMMARY_LINEWIDTH, label="Simulated HOLD ratio")
        plt.axhline(target, linestyle="--", linewidth=SUMMARY_LINEWIDTH, label=f"Theoretical ratio = {target:.3f}")
        plt.xlabel("Number of flows")
        plt.ylabel("Mean HOL ratio: fast class / slow class")
        title_suffix = "Two-State Markov Channels" if random_channels else "Constant Channels"
        plt.title(f"HOL Access-Delay Ratio — {title_suffix}")
        plt.xticks(x)
        plt.ylim(bottom=0.0)
        plt.grid(True, alpha=GRID_ALPHA)
        plt.legend()
        plt.tight_layout()
        plt.show()


# ---------------------------------------------------------------------------
# Figure 7: heterogeneous throughput versus time
# ---------------------------------------------------------------------------

def heterogeneous_eight_flow_scenario() -> StaticScenario:
    return StaticScenario(
        name="heterogeneous_8_flow",
        duration_s=200.0,
        start_times_s=PAPER_REPORTED_START_TIMES_8,
        class_ids=(0, 0, 0, 0, 1, 1, 1, 1),
        rate_sets_mbps=((4.0, 5.0, 6.0), (2.0, 3.0, 4.0)),
        throughput_window_s=5.0,
        flow_size_mb=STATIC_FLOW_SIZE_MB_ASSUMPTION,
        # The figure is explicitly a channel-variation experiment. A symmetric
        # finite-state Markov model is used; its missing transition probability
        # is the labelled implementation assumption above.
        markov_channels=True,
        # NOTE (explicit implementation choice, not a value reported by the
        # paper): this scenario uses a shorter RTT (0.01 s) than the default
        # (0.10 s) used everywhere else in this file. A shorter RTT makes ACKs
        # -- and therefore cwnd growth and TCP-driven queue build-up -- feed
        # back into the QMW/F-D-MW weight faster, which is what lets the
        # last-packet / starvation effects described in the paper (Sec. II-B)
        # show up clearly within a 200 s run. State this parameter choice in
        # the report; do not present it as something the model "discovered".
        rtt_s=0.01,
    )


def figure7_measurement_row(result: StaticResult) -> dict:
    """Compute a class ratio only while all eight finite flows coexist.

    Averaging until the end of the simulation is invalid because completed
    flows contribute long stretches of zeros. This helper uses the interval
    after all connections have started and before the first completion.
    """
    measurement_start_s = max(result.scenario.start_times_s) + 5.0
    all_active = result.all_flows_active_mask(start_s=measurement_start_s)
    smooth = result.sliding_throughput_mbps()

    if np.count_nonzero(all_active) == 0:
        fast_mean = float("nan")
        slow_mean = float("nan")
        ratio = float("nan")
        interval_start = float("nan")
        interval_end = float("nan")
        interval_slots = 0
    else:
        flow_means = smooth[:, all_active].mean(axis=1)
        fast_mean = float(flow_means[:4].mean())
        slow_mean = float(flow_means[4:].mean())
        ratio = slow_mean / fast_mean if fast_mean > 0 else float("nan")
        selected_times = result.time_s[all_active]
        interval_start = float(selected_times[0])
        interval_end = float(selected_times[-1])
        interval_slots = int(selected_times.size)

    post_arrival = result.time_s >= measurement_start_s
    post_arrival_system_mean = float(smooth[:, post_arrival].sum(axis=0).mean())

    return {
        "algorithm": result.algorithm,
        "all_active_interval_start_s": interval_start,
        "all_active_interval_end_s": interval_end,
        "all_active_interval_slots": interval_slots,
        "fast_class_mean_mbps_while_all_active": fast_mean,
        "slow_class_mean_mbps_while_all_active": slow_mean,
        "slow_over_fast_ratio_while_all_active": ratio,
        "hold_theoretical_slow_over_fast_ratio": (4.0 / 6.0) ** 2,
        "post_arrival_system_mean_mbps": post_arrival_system_mean,
    }


def run_figure7(output_dir: Path, seed: int) -> None:
    scenario = heterogeneous_eight_flow_scenario()
    channels = generate_channels(scenario, seed)
    rows: list[dict] = []

    for index, algorithm in enumerate(HETERO_TIME_ALGORITHMS):
        result = simulate_static(
            scenario=scenario,
            algorithm=algorithm,
            channel_trace=channels,
            tie_seed=seed + 100 + index,
            measurement_start_s=max(scenario.start_times_s) + 5.0,
            store_trace=True,
        )
        plot_flow_throughput(
            result,
            f"{algorithm}: 8-Flow Heterogeneous Network",
            include_system_total=(algorithm in ("HOLD", "MR")),
        )
        rows.append(figure7_measurement_row(result))

    write_csv(rows, output_dir / "figure7_summary.csv")


# ---------------------------------------------------------------------------
# Figure 8 and Figure 9: fairness and total-throughput sweeps
# ---------------------------------------------------------------------------

def make_sweep_scenario(
    network_name: str,
    n_users: int,
    arrival_spread_s: float,
    warmup_s: float,
    measurement_s: float,
    start_seed: int,
) -> tuple[StaticScenario, np.ndarray]:
    """Build the long-lived-flow scenario used by Figs. 8 and 9.

    The paper reports 512 seconds of channel-occupation measurement but does
    not report the exact start-time law for this user-count sweep. We therefore
    use reproducible uniform staggering over ``arrival_spread_s`` and start the
    measurement only after every flow has arrived plus a warm-up interval.
    """
    rng = np.random.default_rng(start_seed)
    starts = tuple(np.sort(rng.uniform(0.0, arrival_spread_s, size=n_users)))

    if network_name == "homogeneous":
        class_ids = (0,) * n_users
        rate_sets = ((2.0, 3.0, 4.0),)
        maximum_rates = np.full(n_users, 4.0)
    elif network_name == "heterogeneous":
        class_ids_array = np.arange(n_users) % 2
        class_ids = tuple(int(value) for value in class_ids_array)
        rate_sets = ((4.0, 5.0, 6.0), (2.0, 3.0, 4.0))
        maximum_rates = np.where(class_ids_array == 0, 6.0, 4.0)
    else:
        raise ValueError(f"Unknown network: {network_name}")

    scenario = StaticScenario(
        name=f"sweep_{network_name}_{n_users}",
        duration_s=arrival_spread_s + warmup_s + measurement_s,
        start_times_s=starts,
        class_ids=class_ids,
        rate_sets_mbps=rate_sets,
        throughput_window_s=1.0,
        flow_size_mb=None,
    )
    return scenario, maximum_rates


def aggregate_rows(
    raw_rows: list[dict],
    value_keys: Sequence[str],
    group_keys: Sequence[str],
) -> list[dict]:
    groups: dict[tuple, list[dict]] = {}
    for row in raw_rows:
        key = tuple(row[name] for name in group_keys)
        groups.setdefault(key, []).append(row)

    summary: list[dict] = []
    for key, rows in groups.items():
        output = {name: value for name, value in zip(group_keys, key)}
        for value_key in value_keys:
            values = np.asarray([float(row[value_key]) for row in rows])
            output[f"mean_{value_key}"] = float(values.mean())
            output[f"std_{value_key}"] = (
                float(values.std(ddof=1)) if values.size > 1 else 0.0
            )
        summary.append(output)
    return summary


def run_figure8_and_figure9(
    output_dir: Path,
    profile: Profile,
    seed: int,
    show_figure8: bool = True,
    show_figure9: bool = True,
) -> None:
    raw_rows: list[dict] = []

    for network_index, network_name in enumerate(("homogeneous", "heterogeneous")):
        for n_users in profile.sweep_user_counts:
            for repetition in range(profile.repetitions):
                common_seed = (
                    seed
                    + 100_000 * network_index
                    + 10_000 * repetition
                    + n_users
                )
                scenario, maximum_rates = make_sweep_scenario(
                    network_name=network_name,
                    n_users=n_users,
                    arrival_spread_s=profile.sweep_arrival_spread_s,
                    warmup_s=profile.sweep_warmup_s,
                    measurement_s=profile.sweep_measurement_s,
                    start_seed=common_seed,
                )
                channels = generate_channels(scenario, common_seed + 1_000_000)
                measurement_start = (
                    profile.sweep_arrival_spread_s + profile.sweep_warmup_s
                )

                for algorithm_index, algorithm in enumerate(ALL_ALGORITHMS):
                    result = simulate_static(
                        scenario=scenario,
                        algorithm=algorithm,
                        channel_trace=channels,
                        tie_seed=common_seed + 2_000_000 + algorithm_index,
                        measurement_start_s=measurement_start,
                        store_trace=False,
                    )
                    # Equation used for Fig. 8(b): normalize occupation by each
                    # flow's maximum supported rate before applying Jain's index.
                    if network_name == "heterogeneous":
                        fairness_values = result.occupancy_slots / maximum_rates
                    else:
                        fairness_values = result.occupancy_slots

                    raw_rows.append(
                        {
                            "network": network_name,
                            "users": n_users,
                            "algorithm": algorithm,
                            "repetition": repetition,
                            "measurement_seconds": profile.sweep_measurement_s,
                            "fairness_index": jain_index(fairness_values),
                            "system_throughput_mbps": result.total_average_throughput_mbps(),
                        }
                    )
                    print(
                        f"Sweep {network_name:13s} N={n_users:3d} "
                        f"rep={repetition + 1}/{profile.repetitions} "
                        f"{algorithm:6s}"
                    )

    summary = aggregate_rows(
        raw_rows,
        value_keys=("fairness_index", "system_throughput_mbps"),
        group_keys=("network", "users", "algorithm"),
    )
    write_csv(raw_rows, output_dir / "figure8_9_raw_runs.csv")
    write_csv(summary, output_dir / "figure8_9_summary.csv")

    if show_figure8:
        plot_paper_figure8(summary, profile, output_dir)

    if show_figure9:
        # Fig. 9 corresponds to the homogeneous {2,3,4} Mbps sweep used for
        # Fig. 8(a); its upper envelope is therefore approximately 4 Mbps.
        figure9_rows = [
            row for row in summary if row["network"] == "homogeneous"
        ]
        fig, ax = plt.subplots(figsize=(9.5, 5.8))
        for algorithm in ALL_ALGORITHMS:
            selected = [
                row for row in figure9_rows if row["algorithm"] == algorithm
            ]
            selected.sort(key=lambda row: int(row["users"]))
            x = np.asarray([int(row["users"]) for row in selected])
            y = 1e6 * np.asarray(
                [float(row["mean_system_throughput_mbps"]) for row in selected]
            )
            style = SUMMARY_PLOT_STYLE[algorithm]
            ax.plot(
                x,
                y,
                marker=style["marker"],
                markersize=MARKER_SIZE,
                linewidth=SUMMARY_LINEWIDTH,
                label=algorithm,
            )
        ax.set_xlabel("Number of flows")
        ax.set_ylabel("System average throughput (bps)")
        ax.set_title("Fig. 9. System throughput of different algorithms")
        _set_user_count_axis(ax, max(profile.sweep_user_counts))
        ax.ticklabel_format(axis="y", style="sci", scilimits=(6, 6))
        # Same vertical range used in the article's homogeneous experiment.
        ax.set_ylim(2.8e6, 4.02e6)
        ax.grid(True, alpha=GRID_ALPHA)
        ax.legend(loc="lower right")
        fig.tight_layout()
        plt.show()



# ---------------------------------------------------------------------------
# Figure 10: dynamic finite-flow stability stress test
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class DynamicPopulation:
    start_slots: np.ndarray
    class_ids: np.ndarray
    sizes_packets: np.ndarray
    channel_trace: np.ndarray
    rate_sets: tuple[tuple[int, int], ...]
    markov_stay_probability: float
    rho_target: float
    realized_normalized_load: float


def generate_two_state_markov_block(
    n_slots: int,
    n_flows: int,
    low_rate: int,
    high_rate: int,
    stay_probability: float,
    rng: np.random.Generator,
) -> np.ndarray:
    """Generate independent symmetric two-state Markov traces efficiently."""
    if n_flows == 0:
        return np.empty((n_slots, 0), dtype=np.uint8)
    if not 0.0 <= stay_probability <= 1.0:
        raise ValueError("stay_probability must lie in [0, 1]")

    initial = rng.integers(0, 2, size=n_flows, dtype=np.uint8)
    states = np.empty((n_slots, n_flows), dtype=np.uint8)
    states[0] = initial
    if n_slots > 1:
        flips = (rng.random((n_slots - 1, n_flows)) > stay_probability).astype(
            np.uint8
        )
        # XOR accumulation gives the state after every sequence of flips.
        parity = np.bitwise_xor.accumulate(flips, axis=0)
        states[1:] = parity ^ initial
    return np.where(states == 0, low_rate, high_rate).astype(np.uint8)


def generate_dynamic_population(
    n_slots: int,
    seed: int,
    rho: float = 0.99,
    mean_size_packets: float = 80.0,
    markov_stay_probability: float = MARKOV_STAY_PROBABILITY_ASSUMPTION,
) -> DynamicPopulation:
    """Generate the common finite-flow population used for Fig. 10.

    Source-supported choices: five classes, two-state channels and rho=0.99.
    Unreported details are explicit assumptions: rate pairs (1,2)...(5,6),
    exponential sizes with mean 80 packets, equal normalized load per class,
    and a symmetric Markov transition probability.
    """
    rng = np.random.default_rng(seed)
    rate_sets = ((1, 2), (2, 3), (3, 4), (4, 5), (5, 6))
    maximum_rates = np.asarray([max(rates) for rates in rate_sets], dtype=float)
    class_load = rho / len(rate_sets)
    lambda_per_slot = class_load * maximum_rates / mean_size_packets

    starts: list[int] = []
    classes: list[int] = []
    sizes: list[float] = []

    for class_id, arrival_rate in enumerate(lambda_per_slot):
        current = 0.0
        while True:
            current += rng.exponential(1.0 / arrival_rate)
            slot = int(current)
            if slot >= n_slots:
                break
            starts.append(slot)
            classes.append(class_id)
            sizes.append(max(1.0, float(rng.exponential(mean_size_packets))))

    order = np.argsort(starts)
    start_slots = np.asarray(starts, dtype=int)[order]
    class_ids = np.asarray(classes, dtype=int)[order]
    sizes_packets = np.asarray(sizes, dtype=float)[order]
    n_flows = len(start_slots)

    # Actual two-state Markov channels, shared by every scheduler.
    channel_trace = np.empty((n_slots, n_flows), dtype=np.uint8)
    for class_id, (low_rate, high_rate) in enumerate(rate_sets):
        indices = np.flatnonzero(class_ids == class_id)
        channel_trace[:, indices] = generate_two_state_markov_block(
            n_slots=n_slots,
            n_flows=indices.size,
            low_rate=low_rate,
            high_rate=high_rate,
            stay_probability=markov_stay_probability,
            rng=rng,
        )

    # Normalize the finite realization to the requested traffic intensity using
    # the paper's maximum-rate definition of normalized offered work.
    realized_load = float(
        np.sum(sizes_packets / maximum_rates[class_ids]) / n_slots
    ) if n_flows else 0.0
    if realized_load > 0:
        sizes_packets *= rho / realized_load
    realized_load = float(
        np.sum(sizes_packets / maximum_rates[class_ids]) / n_slots
    ) if n_flows else 0.0

    return DynamicPopulation(
        start_slots=start_slots,
        class_ids=class_ids,
        sizes_packets=sizes_packets,
        channel_trace=channel_trace,
        rate_sets=rate_sets,
        markov_stay_probability=markov_stay_probability,
        rho_target=rho,
        realized_normalized_load=realized_load,
    )


def simulate_dynamic_population(
    population: DynamicPopulation,
    algorithm: str,
    tie_seed: int,
    queue_capacity_packets: float = 100.0,
    rtt_slots: int = 10,
    pf_history_slots: int = 1000,
) -> np.ndarray:
    n_slots, n_flows = population.channel_trace.shape
    start_slots = population.start_slots

    queues = np.zeros(n_flows, dtype=float)
    remaining_sender = population.sizes_packets.copy()
    unacknowledged = np.zeros(n_flows, dtype=float)
    cwnd = np.ones(n_flows, dtype=float)
    ssthresh = np.full(n_flows, 256.0, dtype=float)
    hol = np.zeros(n_flows, dtype=float)
    pf_average = np.full(n_flows, 1e-3, dtype=float)
    completed = np.zeros(n_flows, dtype=bool)
    acknowledgement_ring = np.zeros((rtt_slots + 1, n_flows), dtype=float)

    alpha = 1.0 / max(1, pf_history_slots)
    tie_rng = np.random.default_rng(tie_seed)
    active_count = np.zeros(n_slots, dtype=float)

    for slot in range(n_slots):
        arrived = start_slots <= slot
        active = arrived & (~completed)

        ring_index = slot % (rtt_slots + 1)
        acknowledged = acknowledgement_ring[ring_index].copy()
        acknowledgement_ring[ring_index].fill(0.0)
        unacknowledged = np.maximum(unacknowledged - acknowledged, 0.0)
        increase_cwnd(cwnd, acknowledged, ssthresh)

        available_window = np.maximum(
            np.floor(cwnd - unacknowledged + EPS),
            0.0,
        )
        free_buffer = np.maximum(queue_capacity_packets - queues, 0.0)
        injected = np.minimum(available_window, free_buffer)
        injected = np.minimum(injected, remaining_sender)
        injected *= active
        queues += injected
        remaining_sender -= injected
        unacknowledged += injected

        rates = population.channel_trace[slot].astype(float, copy=False)
        eligible = active & (queues > EPS)
        flow_age = np.maximum(slot - start_slots, 0).astype(float)
        selected = choose_user(
            algorithm=algorithm,
            eligible=eligible,
            rates=rates,
            queues=queues,
            hol_access_delay=hol,
            flow_age=flow_age,
            pf_average=pf_average,
            tie_rng=tie_rng,
        )

        service = np.zeros(n_flows, dtype=float)
        if selected is not None:
            service[selected] = min(queues[selected], rates[selected])
            queues[selected] -= service[selected]
            future_index = (slot + rtt_slots) % (rtt_slots + 1)
            acknowledgement_ring[future_index, selected] += service[selected]

        pf_average = (1.0 - alpha) * pf_average + alpha * service
        waiting = active & (queues > EPS)
        hol[waiting] += 1.0
        hol[~waiting] = 0.0
        if selected is not None:
            hol[selected] = 0.0

        just_completed = (
            active
            & (remaining_sender <= EPS)
            & (queues <= EPS)
            & (unacknowledged <= EPS)
        )
        completed |= just_completed
        active_count[slot] = np.count_nonzero(arrived & (~completed))

    return active_count


def run_figure10(
    output_dir: Path,
    profile: Profile,
    seed: int,
) -> None:
    population = generate_dynamic_population(
        n_slots=profile.stability_slots,
        seed=seed,
        rho=0.99,
    )
    rows: list[dict] = []
    traces: dict[str, np.ndarray] = {}

    for index, algorithm in enumerate(ALL_ALGORITHMS):
        trace = simulate_dynamic_population(
            population=population,
            algorithm=algorithm,
            tie_seed=seed + 1000 + index,
        )
        traces[algorithm] = trace
        tail_start = int(0.8 * trace.size)
        x = np.arange(trace.size, dtype=float)
        slope = float(np.polyfit(x[tail_start:], trace[tail_start:], 1)[0])
        rows.append(
            {
                "algorithm": algorithm,
                "rho_target": population.rho_target,
                "realized_normalized_load": population.realized_normalized_load,
                "generated_flows": len(population.start_slots),
                "markov_stay_probability_assumption": population.markov_stay_probability,
                "final_active_flows": float(trace[-1]),
                "tail_mean_active_flows": float(trace[tail_start:].mean()),
                "tail_linear_slope_flows_per_slot": slope,
            }
        )

    write_csv(rows, output_dir / "figure10_stability_summary.csv")

    plt.figure(figsize=(9.7, 5.8))
    for algorithm in ALL_ALGORITHMS:
        smooth = moving_average(
            traces[algorithm],
            profile.stability_smoothing_slots,
        )
        # The article uses a logarithmic y-axis. Clipping only replaces an
        # initial display value of zero; it never changes the simulated trace
        # or the CSV summaries.
        displayed = np.maximum(smooth, 1.0)
        plt.plot(
            np.arange(displayed.size),
            displayed,
            linewidth=SUMMARY_LINEWIDTH,
            label=algorithm,
        )
    plt.xlabel("Time slot")
    plt.ylabel("Number of flows")
    plt.title(
        "Fig. 10. Throughput-optimality test "
        f"(target rho={population.rho_target:.2f}, realized={population.realized_normalized_load:.3f})"
    )
    plt.yscale("log")
    plt.ylim(bottom=1.0)
    ax = plt.gca()
    ax.set_xlim(0, profile.stability_slots)
    if profile.stability_slots <= 10_000:
        ax.set_xticks(np.arange(0, profile.stability_slots + 1, 2_000))
    else:
        ax.set_xticks(np.arange(0, profile.stability_slots + 1, 10_000))
    plt.grid(True, which="both", alpha=GRID_ALPHA)
    plt.legend()
    plt.tight_layout()
    plt.show()



# ---------------------------------------------------------------------------
# Paper-style composite figures with the exact labels used in the article
# ---------------------------------------------------------------------------

def _paper_subcaption(ax: plt.Axes, text: str, y: float = -0.23) -> None:
    ax.text(
        0.5,
        y,
        text,
        transform=ax.transAxes,
        ha="center",
        va="top",
        fontsize=10,
    )


def _set_time_axis(ax: plt.Axes, x_max: float) -> None:
    """Use the same time limits and major spacing as the corresponding paper plot."""
    ax.set_xlim(0.0, x_max)
    if x_max <= 60.0 + EPS:
        ax.set_xticks(np.arange(0.0, 60.0 + EPS, 10.0))
    elif x_max <= 200.0 + EPS:
        ax.set_xticks(np.arange(0.0, 200.0 + EPS, 50.0))
    else:
        step = x_max / 5.0
        ax.set_xticks(np.arange(0.0, x_max + 0.5 * step, step))


def _set_user_count_axis(ax: plt.Axes, max_users: int) -> None:
    """Keep the x-axis endpoint equal to the largest simulated user count."""
    if max_users <= 64:
        ax.set_xlim(0.0, 64.0)
        ax.set_xticks((0, 16, 32, 48, 64))
    else:
        # The paper uses data through 256 users and labels the axis every 50.
        ax.set_xlim(0.0, 260.0)
        ax.set_xticks((0, 50, 100, 150, 200, 250))


def _paper_bps_axis(ax: plt.Axes, x_max: float, y_max: float) -> None:
    ax.set_xlabel("Time (second)")
    ax.set_ylabel("Average Throughput (bps)")
    _set_time_axis(ax, x_max)
    ax.set_ylim(0.0, y_max)
    ax.ticklabel_format(axis="y", style="sci", scilimits=(6, 6))
    ax.grid(True, alpha=GRID_ALPHA)


def _annotate_line(
    ax: plt.Axes,
    time_s: np.ndarray,
    values: np.ndarray,
    label: str,
    at_s: float,
    offset: tuple[float, float] = (8.0, 0.25e6),
) -> None:
    index = int(np.argmin(np.abs(time_s - at_s)))
    x = float(time_s[index])
    y = float(values[index])
    ax.annotate(
        label,
        xy=(x, y),
        xytext=(x + offset[0], max(0.0, y + offset[1])),
        arrowprops={"arrowstyle": "->", "linewidth": 0.8},
        fontsize=8,
    )


def find_natural_last_packet_tail(
    service_trace_packets: np.ndarray,
    minimum_gap_s: float = 1.0,
) -> tuple[int, int] | None:
    """Locate a genuinely delayed small final service burst, for annotation only.

    This scans the raw (unsmoothed) per-slot service trace for a flow that:
    (1) already received a substantial amount of service, then
    (2) went quiet for at least `minimum_gap_s`, then
    (3) received one small final burst before finishing.

    That pattern is exactly the paper's "last-packet problem" (Sec. II-B):
    a flow's last few packets stranded behind another flow's queue. Returns
    (flow_index, tail_start_slot) for the smallest such delayed burst, or
    None if the simulation did not happen to produce one. This function only
    finds where to point an annotation arrow -- it never modifies the trace
    or any plotted value.
    """
    gap_slots = max(2, int(round(minimum_gap_s / SLOT_SECONDS)))
    candidates: list[tuple[float, int, int]] = []

    for flow, service in enumerate(service_trace_packets):
        nonzero = np.flatnonzero(service > EPS)
        if nonzero.size < 2:
            continue
        gaps = np.diff(nonzero)
        for gap_index in np.flatnonzero(gaps >= gap_slots):
            tail_start = int(nonzero[gap_index + 1])
            tail_packets = float(service[tail_start:].sum())
            earlier_packets = float(service[:tail_start].sum())
            if earlier_packets >= 100.0 and 0.0 < tail_packets <= 100.0:
                # Prefer the smallest delayed tail; break ties with the
                # longer preceding gap (a clearer "stranded packet" case).
                score = tail_packets - 1e-4 * float(gaps[gap_index])
                candidates.append((score, flow, tail_start))

    if not candidates:
        return None
    _, flow, tail_start = min(candidates, key=lambda item: item[0])
    return flow, tail_start


def run_paper_figure4_or_5(
    output_dir: Path,
    n_flows: int,
    seed: int,
) -> None:
    """Create one complete Fig. 4 or Fig. 5 image with exact article labels."""
    scenario = make_homogeneous_scenario(n_flows)
    channels = generate_channels(scenario, seed)
    results: dict[str, StaticResult] = {}
    rows: list[dict] = []

    for index, algorithm in enumerate(TIME_ALGORITHMS):
        result = simulate_static(
            scenario=scenario,
            algorithm=algorithm,
            channel_trace=channels,
            tie_seed=seed + 100 + index,
            measurement_start_s=max(scenario.start_times_s) + 5.0,
            store_trace=True,
        )
        results[algorithm] = result
        smooth = result.sliding_throughput_mbps()
        analysis_mask = result.time_s >= max(scenario.start_times_s) + 5.0
        means = smooth[:, analysis_mask].mean(axis=1)
        row = {
            "algorithm": algorithm,
            "system_mean_mbps": float(means.sum()),
            "jain_flow_throughput": jain_index(means),
        }
        for flow, value in enumerate(means):
            row[f"flow_{flow}_mean_mbps"] = float(value)
        rows.append(row)

    if n_flows == 2:
        fig, axes = plt.subplots(1, 3, figsize=(14.2, 4.9))
        y_max = 3.5e6
        caption = "Fig. 4.  Throughput performance in the 2-flow homogeneous network."
        subcaptions = (
            "(a) HOLD scheduling algorithm.",
            "(b) QMW scheduling algorithm.",
            "(c) F-D-MW scheduling algorithm.",
        )
    else:
        fig, axes = plt.subplots(1, 3, figsize=(14.2, 4.9))
        y_max = 4.0e6
        caption = "Fig. 5.  Throughput performance in the 8-flow homogeneous network."
        subcaptions = (
            "(a) HOLD scheduling algorithm.",
            "(b) QMW scheduling algorithm.",
            "(c) F-D-MW scheduling algorithm.",
        )

    for ax, algorithm, subcaption in zip(axes, TIME_ALGORITHMS, subcaptions):
        result = results[algorithm]
        throughput_bps = result.sliding_throughput_mbps() * 1e6
        for flow in range(throughput_bps.shape[0]):
            ax.plot(result.time_s, throughput_bps[flow], linewidth=FLOW_LINEWIDTH)

        if n_flows == 8:
            system_bps = throughput_bps.sum(axis=0)
            ax.plot(
                result.time_s,
                system_bps,
                marker="^",
                markevery=max(1, len(result.time_s) // 40),
                linewidth=AGGREGATE_LINEWIDTH,
                markersize=MARKER_SIZE,
            )
            _annotate_line(
                ax,
                result.time_s,
                system_bps,
                "Server",
                at_s=95.0,
                offset=(10.0, -0.45e6),
            )

            if algorithm == "HOLD":
                group_a = throughput_bps[:4].mean(axis=0)
                group_b = throughput_bps[4:].mean(axis=0)
                _annotate_line(ax, result.time_s, group_a, "Client[0-3]", 55.0)
                _annotate_line(ax, result.time_s, group_b, "Client[4-7]", 145.0)
            else:
                annotation_times = np.linspace(30.0, 175.0, n_flows)
                for flow, at_s in enumerate(annotation_times):
                    _annotate_line(
                        ax,
                        result.time_s,
                        throughput_bps[flow],
                        f"Client[{flow}]",
                        float(at_s),
                        offset=(3.0, 0.15e6),
                    )

            if algorithm == "QMW" and result.service_trace_packets is not None:
                tail = find_natural_last_packet_tail(result.service_trace_packets)
                if tail is not None:
                    tail_flow, tail_slot = tail
                    _annotate_line(
                        ax,
                        result.time_s,
                        throughput_bps[tail_flow],
                        "last-packet\ndelay",
                        float(result.time_s[tail_slot]),
                        offset=(6.0, 0.55e6),
                    )
        else:
            _annotate_line(ax, result.time_s, throughput_bps[0], "Client[0]", 16.0)
            _annotate_line(ax, result.time_s, throughput_bps[1], "Client[1]", 32.0)

        _paper_bps_axis(ax, scenario.duration_s, y_max)
        _paper_subcaption(ax, subcaption)

    fig.text(0.5, 0.015, caption, ha="center", va="bottom", fontsize=11)
    fig.subplots_adjust(left=0.06, right=0.99, top=0.96, bottom=0.28, wspace=0.33)
    plt.show()
    write_csv(rows, output_dir / ("figure4_summary.csv" if n_flows == 2 else "figure5_summary.csv"))


def run_paper_figure6(
    output_dir: Path,
    profile: Profile,
    seed: int,
) -> None:
    """Create the two-panel Fig. 6 with the exact axes, legends and captions."""
    # Values are the number of flows in EACH class, as in the article.
    class_counts = (
        tuple(range(1, 51))
        if profile.name == "paper"
        else (1, 2, 3, 4, 5, 8, 10, 15, 20, 30, 40, 50)
    )
    all_rows: dict[bool, list[dict]] = {}

    for random_channels in (False, True):
        rows: list[dict] = []
        for flows_per_class in class_counts:
            n_flows = 2 * flows_per_class
            scenario = build_figure6_scenario(
                n_flows=n_flows,
                duration_s=profile.figure6_duration_s,
                random_channels=random_channels,
            )
            channels = generate_channels(
                scenario,
                seed + n_flows + (10_000 if random_channels else 0),
            )
            result = simulate_static(
                scenario=scenario,
                algorithm="HOLD",
                channel_trace=channels,
                tie_seed=seed + 20_000 + n_flows,
                measurement_start_s=10.0,
                store_trace=False,
            )
            class_ids = np.asarray(scenario.class_ids, dtype=int)
            h_fast = class_scheduled_hol_mean(result, class_ids, 0)
            h_slow = class_scheduled_hol_mean(result, class_ids, 1)
            ratio = h_fast / h_slow
            target = max(scenario.rate_sets_mbps[1]) / max(scenario.rate_sets_mbps[0])
            rows.append(
                {
                    "channel_model": "markov" if random_channels else "constant",
                    "flows_in_each_class": flows_per_class,
                    "hol_access_delay_ratio": ratio,
                    "channel_ratio": target,
                }
            )
        all_rows[random_channels] = rows
        model_name = "with_channel_variations" if random_channels else "without_channel_variations"
        write_csv(rows, output_dir / f"figure6_{model_name}_summary.csv")

    fig, axes = plt.subplots(1, 2, figsize=(11.5, 5.0))

    for ax, random_channels in zip(axes, (False, True)):
        rows = all_rows[random_channels]
        x = np.asarray([row["flows_in_each_class"] for row in rows])
        y = np.asarray([row["hol_access_delay_ratio"] for row in rows])
        target = float(rows[0]["channel_ratio"])
        theoretical_label = (
            "Channel max-rate ratio" if random_channels else "Channel rate ratio"
        )
        ax.plot(x, np.full_like(x, target, dtype=float), linewidth=SUMMARY_LINEWIDTH, label=theoretical_label)
        ax.plot(x, y, marker="o", markersize=MARKER_SIZE, linewidth=SUMMARY_LINEWIDTH, fillstyle="none", label="HOL access delay ratio")
        ax.set_xlabel("Number of flows in each class")
        ax.set_ylabel("Ratio")
        ax.set_xlim(0.0, 50.0)
        ax.set_xticks((0, 10, 20, 30, 40, 50))
        if random_channels:
            ax.set_ylim(0.48, 0.60)
            _paper_subcaption(ax, "(b) With channel variations.")
        else:
            ax.set_ylim(0.50, 1.00)
            _paper_subcaption(ax, "(a) Without channel variations.")
        ax.grid(True, alpha=GRID_ALPHA)
        ax.legend(loc="upper right")

    fig.text(
        0.5,
        0.02,
        "Fig. 6.  HOL access delay ratio in the heterogeneous network.",
        ha="center",
        va="bottom",
        fontsize=11,
    )
    fig.subplots_adjust(left=0.08, right=0.98, top=0.96, bottom=0.28, wspace=0.30)
    plt.show()


def run_paper_figure7(output_dir: Path, seed: int) -> None:
    """Create Fig. 7 from the TCP-lite simulator (no fabricated curves)."""
    scenario = heterogeneous_eight_flow_scenario()
    channels = generate_channels(scenario, seed)
    results: dict[str, StaticResult] = {}
    rows: list[dict] = []

    for index, algorithm in enumerate(HETERO_TIME_ALGORITHMS):
        result = simulate_static(
            scenario=scenario,
            algorithm=algorithm,
            channel_trace=channels,
            tie_seed=seed + 100 + index,
            measurement_start_s=max(scenario.start_times_s) + 5.0,
            store_trace=True,
        )
        results[algorithm] = result
        rows.append(figure7_measurement_row(result))

    fig, axes = plt.subplots(2, 2, figsize=(11.7, 9.3))
    axes = axes.ravel()
    subcaptions = {
        "HOLD": "(a) HOLD scheduling algorithm.",
        "MR": "(b) MR scheduling algorithm.",
        "QMW": "(c) QMW scheduling algorithm.",
        "F-D-MW": "(d) F-D-MW scheduling algorithm.",
    }

    for ax, algorithm in zip(axes, HETERO_TIME_ALGORITHMS):
        result = results[algorithm]
        throughput_bps = result.sliding_throughput_mbps() * 1e6
        for flow in range(throughput_bps.shape[0]):
            ax.plot(result.time_s, throughput_bps[flow], linewidth=FLOW_LINEWIDTH)
        if algorithm in ("HOLD", "MR"):
            system_bps = throughput_bps.sum(axis=0)
            ax.plot(
                result.time_s,
                system_bps,
                marker="^",
                markevery=max(1, len(result.time_s) // 35),
                linewidth=AGGREGATE_LINEWIDTH,
                markersize=MARKER_SIZE,
            )
            _annotate_line(
                ax,
                result.time_s,
                system_bps,
                "Server",
                at_s=75.0,
                offset=(10.0, -0.4e6),
            )
            class_0 = throughput_bps[:4].mean(axis=0)
            class_1 = throughput_bps[4:].mean(axis=0)
            _annotate_line(ax, result.time_s, class_0, "Client[0-3]", 45.0)
            _annotate_line(ax, result.time_s, class_1, "Client[4-7]", 115.0)
        else:
            annotation_times = np.linspace(15.0, 155.0, 8)
            for flow, at_s in enumerate(annotation_times):
                _annotate_line(
                    ax,
                    result.time_s,
                    throughput_bps[flow],
                    f"Client[{flow}]",
                    float(at_s),
                    offset=(4.0, 0.18e6),
                )

        if algorithm == "QMW" and result.service_trace_packets is not None:
            tail = find_natural_last_packet_tail(result.service_trace_packets)
            if tail is not None:
                tail_flow, tail_slot = tail
                _annotate_line(
                    ax,
                    result.time_s,
                    throughput_bps[tail_flow],
                    "last-packet\ndelay",
                    float(result.time_s[tail_slot]),
                    offset=(7.0, 0.7e6),
                )

        _paper_bps_axis(ax, scenario.duration_s, 6.5e6)
        _paper_subcaption(ax, subcaptions[algorithm], y=-0.20)

    fig.text(
        0.5,
        0.012,
        "Fig. 7.  Throughput performance in the 8-flow heterogeneous network with channel variations.",
        ha="center",
        va="bottom",
        fontsize=11,
    )
    fig.subplots_adjust(
        left=0.08,
        right=0.99,
        top=0.98,
        bottom=0.15,
        hspace=0.42,
        wspace=0.27,
    )
    plt.show()
    write_csv(rows, output_dir / "figure7_summary.csv")


def plot_paper_figure8(
    summary: list[dict],
    profile: Profile,
    output_dir: Path,
) -> None:
    """Create Fig. 8 with PF triangles visibly layered above the HOLD line."""
    del output_dir  # Numerical CSVs are written by run_figure8_and_figure9.

    fig, axes = plt.subplots(1, 2, figsize=(11.7, 5.1))
    subcaptions = {
        "homogeneous": "(a) Homogeneous network.",
        "heterogeneous": "(b) Heterogeneous network.",
    }

    for ax, network_name in zip(axes, ("homogeneous", "heterogeneous")):
        network_rows = [row for row in summary if row["network"] == network_name]

        # HOLD is drawn first. PF is drawn last, with no connecting line and a
        # higher z-order, so the hollow triangles remain visible on y≈1.
        for algorithm in FAIRNESS_ALGORITHMS:
            selected = [
                row for row in network_rows if row["algorithm"] == algorithm
            ]
            selected.sort(key=lambda row: int(row["users"]))
            x = np.asarray([int(row["users"]) for row in selected])
            y = np.asarray([float(row["mean_fairness_index"]) for row in selected])
            style = FAIRNESS_PLOT_STYLE[algorithm]

            plot_kwargs = {
                "color": style["color"],
                "linestyle": style["linestyle"],
                "marker": style["marker"],
                "markersize": MARKER_SIZE + (1.0 if algorithm == "PF" else 0.0),
                "linewidth": SUMMARY_LINEWIDTH,
                "label": algorithm,
                "zorder": style["zorder"],
            }
            if algorithm in ("QMW", "PF"):
                plot_kwargs["markerfacecolor"] = "none"
                plot_kwargs["markeredgewidth"] = 0.8

            ax.plot(x, y, **plot_kwargs)

        ax.set_xlabel("Number of users")
        ax.set_ylabel("Fairness index of channel occupation")
        ax.set_yscale("log")
        ax.set_ylim(0.005, 1.5)
        _set_user_count_axis(ax, max(profile.sweep_user_counts))
        ax.grid(True, which="both", alpha=GRID_ALPHA)
        ax.legend(loc="upper right")
        _paper_subcaption(ax, subcaptions[network_name])

    fig.text(
        0.5,
        0.02,
        "Fig. 8.  Jain’s fairness index in terms of channel occupation.",
        ha="center",
        va="bottom",
        fontsize=11,
    )
    fig.subplots_adjust(
        left=0.08,
        right=0.98,
        top=0.96,
        bottom=0.29,
        wspace=0.30,
    )
    plt.show()


# ---------------------------------------------------------------------------
# Command-line interface
# ---------------------------------------------------------------------------

def normalize_experiments(values: Sequence[str]) -> list[str]:
    all_names = [
        "figure4",
        "figure5",
        "figure6",
        "figure7",
        "figure8",
        "figure9",
        "figure10",
    ]
    if "all" in values:
        return all_names
    unknown = sorted(set(values) - set(all_names))
    if unknown:
        raise ValueError(f"Unknown experiments: {unknown}")
    # Preserve the natural figure order.
    return [name for name in all_names if name in values]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run the all-in-one HOLD scheduling experiments"
    )
    parser.add_argument(
        "--experiments",
        nargs="+",
        default=["all"],
        help="all, figure4, figure5, figure6, figure7, figure8, figure9, figure10",
    )
    parser.add_argument(
        "--profile",
        choices=tuple(PROFILES),
        default="quick",
        help="quick runs fast; paper uses more users and repetitions",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path("hold_results"),
    )
    parser.add_argument("--seed", type=int, default=31)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    profile = PROFILES[args.profile]
    experiments = normalize_experiments(args.experiments)
    args.output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Profile: {profile.name}")
    print(f"Experiments: {', '.join(experiments)}")
    print(f"Output directory for CSV summaries: {args.output_dir.resolve()}")
    print("Image policy: figures are displayed only; no PNG/PDF image is written.")
    print("Every figure below is generated by actually running the schedulers "
          "on the TCP-lite model -- nothing is digitized or hand-tuned.")

    if "figure4" in experiments:
        print("\nRunning Figure 4-style experiment...")
        run_paper_figure4_or_5(
            args.output_dir,
            n_flows=2,
            seed=args.seed + 400,
        )

    if "figure5" in experiments:
        print("\nRunning Figure 5-style experiment...")
        run_paper_figure4_or_5(
            args.output_dir,
            n_flows=8,
            seed=args.seed + 500,
        )

    if "figure6" in experiments:
        print("\nRunning Figure 6-style experiment...")
        run_paper_figure6(args.output_dir, profile, args.seed + 600)

    if "figure7" in experiments:
        print("\nRunning Figure 7-style experiment...")
        run_paper_figure7(args.output_dir, args.seed + 700)

    if "figure8" in experiments or "figure9" in experiments:
        print("\nRunning Figure 8/9-style sweep...")
        run_figure8_and_figure9(
            args.output_dir,
            profile,
            args.seed + 800,
            show_figure8="figure8" in experiments,
            show_figure9="figure9" in experiments,
        )

    if "figure10" in experiments:
        print("\nRunning Figure 10-style stability stress test...")
        run_figure10(args.output_dir, profile, args.seed + 1000)

    print("\nFinished. Generated numerical files:")
    for path in sorted(args.output_dir.iterdir()):
        print(f"  {path.name}")


if __name__ == "__main__":
    main()