clc;
clear all;
close all;

%---------------------------------------------------
%------------------ QUESTION 1 ---------------------
%---------------------------------------------------

%---- Question 1.2.1 -----

function bit_vec = BitVec(Nbit, pbit)
    % [alphabet; probabilities]
    bit_vec = randsrc(Nbit, 1, [0 1; (1 - pbit) pbit]);

    % Ensure numeric type double and strict {0,1}
    bit_vec = double(bit_vec);
end


%---- Question 1.2.2 -----

function sym_vec = QAM4SymVec(bit_vec, Es)
    % Ensure column vector
    bit_vec = bit_vec(:);

    % If odd number of bits, pad with 0 (keeps pairs well-defined)
    if mod(length(bit_vec), 2) ~= 0
        bit_vec(end+1) = 0;
    end

    % Group into pairs: each row is [b1 b2]
    b = reshape(bit_vec, 2, []).';   % size: Nsym x 2
    b1 = b(:,1);
    b2 = b(:,2);

    % 4-QAM constellation points from Figure 1 (with Es):
    a = sqrt(Es/2);
    s0 =  a + 1j*a;
    s1 = -a + 1j*a;
    s2 =  a - 1j*a;
    s3 = -a - 1j*a;

    % Allocate memory for output
    Nsym = size(b,1);
    sym_vec = zeros(Nsym,1);

    % Apply mapping rule:
    idx = (b1==0 & b2==0); sym_vec(idx) = s0;
    idx = (b1==0 & b2==1); sym_vec(idx) = s1;
    idx = (b1==1 & b2==1); sym_vec(idx) = s2;
    idx = (b1==1 & b2==0); sym_vec(idx) = s3;
end


%---- Question 1.2.3 -----

function [sym_vec_tx, yvec] = QAM4_Rec(SNRb, Es, Nbit, pbit)
    % Generate bits
    bit_vec = BitVec(Nbit, pbit);

    % Map bits to 4QAM symbols (each symbol carries 2 bits)
    sym_vec_tx = QAM4SymVec(bit_vec, Es);

    % Convert SNRb[dB] to linear and compute N0
    %    For 4QAM: Eb = Es/2
    SNRb_lin = 10^(SNRb/10);
    Eb = Es/2;
    N0 = Eb / SNRb_lin;

    % Generate complex AWGN: w ~ CN(0, N0)
    %    If w = x + j*y, with x,y ~ N(0, N0/2) i.i.d.
    n = length(sym_vec_tx);
    w = sqrt(N0/2) * (randn(n,1) + 1j*randn(n,1));

    % Channel output
    yvec = sym_vec_tx + w;
end


%---- Question 1.2.4 -----

function svecdec = QAM4_SymMAPDec(yvec, SNRb, Es, pbit)
    % Ensure column vector
    yvec = yvec(:);

    % --- Constellation points (same as in QAM4SymVec) ---
    a  = sqrt(Es/2);
    s0 =  a + 1j*a;   % '00'
    s1 = -a + 1j*a;   % '01'
    s2 =  a - 1j*a;   % '11'
    s3 = -a - 1j*a;   % '10'
    S  = [s0 s1 s2 s3];

    p0 = 1 - pbit;
    p1 = pbit;

    % Mapping: '00'->s0, '01'->s1, '11'->s2, '10'->s3
    Ps0 = p0 * p0;    % P('00')
    Ps1 = p0 * p1;    % P('01')
    Ps2 = p1 * p1;    % P('11')
    Ps3 = p1 * p0;    % P('10')
    Ps  = [Ps0 Ps1 Ps2 Ps3];

    % Numerical safety: avoid log(0) if pbit is 0 or 1
    epsp = 1e-12;
    Ps = max(Ps, epsp);

    % --- Compute N0 from SNRb and Es ---
    SNRb_lin = 10^(SNRb/10);
    Eb = Es/2;
    N0 = Eb / SNRb_lin;

    % --- MAP metric: |y - s|^2 - N0*log(P(s)) ---
    % Build Nx4 distance matrix
    % dist(n,i) = |y(n) - S(i)|^2
    dist = abs(yvec - S).^2;                % implicit expansion (R2016b+)
    metric = dist - N0 * log(Ps); % Decision rool matrix

    % Pick the minimum-metric symbol index
    [~, idx] = min(metric, [], 2);

    % Output decoded symbols
    svecdec = S(idx).';
