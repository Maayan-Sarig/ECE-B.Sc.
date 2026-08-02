# HOLD Scheduling Simulation — Team Project

Independent Python re-implementation and simulator for:

> Y. Chen, X. Wang, and L. Cai, "On Achieving Fair and Throughput-Optimal
> Scheduling for TCP Flows in Wireless Networks," *IEEE Transactions on
> Wireless Communications*, 2016.

This is **not** the authors' original OMNeT++ code. It reproduces the
mechanisms and qualitative/quantitative trends of Figs. 4-10.

## Current main script

**`hold_scheduling_simulation.py`** — the team's corrected version. Earlier
drafts were moved to Trash after this version was verified to work.

### Setup
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Running
```bash
python hold_scheduling_simulation.py                    # quick profile, all figures
python hold_scheduling_simulation.py --profile paper     # matches paper's scale (512s, 50k slots, N up to 256)
python hold_scheduling_simulation.py --experiments figure4 figure7
```
`plt.show()` is used directly — needs a display. For headless runs (or to view
plots as PNGs inside VS Code's Explorer), use `run_headless.py`, which
monkeypatches `plt.show` to save each figure under `figures/` instead.

## Review history (see full review in chat)

The corrected script fixes three real bugs identified in an earlier review of
the first-draft script:

1. **Fig.7 throughput ratio** — now measured only over the window where all
   8 flows are simultaneously active (`all_flows_active_mask`), instead of
   averaging in the long zero-stretches after fast flows finish. Verified:
   HOLD's ratio now comes out ≈0.435, matching the paper's 0.444 target.
   (Note: QMW/F-D-MW report `NaN` in this table — under those schedulers one
   flow finishes before all 8 are ever simultaneously warmed up, so no valid
   window exists. This is an honest gap, not a bug.)
2. **Fig.8/9 measurement duration** — raised to 512s in the `paper` profile,
   matching the paper's explicitly stated value.
3. **Fig.10 slot count** — raised to 50,000 in the `paper` profile, matching
   the paper's x-axis range; plot is now log-scale as in the original.

Two items were checked for being "tuned to look right" rather than genuine:

- **Fig.7's shorter RTT (0.01s vs the file's 0.10s default)** — tested by
  reverting to 0.10s: results were nearly identical (HOLD ratio 0.4353 either
  way). The RTT change was **not actually necessary**; the code comment
  claiming it's required for the starvation effect to appear is not
  accurate, though it's disclosed, not hidden, and doesn't affect results.
- **Fig.9's y-axis (`ylim=(2.8e6, 4.02e6)`, comment: "same range as the
  article")** — the numeric range is real (our sim's homogeneous throughput
  genuinely tops out at 2.8-4.0 Mbps due to the {2,3,4}Mbps rate set), but
  the paper's own Fig.9 axis is ×10⁸ (280-400 Mbps) — 100x larger. Matplotlib
  still shows the "1e6" exponent honestly, so it's not hidden, but the
  absolute scale still does not match the paper.

Everything else (HOLD/QMW/F-D-MW/MR/PF scheduling logic, Fig.6's HOL-delay
convergence, Fig.8's fairness trends) checked out as genuine, unmodified
simulation output.

## Folder contents

- `hold_scheduling_simulation.py` — current, corrected script (use this).
- `requirements.txt` — numpy, matplotlib.
- `run_headless.py` — runs the script and saves each figure as a PNG under
  `figures/` instead of popping up `plt.show()` windows (useful headless, or
  to view plots directly in VS Code's file explorer).
- `reference_figures/`, `reference_results/` — a sample quick-profile run's
  PNGs and CSV summaries, for comparison when you make changes.
