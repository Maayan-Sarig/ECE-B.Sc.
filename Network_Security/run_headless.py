"""Headless runner: saves every figure produced by hold_all_experiments.py to PNG
instead of popping up an interactive window (there is no display here)."""
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
    "hold_all_experiments.py",
    "--profile", "quick",
    "--output-dir", "hold_results",
]

import hold_all_experiments

hold_all_experiments.main()
