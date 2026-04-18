%------------------ Functions ---------------------

function [x_array, x_array_diff, x_array_error] = NR_1b(x_prev, s, q)
    tol  = 10^(-12);
    max_iter = 100;
    x=x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t^4-3);
    f_tag = @(t)(4*t^3);
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(f(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = x_prev-q*f(x_prev)/f_tag(x_prev);   % multiply by q for error correction to high order square rout, done after question 2c
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


function [x_array, x_array_diff, x_array_error] = NR_2a(x_prev, s)
    tol  = 10^(-12);
    max_iter = 100;
    x=x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t^5-6*t^4+14*t^3-20*t^2+24*t-16);
    f_tag = @(t)(5*t^4-24*t^3+42*t^2-40*t+24);
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(f(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = x_prev-f(x_prev)/f_tag(x_prev);
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


function [x_array, x_array_diff, x_array_error] = NR_2b(x_prev, s)
    tol  = 10^(-12);
    max_iter = 100;
    x=x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t^5-6*t^4+14*t^3-20*t^2+24*t-16);
    f_tag = @(t)(5*t^4-24*t^3+42*t^2-40*t+24);
    f_tagyam = @(t)(20*t^3-72*t^2+84*t-40);
    u = @(t)(f(t)/f_tag(t));
    u_tag = @(t)(1-(f_tagyam(t)*f(t))/((f_tag(t))^2));
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(u(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = x_prev-u(x_prev)/u_tag(x_prev);
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


function [x_array, x_array_diff, x_array_error] = NR_2c(x_prev, s, q)
    tol  = 10^(-12);
    max_iter = 100;
    x=x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t^5-6*t^4+14*t^3-20*t^2+24*t-16);
    f_tag = @(t)(5*t^4-24*t^3+42*t^2-40*t+24);
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(f(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = x_prev-q*f(x_prev)/f_tag(x_prev);
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


function [x_array, x_array_diff, x_array_error] = FP_3a(x_prev, s)
    tol  = 10^(-12);
    max_iter = 100;
    x=x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t-2*sin(t));
    f_tagyam = @(t)(2*sin(t));
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(f(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = f_tagyam(x_prev);
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


function [x_array, x_array_diff, x_array_error] = NR_3b(x_prev, s)
    tol  = 10^(-12);
    max_iter = 100;
    x = x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t-2*sin(t));
    f_tag = @(t)(1-2*cos(t));
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(f(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = x_prev-f(x_prev)/f_tag(x_prev);
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


function [x_array, x_array_diff, x_array_error] = FP_3d(x_prev, s)
    tol  = 10^(-12);
    max_iter = 100;
    x=x_prev;
    iter = 1;
    x_array = zeros();
    x_array_diff = zeros();
    x_array_error = zeros();
    f = @(t)(t-2*sin(t));
    g = @(t)(asin(t/2));
    x_array(iter) = x_prev;
    x_array_diff(iter) = 0;
    x_array_error(iter) = abs(x_prev - s);

    while   (abs(f(x)) > tol && iter < max_iter)
        iter = iter + 1;
        x_prev = x;
        x = g(x_prev);
        x_array(iter) = x;
        x_array_diff(iter) = abs(x-x_prev);
        x_array_error(iter) = abs(x - s);
    end
end


%------------------ QUESTION 1---------------------
I_1 = 211563176;
I_2 = 206511776;
a = 1;
b = 5;
x0_1 = a+(I_1/(I_1 + I_2))*(b-a);
s = 3^(0.25);
q_1 = 1;
%------------------ QUESTION 1b---------------------

[x_NR_1b, x_NR_diff_1b, x_NR_error_1b] = NR_1b(x0_1, s, q_1);   % use Newton-Raphson method
n = (1:length(x_NR_1b))';   % number the table row
Table_1b = table(n, x_NR_1b', x_NR_diff_1b', x_NR_error_1b',VariableNames={'Iteration','x_n', '|x_n - x_n-1|', '|x_n-s|'});
disp(Table_1b)

%------------------ QUESTION 1c---------------------
 
figure(1)
x_axis = log(x_NR_error_1b(1:end-1));
y_axis = log(x_NR_error_1b(2:end));
plot(x_axis,y_axis,'-o', Color='r');
title('QUESTION 1c - Newton-Raphson');
subtitle('x^{4}-3=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
movegui(figure(1),"northwest");


%------------------ QUESTION 2---------------------
a = 1;
b = 5;
x0_2 = 5;
s_2 = 2; 
q_2 = 3;
%------------------ QUESTION 2a---------------------

[x_NR_2a, x_NR_diff_2a, x_NR_error_2a] = NR_2a(x0_2, s_2);   % use Newton-Raphson method
n = (1:length(x_NR_2a))';   % number the table row
Table_2a = table(n, x_NR_2a', x_NR_diff_2a', x_NR_error_2a', VariableNames={'Iteration','x_n', '|x_n - x_n-1|', '|x_n-s|'});
disp(Table_2a)

figure(2)
x_axis_2a = log(x_NR_error_2a(1:end-1));
y_axis_2a = log(x_NR_error_2a(2:end));
plot(x_axis_2a,y_axis_2a,'-o', Color='g');
title('QUESTION 2a - Newton-Raphson');
subtitle('x^{5}-6x^{4}+14x^{3}-20x^{2}+24x-16=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
movegui(figure(2),"north");

%------------------ QUESTION 2b---------------------

[x_NR_2b, x_NR_diff_2b, x_NR_error_2b] = NR_2b(x0_2, s_2);   % use Newton-Raphson method
n = (1:length(x_NR_2b))';   % number the table row
Table_2b = table(n, x_NR_2b', x_NR_diff_2b', x_NR_error_2b',VariableNames={'Iteration','x_n', '|x_n - x_n-1|', '|x_n-s|'});
disp(Table_2b)

figure(3)
x_axis_2b = log(x_NR_error_2b(1:end-1));
y_axis_2b = log(x_NR_error_2b(2:end));
plot(x_axis_2b,y_axis_2b,'-o', Color='b');
title('QUESTION 2b - Newton-Raphson high order square root');
subtitle('x^{5}-6x^{4}+14x^{3}-20x^{2}+24x-16=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
movegui(figure(3),"northeast");


%------------------ QUESTION 2c---------------------

[x_NR_2c, x_NR_diff_2c, x_NR_error_2c] = NR_2c(x0_2, s_2, q_2);   % use Newton-Raphson method
n = (1:length(x_NR_2c))';   % number the table row
Table_2c = table(n, x_NR_2c', x_NR_diff_2c', x_NR_error_2c',VariableNames={'Iteration','x_n', '|x_n - x_n-1|', '|x_n-s|'});
disp(Table_2c)

figure(4)
x_axis_2c = log(x_NR_error_2c(1:end-1));
y_axis_2c = log(x_NR_error_2c(2:end));
plot(x_axis_2c,y_axis_2c,'-o', Color='r');
title('QUESTION 2c - Newton-Raphson high order square root with q');
subtitle('x^{5}-6x^{4}+14x^{3}-20x^{2}+24x-16=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
movegui(figure(4),"southwest");


%------------------ QUESTION 3---------------------
x0_3 = pi/2;
s_3 = 1.895494267034;
%------------------ QUESTION 3a---------------------

[x_FP1, x_FP1_diff, x_FP1_error] = FP_3a(x0_3, s_3);   % use fixed point method
n = (1:length(x_FP1))';   % number the table row
Table_3a = table(n, x_FP1',x_FP1_diff',x_FP1_error',VariableNames={'Iteration','x_n', '|x_n - x_n-1|', '|x_n-s|'});
disp(Table_3a)

figure(5)
x_axis_3a = log(x_FP1_error(1:end-1));
y_axis_3a = log(x_FP1_error(2:end));
plot(x_axis_3a,y_axis_3a,'-o', Color='m');
title('QUESTION 3a - Fixed Point');
subtitle('x-2sin(x)=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
movegui(figure(5),"south");

%------------------ QUESTION 3b---------------------

[x_NR_3b, x_NR_diff_3b, x_NR_error_3b] = NR_3b(x0_3, s_3);   % use Newton-Raphson method
figure(6)
x_axis_3b = log(x_NR_error_3b(1:end-1));
y_axis_3b = log(x_NR_error_3b(2:end));
plot(x_axis_3b,y_axis_3b,'-o', Color='y');
title('QUESTION 3b - Newton-Raphson');
subtitle('x-2sin(x)=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
movegui(figure(6),"southeast");

%------------------ QUESTION 3d---------------------

[x_FP_3d, x_FP1_diff_3d, x_FP1_error_3d] = FP_3d(x0_3, s_3);
figure(7)
x_axis_3d = log(x_FP1_error(1:end-1));
y_axis_3d = log(x_FP1_error(2:end));
plot(x_axis_3d,y_axis_3d,'-o', Color='bl');
title('QUESTION 3d - Fixed Point');
subtitle('x-2sin(x)=0');
xlabel('log(\bf\epsilon_n_-_1))');
ylabel('log(\bf\epsilon_n)');
grid on;
