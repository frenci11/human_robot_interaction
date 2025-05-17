
%this scripts shows 2 numerical methods for solving n-order O.D.E (for autonomus and
%non autonomus types, the equation needs to have it's variables separated correctly)

%in particular it compares backward euler vs 4_th order Runhe_Kutta approximation,
%against analytical solution.

clc
clear
syms x y C

t_o =0;
t_end =40;
dt= 0.001;

%dy/dx=sin(x)^2*y(x)
dy=sin(cos(x))^3*y;

%separable variable equation, need to separate variables
% before integrating both sides
C_enable=0;
exact_sol = int(dy/(1*y), x) + 0;
% Explicit symbolic solution
%sometimes the solver may not give explicit solution.
%so the next lines for finding the correct C value given the initial condition
%may not work. in this case, set C_enable=0 and do not put C after exact_sol
exact_sol= solve(int(1/(1*y),y)==exact_sol,y)

dy=matlabFunction(dy,'Vars',[x,y]);

steps=round((t_end-t_o)/dt);

y_sol=zeros(1,steps);

%initial conditions
y_sol(1)=1;
y_kutta=y_sol;



for n=1:steps-1

    %backward Euler
    y_sol(n+1)=y_sol(n) + dt*dy(n*dt,y_sol(n));

    %Runge Kutta
    k1=dy(n*dt,y_kutta(n));
    k2=dy(n*dt + dt/2 , y_kutta(n) + dt*k1/2);
    k3=dy(n*dt + dt/2 , y_kutta(n) + dt*k2/2);
    k4=dy(n*dt + dt, y_kutta(n) + dt*k3);

    y_kutta(n+1)=y_kutta(n) + dt/6*(k1+2*k2+2*k3+k4);


end


%ensuring same initial conditions C (y_sol(1)) for numerical and analytical solutions
if(C_enable)
    C_val = solve(subs(exact_sol, x, t_o) == y_sol(1) , C)
    exact_sol = simplify(subs(exact_sol, C, C_val));
end

figure(1);
clf
hold on;
plot(linspace(t_o,t_end,steps),y_sol, 'b-', 'DisplayName', 'Backward Euler','LineWidth',1);
plot(linspace(t_o,t_end,steps),y_kutta, 'Color','#EDB120', 'DisplayName', 'Runge Kutta','LineWidth',1);
fplot(exact_sol, [t_o t_end], 'r-', 'DisplayName', 'Explicit Solution','LineWidth',1);
grid on;
grid minor;
hold off;

legend('show');
title('Backward Euler, Runge Kutta vs Explicit Solution');