end


%---- Question 1.2.5 -----

function ser = CompSER(sym_vec_tx, svecdec)
    % Ensure column vectors
    sym_vec_tx = sym_vec_tx(:);
    svecdec = svecdec(:);

    % SER computation
    ser = mean(sym_vec_tx ~= svecdec);
end


%---- Question 1.2.6 -----

Es   = 1;
Nbit = 1e5;
pbit = 0.5;

SNRb_vec = -6:1:6;                 % [-6,-5,...,5,6] dB
SER_vec  = zeros(size(SNRb_vec));  % output vector SER vs SNRb

for k = 1:length(SNRb_vec)
    SNRb = SNRb_vec(k);

    % Channel I/O
    [sym_vec_tx, yvec] = QAM4_Rec(SNRb, Es, Nbit, pbit);

    % MAP decoding
    svecdec = QAM4_SymMAPDec(yvec, SNRb, Es, pbit);

    % SER computation (item 1.2.5)
    SER_vec(k) = CompSER(sym_vec_tx, svecdec);
end

% Show results as a table
disp(table(SNRb_vec(:), SER_vec(:), 'VariableNames', {'SNRb_dB','SER'}));


%---- Question 1.2.7 -----

Es   = 1;
Nbit = 1e5;
pbit = 0.8;

SNRb_vec   = -6:1:6;                  % [-6,-5,...,5,6] dB
SER_vec_p2 = zeros(size(SNRb_vec));   % SER vs SNRb for pbit=0.8

for ii = 1:length(SNRb_vec)
    SNRb = SNRb_vec(ii);

    % Channel I/O
    [sym_vec_tx, yvec] = QAM4_Rec(SNRb, Es, Nbit, pbit);

    % MAP decoding (uses pbit for priors)
    svecdec = QAM4_SymMAPDec(yvec, SNRb, Es, pbit);

    % SER computation
    SER_vec_p2(ii) = CompSER(sym_vec_tx, svecdec);
end

% Show results as a table
disp(table(SNRb_vec(:), SER_vec_p2(:), 'VariableNames', {'SNRb_dB','SER_pbit_0p8'}));


%---- Question 1.2.8 -----

SNRb_lin = 10.^(SNRb_vec/10);           % convert dB -> linear
x = sqrt(2 .* SNRb_lin);
Qx = qfunc(x);
SER_analytic_p05 = 2.*Qx - (Qx.^2);

% Plot in a single figure: simulated p=0.5, simulated p=0.8, analytic p=0.5
figure;
semilogy(SNRb_vec, SER_vec, 'o-'); hold on; grid on;
semilogy(SNRb_vec, SER_vec_p2, 's-');
semilogy(SNRb_vec, SER_analytic_p05, '^-');

xlabel('SNR_b [dB]');
ylabel('SER');
title('4-QAM SER vs SNR_b: Simulation (p=0.5, p=0.8) and Analytic (p=0.5)');
legend('Sim p=0.5','Sim p=0.8','Analytic p=0.5','Location','southwest');


%---- Question 1.2.9 -----

Es   = 1;
Nbit = 1e5;
SNRb = -3;                         % [dB] fixed

p1_vec   = 0.01:0.01:0.99;         % p1 = 0.01,0.02,...,0.99
SER_p1   = zeros(size(p1_vec));    % SER as function of p1

for k = 1:length(p1_vec)
    pbit = p1_vec(k);

    % Channel I/O (includes BitVec + QAM4SymVec internally)
    [sym_vec_tx, yvec] = QAM4_Rec(SNRb, Es, Nbit, pbit);

    % MAP decoding for current pbit
    svecdec = QAM4_SymMAPDec(yvec, SNRb, Es, pbit);

    % SER
    SER_p1(k) = CompSER(sym_vec_tx, svecdec);
end

