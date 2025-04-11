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
load(fullfile(common_files,"current_controller_tf.mat"));
load(fullfile(common_files,"dTheta_controller.mat"));


load(fullfile(common_files,"transfer_dThetaRef_to_theta.mat"))

disp('transfer_dThetaRef_to_theta poles');
disp(pole(transfer_dThetaRef_to_theta));
disp('transfer_dThetaRef_to_theta zeros');
disp(zero(transfer_dThetaRef_to_theta));

%sisotool(transfer_dThetaRef_to_theta)