s = tf('s');

Jm = 0.1;
d = 0.01;

theta_0 = 0.5;
k_e = [1 10 100 1000];

% tau_s = k_e * (theta_e - theta_0)
% transfer function from tau_m (motor torque) to tau_s(env torque)

plants = cell([1, size(k_e,2)]);

for i = 1:size(k_e, 2)
    plants{1, i} = tf(1 / ((Jm/k_e(i))*s^2 + (d/k_e(i))*s + 1));
end

stackedPlants = stack(1, plants{:});

sisotool(stackedPlants);