% Plot SER vs p1
figure;
plot(p1_vec, SER_p1, 'o-'); grid on;
xlabel('p_1');
ylabel('SER');
title('4-QAM SER vs p_1 at SNR_b = -3 dB (MAP)');




%------------------ QUESTION 1.2.10 (8-QAM) ------------------

% ---- 1.2.10: Generate 8QAM symbol sequence (equal priors) ----

function sym_vec8 = QAM8SymVec(Nsym, Es)
    a = sqrt(Es);

    % Figure 2 constellation points, ordered as s0..s7
    S = [ ...
        ( a + 1j*(a/2) ), ... % s0
        ( a - 1j*(a/2) ), ... % s1
        ( a/2 + 1j*0    ), ... % s2
        ( 0   + 1j*(a/2)), ... % s3
        ( 0   - 1j*(a/2)), ... % s4
        (-a/2 + 1j*0    ), ... % s5
        (-a  + 1j*(a/2) ), ... % s6
        (-a  - 1j*(a/2) )  ... % s7
    ];

    % iid symbols with equal a-priori probabilities
    sym_vec8 = randsrc(Nsym, 1, [S; (1/8)*ones(1,8)]);
    sym_vec8 = sym_vec8(:);
end

% ---- 1.2.10: AWGN channel for 8QAM symbols ----

function yvec = QAM8_Rec(sym_vec8, SNRb, Es)
    sym_vec8 = sym_vec8(:);

    SNRb_lin = 10^(SNRb/10);    % Convert SNRb[dB] -> linear

    % For 8QAM: m = log2(8)=3, so Eb = Es/3
    Eb = Es/3;
    N0 = Eb / SNRb_lin;

    % Complex AWGN: w ~ CN(0, N0)
    n = length(sym_vec8);
    w = sqrt(N0/2) * (randn(n,1) + 1j*randn(n,1));

    yvec = sym_vec8 + w;
end

% ---- 1.2.10: MAP decoder for 8QAM (equal priors => ML) ----
function svecdec = QAM8_SymMAPDec(yvec, Es)
    yvec = yvec(:);
    a = sqrt(Es);

    S = [ ...
        ( a + 1j*(a/2) ), ...
        ( a - 1j*(a/2) ), ...
        ( a/2 + 1j*0    ), ...
        ( 0   + 1j*(a/2)), ...
        ( 0   - 1j*(a/2)), ...
        (-a/2 + 1j*0    ), ...
        (-a  + 1j*(a/2) ), ...
        (-a  - 1j*(a/2) ) ...
    ];

    % Nearest-neighbor decision
    dist = abs(yvec - S).^2;     % implicit expansion (R2016b+)
    [~, idx] = min(dist, [], 2);
    svecdec = S(idx).';
end

% ------------------ Run 1.2.10 experiment ------------------
Es   = 1;
Nsym = (1e5 + 2)/3;          
SNRb_vec8 = -25:1:0;         

SER_8QAM = zeros(size(SNRb_vec8));

for k = 1:length(SNRb_vec8)
    SNRb = SNRb_vec8(k);

    sym_vec8 = QAM8SymVec(Nsym, Es);
    yvec     = QAM8_Rec(sym_vec8, SNRb, Es);
    svecdec  = QAM8_SymMAPDec(yvec, Es);

    SER_8QAM(k) = CompSER(sym_vec8, svecdec);
end

% Show results
disp(table(SNRb_vec8(:), SER_8QAM(:), 'VariableNames', {'SNRb_dB','SER_8QAM'}));

% Optional plot
figure;
semilogy(SNRb_vec8, SER_8QAM, 'o-'); grid on;
xlabel('SNR_b [dB]');
ylabel('SER');
title('8-QAM SER vs SNR_b (MAP, equal priors)');

%---- Question 1.2.11 -----

SNRb_lin = 10.^(SNRb_vec8/10);  % Convert SNRb[dB] -> linear

% Nearest-Neighbor Approximation for 8QAM (equal priors):
% SER_NNA ~= 2 * Q( sqrt( (3/4) * SNRb ) )
x = sqrt((3/4) .* SNRb_lin);

% Q-function without toolbox: Q(x) = 0.5*erfc(x/sqrt(2))
Qx = 0.5 * erfc(x./sqrt(2));

