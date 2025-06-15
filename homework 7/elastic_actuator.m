clc
clear

G=load("plant_tf.mat","linsys1");
C=load("controller.mat")
C=C.C;
G=G.linsys1;

s = tf('s');

Jm= 0.1;
d= 0.01;
K_e = 10;
theta_o=2;
r=1;

%tf from tau_m to dd_theta
plant = s^2/(Jm*r^2*(s^2+(d/Jm)*s))

%sisotool(G,1)