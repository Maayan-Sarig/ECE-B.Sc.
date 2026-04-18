import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':

    #1A

    N = 30
    theta1 = np.pi/10.25
    theta2 = 2*np.pi/5
    n = np.arange(0,N)

    s_n = 2*np.cos(theta1*n)
    v_n = 3*np.sin(theta2*n)
    x_n = s_n + v_n

    S_k = np.fft.fft(s_n)
    V_k = np.fft.fft(v_n)
    X_k = S_k + V_k

    # Plotting in Time Domain

    plt.plot(n, x_n, label='$x[n]$', color='blue')
    plt.plot(n, s_n, label='$s[n]$', color='red')
    plt.plot(n, v_n, label='$v[n]$', color='green')
    plt.xlabel('n')
    plt.ylabel('Signal Amplitude')
    plt.title('1A - Plotting Signals')
    plt.legend()
    plt.grid(True)
    plt.show()


    #Plotting in Frequency Domain

    plt.stem(n, abs(X_k), linefmt='b--', markerfmt='bo', basefmt='k-', label='$X^{d}[k]$')
    plt.stem(n, abs(S_k), linefmt='r--', markerfmt='ro', basefmt='k-', label='$S^{d}[k]$')
    plt.stem(n, abs(V_k), linefmt='g--', markerfmt='go', basefmt='k-', label='$V^{d}[k]$')
    plt.xlabel('k')
    plt.ylabel('FFT Magnitude')
    plt.title('1A - Plotting FFT ')
    plt.legend()
    plt.grid(True)
    plt.show()

    #1B
    pad = 15
    N2 = N+pad
    n2 = np.arange(0,N2)
    xz_n = np.pad(x_n, (0,pad), mode='constant', constant_values=0)

    Xz_k = np.fft.fft(xz_n)

    plt.stem(n*(2*np.pi/N), abs(X_k), linefmt='b--', markerfmt='bo', basefmt='k-', label='$X^{d}[k]$')
    plt.stem(n2*(2*np.pi/N2), abs(Xz_k), linefmt='r--', markerfmt='ro', basefmt='k-', label='$X_{z}^{d}[k]$')
    plt.xlabel('θ [rad]')
    plt.ylabel('FFT Magnitude')
    plt.title('1B - Zero-Padding Comparison ')
    plt.legend()
    plt.grid(True)
    plt.show()

    #1C

    s2_n = 2 * np.cos(theta1 * n2)
    v2_n = 3 * np.sin(theta2 * n2)
    x2_n = s_n + v_n

    S2_k = np.fft.fft(s2_n)
    V2_k = np.fft.fft(v2_n)
    X2_k = S2_k + V2_k

    plt.stem(n*(2*np.pi/N), abs(X_k), linefmt='b--', markerfmt='bo', basefmt='k-', label='$X^{d}[k]$')
    plt.stem(n2*(2*np.pi/N2), abs(X2_k), linefmt='r--', markerfmt='ro', basefmt='k-', label='$X_{2}^{d}[k]$')
    plt.xlabel('k')
    plt.ylabel('FFT Magnitude')
    plt.title('1C - Additional Sampling Points')
    plt.legend()
    plt.grid(True)
    plt.show()

    #1D

    parseval_x_n = sum((abs(x_n)*abs(x_n)))
    parseval_X_k = 1/len(X_k)*sum((abs(X_k)*abs(X_k)))



    parseval_xz_n = sum((abs(xz_n) * abs(xz_n)))
    parseval_Xz_k = 1 / len(Xz_k) * sum((abs(Xz_k) * abs(Xz_k)))

    print('Parseval for X[n]:')
    print(parseval_x_n)
    print(parseval_X_k)

    print('Parseval for X_{z}[n]:')
    print(parseval_xz_n)
    print(parseval_Xz_k)


    #1E

    theta = np.arange(0,2*np.pi,0.01)
    H1 = 1/3*(1+np.exp(-1j*theta)+np.exp(-2j*theta))

    plt.stem(n * (2 * np.pi / N), abs(X_k)/max(abs(X_k)), linefmt='b--', markerfmt='bo', basefmt='k-', label='$X^{d}[k]$')
    plt.plot(theta, abs(H1)/max(abs(H1)), label='$H_{1}^{f}[θ]$', color='red')
    plt.xlabel('θ [rad]')
    plt.ylabel('Frequency Domain Magnitude')
    plt.title('1E - $H_{1}^{f}[θ]$ and $X^{d}[k]$ ')
    plt.legend()
    plt.grid(True)
    plt.show()

    #Calculating Y1 from the circular convolution of H, X:
    N3 = 32
    n3 = np.arange(0,N3)
    h1_n = 1/3*(np.equal(n,0)+np.equal(n,1)+np.equal(n,2))

    h1a_n = np.pad(h1_n, (0,2),mode='constant', constant_values=0)
    xa_n = np.pad(x_n, (0,2),mode='constant', constant_values=0)

    H1a_k = np.fft.fft(h1a_n)
    Xa_k = np.fft.fft(xa_n)
    Y1_k = H1a_k*Xa_k

    y1_n = np.fft.ifft(Y1_k)

    plt.stem(n*(2*np.pi/N), abs(X_k), linefmt='b--', markerfmt='bo', basefmt='k-', label='$|X^{d}[k]$|')
    plt.stem(n3*(2*np.pi/N3), abs(Y1_k), linefmt='r--', markerfmt='ro', basefmt='k-', label='$|Y_{1}^{d}[k]$|')
    plt.xlabel('k')
    plt.ylabel('FFT Magnitude')
    plt.title('1E - $|X^{d}[k]|$ and $|Y_{1}^{d}[k]|$')
    plt.legend()
    plt.grid(True)
    plt.show()

    plt.plot(n, x_n, label='$x[n]$', color='blue')
    plt.plot(n, s_n, label='$s[n]$', color='red')
    plt.plot(n, v_n, label='$v[n]$', color='green')
    plt.plot(n, y1_n[0:N], label='$y_{1}[n]$', color='orange')
    plt.xlabel('n')
    plt.ylabel('Signal Amplitude')
    plt.title('1E - Plotting all Signals')
    plt.legend()
    plt.grid(True)
    plt.show()

    #1F - H2

    H2 = 1 + np.exp(-1j * theta)

    plt.stem(n * (2 * np.pi / N), abs(X_k) / max(abs(X_k)), linefmt='b--', markerfmt='bo', basefmt='k-',
             label='$X^{d}[k]$')
    plt.plot(theta, abs(H2) / max(abs(H2)), label='$H_{2}^{f}[θ]$', color='red')
    plt.xlabel('θ [rad]')
    plt.ylabel('Frequency Domain Magnitude')
    plt.title('1F - $H_{2}^{f}[θ]$ and $X^{d}[k]$ ')
    plt.legend()
    plt.grid(True)
    plt.show()


    h2_n = np.equal(n, 0) + np.equal(n, 1)

    h2a_n = np.pad(h1_n, (0, 1), mode='constant', constant_values=0)
    x2a_n = np.pad(x_n, (0, 1), mode='constant', constant_values=0)

    H2a_k = np.fft.fft(h2a_n)
    X2a_k = np.fft.fft(x2a_n)
    Y2_k = H2a_k * X2a_k

    y2_n = np.fft.ifft(Y2_k)

    plt.plot(n, x_n, label='$x[n]$', color='blue')
    plt.plot(n, s_n, label='$s[n]$', color='red')
    plt.plot(n, v_n, label='$v[n]$', color='green')
    plt.plot(n, y2_n[0:N], label='$y_{2}[n]$', color='orange')
    plt.xlabel('n')
    plt.ylabel('Signal Amplitude')
    plt.title('1F - Plotting all Signals')
    plt.legend()
    plt.grid(True)
    plt.show()
























