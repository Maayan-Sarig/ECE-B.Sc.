# HOLD Scheduling Simulation

Independent Python re-implementation and simulator for:

> Y. Chen, X. Wang, and L. Cai, "On Achieving Fair and Throughput-Optimal
> Scheduling for TCP Flows in Wireless Networks," *IEEE Transactions on
> Wireless Communications*, 2016.

This is **not** the authors' original OMNeT++ code. It's a model-based
reproduction intended to check the mechanisms and qualitative trends of
Figs. 4-10 in the paper (fairness of HOLD vs. starvation under QMW/F-D-MW,
HOL access-delay convergence, throughput-optimality/stability under load).

## Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Running

```bash
# Quick run (all 7 figures, ~30s)
python hold_all_experiments.py

# Higher-fidelity run (more users/repetitions, matches paper's scale better)
python hold_all_experiments.py --profile paper

# Only specific figures
python hold_all_experiments.py --experiments figure4 figure8 figure9
```

By default this calls `plt.show()` for each figure, which needs a display.
If you're running headless (e.g. over SSH, in CI, or without a GUI backend),
use `run_headless.py` instead — it monkeypatches `plt.show()` to save each
figure as a PNG under `figures/` rather than popping up a window:

```bash
python run_headless.py
```

## Reference outputs

`reference_figures/` and `reference_results/` contain a sample run's PNGs
and CSV summaries (quick profile), for comparison when you make changes.

## Known deviation from the paper

Figure 7 (8-flow heterogeneous throughput) uses **finite (10MB) flows**
rather than long-lived ones. The faster class finishes its transfer sooner
and goes idle for the rest of the measurement window, which drags down its
time-averaged throughput and inverts the fast/slow throughput ratio relative
to the paper's reported ~0.44 (see `reference_results/figure7_summary.csv`).
Restricting the average to the window where both classes are still active
recovers the expected ratio (~0.49). Worth fixing if you need Fig. 7's
numbers to line up, e.g. by switching that scenario to long-lived flows like
Figs. 8/9 already do, or by excluding post-completion slots from the average.
