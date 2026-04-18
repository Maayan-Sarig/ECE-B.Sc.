import numpy as np
import matplotlib.pyplot as plt
import math


def projection_coef(x_t, mat, T):
    interval = np.linspace(0, T, len(x_t))
    basis_dim = mat.shape[1]
    c = np.zeros(basis_dim, dtype=complex)

    for n in range(basis_dim):
        c[n] = np.trapz(x_t * np.conj(mat[:, n]), interval) \
               / np.trapz(np.abs(mat[:, n]) ** 2, interval)

    return c


def triangularPulse(x):
    return (np.abs(x) <= 1) * (1 - np.abs(x))


def rectangular_pulse(x):
    return np.where(np.abs(x) < 0.5, 1, np.where(np.abs(x) == 0.5, 0.5, 0))




if __name__ == '__main__':

    # Q1
    # 1A
    wm = 3 * np.pi
    t = np.arange(0.2, 3, 0.01)  # 0.01 is 1/T_s = f_s
    x = 4 / (wm * np.pi * t ** 2) * (np.sin(wm * t)) ** 2. * (np.cos(wm * t)) * (np.sin(2 * wm * t))



    ##plot
    plt.plot(t, x, label='x(t)', color='blue')
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('1A - Plot of x(t)')
    plt.legend()
    plt.grid(True)
    plt.show()

    # 1B

    w_min, w_max = -17 * np.pi, 17 * np.pi
    w = np.linspace(w_min, w_max, 2000)

    X_f = (1 / 1j) * (-1*(triangularPulse((w + 3 * wm) / (2 * wm))) - \
                        triangularPulse((w + wm) / (2 * wm)) + \
                        triangularPulse((w - wm) / (2 * wm)) + \
                        triangularPulse((w - 3 * wm) / (2 * wm)))

    plt.plot(w, np.abs(X_f), label='|X(ω)|', color='green')
    plt.xlabel('ω [rad/s]')
    plt.ylabel('|X_F(ω)|')
    plt.title('1B - Absolute Value of X$^{F}$(w)')
    plt.grid(True)
    plt.legend()
    plt.show()

    # 1C

    T_s = 1 / 15
    w_s = (2 * np.pi) / T_s
    t_sample = np.arange(0.2, 3, T_s)  # the points where the signal is sampled
    x_sampled = 4 / (wm * np.pi * t_sample ** 2) * (np.sin(wm * t_sample)) ** 2 * (np.cos(wm * t_sample)) * (
        np.sin(2 * wm * t_sample))

    # ZOH
    t_ZOH = t
    x_ZOH = np.zeros_like(t)
    for i in range(len(t_sample) - 1):
        x_ZOH[(t >= t_sample[i]) & (t < t_sample[i + 1])] = x_sampled[i]
    x_ZOH[t >= t_sample[-1]] = x_sampled[-1]  # Last interval

    plt.plot(t, x, label='$x(t)$', color='blue')
    plt.plot(t, x_ZOH, label='$x_{ZOH}(t)$ ', color='orange', linestyle='--')
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('1C - Zero Order Hold (ZOH)')
    plt.legend()
    plt.grid(True)
    plt.show()

    #1D

    x_F_ZOH = np.zeros_like(w, dtype=complex)
    for k in range(-5, 6):
        x_F_ZOH += (triangularPulse((w - 3 * wm - k * w_s) / (2 * wm)) - triangularPulse((w + wm - k * w_s) / (2 * wm))
                    + triangularPulse((w - wm - k * w_s) / (2 * wm)) - triangularPulse(
                    (w + 3 * wm - k * w_s) / (2 * wm)))

    x_F_ZOH = (1 / 1j) * np.sinc((w * T_s) / (2 * np.pi)) * np.exp(-1j * w * T_s / 2) * x_F_ZOH

    plt.plot(w, np.abs(x_F_ZOH), label='|X_F_zoh(ω)|', color='green')
    plt.xlabel('ω [rad/s]')
    plt.ylabel('|X_F(ω)|')
    plt.title('1D - Absolute Value of  X$^{F}_{zoh}$(ω)')
    plt.grid(True)
    plt.legend()
    plt.show()

    #1E
    fs = 1 / T_s
    omega_s = 2 * np.pi * fs
    omega = w
    H_filter = np.where(np.abs(omega) <= omega_s / 2, np.exp(1j * np.pi * omega / omega_s) / np.sinc(omega / omega_s), 0)
    x_F_rec = x_F_ZOH * H_filter
    t_rec = t
    x_rec = np.zeros_like(t_rec, dtype=complex)

    for i, t_val in enumerate(t_rec):  # Inverse FT using trapz
        integrand = x_F_rec * np.exp(1j * omega * t_val)
        x_rec[i] = np.trapz(integrand, omega) / (2 * np.pi)

    x_rec = x_rec.real  # take real part

    plt.plot(t, x, label='$x(t)$ ', color='blue')
    plt.plot(t, x_rec, label='$x_{rec}(t)$ ', color='orange', linestyle='-.')
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('1E - Reconstruction of x(t), $ω_{s}$ = 10$ω_{m}$ ')
    plt.legend()
    plt.grid(True)
    plt.show()

    #1F

    new_w_s = 9 * wm
    new_T_s = (2 * np.pi) / new_w_s
    new_f_s = 1 / new_T_s

    H2 = np.where(np.abs(omega) <= new_w_s / 2, np.exp(1j * np.pi * omega / new_w_s) / np.sinc(omega / new_w_s), 0)
    x_F_rec2 = x_F_ZOH * H2  # multiplication in the freq domain
    t_rec2 = t
    x_rec2 = np.zeros_like(t_rec, dtype=complex)

    for i, t_val in enumerate(t_rec):  # Inverse FT using trapz
        integrand = x_F_rec2 * np.exp(1j * omega * t_val)
        x_rec2[i] = np.trapz(integrand, omega) / (2 * np.pi)

    x_rec2 = x_rec2.real  # take real part

    plt.plot(t, x, label='$x(t)$ ', color='blue')
    plt.plot(t, x_rec2, label='$x_{rec}(t)$ ', color='orange', linestyle='-.')
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('1F - Reconstruction of x(t), $ω_{s}$ = 9$ω_{m}$')
    plt.legend()
    plt.grid(True)
    plt.show()

    #Q2

    #2A
    w_A = 7 * np.pi
    w_B = 4 * np.pi
    T = 2
    w0 = (2 * np.pi) / T
    n_sample = 15
    t_continuous = np.linspace(0, T, 1000)
    x = 5 * (np.cos(w_A * t_continuous)) - 3 * (np.sin(w_B * t_continuous))

    # x sampled
    t_s = np.linspace(T / n_sample, T, n_sample)
    x_s = 5 * (np.cos(w_A * t_s)) - 3 * (np.sin(w_B * t_s))

    # create figure
    plt.figure()

    # Continuous signal x(t)
    plt.plot(t_continuous, x, label='$x(t)$ ', color='blue')

    # Discrete sampled signal x_s
    plt.stem(t_s, x_s, linefmt='r--', markerfmt='ro', basefmt='k-', label='$x_s[n]$')
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2A Uniform Sampling- $x(t)$ and $x_{s}[n]$')
    plt.legend()
    plt.grid(True)
    plt.show()

    #2B
    # FS matrix
    M = 7
    F = np.zeros((n_sample, 2 * M + 1), dtype=complex)
    for n in range(n_sample):
        for m in range(-M, M + 1):
            F[n, m + M] = np.exp(1j * m * w0 * t_s[n])

    a = np.linalg.inv(F) @ x_s

    print("Fourier coefficients:")
    for k in range(-M, M + 1):
        print(f"a[{k}]) = {a[k + M]:.4f}")

    x_rec = np.zeros_like(t_continuous, dtype=complex)
    for k in range(-M, M + 1):
        x_rec += a[k + M] * np.exp(1j * k * w0 * t_continuous)

    x_rec = x_rec.real
    #2C

    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$ ', color='blue')
    plt.plot(t_continuous, x_rec, label='$x_{rec}(t)$ ', color='red', linestyle='--')
    plt.xlim(0, 2)
    plt.ylim(-8, 8)
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2C - Uniform Sampling - $x(t)$ and the reconstructed $x_{rec}(t)$')
    plt.legend()
    plt.grid(True)
    plt.show()

    # 2D - Random Sampling: Repeat A->C
    #2A again1

    t_s_rand = np.sort(T * np.random.rand(n_sample))  # random points in [0, T]
    x_s_rand = 5 * np.cos(w_A * t_s_rand) - 3 * np.sin(w_B * t_s_rand)

    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$ ', color='blue')
    plt.stem(t_s_rand, x_s_rand, linefmt='g--', markerfmt='go', basefmt='k-', label='$x_{s}[n]$ ')
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2D-A - Random Sampling: $x(t)$ and $x_{s}[n]$')
    plt.legend()
    plt.grid(True)
    plt.show()

    #2B again1
    # recreate matrix
    F_rand = np.zeros((n_sample, 2 * M + 1), dtype=complex)
    for n in range(n_sample):
        for m in range(-M, M + 1):
            F_rand[n, m + M] = np.exp(1j * m * w0 * t_s_rand[n])

    a_rand = np.linalg.inv(F_rand) @ x_s_rand

    print("Fourier coefficients (Random Sampling 2D-B):")
    for k in range(-M, M + 1):
        print(f"a[{k}] = {a_rand[k + M]:.4f}")

    # 2C again1

    x_rec_rand = np.zeros_like(t_continuous, dtype=complex)
    for k in range(-M, M + 1):
        x_rec_rand += a_rand[k + M] * np.exp(1j * k * w0 * t_continuous)

    x_rec_rand = x_rec_rand.real

    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$ ', color='blue')
    plt.plot(t_continuous, x_rec_rand, label='$x_{rec}(t)$ ', color='green', linestyle='-.')
    plt.xlim(0, 2)
    plt.ylim(-8, 8)
    plt.xlabel('Time [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2D-C - Random Sampling: $x(t)$ and the reconstructed $x_{rec}(t)$')
    plt.legend()
    plt.grid(True)
    plt.show()

    #2E - Sampling Uncertainty
    t_s_uncertain_rand = t_s_rand + (0.01 * np.random.rand(n_sample))
    x_s_uncertain_rand = 5 * (np.cos(w_A * t_s_rand)) - 3 * (np.sin(w_B * t_s_rand))
    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$ ', color='blue')
    plt.stem(t_s_uncertain_rand, x_s_uncertain_rand, linefmt='m-', markerfmt='mo', basefmt='k-', label='$x_{s}^{uncertain}[n]$')
    plt.xlim(0, 2)
    plt.ylim(-8, 8)
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2E- Sampling Uncertainty [n=15] - $x(t)$ and $x_{uncertain}[n]$')
    plt.legend()
    plt.grid(True)
    plt.show()

    # question 2e - d fourier matrix uncertain random sampling
    F_uncertain_rand = np.zeros((n_sample, 2 * M + 1), dtype=complex)
    for n in range(n_sample):
        for m in range(-M, M + 1):
            F_uncertain_rand[n, m + M] = np.exp(1j * m * w0 * t_s_uncertain_rand[n])

    a_uncertain_rand = np.linalg.inv(F_uncertain_rand) @ x_s_uncertain_rand

    # condition number
    cond_original = np.linalg.cond(F)
    cond_uncertain_rand = np.linalg.cond(F_uncertain_rand)

    print(f"Condition number of F (Original): {cond_original:.4f}")
    print(f"Condition number of F (Uncertain with random sampling): {cond_uncertain_rand:.4f}")

    print("Fourier coefficients uncertainty and random sampling:")
    for k in range(-M, M + 1):
        print(f"a[{k}] = {a_uncertain_rand[k + M]:.7f}")

    # 2E - D
    x_rec_uncertain_rand = np.zeros_like(t_continuous, dtype=complex)
    for k in range(-M, M + 1):
        x_rec_uncertain_rand += a_uncertain_rand[k + M] * np.exp(1j * k * w0 * t_continuous)

    x_rec_uncertain_rand = x_rec_uncertain_rand.real

    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$', color='blue')
    plt.plot(t_continuous, x_rec_uncertain_rand, label='$x_{rec}^{uncertain}(t)$',
             color='m', linestyle='--')
    plt.xlim(0, 2)
    plt.ylim(-40, 40)
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2E-D - Sampling Uncertainty [n=15] - $x(t)$ and the reconstructed $x_{rec}^{uncertain}(t)$')
    plt.legend()
    plt.grid(True)
    plt.show()

    # 2F
    # question 2 a again 40 samples
    new_N_samples = 40
    new_t_s_rand = np.sort(T * np.random.rand(new_N_samples))
    new_t_s_uncertain_rand = new_t_s_rand + (0.01 * np.random.rand(new_N_samples))
    new_x_s_uncertain_rand = 5 * np.cos(w_A * new_t_s_rand) - 3 * np.sin(w_B * new_t_s_rand)

    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$ ', color='blue')
    plt.stem(new_t_s_uncertain_rand, new_x_s_uncertain_rand, linefmt='c-', markerfmt='co', basefmt='k-',
             label='$x_{uncertain}[n]$')
    plt.xlim(0, 2)
    plt.ylim(-8, 8)
    plt.xlabel('t [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2F - Sampling Uncertainty [n=40] - $x(t)$ and $x_{uncertain}[n]$')
    plt.legend()
    plt.grid(True)
    plt.show()

    # question 2 b again 40 samples
    # fourier matrix
    new_F_uncertain_rand = np.zeros((new_N_samples, 2 * M + 1), dtype=complex)
    for n in range(new_N_samples):
        for m in range(-M, M + 1):
            new_F_uncertain_rand[n, m + M] = np.exp(1j * m * w0 * new_t_s_uncertain_rand[n])

    new_a_uncertain_rand, _, _, _ = np.linalg.lstsq(new_F_uncertain_rand, new_x_s_uncertain_rand,
                                                    rcond=None)

    # cond num
    cond_original = np.linalg.cond(F)
    new_cond_uncertain_rand = np.linalg.cond(new_F_uncertain_rand)

    print(f"Condition number of F (Original): {cond_original:.4f}")
    print(f"Condition number of F (Uncertain with 40 random sampling): {new_cond_uncertain_rand:.4f}")

    print("Fourier coefficients (uncertainty and random sampling):")
    for k in range(-M, M + 1):
        print(f"a[{k}] = {new_a_uncertain_rand[k + M]:.7f}")

    # question 2c again 40 samples - reconstruction
    new_x_rec_uncertain_rand = np.zeros_like(t_continuous, dtype=complex)
    for k in range(-M, M + 1):
        new_x_rec_uncertain_rand += new_a_uncertain_rand[k + M] * np.exp(1j * k * w0 * t_continuous)

    new_x_rec_uncertain_rand = new_x_rec_uncertain_rand.real

    plt.figure()
    plt.plot(t_continuous, x, label='$x(t)$', color='blue')
    plt.plot(t_continuous, new_x_rec_uncertain_rand,
             label='$x_{rec}^{uncertain}(t)$ ',
             color='cyan', linestyle='--')
    plt.xlim(0, 2)
    plt.ylim(-20, 20)
    plt.xlabel('Time [s]')
    plt.ylabel('x(t) [V]')
    plt.title('2F - 40 Samples - $x(t)$ and the reconstructed $x_{rec}(t)$')
    plt.legend()
    plt.grid(True)
    plt.show()

    #Q3

    #3A - fourier coefs function

    #3B
    # functions
    T = 10
    phi_n_range = range(-20, 21)
    psi_n_range = range(0, 20)
    t = np.linspace(0, T, 1001)
    f_t = 4 * np.cos((4 * np.pi / T) * t) + np.sin((10 * np.pi / T) * t)
    g_t = 2 * np.sign(np.sin((6 * np.pi / T) * t)) - 4 * np.sign(np.sin((4 * np.pi / T) * t))
    phi_lim, phi_time = np.meshgrid(phi_n_range, t)
    phi_Mbase = np.exp((1j * 2 * np.pi / T) * phi_lim * phi_time)

    c_n_f_phi = projection_coef(f_t, phi_Mbase, T)

    print("Projection Coefficients [f(t) and phi(t)] c_n for n = -20 -> 20:")
    for n, coeff in zip(phi_n_range, c_n_f_phi):
        print(f"n = {n:>3}: c_n = {coeff.real:.4f} + {coeff.imag:.4f}i")

    c_n_g_phi = projection_coef(g_t, phi_Mbase, T)

    print("Projection Coefficients[g(t) and phi(t)] c_n for n = -20 -> 20:")
    for n, coeff in zip(phi_n_range, c_n_g_phi):
        print(f"n = {n:>3}: c_n = {coeff.real:.4f} + {coeff.imag:.4f}j")

    psi_lim, psi_time = np.meshgrid(psi_n_range, t)
    psi_Mbase = rectangular_pulse((psi_time * (20 / T) - (psi_lim + 0.5)))

    c_n_f_psi = projection_coef(f_t, psi_Mbase, T)

    print("Projection Coefficients[f(t) and psi(t)] c_n for n = 0 -> 20:")
    for n, coeff in zip(psi_n_range, c_n_f_psi):
        print(f"n = {n:>3}: c_n = {coeff.real:.4f} + {coeff.imag:.4f}j")

    c_n_g_psi = projection_coef(g_t, psi_Mbase, T)

    print("Projection Coefficients[g(t) and psi(t)] c_n for n = 0 to 20:")
    for n, coeff in zip(psi_n_range, c_n_g_psi):
        print(f"n = {n:>3}: c_n = {coeff.real:.4f} + {coeff.imag:.4f}j")

    #3C

    rec_f_phi = np.sum(c_n_f_phi * phi_Mbase, axis=1).real
    rec_g_phi = np.sum(c_n_g_phi * phi_Mbase, axis=1).real
    rec_f_psi = np.sum(c_n_f_psi * psi_Mbase, axis=1).real
    rec_g_psi = np.sum(c_n_g_psi * psi_Mbase, axis=1).real

    plt.figure(figsize=(12, 8))

    # Signal f(t) and reconstructions
    plt.subplot(2, 1, 1)
    plt.plot(t, f_t, 'b', label='f(t)')
    plt.plot(t, rec_f_phi, '--g', linewidth=2.5, label='$f_{rec_φ}(t)$')
    plt.plot(t, rec_f_psi, '--r', linewidth=1.5, label='$f_{rec_ψ}(t)$')
    plt.xlim(0, 10)
    plt.title('3C - f(t) and reconstruction by φ and ψ')
    plt.xlabel('t [s]')
    plt.ylabel('f(t) [V]')
    plt.legend()
    plt.grid()

    # Signal g(t) and reconstructions
    plt.subplot(2, 1, 2)
    plt.plot(t, g_t, 'b', label='g(t)')
    plt.plot(t, rec_g_phi, '--g', linewidth=2.5, label='$g_{rec_φ}(t)$')
    plt.plot(t, rec_g_psi, '--r', linewidth=1.5, label='$g_{rec_ψ}(t)$')
    plt.xlim(0, 10)
    plt.title('3C - g(t) and reconstruction by φ and ψ')
    plt.xlabel('t [s]')
    plt.ylabel('g(t) [V]')
    plt.legend()
    plt.grid()

    plt.tight_layout()
    plt.show()
