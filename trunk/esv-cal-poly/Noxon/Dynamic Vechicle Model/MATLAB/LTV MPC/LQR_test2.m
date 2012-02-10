% Author: Nikola Noxon
% California Polytehnic State University
% email: nikolanoxon@gmail.com
% Jan 2012; Last revision: 1-18-12

%This code sets up the LQR controller for an 8 DOF Dynamic Vehicle
%Model (DVM). The output of the LQR controller is processed into the Linear
%Time Varying Model Predictive Controller (LTV MPC) for use in stability
%control. The cost function to be minimized is:
% J = (1/2)[x(N) - x_f]'M[x(N) - x_f]
%     +(1/2)?{[x(k) - n(k)]'Q[x(k) - n(k)] + u(k)'Ru(k)}  (k=0 to N-1)

%------------- BEGIN CODE --------------

%Iterations
N = 2;

%Constraints
x(1) = 10;
x(N) = -20;
n = [0,0,0,0,0];
u = [1,1,1,1,1];


%Constants
M = 1;
Q = 1;
R = 1;

%Dynamic System
A = 1;
B = 1;
%Boundary Conditions
W = zeros(1,N);
V = zeros(1,N);

W(1) = M;
V(1) = M*x(N);

%This has been tested successfully with problem 17.5 in Modern Control
%Theory
% for i = 2:(N+1)
%     
%     %the N+2-i term offsets the index of n() so that is compatible with
%     %matlab
%     k_index = N - i;
%     k = k_index + 2;
%     
%    
%     U(i-1) = [R + B'*W(i-1)*B]^(-1);
%     W(i) = Q + A'*W(i-1)*A - A'*W(i-1)*B*U(i-1)*W(i-1)*A;
%     V(i) = A'*V(i-1) - A'*W(i-1)*B*U(i-1)*B'*V(i-1) - Q*n(k);
% end

for k = 0:(N-1)
    
    i = k+1;
    i_prime = N - i;
    
   
    U(i_prime) = [R + B'*W(i_prime)*B]^(-1);
    W(i_prime+1) = Q + A'*W(i_prime)*A - A'*W(i_prime)*B*U(i_prime)*W(i_prime)*A;
    V(i_prime+1) = A'*V(i_prime) - A'*W(i_prime)*B*U(i_prime)*B'*V(i_prime) - Q*n(i);
end
% 
%Finish the forward path stuff! ie, this stuff below is wrong!
% for k = 0:(N-1)
%     
%     i = k+1;
%     i_prime = N - k;
%     F(i) = -(R + B'*W(i_prime)*B)^(-1)*B';
%     G(i) = F(i)*W(i_prime)*A;
%     u_new(i) = F(i)*V(i_prime) - G(i)*x(i);
%     x(i+1) = A*x(i) + B*u_new(i)
% 
% end
U
V
%u_new