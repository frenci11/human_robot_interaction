% homework 1 - position control
DCX22L_113_1_18V;

% sisotool(motor * 1/s);

% C_no_integrator =  0.0090169 * (s+60)^3;

% By adding a pole and a zero to the C_no_integrator controller we get 
% better disturbance rejection 
% C_no_integrator_better_du_rejection = 0.43396*((s+60)^2)*(s^2 + 160*s + 6401) / (s+1);

C_position_integrator =   0.075865 *(s+3.859) * (s+50.01) * 1/s;