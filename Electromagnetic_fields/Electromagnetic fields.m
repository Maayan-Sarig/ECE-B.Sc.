% Credit to Itay Luzon & Maayan Sarig %
% Main Program %
clear all;
close all;

% milli_meter = 10^-3;
delta = 0.1;
tau_list = 10 .^ [-1, -2, -3, -4, -5];
w_out = 10;
h_out = 4;
w_in = 0.8;
d_in = 2;
M = (h_out/delta)+1;  % M=41
N = (w_out/delta)+1;  % N =101
y_0 = 1+0.5*(w_out-(2*w_in+d_in))/delta;
cons = (y_0-1)*delta;
y_1 = 1+(cons+w_in+d_in)/delta;
x_0 = 1+(0.5*(h_out-w_in))/delta;
x_0_fin = x_0 + w_in/delta;
y_0_fin = y_0 + w_in/delta;
y_1_fin = y_1 + w_in/delta;

% defining phi_i_minus1 from the given information:
% C_1 on 1 voltage and C_2 on -1 voltage:
phi_i_minus1 = zeros(M,N);
phi_i_minus1(x_0:x_0_fin,y_0:y_0_fin) = 1;
phi_i_minus1(x_0:x_0_fin,y_1:y_1_fin) = -1;
iter_vec= zeros;

for idx=1:5
    cur_tau = tau_list(idx);
    [phi_i,iter,Ex,Ey] = Close_Neighbors_method(cur_tau,M,N,phi_i_minus1);
    iter_vec(idx) = iter;
    if idx == 5
        figure(1);
        % Potential Calc:
        imagesc(phi_i);
        title(['Potential for Tau $10^{' num2str(log10(cur_tau)) '}$'], 'Interpreter', 'latex');
        xlabel('$10^{-1}$ mm', 'Interpreter', 'latex');
        ylabel('$10^{-1}$ mm', 'Interpreter', 'latex');
        set(gca, 'YDir', 'normal');
        colorbar;
    
        % Electric Field Calc:
        figure(2);
        [X, Y] = meshgrid(1:N, 1:M);
        quiver(X,Y,Ex, Ey, 'LineWidth', 2, 'MaxHeadSize', 2.5);
        title(['Electric Field for Tau $10^{' num2str(log10(cur_tau)) '}$'], 'Interpreter', 'latex');
        xlabel('$10^{-1}$ mm', 'Interpreter', 'latex');
        ylabel('$10^{-1}$ mm', 'Interpreter', 'latex');
        xlim([0 100]);  
        ylim([0 40]);
    end
end

figure(3);
semilogx(tau_list,iter_vec,'--o');
title('Number of Iterations As A Function Of The Error');
xlabel('Tau');
ylabel('Number Of Iterations');
grid on;

% finding eta on the PEC:
eta = zeros(M,N);
eps_0 = 8.85*10^-12;
% finding eta on c0:
for m = 2:M-1
    eta(m,1) = -eps_0 * Ex(m,2); % left layer
    eta(m,N) = eps_0 * Ex(m,N-1); % right layer
end
for n = 2:N-1
    eta(1,n) = -eps_0 * Ey(2,n);  % down layer
    eta(M,n) = eps_0 * Ey(M-1,n); % top layer
end

% finding eta on c1:
for m = 17:24
    eta(m,33) = -eps_0 * Ex(m,33); % left layer
    eta(m,40) = eps_0 * Ex(m,40);  % right layer
end
for n = 33:40
    eta(17,n) = -eps_0 * Ey(17,n); % down layer
    eta(24,n) = eps_0 * Ey(24,n); % top layer
end

% finding eta on c2:
for m = 17:24
    eta(m,61) = -eps_0 * Ex(m,61); % left layer
    eta(m,68) = eps_0 * Ex(m,68);  % right layer
end
for n = 61:68
    eta(17,n) =  -eps_0 * Ey(17,n); % down layer
    eta(24,n) = eps_0 * Ey(24,n); % top layer
end

% showing the solution:
figure(4);
subplot(2,1,1);
imagesc(eta);
set(gca, 'YDir', 'normal'); % Set the origin to bottom-left
colorbar;
xlabel('[10^-^1mm]');
ylabel('[10^-^1mm]');
title('Surface Charge Density');

subplot(2,1,2);
surf(eta);
set(gca, 'YDir', 'normal'); % Set the origin to bottom-left
colorbar;
xlabel('[10^-^1mm]');
ylabel('[10^-^1mm]');
view(0, 0);
xlim([0 100]);  
ylim([0 40]);

% Calculate Q on the PEC
%C_0
tot_eta_on_c0 = sum(sum(eta(1,:)))+sum(sum(eta(:,1)))+ sum(sum(eta(M,:))) +sum(sum(eta(:,N)));
surface_of_c0 = (w_out * h_out) / delta;
Q0 = tot_eta_on_c0 * surface_of_c0/100;
%C_1
tot_etq_on_c1 = sum(sum(eta(17,33:40)))+sum(sum(eta(17:24,33)))+ sum(sum(eta(24,33:40))) +sum(sum(eta(17:24,40))); 
surface_of_c1 = w_in^2 / delta;
Q1 = tot_etq_on_c1 * surface_of_c1;
%C_2
tot_etq_on_c1 = sum(sum(eta(17,61:68)))+sum(sum(eta(17:24,61)))+ sum(sum(eta(24,61:68))) +sum(sum(eta(17:24,68))); 
surface_of_c1 = w_in^2 / delta;
Q2 = tot_etq_on_c1 * surface_of_c1;

% finding the total capacity of the device:
C = Q1/2;  % C=Q/V and v=2 volt.

% Display results
disp([newline 'Q0 = ', num2str(Q0), ' [C/mm]']);
disp([newline 'Q1 = ', num2str(Q1), ' [C/mm]']);
disp([newline 'Q2 = ', num2str(Q2), ' [C/mm]']);
disp([newline 'C = ', num2str(C), ' [F/mm]']);

movegui(figure(1), 'west');
movegui(figure(2), 'north');
movegui(figure(3), 'east');
movegui(figure(4), 'south');

function [phi_i,iter,Ex,Ey] = Close_Neighbors_method(cur_tho,M,N,phi_i_minus1)
   delta = 0.1;
   Ex =zeros(M,N);
   Ey = zeros(M,N);
   phi_i = phi_i_minus1;
   error = 10000; % realy big number for entering the first loop
   iter = 0;
   while abs(error)>cur_tho
        for m=2:M-1
            for n=2:N-1
                % knwon potential:
                if ((m >= 17 && m <= 24 && n >= 33 && n <= 40) || (m >= 17 && m <= 24 && n >= 61 && n <= 68))
                    continue
                % calc the unknown potential:
                end
                phi_i(m,n) = (phi_i_minus1(m+1,n) +phi_i_minus1(m-1,n) ...
                + phi_i_minus1(m,n+1)+ phi_i_minus1(m,n-1))/4;

                % Ex(m,n) = -(phi_i(m,n+1)-phi_i(m,n-1))/(2*delta);
                % Ey(m,n) = -(phi_i(m+1,n)-phi_i(m-1,n))/(2*delta);

            end
        end
        error = norm(phi_i-phi_i_minus1,'fro');
        phi_i_minus1 = phi_i;
        iter=iter+1;
   end
   for m = 2:M-1
        for n = 2:N-1
            Ex(m, n) = - (phi_i(m, n+1) - phi_i(m, n-1)) / (2 * delta);
            Ey(m, n) = - (phi_i(m+1, n) - phi_i(m-1, n)) / (2 * delta);
        end
    end
end