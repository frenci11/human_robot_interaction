%es3 motor current-position control

clc
clear

set(cstprefs.tbxprefs,'FrequencyUnits','Hz')

%load the motor plant (from v to theta) and the previous current_controller.
%calculated with sisotool
load('..\homework 1\motor_plant_tf.mat');
iC=load('..\homework 2\current_controller_tf.mat');
iC=iC.C;


%loading single block for simulink, even if i already have
%the complete TF
load('..\homework 2\El.mat');
load('..\homework 2\Me.mat');
load('..\homework 2\Kt.mat');


%using simulink to linearize the model with current controller embedded,
%so to have a transfer function plant from i_ref to theta.
open_system('current_position_feedback.slx')

%you use model linearizer, specify in/out of the desired tf, and then convert
%from statespace to tf
plant=load("plant_with_current_controller.mat");
%this is the precomputed tf from simulink
plant=tf(plant.linsys1);
tf(plant)

%loading new position controller from sisotool
pC=load('new_position_comtroller.mat');
pC=pC.C;



figure(1)
rlocus(plant)
title 'open loop plant'
grid on

sisotool(plant,pC);