import numpy as np


def euler(f, a: float, b: float, initial_cond: float, N=None, h=None):
    if N is None and h is None:
        raise ValueError
    if N is not None and h is not None and h != ((b - a) / N):
        raise ValueError
    if h is None:
        h = (b - a) / N
    if N is None:
        N = (b - a) / h
    t = np.arange(a, b + h, h)
    y = np.zeros(len(t), dtype=float)
    y[0] = initial_cond
    for i in range(1, len(y)):
        y[i] = y[i-1] + h*f(t[i-1], y[i-1])
    return t, y
