%motor velocity, cascaded current control

clc
clear

set(cstprefs.tbxprefs,'FrequencyUnits','Hz')
common_files= fullfile('..','common_files/');


s = tf('s');

load(fullfile(common_files,"El.mat"));
load(fullfile(common_files,"Me.mat"));
load(fullfile(common_files,"Kt.mat"));
%loading previous controller to cascade it to plant
i_controller=load(fullfile(common_files,"current_controller_tf.mat"));
i_controller=i_controller.C;

v_to_i=( El / (1+(El*Me*Kt^2)) );
%transfer function from i_ref to d_theta
plant =minreal((i_controller*v_to_i/(1+i_controller*v_to_i))*Kt*Me);


disp('plant poles');
disp(pole(plant));
disp('plant zeros');
disp(zero(plant));


% figure(1)
% pzmap(plant)
% bode(plant)
% %step(plant);


%controller computed with sisotool
dTheta_controller=load(fullfile(common_files,"dTheta_controller.mat"));
dTheta_controller=dTheta_controller.C;

%sisotool(transfer_iRef_to_dTheta)









