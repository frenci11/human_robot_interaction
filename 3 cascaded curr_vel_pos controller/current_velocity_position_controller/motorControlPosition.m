%motor position, cascaded velocity, cascaded current control

clc
clear

set(cstprefs.tbxprefs,'FrequencyUnits','Hz')
common_files= fullfile('..','common_files/');


s = tf('s');

load(fullfile(common_files,"El.mat"));
load(fullfile(common_files,"Me.mat"));
load(fullfile(common_files,"Kt.mat"));
%loading previous controllers to cascade them to plant
i_controller=load(fullfile(common_files,"current_controller_tf.mat"));
i_controller=i_controller.C;
dTheta_controller=load(fullfile(common_files,"dTheta_controller.mat"));
dTheta_controller=dTheta_controller.C;


v_to_i=( El / (1+(El*Me*Kt^2)) );
%transfer function from i_ref to d_theta
iRef_to_dTheta = minreal((i_controller*v_to_i/(1+i_controller*v_to_i))*Kt*Me);

plant = feedback(iRef_to_dTheta*dTheta_controller,1)*1/s;

disp('plant poles');
disp(pole(plant));
disp('plant zeros');
disp(zero(plant));


% load(fullfile(common_files,"transfer_dThetaRef_to_theta.mat"))
% 
% disp('transfer_dThetaRef_to_theta poles');
% disp(pole(transfer_dThetaRef_to_theta));
% disp('transfer_dThetaRef_to_theta zeros');
% disp(zero(transfer_dThetaRef_to_theta));

theta_controller=load(fullfile(common_files,"theta_controller.mat"));
theta_controller=theta_controller.C;

%sisotool(plant,1)


%% trajectory generation
syms t

amplitude=1.5;
frequency=10;
phase=0;

theta=amplitude*sin(frequency*t+phase);
d_theta=diff(theta,t);
dd_theta=diff(d_theta,t);

theta=matlabFunction(theta,Vars=t);
d_theta=matlabFunction(d_theta,Vars=t);
dd_theta=matlabFunction(dd_theta,Vars=t);











