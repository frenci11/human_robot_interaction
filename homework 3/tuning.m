% tuned controllers for the position-velocity-current cascaded control
DCX22L_113_1_18V;

C_current = 5000 * (1 + 0.002*s)/s;
% C_current = 4000 * (1 + 0.2*s)/s;

motor_velocity = feedback(C_current * motor_current, 1) * K * Me;

% sisotool(motor_velocity);

C_velocity =  1000 * (0.02*s + 1)/s;

motor_position = feedback(C_velocity * motor_velocity, 1) * 1/s;

% sisotool(motor_position);

C_position = 300*(1 + 0.2*s)/s;

complete_motor_system = feedback(C_position * motor_position, 1);

enable_saturators = false;