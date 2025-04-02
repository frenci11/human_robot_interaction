
%homework 1 motor position control
clc
clear

set(cstprefs.tbxprefs,'FrequencyUnits','Hz')

load position_controller_sisotool.mat

% maxon DCX22L with ratio 1:1
% r = 1;
% Kt = 0.0705*r; 
% Im = 0.0003*r^2;
% Fm = 0.00001*r^2; 
% Kv = 1/(2*pi*135/60)*r;
% Ra = 0.343;
% La = 0.000264;


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
%mechanical
Me =  Kt / (s*Im + Fm);


%transfer function from v to theta
plant = 1/s*( (El*Me) / (1+(El*Me*Kt)) )

save('motor_plant_tf.mat','plant');

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
p_controller=load("position_controller_tf.mat");
p_controller=p_controller.C
subplot(1,2,2)

feedback=(p_controller*plant)/(1+p_controller*plant);

rlocus(feedback)
title 'closed loop'
grid on

disp('closed loop poles');
disp(pole(feedback))
disp('closed loop zeros');
disp(zero(feedback))

sisotool(plant,p_controller);

open_system("Feedback_Configuration_1.slx");











