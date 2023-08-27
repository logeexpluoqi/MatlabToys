t = 1 : 1000;
nsig = 5 * sin(0.01 * t) + rand(1, length(t)) + randn(1, length(t)) + 5 * cos(0.05 * t + pi/1.5);
kf = zeros(size(nsig));

x = 0; % state, x(k) = a * x(k-1) + b * u(k)
a = 1; % state transfer matrix
b = 0; % control matrix
h = 1; % observer matrix
p = 0; % estimate cov
q = 0.2; % process cov
r = 0.8; % observer cov
g = 0; % kalman gain

gain =zeros(size(nsig));

for i = 1 : length(nsig)
    x = a * x + b * nsig(i);
    p = a * p * a + q;

    g = p * h / (h * p * h + r);
    x = x + g * (nsig(i) - h * x);
    p = (1 - g * h) * p;

    kf(i) = x;
    gain(i) = g;
end

plot(t, nsig, '.-', t, kf, '.-', t, gain, '.-');
legend("noise", "filtered", "kalman gain");
grid on;