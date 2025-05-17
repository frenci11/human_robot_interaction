

syms t real;

A = 0.1;
f0 = 0;
f1 = 20;
t1 = 20;

sweep_traj = A * sin(2*pi*(f0 * t + (f1 - f0) * t^2 / (2 * t1)));
sweep_dtraj = diff(sweep_traj);
sweep_ddtraj = diff(sweep_dtraj);

sweep_traj = matlabFunction(sweep_traj, Vars=[t]);
sweep_dtraj = matlabFunction(sweep_dtraj, Vars=[t]);
sweep_ddtraj = matlabFunction(sweep_dtraj, Vars=[t]);