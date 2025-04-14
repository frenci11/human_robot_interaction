s = tf('s');

K = 1.504;  % N*m/A
J = 0.0104; % Kg*m^2
b = 0.0068; % N*m
Kv = 654;   % rpm/V
Kt = 14.6;  % mN*m/A
R = 0.68;   % ohm
L = 0.0779 * 1e-3; % H

I_max = 2.26;   % A - max current 
V_nominal = 18; % V - nominal voltage

El = 1 / (s*L + R);  % Electrical subsystem
Me =  1 / (s*J + b); % Mechanical subsystem

motor = feedback(El * K * Me, K);

motor_current = feedback(El, K * Me * K);
