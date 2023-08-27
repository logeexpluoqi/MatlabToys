clear; close all; clc;

[u,t] = gensig("square", 3, 10);
y1 = zeros(1, length(t));
y2 = zeros(1, length(t));
y3 = zeros(1, length(t));
fc = 10;
ts = 0.001;

alpha = 1 / (2 * pi * fc * ts + 1);

u_k1 = 0;
y_k1 = 0;

for i = 1:length(t)
    y1(i) = alpha * (u(i) - u_k1 + y_k1);
    u_k1 = u(i);
    y_k1 = y1(i);
end
for i = 1:length(t)
    y2(i) = alpha * (y1(i) - u_k1 + y_k1);
    u_k1 = y1(i);
    y_k1 = y2(i);
end
for i = 1:length(t)
    y3(i) = alpha * (y2(i) - u_k1 + y_k1);
    u_k1 = y1(i);
    y_k1 = y2(i);
end


plot(t, u, '-', ...
    t, y1, '.-', ...
    t, y2, '.-', ...
    t, y3, '.-');
legend("signal", "1 order", "2 order", "3 order")

