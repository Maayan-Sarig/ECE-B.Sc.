"""Run hold_scheduling_simulation.py and save every figure as PNG under figures/,
instead of popping up plt.show() windows. Then just open the PNGs in VS Code's
file explorer to view them (image preview is built in, no extension needed)."""
import itertools
import sys
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

FIG_DIR = Path("figures")
FIG_DIR.mkdir(exist_ok=True)
counter = itertools.count(1)


def show_and_save(*args, **kwargs):
    n = next(counter)
    fig = plt.gcf()
    path = FIG_DIR / f"fig_{n:02d}.png"
    fig.savefig(path, dpi=110)
    print(f"[saved] {path}")
    plt.close(fig)


plt.show = show_and_save

sys.argv = [
    "hold_scheduling_simulation.py",
    "--profile", "quick",
    "--output-dir", "hold_results",
]

import hold_scheduling_simulation

hold_scheduling_simulation.main()
