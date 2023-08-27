clear; clc; close all;

dy = @(x, y) sqrt(x)/(y + 1) + cos(x) + sin(3 * y);

h = 0.5;
tspan = [0,15];

n = (tspan(2) - tspan(1)) / h;
t0 = tspan(1);

%% sim rk4 and euler
y_1st = zeros(n, 1);
y_1st(1) = dy(t0, 0);

y_2st = y_1st;
y_2st(1) = y_1st(1);

rk4 = y_1st;
rk4(1) = y_1st(1);
for i = 1 : n
    tn = (h * (i - 1) + t0);
    y_1st(i+1) = y_1st(i) + h  * dy(tn, y_1st(i));

    y_hat = y_2st(i) + h * dy(tn, y_2st(i));
    y_2st(i+1) = y_2st(i) + (h/2) * (dy(tn, y_2st(i)) + dy(tn + h, y_hat));

    k1 = dy(tn, rk4(i));
    k2 = dy(tn + h/2, rk4(i) + (h/2) * k1);
    k3 = dy(tn + h/2, rk4(i) + (h/2) * k2);
    k4 = dy(tn + h, rk4(i) + h * k3);
    rk4(i+1) = rk4(i) + (h/6) * (k1 + 2*k2 + 2*k3 + k4);
end

%% sim rk45
rk45(1) = rk4(1);
tol = 0.0003;
h45 = h;
max_h = h / 2;
i = 1;
t45(1) = t0;
tn = t0;
while(tn < tspan(2))
    bingo = false;
    while(~bingo)
        k1 = dy(tn, rk45(i));
        k2 = dy(tn + 0.25 * h45, rk45(i) + 0.25 * h45 * k1);
        k3 = dy(tn + 0.375 * h45, rk45(i) + 0.09375 * h45 * k1 + 0.28125 * h45 * k2);
        k4 = dy(tn + (12 / 13) * h45, rk45(i) + (1932 / 2197) * h45 * k1 - (7200 / 2197) * h45 * k2 + (7296 / 2197) * h45 * k3);
        k5 = dy(tn + h45, rk45(i) + (439 / 216) * h45 * k1 - 8 * h45 * k2 + (3680 / 513) * h45 * k3 - (845 / 4104) * h45 * k4);
        k6 = dy(tn + 0.5 * h45, rk45(i) - (8 / 27) * h45 * k1 + 2 * h45 * k2 - (3544 / 2565) * h45 * k3 + (1859 / 4104) * h45 * k4 - 0.275 * h * k5);
        w = rk45(i) + h45 * ((25 / 216) * k1 + (1408 / 2565) * k3 + (2197 / 4104) * k4 - 0.2 * k5);
        z = rk45(i) + h45 * ((16 / 135) * k1 + (6656 / 12825) * k3 + (28561 / 56430) * k4 - (9 / 50) * k5 + (2 / 55) * k6);
        e = abs(z - w);
        if(e / abs(w) < tol)
            rk45(i+1) = z;
            tn = tn + h45;
            h45 = h45 * 2;
            bingo = true;
        else
            h45 = h45 / 2;
        end
        if(h45 > max_h)
            h45 = max_h;
        end
    end
    i = i + 1;
    t45(i) = tn;
end


%% matlab ode45
[t, yi] = ode45(dy, tspan, dy(t0, 0));

%% show
plot(...
    tspan(1):h:tspan(2), y_1st, 'x-', ...
    tspan(1):h:tspan(2), y_2st, 'x-', ...
    tspan(1):h:tspan(2), rk4, '.-', ...
    t45, rk45, '.-', ...
    t, yi, '.-');
legend(...
    "euler 1st", ...
    "euler 2st", ...
    "rk4", ...
    "rk45", ...
    "ode45")
title("dy/dx = sqrt(x) / (y + 1) + cos(x) + sin(3 * y)")
ylabel("y")
xlabel("x")
grid on
