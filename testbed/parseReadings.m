close all;
clc;

% loads raw data from ForeCast csv exports
FF_sweep_csv = readtable('./testbed/recordings/FF_sweep.csv');
PID_sweep_csv = readtable('./testbed/recordings/PID_sweep.csv');

FF_sweep = struct();

FF_sweep.tauM = timeseries(FF_sweep_csv.tauM,FF_sweep_csv.t);
FF_sweep.thetaM = timeseries(FF_sweep_csv.thetaM,FF_sweep_csv.t);
FF_sweep.Reference  = timeseries(FF_sweep_csv.Reference,FF_sweep_csv.t);

[FF_sweep_tf_est, f] = tfestimate(FF_sweep.Reference.Data,FF_sweep.thetaM.Data,512,[],1:0.1:20,2000);

FF_sweep.tf_est = struct('mag_db', 20*log10(abs(FF_sweep_tf_est)), 'phase_deg', angle(FF_sweep_tf_est)*180/pi,'f', f);

PID_sweep = struct();

PID_sweep.tauM = timeseries(PID_sweep_csv.tauM,PID_sweep_csv.t);
PID_sweep.thetaM = timeseries(PID_sweep_csv.thetaM,PID_sweep_csv.t);
PID_sweep.Reference  = timeseries(PID_sweep_csv.Output,PID_sweep_csv.t);

[PID_sweep_tf_est, f] = tfestimate(PID_sweep.Reference.Data,PID_sweep.thetaM.Data,512,[],1:0.1:20,2000);

PID_sweep.tf_est = struct('mag_db', 20*log10(abs(PID_sweep_tf_est)), 'phase_deg', angle(PID_sweep_tf_est)*180/pi, 'f', f);

%% load sim data

load simout.mat;

sim_FF_sweep = struct();

sim_FF_sweep.tauM = out.logsout.getElement('tauM_ff').Values;
sim_FF_sweep.thetaM = out.logsout.getElement('thetaM_ff').Values;
sim_FF_sweep.Reference  =  out.logsout.getElement('Reference').Values;

[sim_FF_sweep_tf_est, sim_f] = tfestimate(sim_FF_sweep.Reference.Data,sim_FF_sweep.thetaM.Data,512,[],1:0.1:20,2000);

sim_FF_sweep.tf_est = struct('mag_db', 20*log10(abs(sim_FF_sweep_tf_est)), 'phase_deg', angle(sim_FF_sweep_tf_est)*180/pi,'f', f);

sim_PID_sweep = struct();

sim_PID_sweep.tauM = out.logsout.getElement('tauM_PID').Values;
sim_PID_sweep.thetaM = out.logsout.getElement('thetaM_PID').Values;
sim_PID_sweep.Reference  = out.logsout.getElement('Reference').Values;

[sim_PID_sweep_tf_est, sim_f] = tfestimate(sim_PID_sweep.Reference.Data,sim_PID_sweep.thetaM.Data,512,[],1:0.1:20,2000);

sim_PID_sweep.tf_est = struct('mag_db', 20*log10(abs(sim_PID_sweep_tf_est)), 'phase_deg', angle(sim_PID_sweep_tf_est)*180/pi, 'f', f);


%% plots

figure("Name", 'Test bed');
subplot(231);
title('PID controller');
hold on;
grid on;
plot(PID_sweep.Reference);
plot(PID_sweep.thetaM);
xlabel('time (t)');
ylabel('amplitude (rad)');

subplot(232);
title('PID controller - freq. response');
hold on;
grid on;
plot(f, PID_sweep.tf_est.mag_db);
yline(-3, 'r--', '-3 dB'); 
xlabel('freq. (Hz)');
ylabel('magnitude (dB)');
xlim([1 20]);

subplot(233);
title('PID controller - freq. response');
hold on;
grid on;
plot(f, PID_sweep.tf_est.phase_deg);
yline(-180, 'r--', '-180 deg'); 
xlabel('freq. (Hz)');
ylabel('phase (deg)');
xlim([1 20]);

subplot(234);
title('FF controller');
hold on;
grid on;
plot(FF_sweep.Reference);
plot(FF_sweep.thetaM);
xlabel('time (t)');
ylabel('amplitude (rad)');

subplot(235);
title('FF controller - freq. response');
hold on;
grid on;
plot(f, FF_sweep.tf_est.mag_db);
yline(-3, 'r--', '-3 dB'); 
xlabel('freq. (Hz)');
ylabel('magnitude (dB)');
xlim([1 20]);

subplot(236);
title('PID controller - freq. response');
hold on;
grid on;
plot(f, FF_sweep.tf_est.phase_deg);
yline(-180, 'r--', '-180 deg'); 
xlabel('freq. (Hz)');
ylabel('phase (deg)');
xlim([1 20]);

%%

figure("Name", 'Simulation');

subplot(231);
title('PID controller');
hold on;
grid on;
plot(sim_PID_sweep.Reference);
plot(sim_PID_sweep.thetaM);
xlabel('time (t)');
ylabel('amplitude (rad)');

subplot(232);
title('PID controller - freq. response');
hold on;
grid on;
plot(sim_f, sim_PID_sweep.tf_est.mag_db);
yline(-3, 'r--', '-3 dB'); 
xlabel('freq. (Hz)');
ylabel('magnitude (dB)');
xlim([1 20]);

subplot(233);
title('PID controller - freq. response');
hold on;
grid on;
plot(sim_f, sim_PID_sweep.tf_est.phase_deg);
yline(-180, 'r--', '-180 deg'); 
xlabel('freq. (Hz)');
ylabel('phase (deg)');
xlim([1 20]);

subplot(234);
title('FF controller');
hold on;
grid on;
plot(sim_FF_sweep.Reference);
plot(sim_FF_sweep.thetaM);
xlabel('time (t)');
ylabel('amplitude (rad)');

subplot(235);
title('FF controller - freq. response');
hold on;
grid on;
plot(sim_f, sim_FF_sweep.tf_est.mag_db);
yline(-3, 'r--', '-3 dB'); 
xlabel('freq. (Hz)');
ylabel('magnitude (dB)');
xlim([1 20]);

subplot(236);
title('PID controller - freq. response');
hold on;
grid on;
plot(sim_f, sim_FF_sweep.tf_est.phase_deg);
yline(-180, 'r--', '-180 deg'); 
xlabel('freq. (Hz)');
ylabel('phase (deg)');
xlim([1 20]);
