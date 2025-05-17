% homework 3 - position-velocity-current control
DCX22L_113_1_18V;

C_current = 5000 * (1 + 0.002*s)/s;
% C_current = 4000 * (1 + 0.2*s)/s;

motor_velocity = feedback(C_current * motor_current, 1) * K * Me;

% sisotool(motor_velocity);

C_velocity =  1000 * (0.02*s + 1)/s;

motor_position = feedback(C_velocity * motor_velocity, 1) * 1/s;

% sisotool(motor_position);

C_position = 300*(1 + 0.2*s)/s;
% C_position = 100*(1 + 1*s)/s;

complete_motor_system = feedback(C_position * motor_position, 1);



%% automatic tuning session

C_current_auto = C_current; %tunablePID('C_current_auto','pi');
% C_current_auto.Kp.Minimum = 0;
% C_current_auto.Ki.Minimum = 0;
% C_current_auto.Kp.Maximum = 100;
% C_current_auto.Ki.Maximum = 20;

C_velocity_auto = tunablePID('C_velocity_auto','pi');
C_velocity_auto.Kp.Minimum = 0;
C_velocity_auto.Ki.Minimum = 0;
C_velocity_auto.Kp.Maximum = 50;
C_velocity_auto.Ki.Maximum = 10;

C_position_auto = tunablePID('C_position_auto','pd');
C_position_auto.Kp.Minimum = 0;
C_position_auto.Kd.Minimum = 0;
C_position_auto.Kp.Maximum = 20;
C_position_auto.Kd.Maximum = 5;

in_current = AnalysisPoint('inCurrent');
out_C_current = AnalysisPoint('outCCurrent');
out_current = AnalysisPoint('outCurrent');
in_velocity = AnalysisPoint('inVelocity');
out_C_velocity =  AnalysisPoint('outCVelocity');
out_velocity = AnalysisPoint('outVelocity');

in_torque_disturbance = AnalysisPoint('in_torque_disturbance');

out_C_position=  AnalysisPoint('outCPosition');

current_subsystem = in_current * feedback(C_current_auto * out_C_current * motor_current, 1) * out_current;
velocity_subsystem = in_velocity * feedback(C_velocity_auto * out_C_velocity *  current_subsystem * K * in_torque_disturbance * Me, 1) * out_velocity;
position_system = feedback(C_position_auto * out_C_position* velocity_subsystem * 1/s, 1);

controlSystemTuner(position_system);

%% results after tuning 

C_current_autotuned = 5.29e5 + 2.01e6/s;

C_velocity_autotuned = 1.04 + 1.05e-7/s; 

C_position_autotuned = 7.23 + -0.573 * s / (0.0793 * s + 1);

autotuned_motor_velocity = feedback(C_current_autotuned * motor_current, 1) * K * Me;
autotuned_motor_position = feedback(C_velocity_autotuned * autotuned_motor_velocity, 1) * 1/s;
autotuned_motor_system = feedback(C_position_autotuned * autotuned_motor_position, 1);

%% plots 

figure();
subplot(121);
hold on;
stepplot(autotuned_motor_system);
stepplot(complete_motor_system);
stepplot(feedback(C_position_integrator*motor*1/s, 1));
legend('Autotuned cascaded control','Manual-tuned cascaded control', 'position control');
grid on;


subplot(122);
hold on;
margin(autotuned_motor_system);
margin(complete_motor_system);
margin(feedback(C_position_integrator*motor*1/s, 1));
legend('Autotuned cascaded control','Manual-tuned cascaded control', 'position control');
grid on;
