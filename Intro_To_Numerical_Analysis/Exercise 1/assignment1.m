%----------------------Question 1----------------------
q = [2,1,1,5,6,3,1,7,6,2,0,6,5,1,1,7,7,6] ;
M = 18 ;
mat_size = M;
rho = 1 ;
h = pi*rho/90 ;


function A = create_matrix(h,M)
ro = 1 ;
A = zeros(M,M);
for m = 1:M
    for n = 1:M
        r_mn = sqrt((h+ro*sin(((m*pi)/M))- ro*sin(((n*pi)/M))).^2+(ro*cos((m*pi)/M)-ro*cos((n*pi)/M)).^2);
    A(m,n) = 1 ./ (4*pi*r_mn) ;
    end
end
end

function A = create_matrix_in_power(h,M)
ro = 1 ;
A = zeros(M,M);
for m = 1:M
    for n = 1:M
        r_mn = (h+ro*sin(((m*pi)/M))- ro*sin(((n*pi)/M))).^2+(ro*cos((m*pi)/M)-ro*cos((n*pi)/M)).^2 ;
    A(m,n) = 1 ./ (4*pi*r_mn) ;
    end
end
end



function [rel_err, rel_dist] = Gauss_Saidel( solution, A, b)
    Q = tril(A) ;
    U_negative = Q - A ;
    G = Q \ U_negative ;
    C = Q \ b ;
    x = C ; 
    % heatmap(G)
    % colormap("hsv") 
    tolerance = 10^(-3) ;
    max_iterations = 500 ;
    rel_dist = zeros;
    rel_err = zeros;
    index = 1;
    err = norm(x-solution, inf);

    while  err > tolerance && index < max_iterations
         x_prev = x;
         x = G * x_prev + C;
         err = norm(x-solution, inf);
         rel_err(index) = norm((solution - x), inf)/norm(solution, inf);
         rel_dist(index) = norm(x - x_prev, inf)/norm(x_prev, inf) ;
         index = index + 1 ;
    end
end

function [rel_err, rel_dist] = Jacobi(solution, A, b)
    D = diag(diag(A)) ;
    G = -1 *D \ (A-D);
    disp(norm(G, inf))
    C = D \ b ;
    x = C ;
    % heatmap(G)
    % colormap("hot") 
    tolerance = 10^(-3) ;
    max_iterations = 500 ;
    rel_dist = zeros;
    rel_err = zeros;
    index = 1;
    err = norm(x-solution, inf);

    while  err > tolerance && index < max_iterations
         x_prev = x;
         x = G * x_prev + C;
         err = norm(x-solution, inf);
         rel_err(index) = norm((solution - x), inf)/norm(solution, inf);
         rel_dist(index) = norm(x - x_prev, inf)/norm(x_prev, inf) ;
         index = index + 1 ;
    end
end




function plotting (rel_dist, rel_err, plot_title, case_num)
    indexes = 1:length(rel_dist);
    figure;
    semilogy(indexes, rel_err, 'b', 'LineWidth', 2); % Plot Relative Error
    hold on;
    semilogy(indexes, rel_dist, 'r', 'LineWidth', 2); % Plot Relative Distance
    hold off;
    xlabel('Iteration');
    ylabel('Error');
    legend('Relative Error', 'Relative Distance');
    title('Convergence Plot:' ,plot_title); 
    grid on;
    switch case_num
        case 1
            movegui('northwest'); % Move the first plot to the top left
        case 2
            movegui('north'); % Move the second plot to the top center
        case 3
            movegui('northeast'); % Move the third plot to the top right
        case 4
            movegui('southwest'); % Move the forth plot to the buttom left
        case 5
            movegui('south'); % Move the fifth plot to the buttom center
    end
end



%Question 1a
A_1 = create_matrix(h, mat_size) ;
v_1 = A_1 * q.' ; 
[rel_err_1, rel_dist_1] = Gauss_Saidel(q.',A_1,v_1) ;
plotting(rel_dist_1, rel_err_1,'Gauss-Seidel' , 1)

% Question 1b_i
A_2 = create_matrix(2.5*h, mat_size) ;
v_2 = A_2 * q.' ; 
[rel_err_2, rel_dist_2] = Gauss_Saidel(q.',A_2,v_2) ;
plotting(rel_dist_2, rel_err_2, 'Gauss-Seidel' , 2)

% Question 1b_ii
A_3 = create_matrix(5*h, mat_size) ;
v_3 = A_3 * q.' ; 
[rel_err_3, rel_dist_3] = Gauss_Saidel(q.',A_3,v_3) ;
plotting(rel_dist_3, rel_err_3,'Gauss-Seidel' , 3)


%Question 1c
[rel_err_Jacobi_1, rel_dist_Jacobi_1] = Jacobi(q.',A_1,v_1) ;
plotting(rel_dist_Jacobi_1,rel_err_Jacobi_1, 'Jacobi' , 4)


%Question 1d
A_4 = create_matrix_in_power(h, mat_size) ;
v_4 = A_4 * q.' ; 
[rel_err_Jacobi_2, rel_dist_Jacobi_2] = Jacobi(q.',A_4,v_4) ;
plotting(rel_dist_Jacobi_2,rel_err_Jacobi_2, 'Jacobi of new matrix', 5)


%----------------------Question 2----------------------


q = [2,1,1,5,6,3,1,7,6,2,0,6,5,1,1,7,7,6] ;
M = 18 ;
mat_size = M ;
rho = 1 ;
h = [pi*rho/(5*M), pi*rho/(2*M), 2*pi*rho/M, 5*pi*rho/M, 10*pi*rho/M] ;
det_B = zeros(5,1) ;
rel_error = zeros(5,1) ;
for i = 1:length(h)
    h_current = h(i) ;
    B = create_matrix(h_current, mat_size) ;
    % heatmap(B)
    % colormap("hsv")
    solution = B * q.' ;
    det_B(i) = abs(det(B)) ;
    q_tilda = (transpose(B) * B) \ (transpose(B)*solution) ;    
    rel_error(i) = norm(solution - (B * q_tilda) , 2) / (norm(q));
end

disp(det_B)
disp(rel_error)
figure ;
loglog(h, det_B, '-o', 'LineWidth', 2, 'DisplayName', 'Determinant of B') ;
hold on ;
loglog(h, rel_error, '-s', 'LineWidth', 2, 'DisplayName', 'Relative Error') ;
title('Least Squares method') ;
xlabel('h') ;
ylabel('Relative Error / Absolute Value of det(B)') ;
legend('abs(det(B))','Relative error','Location','southwest') ;
grid on ;
movegui('southeast'); % Move the sixth plot to the buttom right
