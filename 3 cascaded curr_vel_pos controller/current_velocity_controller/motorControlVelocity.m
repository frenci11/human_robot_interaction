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
load(fullfile(common_files,"current_controller_tf.mat"));


%transfer function from i_ref to d_theta computed with linear system toolbox
load(fullfile(common_files,"transfer_iRef_to_dTheta.mat"))

disp('transfer_iRef_to_dTheta poles');
disp(pole(transfer_iRef_to_dTheta));
disp('transfer_iRef_to_dTheta zeros');
disp(zero(transfer_iRef_to_dTheta));


%controller computed with sisotool
%dTheta_controller=load(fullfile(common_files,"dTheta_controller.mat"));
%dTheta_controller=dTheta_controller.dTheta_controller;

%sisotool(transfer_iRef_to_dTheta)