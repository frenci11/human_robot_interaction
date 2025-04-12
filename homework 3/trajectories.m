
syms A t f ;

sinusoidal_trajectory = A*sin(2*pi*f*t);

sinusoidal_trajectory = [
    sinusoidal_trajectory;
    diff(sinusoidal_trajectory, t);
    diff(diff(sinusoidal_trajectory,t),t);
];

sinusoidal_trajectory = matlabFunction(sinusoidal_trajectory,Vars=[t, f, A]);