SER_8QAM_NNA = 2 .* Qx;

% Plot both on the same graph
figure;
semilogy(SNRb_vec8, SER_8QAM, 'o-'); hold on; grid on;
semilogy(SNRb_vec8, SER_8QAM_NNA, 's-');
xlabel('SNR_b [dB]');
ylabel('SER');
title('8-QAM SER vs SNR_b: Simulation (1.2.10) and NNA Approx. (1.1.7)');
legend('Simulation','Nearest-Neighbor Approx.','Location','southwest');

%---------------------------------------------------
%------------------ QUESTION 2 ---------------------
%---------------------------------------------------

Nsc = 128;
Ncp = 8;

%---- Question 2.2.1 -----

function xofdm = OFDM_Mod(bit_stream, Nsc, Ncp, constellation)
    Es = 1;
    bit_stream = bit_stream(:);
    
    switch constellation
        case 'BPSK', M=1; 
        case '4QAM', M=2; 
        case '8QAM', M=3; 
    end
    

    bits_per_ofdm = Nsc * M;
    num_ofdm = ceil(length(bit_stream) / bits_per_ofdm);
    pad_len = num_ofdm * bits_per_ofdm - length(bit_stream);
    if pad_len > 0
        bit_stream = [bit_stream; randi([0 1], pad_len, 1)];
    end

    bit_groups = reshape(bit_stream, M, []).';
    dec_vals = bi2de(bit_groups, 'left-msb'); % Values 0..2^M-1
    
    switch constellation
        case 'BPSK'
            d = sqrt(Es);
            S = [d; -d]; % 0->d, 1->-d
            
        case '4QAM'
            d = sqrt(Es/2);
            S_raw = [ (d + 1j*d); (-d + 1j*d); (d - 1j*d); (-d - 1j*d) ]; 
            S = [ (d+1j*d); (-d+1j*d); (d-1j*d); (-d-1j*d) ]; 
            S = zeros(4,1);
            S(0+1) = d + 1j*d;   % 00
            S(1+1) = -d + 1j*d;  % 01
            S(2+1) = d - 1j*d;   % 10 
            S(3+1) = -d - 1j*d;  % 11
            
        case '8QAM'
            d = sqrt(Es/3);
            S_pts = [ (2*d+1j*d); (2*d-1j*d); (d+0j); (0j+d); ...
                      (0j-d); (-d+0j); (-2*d+1j*d); (-2*d-1j*d)];
            S = S_pts;
    end
    
    sym_stream = S(dec_vals + 1);
    
    X_freq = reshape(sym_stream, Nsc, num_ofdm); 
    x_time = sqrt(Nsc) * ifft(X_freq, Nsc); % Column-wise IFFT
    
    cp = x_time(end-Ncp+1:end, :);
    x_with_cp = [cp; x_time];
    xofdm = x_with_cp(:);
end


%---- Bit mapping (Tx) ----

function sym_stream = map_bits_to_symbols(bit_stream, Es, constellation)
    bit_stream = bit_stream(:);

    switch upper(constellation)

        case 'BPSK'
            a = sqrt(Es);
            sym_stream = a * (1 - 2*bit_stream);

        case '4QAM'
            b = reshape(bit_stream, 2, []).'; % Nsym x 2
            
            a = sqrt(Es/2);
            s0 =  a + 1j*a; % 00
            s1 = -a + 1j*a; % 01
            s2 =  a - 1j*a; % 11
            s3 = -a - 1j*a; % 10
            
            Nsym = size(b,1);
            sym_stream = zeros(Nsym,1);
            
            % Vectorized mapping
            idx00 = (b(:,1)==0 & b(:,2)==0); sym_stream(idx00) = s0;
            idx01 = (b(:,1)==0 & b(:,2)==1); sym_stream(idx01) = s1;
            idx11 = (b(:,1)==1 & b(:,2)==1); sym_stream(idx11) = s2;
            idx10 = (b(:,1)==1 & b(:,2)==0); sym_stream(idx10) = s3;

        case '8QAM'
            b = reshape(bit_stream, 3, []).'; 

            a = sqrt(Es);
            S = [ ...
                ( a + 1j*(a/2) ), ... % s0 (000) -> idx 1
                ( a - 1j*(a/2) ), ... % s1 (001) -> idx 2
                ( a/2 + 1j*0    ), ... % s2 (010) -> idx 3
                ( 0   + 1j*(a/2)), ... % s3 (011) -> idx 4
                ( 0   - 1j*(a/2)), ... % s4 (100) -> idx 5
                (-a/2 + 1j*0    ), ... % s5 (101) -> idx 6
                (-a  + 1j*(a/2) ), ... % s6 (110) -> idx 7
                (-a  - 1j*(a/2) )  ... % s7 (111) -> idx 8
            ].';

            idx = 1 + (4*b(:,1) + 2*b(:,2) + 1*b(:,3));
            sym_stream = S(idx);

        otherwise
            error('map_bits_to_symbols:BadConstellation','Unsupported constellation.');
    end
