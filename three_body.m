clear; close all; clc;

m1 = 5.5e4;
m2 = 4.5e4;
m3 = 3.5e4;

v0_1 = [2; 5.1; 3];
v0_2 = [2; -3; -0.8];
v0_3 = [-1.5; 1.5; -1];

p1 = [-8000; -5000; -6000];
p2 = [-3000; 7000; 5000];
p3 = [5000; -7000; 5000];

m = [m1; m2; m3];
v0 = [v0_1, v0_2, v0_3];
p0 = ([p1, p2, p3]);

ts = 10;
tend = 5000000;
t = 0 : ts : tend;

v = v0;
p = zeros(3, 3, length(t));
p(:, :, 1) = p0;
lim = 100000;

for i = 2 : length(t)
    a = acc_calcu(p(:, :, i-1), m, 10);
    v = v + a * ts;
    p(:, 1, i) = p(:, 1, i-1) + v(:, 1) * ts;
    p(:, 2, i) = p(:, 2, i-1) + v(:, 2) * ts;
    p(:, 3, i) = p(:, 3, i-1) + v(:, 3) * ts; 

    clf
    plot3(p(1,1,i), p(2,1,i), p(3,1,i), 'r.', "MarkerSize", 25)
    axis([-lim, lim, -lim, lim, -lim, lim])
    hold on
    grid minor
    plot3(p(1,2,i), p(2,2,i), p(3,2,i), 'c.', "MarkerSize", 25)
    plot3(p(1,3,i), p(2,3,i), p(3,3,i), 'b.', "MarkerSize", 25)
    pause(0.001);
end


function acc = acc_calcu(p, m, c)
% - p: position, 3x3
% - m: mass, 3x1
% - c: gravity constant, 1x1
    acc = zeros(3, 3);
    acc(:, 1) = (c*m(2) * (p(:, 2) - p(:, 1)) / norm(p(:, 2) - p(:, 1)).^3 ...
                 + c*m(3) * (p(:, 3) - p(:, 1)) / norm(p(:, 3) - p(:, 1)).^3);

    acc(:, 2) = (c*m(3) * (p(:, 3) - p(:, 2)) / norm(p(:, 3) - p(:, 2)).^3 ...
                 + c*m(1) * (p(:, 1) - p(:, 2)) / norm(p(:, 1) - p(:, 2)).^3);

    acc(:, 3) = (c*m(1) * (p(:, 1) - p(:, 3)) / norm(p(:, 1) - p(:, 3)).^3 ...
                 + c*m(2) * (p(:, 2) - p(:, 3)) / norm(p(:, 2) - p(:, 3)).^3);
end

