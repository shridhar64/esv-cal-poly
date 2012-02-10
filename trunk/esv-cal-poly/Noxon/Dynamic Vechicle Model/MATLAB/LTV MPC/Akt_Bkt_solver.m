% Author: Nikola Noxon
% California Polytehnic State University
% email: nikolanoxon@gmail.com
% Oct 2011; Last revision: 1-12-16

% The following code solves for the 8 DOF dynamic vehicle model (DVM) in
% variable form. This is done to significantly decrease computation
% overhead during real-time calculation
% The uncoupled, discrete, linearized 8 DOF DVM has the forumulation:
% ?(k + 1) = Ak,t*?(k) + Bk,t*U(k) + dk,t(k),
% dk,t = ?k+1,t ? Ak,t*?k,t ? Bk,t*Ut
%
% The code returns Ak,t and Bk,t

%------------- BEGIN CODE --------------

% the following variables comprise all constants, states, and inputs used
% in calculation
syms    tau g x_d y_d phi_d phi psi_d psi delta A1 A2 A3 A4 B1 B2 B3 B4...
        C1 C2 C3 C4 D1 D2 D3 D4 D5 D6 t_f t_r l_f l_r M_s h_s C_af C_ar...
        K_phif K_phir B_phif B_phir 

%----------------------
% VARIABLE CALCULATED PARAMETERS
%----------------------

%left front wheel velocity
vx_lf = x_d + psi_d*t_f/2;
vy_lf = y_d + psi_d*l_f;
 
%right front wheel velocity
vx_rf = x_d - psi_d*t_f/2;
vy_rf = y_d + psi_d*l_f;
 
%left rear wheel velocity
vx_lr = x_d + psi_d*t_r/2;
vy_lr = y_d - psi_d*l_r;
 
%right rear wheel velocity
vx_rr = x_d - psi_d*t_r/2;
vy_rr = y_d - psi_d*l_r;  

% Tire longitudinal and cornering velocities
vc_lf = vy_lf*cos(delta) - vx_lf*sin(delta);
vc_rf = vy_rf*cos(delta) - vx_rf*sin(delta);
vc_lr = vy_lr*cos(delta) - vx_lr*sin(delta);
vc_rr = vy_rr*cos(delta) - vx_rr*sin(delta);

vl_lf = vy_lf*sin(delta) + vx_lf*cos(delta);
vl_rf = vy_rf*sin(delta) + vx_rf*cos(delta);
vl_lr = vy_lr*sin(delta) + vx_lr*cos(delta);
vl_rr = vy_rr*sin(delta) + vx_rr*cos(delta);

% Slip angles
a_lf = atan(vc_lf/vl_lf);
a_rf = atan(vc_rf/vl_rf);
a_lr = atan(vc_lr/vl_lr);
a_rr = atan(vc_rr/vl_rr);

% Tire longitudinal and cornering forces
Fc_lf = -a_lf*C_af;
Fc_rf = -a_rf*C_af;
Fc_lr = -a_lr*C_ar;
Fc_rr = -a_rr*C_ar;

Fl_lf = 0; %assumes longitudinal forces are negligible
Fl_rf = 0;
Fl_lr = 0;
Fl_rr = 0;
 
%Normal components of tire forces
Fxlf = Fl_lf*cos(delta) - Fc_lf*sin(delta);
Fxrf = Fl_rf*cos(delta) - Fc_rf*sin(delta);
Fxlr = Fl_lr;
Fxrr = Fl_rr;
 
Fylf = Fl_lf*sin(delta) + Fc_lf*cos(delta);
Fyrf = Fl_rf*sin(delta) + Fc_rf*cos(delta);
Fylr = Fc_lr;
Fyrr = Fc_rr;

% Tire Torques
T_phif = -K_phif*phi - B_phif*phi_d;
T_phir = -K_phir*phi - B_phir*phi_d;
 
% Sum forces and torques
sigFx = Fxlf + Fxrf + Fxlr + Fxrr;
sigFy = Fylf + Fyrf + Fylr + Fyrr;
sigTxs = T_phif + T_phir - M_s*g*h_s*sin(phi); %aerodynamic roll moment = 0
sigTz = (Fylf + Fyrf)*l_f - (Fylr + Fyrr)*l_r + t_f/2*(Fxlf - Fxrf)...
        + t_r/2*(Fxlr - Fxrr);
    
%-------------------
%EQUATIONS OF MOTION
%-------------------

% mass matrix for coupled EoM
Mass_Matrix =   [1              0       0               A1*sin(phi)
                 0              1       B1*cos(phi)     0
                 0              0       1               C1*cos(phi)
                 D2*sin(phi)    0       D1*cos(phi)     1];
             
% coupled equations of motion for x_dd, y_dd, phi_dd, psi_dd
F_Ec =  [A2*sigFx + psi_d*x_d + A3*cos(phi)*phi_d*psi_d
        B2*sigFy - psi_d*y_d + B3*sin(phi)*phi_d^2+B4*sin(phi)*psi_d^2
        C2*sigTxs + C3*sin(phi)*cos(phi)*phi_d*psi_d...
        + C4*sin(phi)*cos(phi)*psi_d^2
        D3*sigTz + D4*sin(phi)*cos(phi)*phi_d*psi_d...
        + D5*sin(phi)*phi_d^2 + D6*sin(phi)*cos(phi)*psi_d^2];

% decouple the EoM
F_Eu = Mass_Matrix^-1*F_Ec;

% extract the left hand side of the EoM
x_dd = F_Eu(1);
y_dd = F_Eu(2);
phi_dd = F_Eu(3);
psi_dd = F_Eu(4);


% define the state space
E = [x_d; y_d; phi_d; phi; psi_d; psi];

% define the state trajectory
F_E = [x_dd; y_dd; phi_dd; phi_d; psi_dd; psi_d];   

% discretize using the Euler Method
F_Ed = tau*F_E + E;

% differentiate the discretized system
dFde1 = diff(F_Ed,E(1));
dFde2 = diff(F_Ed,E(2));
dFde3 = diff(F_Ed,E(3));
dFde4 = diff(F_Ed,E(4));
dFde5 = diff(F_Ed,E(5));
dFde6 = diff(F_Ed,E(6));

A_kt = [dFde1, dFde2, dFde3, dFde4, dFde5, dFde6]

B_kt = diff(F_Ed,delta)

%------------- END OF CODE --------------