end


%---- Question 2.2.2 -----

function [r1ofdm, r2ofdm] = Wireless_Channel(xofdm, N0)

    xofdm = xofdm(:);
    N = length(xofdm);

    % Channel 1 parameters
    a1 = (1/10.2424) * [8.1, 2.3, 5, 23, 1.9, 0.5].';
    w0 = 2*pi*sqrt(2);
    L1 = 6;

    % Channel 2 parameters
    a2 = (1/11.4648) * [8.1, 2.3, 5, 23, 1.9, 0.5, 3, 1.1, 0.9, 0.35, 1.5, 2, 3].';
    L2 = 13;

    % Build CIRs h1[n], h2[n]
    n1 = (0:L1-1).';
    n2 = (0:L2-1).';

    h1 = a1 .* exp(-1j*w0*n1);
    h2 = a2 .* exp(-1j*w0*n2);

    y1_full = conv(xofdm, h1);
    y2_full = conv(xofdm, h2);

    y1 = y1_full(1:N);
    y2 = y2_full(1:N);

    wvec = sqrt(N0/2) * (randn(N,1) + 1j*randn(N,1));

    r1ofdm = y1 + wvec;
    r2ofdm = y2 + wvec;
end


%---- Question 2.2.3 -----

function dec_bits = OFDM_Demod(rvec, Nsc, Ncp, constellation, Channel)
    Es = 1;
    symLen = Nsc + Ncp;
    num_rx_syms = floor(length(rvec) / symLen);
    rvec = rvec(1:num_rx_syms*symLen); 
    
    r_matrix_cp = reshape(rvec, symLen, num_rx_syms);
    r_matrix = r_matrix_cp(Ncp+1:end, :);
    Y_freq = (1/sqrt(Nsc)) * fft(r_matrix, Nsc);
    
    H = channel_freq_response(Nsc, Channel); 
    H_mat = repmat(H, 1, num_rx_syms);
    epsH = 1e-12; 
    H_mat(abs(H_mat) < epsH) = epsH;
    
    Syms_hat_matrix = Y_freq ./ H_mat;
    Syms_hat_vec = Syms_hat_matrix(:);
    
    switch constellation
        case 'BPSK'
            d = sqrt(Es);
            S = [d, -d].'; 
            bits_map = [0; 1];
            M = 1;
            
        case '4QAM'
            d = sqrt(Es/2);
            S = [ (d + 1j*d); (-d + 1j*d); (-d - 1j*d); (d - 1j*d) ]; 
            bits_map = [0 0; 0 1; 1 1; 1 0]; 
            M = 2;
            
        case '8QAM'
            d = sqrt(Es/3);
            S = [ (2*d+1j*d); (2*d-1j*d); (d+0j); (0j+d); ...
                  (0j-d); (-d+0j); (-2*d+1j*d); (-2*d-1j*d)];
            bits_map = de2bi(0:7, 3, 'left-msb'); 
            M = 3;
    end
    
    % --- Vectorized Min-Distance Decoder ---
    num_syms = length(Syms_hat_vec);
    rx_mat = repmat(Syms_hat_vec.', length(S), 1); 
    S_mat = repmat(S, 1, num_syms);
    [~, min_idxs] = min(abs(rx_mat - S_mat).^2);
    decoded_bits_matrix = bits_map(min_idxs, :);
    dec_bits = decoded_bits_matrix.';
    dec_bits = dec_bits(:);
end


function H = channel_freq_response(Nsc, Channel)
    w0 = 2*pi*sqrt(2);
    if Channel == 1
        a = (1/10.2424) * [8.1, 2.3, 5, 23, 1.9, 0.5].';
        L = 6;
    elseif Channel == 2
        a = (1/11.4648) * [8.1, 2.3, 5, 23, 1.9, 0.5, 3, 1.1, 0.9, 0.35, 1.5, 2, 3].';
        L = 13;
    else
        error('Bad Channel Index');
    end
    n = (0:L-1).';
    h = a .* exp(-1j*w0*n);
    
    H = fft(h, Nsc);
    H = H(:);
end


% ---- ML Decoder (Nearest Neighbor) ----

function sym_hat = decode_symbols_ML(zvec, Es, constellation)
    zvec = zvec(:);
    
    switch upper(constellation)
        case 'BPSK'
            a = sqrt(Es);
            sym_hat = a * ones(size(zvec));
            sym_hat(real(zvec) < 0) = -a;

        case '4QAM'
            a = sqrt(Es/2);
            S = [ (a+1j*a), (-a+1j*a), (a-1j*a), (-a-1j*a) ];
            dist = abs(zvec - S).^2; 
            [~, idx] = min(dist, [], 2);
            sym_hat = S(idx).';

        case '8QAM'
            a = sqrt(Es);
            S = [ ...
                ( a + 1j*(a/2) ), ( a - 1j*(a/2) ), ( a/2 + 1j*0 ), ( 0 + 1j*(a/2) ), ...
                ( 0 - 1j*(a/2) ), (-a/2 + 1j*0 ), (-a + 1j*(a/2) ), (-a - 1j*(a/2) ) ...
            ];
            
            dist = abs(zvec - S).^2;
            [~, idx] = min(dist, [], 2);
            sym_hat = S(idx).';
            
        otherwise
            error('Unsupported constellation');
    end
end


% ---- Symbols to Bits (Inverse Mapping) - Optimized ----

function bits = symbols_to_bits(sym_hat, Es, constellation)
    sym_hat = sym_hat(:);
    
    switch upper(constellation)
        case 'BPSK'
            bits = zeros(length(sym_hat), 1);
            bits(real(sym_hat) < 0) = 1;

        case '4QAM'
            b1 = double(imag(sym_hat) < 0);
            b2 = double( (real(sym_hat) > 0) ~= (imag(sym_hat) > 0) );
            
            temp = [b1.'; b2.'];
            bits = temp(:);

        case '8QAM'
            a = sqrt(Es);
            S = [ ...
                ( a + 1j*(a/2) ), ...
                ( a - 1j*(a/2) ), ...
                ( a/2 + 1j*0    ), ...
                ( 0   + 1j*(a/2)), ...
                ( 0   - 1j*(a/2)), ...
                (-a/2 + 1j*0    ), ...
                (-a  + 1j*(a/2) ), ...
                (-a  - 1j*(a/2) ) ...
            ].';

            [~, idx] = ismember(sym_hat, S);
            val = idx - 1;
            b1 = floor(val/4);
            val = val - 4*b1;
            b2 = floor(val/2);
            b3 = val - 2*b2;
            
            temp = [b1.'; b2.'; b3.'];
            bits = temp(:);
            
        otherwise
            error('Unsupported constellation');
    end
end


%---- Question 2.2.5 -----

N_OFDM = 10000;
Nbit = N_OFDM * Nsc * 1;
pbit = 0.5;
bit_stream = BitVec(Nbit, pbit);
xofdm = OFDM_Mod(bit_stream, Nsc, Ncp, 'BPSK');

%---- Question 2.2.6 -----

EbN0_dB_vec = -10:2:20;
BER_ch1_BPSK = zeros(size(EbN0_dB_vec));
a1 = (1/10.2424) * [8.1, 2.3, 5, 23, 1.9, 0.5].';
a1_norm2 = sum(abs(a1).^2);
sigma_x2 = 1; 

for k = 1:length(EbN0_dB_vec)
    EbN0_lin = 10^(EbN0_dB_vec(k)/10);
    N0 = (a1_norm2 * sigma_x2) / EbN0_lin;
    [r1, ~] = Wireless_Channel(xofdm, N0);
    dec_bits = OFDM_Demod(r1, Nsc, Ncp, 'BPSK', 1);
    L = min(length(bit_stream), length(dec_bits));
    BER_ch1_BPSK(k) = mean(bit_stream(1:L) ~= dec_bits(1:L));
end



%---- Question 2.2.7 -----

BER_all = zeros(3, length(EbN0_dB_vec));
const_list = {'BPSK','4QAM','8QAM'};

for c = 1:3
    const = const_list{c};
    switch const
        case 'BPSK', m=1; M=2;
        case '4QAM', m=2; M=4;
        case '8QAM', m=3; M=8;
    end
    
    Nbit = N_OFDM * Nsc * m;
    bit_st = BitVec(Nbit, pbit);
    tx = OFDM_Mod(bit_st, Nsc, Ncp, const);
    sig2 = mean(abs(tx).^2);
    
    for k = 1:length(EbN0_dB_vec)
        EbN0_lin = 10^(EbN0_dB_vec(k)/10);
        N0 = (a1_norm2 * sig2) / (EbN0_lin * log2(M));
        [r1, ~] = Wireless_Channel(tx, N0);
        dec = OFDM_Demod(r1, Nsc, Ncp, const, 1);
        L = min(length(bit_st), length(dec));
        BER_all(c,k) = mean(bit_st(1:L) ~= dec(1:L));
    end
end

figure;
semilogy(EbN0_dB_vec, BER_all(1,:), 'o-'); hold on; grid on;
semilogy(EbN0_dB_vec, BER_all(2,:), 's-');
semilogy(EbN0_dB_vec, BER_all(3,:), '^-');
xlabel('E_b/N_0 [dB]'); ylabel('BER'); legend('BPSK','4QAM','8QAM');
title('2.2.7: BER Comparison (Channel 1)');


%---- Question 2.2.8 -----

const_list_2 = {'BPSK', '4QAM'};
BER_ch1 = zeros(2, length(EbN0_dB_vec));
BER_ch2 = zeros(2, length(EbN0_dB_vec));

for c = 1:2
    const = const_list_2{c};
    switch const
        case 'BPSK', m=1; M=2;
        case '4QAM', m=2; M=4;
    end
    
    Nbit = N_OFDM * Nsc * m;
    bit_st = BitVec(Nbit, pbit);
    tx = OFDM_Mod(bit_st, Nsc, Ncp, const);
    sig2 = mean(abs(tx).^2);
    
    for k = 1:length(EbN0_dB_vec)
        EbN0_lin = 10^(EbN0_dB_vec(k)/10);
        N0 = (a1_norm2 * sig2) / (EbN0_lin * log2(M));
        
        [r1, r2] = Wireless_Channel(tx, N0);
        
        d1 = OFDM_Demod(r1, Nsc, Ncp, const, 1);
        d2 = OFDM_Demod(r2, Nsc, Ncp, const, 2);
        
        L1 = min(length(bit_st), length(d1));
        L2 = min(length(bit_st), length(d2));
        
        BER_ch1(c,k) = mean(bit_st(1:L1) ~= d1(1:L1));
        BER_ch2(c,k) = mean(bit_st(1:L2) ~= d2(1:L2));
    end
end

figure;
semilogy(EbN0_dB_vec, BER_ch1(1,:), 'b-o'); hold on; grid on;
semilogy(EbN0_dB_vec, BER_ch2(1,:), 'b--o');
semilogy(EbN0_dB_vec, BER_ch1(2,:), 'r-s');
semilogy(EbN0_dB_vec, BER_ch2(2,:), 'r--s');
xlabel('E_b/N_0 [dB]'); ylabel('BER');
legend('Ch1 BPSK','Ch2 BPSK','Ch1 4QAM','Ch2 4QAM');
title('2.2.8: Channel 1 vs Channel 2');