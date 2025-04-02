
%es2 motor current control

clc
clear

set(cstprefs.tbxprefs,'FrequencyUnits','Hz')

% maxon DCX22L with ratio 103:1
Kt = 1.503; 
Im = 0.0104;
Fm = 0.0068; 
Kv = 1/(2*pi*135/60);
Ra = 0.68;
La = 0.0779;

s = tf('s');

%electrical
El = 1 / (s*La + Ra);
%mechanical (note now Kt is not on Me)
Me =  1 / (s*Im + Fm);

%transfer function from v to i
plant = ( El / (1+(El*Me*Kt^2)) );
save('plant_v_to_i_tf.mat','plant');

save('El.mat',"El");
save('Me.mat',"Me");
save('Kt.mat',"Kt")

disp('plant poles');
disp(pole(plant));
disp('plant zeros');
disp(zero(plant));


figure(1)
subplot(1,2,1)
rlocus(plant)
title 'open loop plant'
grid on

%controller computed with sisotool
i_controller=load("current_controller_tf.mat");
i_controller=i_controller.C;

feedback=(i_controller*plant)/(1+i_controller*plant);

rlocus(feedback)
title 'closed loop'
grid on

disp('closed loop poles');
disp(vpa(pole(feedback),6))
disp('closed loop zeros');
disp(vpa(zero(feedback),6))

sisotool(plant,i_controller);

%for simulink

open_system('current_feedback.slx')


%% how to compute the transfer function from v_to_i

syms El Me k v u_1 i d_theta

eq1 = i == u_1 * El;
eq2 = u_1 == v - k * d_theta;
eq3 = d_theta == u_1 * El * k * Me;

% Solve the system step by step
sol = solve([eq1, eq2, eq3], [i, u_1, d_theta]);

% Extract i
simplify(sol.i)

%% some tests of 2^nd order diff. eqation
% clc
% clear
% 
% s= tf('s');
% %damping factor
% zeta=1.1;
% %natural frequency
% omega=10;
% 
% %if zeta < 1 system oscillates.
% 
% G= omega^2/(s^2+2*zeta*omega*s+omega^2)
% 
% 
% C=1.266*1/s;
% 
% disp('poles');
% disp(pole(G));
% disp('zeros');
% disp(zero(G));
% 
% figure(1)
% subplot(1,2,1)
% step(G);
% grid on
% subplot(1,2,2)
% rlocus(G)
% title 'open loop locus'
% grid on
% 
% %sisotool(G,C)
% feedback= (G)/(1+C*G);
% 
% figure(2)
% subplot(1,2,1)
% step(feedback)
% grid on
% subplot(1,2,2)
% rlocus(feedback);
% title 'closed loop locus'
% grid on
% 
% disp(' fb poles');
% disp(pole(feedback));
% disp(' fb zeros');
% disp(zero(feedback));
% 
% figure(3)
% subplot(1,2,1)
% step(feedback);
% title 'feedback with unitary loop'
% 
% grid on
% subplot(1,2,2)
% step((C*G)/(1+C*G));
% title 'feedback as for sisotool'
% grid on


















