clc;
clear all;
close all;

%------------------ QUESTION 1 ---------------------

A_1 = 1;
f_1 = 1;
A_2 = 2;
f_2 = 2.5;
A_c = 2;
f_c = 25;
A = 3;
k_f = 1;
f_s = 3.34e3;
t = -3:1/f_s:3;
N = length(t);
f = (-N/2 : N/2-1)*(f_s/N);

%---- Channels -----
K_1 = 1; % 0[dB]
K_2 = 1/sqrt(10); % -10[dB]
t_1 = 4.8e-3;
t_2 = 14.4e-3;
B = 5; % B = 2f_max , f_max = 2.5


%---- Question 1.2.1 -----
Vm = A_1*sin(2*pi*f_1*t)+A_2*sin(2*pi*f_2*t);
Vc = A_c*cos(2*pi*f_c*t);

%---- Question 1.2.1.1 -----
figure(1); 
sgtitle('Question 1.2.1.1');

subplot(2,1,1);
plot(t,Vm,"LineWidth",1);
title('V_m( t ) Data Signal'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [V]','FontSize',12);
legend({'V_m(t)'});


subplot(2,1,2);
plot(t,Vc,"LineWidth",1);
title('V_c( t ) Carrier Signal'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [V]','FontSize',12);
legend({'V_c(t)'});
grid on;
xlim([-0.2 0.2]);


%---- Question 1.2.1.2 -----
function Vsc = DSB_SC_Mod(Vm,Vc)
    Vsc = Vm.*Vc;
end

Vsc = DSB_SC_Mod(Vm,Vc);
F_Vsc = fftshift(fft(Vsc,N))/f_s;

figure(2); 
sgtitle('Question 1.2.1.2');

subplot(2,1,1);
plot(t,Vsc,"LineWidth",1);
title('V_{sc}( t ) DSB-SC Time Domain'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [V]','FontSize',12);
legend({'V_{sc}(t)'});
grid on;
xlim([-0.2 0.2]);
ylim([-6 6]);

subplot(2,1,2);
plot(f, abs(F_Vsc),"LineWidth",1);
title('|V_{sc}( f )| DSB-SC Magnitude'); xlabel('f [Hz]','FontSize',12); ylabel('|V_{sc}(f)|','FontSize',12);
legend({'|V_{sc}(f)|'});
grid on;
xlim([-40 40]);
ylim([0 7]);

%---- Question 1.2.1.3 -----
function V_LC = DSB_LC_Mod(Vm,Vc,A)
    V_LC = (A+Vm).*Vc;
end

V_LC = DSB_LC_Mod(Vm,Vc,A);
F_V_LC = fftshift(fft(V_LC,N))/f_s;

figure(3); 
sgtitle('Question 1.2.1.3');

subplot(2,1,1);
plot(t,V_LC,"LineWidth",1);
title('V_{LC}( t ) DSB-LC Time Domain'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [V]','FontSize',12);
legend({'V_{LC}(t)'});
grid on;
xlim([-0.5 0.5]);

subplot(2,1,2);
plot(f, abs(F_V_LC),"LineWidth",1);
title('|V_{LC}( f )| DSB-LC Magnitude'); xlabel('f [Hz]','FontSize',12); ylabel('|V_{LC}(f)|','FontSize',12);
legend({'|V_{LC}(f)|'});
grid on;
xlim([-40 40]);
ylim([0 20]);

%---- Question 1.2.1.4 -----
function V_FM = FM_Mod(Vm,Vc,k_f,f_s)
    dt = 1/f_s;
    Phi = 2*pi*k_f*cumtrapz(Vm)*dt;
    Vc_sin = imag(hilbert(Vc));
    V_FM = Vc.*cos(Phi)-Vc_sin.*sin(Phi);
end

V_FM = FM_Mod(Vm,Vc,k_f,f_s);
F_V_FM = fftshift(fft(V_FM,N))/f_s;

figure(4); 
sgtitle('Question 1.2.1.4');

subplot(2,1,1);
plot(t,V_FM,"LineWidth",2);
title('V_{FM}( t )'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [V]','FontSize',12);
legend({'V_{FM}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(2,1,2);
plot(f, abs(F_V_FM),"LineWidth",1);
title('|V_{FM}( f )| FM - Magnitude '); xlabel('f [Hz]','FontSize',12); ylabel('|V_{FM}(f)|','FontSize',12);
legend({'|V_{FM}(f)|'});
grid on;
xlim([-40 40]);

%---- Question 1.2.2.1 -----

Pch = ((K_1^2)+(K_2^2))*((A_c^2)*((A_1^2)+(A_2^2))/4)+(K_1*K_2*(A_c^2)/2)*((A_1^2)*cos(2*pi*f_1*(t_2-t_1))+(A_2^2)*cos(2*pi*f_2*(t_2-t_1)))*cos(2*pi*f_c*(t_2-t_1));
SNR1 = 0.1;
SNR2 = 1;
SNR3 = 10;

N1 = Pch/(B*SNR1);
N2 = Pch/(B*SNR2);
N3 = Pch/(B*SNR3);

z_1 = sqrt(N1/2)*randn(1,length(t));
z_2 = sqrt(N2/2)*randn(1,length(t));
z_3 = sqrt(N3/2)*randn(1,length(t));

%---- Question 1.2.2.2 -----


x_sc_1 = Vsc + z_1;
x_sc_2 = Vsc + z_2;
x_sc_3 = Vsc + z_3;

F_X_sc_1 = fftshift(fft(x_sc_1,N))/f_s;
F_X_sc_2 = fftshift(fft(x_sc_2,N))/f_s;
F_X_sc_3 = fftshift(fft(x_sc_3,N))/f_s;


delay_samples_1 = round(t_1 * f_s);
delay_samples_2 = round(t_2 * f_s);

max_delay = max(delay_samples_1, delay_samples_2);
h_ch = zeros(1, max_delay + 1);

h_ch(delay_samples_1 + 1) = K_1; 
h_ch(delay_samples_2 + 1) = K_2;

x_r_sc_ch_3 = conv(Vsc, h_ch,'same') + z_3;


F_X_sc_ch_3 = fftshift(fft(x_r_sc_ch_3,N))/f_s;

figure(5); 
sgtitle('Question 1.2.2.2 - Time Domain');

subplot(2,2,1);
plot(t, x_sc_1,"LineWidth",1);
title('x_{sc}( t ) Time Domain - Noise -10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'x_{sc}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(2,2,2);
plot(t, x_sc_2,"LineWidth",1);
title('x_{sc}( t ) Time Domain - Noise 0 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'x_{sc}( t )'});
grid on;
xlim([-0.2 0.2]);

subplot(2,2,3);
plot(t, x_sc_3,"LineWidth",1);
title('x_{sc}( t ) Time Domain - Noise 10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'x_{sc}( t )'});
grid on;
xlim([-0.2 0.2]);

subplot(2,2,4);
plot(t, x_r_sc_ch_3 ,"LineWidth",1);
title('x_{sc- ch}( t ) Time Domain - Noise 10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'x_{sc}( t )'});
grid on;
xlim([-0.2 0.2]);




figure(6); 
sgtitle('Question 1.2.2.2 - Magnitude');

subplot(2,2,1);
plot(f, abs(F_X_sc_1),"LineWidth",1);
title('|X_{sc}( f )| Magnitude - Noise -10 [dB]'); xlabel('f [Hz]','FontSize',12); ylabel('|X_{sc}(f)|','FontSize',12);
legend({'|X_{sc}(f)|'});
grid on;
xlim([-40 40]);
ylim([0 8]);

subplot(2,2,2);
plot(f, abs(F_X_sc_2),"LineWidth",1);
title('|X_{sc}( f )| Magnitude - Noise 0 [dB]'); xlabel('f [Hz]','FontSize',12); ylabel('|X_{sc}(f)|','FontSize',12);
legend({'|X_{sc}(f)|'});
grid on;
xlim([-40 40]);
ylim([0 8]);

subplot(2,2,3);
plot(f, abs(F_X_sc_3),"LineWidth",1);
title('|X_{sc}( f )| Magnitude - Noise 10 [dB]'); xlabel('f [Hz]','FontSize',12); ylabel('|X_{sc}(f)|','FontSize',12);
legend({'|X_{sc}(f)|'});
grid on;
xlim([-40 40]);
ylim([0 10]);

subplot(2,2,4);
plot(f, abs(F_X_sc_ch_3),"LineWidth",1);
title('|X_{sc-ch}( f )| Magnitude - Noise 10 [dB]'); xlabel('f [Hz]','FontSize',12); ylabel('|X_{sc-ch}(f)|','FontSize',12);
legend({'|X_{sc-ch}(f)|'});
grid on;
xlim([-40 40]);
ylim([0 10]);

%---- Question 1.2.2.3 -----

x_lc_2 = V_LC + z_2;
x_r_lc_ch_2 = conv(V_LC, h_ch,'same') + z_2;


x_FM_2 = V_FM + z_2;
x_r_FM_ch_2 = conv(V_FM, h_ch,'same') + z_2;


figure(7); 
sgtitle('Question 1.2.2.3 - Time Domain');

subplot(2,2,1);
plot(t, x_lc_2,"LineWidth",1);
title('X_{lc}( t ) Time Domain - Noise 10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{lc}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(2,2,2);
plot(t, x_FM_2,"LineWidth",1);
title('X_{FM}( t ) Time Domain - Noise 10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{FM}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(2,2,3);
plot(t, x_r_lc_ch_2,"LineWidth",1);
title('X_{lc-ch}( t ) Time Domain - Noise 10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{lc-ch}(t)'});
grid on;
xlim([-0.2 0.2]);


subplot(2,2,4);
plot(t, x_r_FM_ch_2,"LineWidth",1);
title('X_{FM-ch}( t ) Time Domain - Noise 10 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{FM-ch}(t)'});
grid on;
xlim([-0.2 0.2]);


%---- Question 1.2.3.1 -----

w_p = 2*pi*1.2*B;
w_p_tag = w_p/2;


h_lpf = sin(w_p_tag * t) ./ (pi * t);

center_index = find(t == 0);

if ~isempty(center_index)
    h_lpf(center_index) = w_p_tag / pi;
end
h_lpf = h_lpf / sum(h_lpf);

h_bpf = 2 * h_lpf .* cos(2 * pi * f_c * t);
H_BPF = fftshift(fft(h_bpf, N)) / f_s;

figure(8); 
sgtitle('Question 1.2.3.1 - Bandpass Filter');

subplot(2,1,1);
plot(t, h_bpf, 'LineWidth', 1);
title('Question 1.2.3.1 - BPF In Time Domain'); xlabel('t [sec]'); ylabel('Amplitude [V]');
grid on;
xlim([-0.2 0.2]);

subplot(2,1,2);
plot(f, abs(H_BPF), 'LineWidth', 1);
title('Question 1.2.3.1 - Frequency Response of BPF'); xlabel('Frequency [Hz]'); ylabel('|H_{BPF}(f)|');
grid on;
xlim([-40 40]);


%---- Question 1.2.3.2 -----

x_l_sc_1 = conv(x_sc_1, h_bpf, 'same');
x_l_sc_2 = conv(x_sc_2, h_bpf, 'same');
x_l_sc_3 = conv(x_sc_3, h_bpf, 'same');


figure(9); 
sgtitle('Question 1.2.3.2');

subplot(3,1,1);
plot(t, x_l_sc_1,"LineWidth",1);
title('Filtered SC signal - Noise -10 [dB] '); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{l-sc}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(3,1,2);
plot(t, x_l_sc_2,"LineWidth",1);
title('Filtered SC signal - Noise 0 [dB] '); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{l-sc}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(3,1,3);
plot(t, x_l_sc_3,"LineWidth",1);
title('Filtered SC signal - Noise 10 [dB] '); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'X_{l-sc}(t)'});
grid on;
xlim([-0.2 0.2]);



%---- Question 1.2.3.3 -----

x_l_lc_2 = conv(x_lc_2, h_bpf, 'same');
x_l_FM_2 = conv(x_FM_2, h_bpf, 'same');

figure(10); 
sgtitle('Question 1.2.3.3');

subplot(2,1,1);
plot(t, x_l_lc_2,"LineWidth",1);
title('Filtered LC signal - Noise 0 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'x_{l-lc}(t)'});
grid on;
xlim([-0.2 0.2]);

subplot(2,1,2);
plot(t, x_l_FM_2,"LineWidth",1);
title('Filtered FM signal - Noise 0 [dB]'); xlabel('t [sec]','FontSize',12); ylabel('Amplitude [v]','FontSize',12);
legend({'x_{l-FM}(t)'});
grid on;
xlim([-0.2 0.2]);



%---- Question 1.2.3.4 -----

% ------ DSB-SC --------
demodulator_1 = x_l_sc_1 .* Vc;
demod_sc_1 = conv(demodulator_1, h_lpf, 'same');

demodulator_2 = x_l_sc_2 .* Vc;
demod_sc_2 = conv(demodulator_2, h_lpf, 'same');

demodulator_3 = x_l_sc_3 .* Vc;
demod_sc_3 = conv(demodulator_3, h_lpf, 'same');

% ------ DSB-LC --------
x_hat_l_lc_2 = imag(hilbert(x_l_lc_2));
demodulated_x_lc_2 = (sqrt(x_l_lc_2.^2 + x_hat_l_lc_2.^2) - A * A_c) / A_c;

% ------ FM --------

demodulated_x_FM = fmdemod(x_l_FM_2, f_c, f_s, k_f);

figure(11); 

sgtitle('Question 1.2.3.4 - Demodulated Signals Comparison');


% Subplot 1: DSB-SC (High Noise)
subplot(5,1,1);
plot(t, Vm, 'k', 'LineWidth', 1); hold on;
plot(t, demod_sc_1, 'c');
title('Demodulated DSB-SC (SNR = -10dB)');
legend('Original', 'Recovered'); xlim([-1 1]); grid on;

% Subplot 2: DSB-SC (Medium Noise)
subplot(5,1,2);
plot(t, Vm, 'k', 'LineWidth', 1); hold on;
plot(t, demod_sc_2, 'r');
title('Demodulated DSB-SC (SNR = 0dB)');
legend('Original', 'Recovered'); xlim([-1 1]); grid on;

% Subplot 3: DSB-SC (Low Noise)
subplot(5,1,3);
plot(t, Vm, 'k', 'LineWidth', 1); hold on;
plot(t, demod_sc_3, 'b');
title('Demodulated DSB-SC (SNR = 10dB)');
ylabel('Amplitude [v]','FontSize',12);
legend('Original', 'Recovered'); xlim([-1 1]); grid on;

% Subplot 4: DSB-LC (Envelope Detector)
subplot(5,1,4);
plot(t, Vm, 'k', 'LineWidth', 1); hold on;
plot(t, demodulated_x_lc_2, 'm');
title('Demodulated DSB-LC (Envelope Detector)');
legend('Original', 'Recovered'); xlim([-1 1]); grid on;

% Subplot 5: FM (Derivative Discriminator)
subplot(5,1,5);
plot(t, Vm, 'k', 'LineWidth', 1); hold on;
plot(t, demodulated_x_FM, 'g');
title('Demodulated FM (Differentiation)');
xlabel('Time [sec]', 'FontSize', 12);
legend('Original', 'Recovered'); xlim([-1 1]); grid on;


%------------------ QUESTION 2 ---------------------

p_s1 = 0.5;
p_s2 = 0.25;
p_s3 = 0.25;

%------------------ QUESTION 2.2.1 ---------------------

function s_t = sym_gen(p_s1, p_s2, N)
    s1 = -1;
    s2 = 0;
    s3 = 1;
    
    r_vec = rand(1, N); % Create random vector of numbers unifromly distributed on [0,1]
    s_t = zeros(1, N);

    indices_s1 = r_vec <= p_s1;
    s_t(indices_s1) = s1;

    threshold_2 = p_s1 + p_s2;
    indices_s2 = (r_vec > p_s1) & (r_vec <= threshold_2);
    s_t(indices_s2) = s2;

    indices_s3 = r_vec > threshold_2;
    s_t(indices_s3) = s3;
end

%------------------ QUESTION 2.2.2 ---------------------

tran_prob = [[0.6,0.2,0.2,0];[0.3,0.1,0.5,0.1];[0,0.25,0.4,0.35]];

function received_t = rec_gen(s_t, tran_prob)
    N = length(s_t);
    received_t = zeros(1, N);
    
    for k = 1:N
        current_symbol = s_t(k);
        
        if current_symbol == -1
            row_idx = 1;
        elseif current_symbol == 0
            row_idx = 2;
        elseif current_symbol == 1
            row_idx = 3;
        else
            error('Invalid symbol in s_t');
        end
        
        probs = tran_prob(row_idx, :); 
        
        r_val = rand;
        cdf = cumsum(probs);
        
        rec_idx = find(r_val <= cdf, 1, 'first');
        
        received_t(k) = rec_idx;
    end
end

%------------------ QUESTION 2.2.3 ---------------------
function dec_s = test_dec(received_t, type)
    N = length(received_t);
    dec_s = zeros(1,N);
    if strcmp(type, 'ML')
        for k = 1:N
            current_received = received_t(k);
            
            if current_received == 1
                dec_s(k) = -1;
            elseif current_received == 2
                dec_s(k) = 1;
            elseif current_received == 3
                dec_s(k) = 0;
            elseif current_received == 4
                dec_s(k) = 1;
            end
        end
    else
        for k = 1:N
            current_received = received_t(k);
            
            if current_received == 1
                dec_s(k) = -1;
            elseif current_received == 2
                dec_s(k) = -1;
            elseif current_received == 3
                dec_s(k) = 0;
            elseif current_received == 4
                dec_s(k) = 1;
            end
        end
    end
end


%------------------ QUESTION 2.2.4 ---------------------

N = 10000;

s_t = sym_gen(p_s1, p_s2, N);
received_t = rec_gen(s_t, tran_prob);

% ------ ML --------

s_ML = test_dec(received_t, 'ML');
errors_ML = sum(s_t ~= s_ML);
Pe_ML = errors_ML / N;

% ------ MAP --------

s_MAP = test_dec(received_t, 'MAP');
errors_MAP = sum(s_t ~= s_MAP);
Pe_MAP = errors_MAP / N;

fprintf('Pe (ML): %.4f\n', Pe_ML);
fprintf('Pe (MAP): %.4f\n', Pe_MAP);