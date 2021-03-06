%% run duifhuis model with a pure tone
f0 = 1000;  %frequency
a = 1;      %amplitude
dur = 0.02; %stimulus duration
rho = 1000; %density of water
n_osc = 300; %number of oscilators

% for each oscillator the acceleration is
% g = (dv1 V + dv3 V^3 + dvy2 V Y^2 )*omega/20 + (Y + dy3 Y^3)*omega^2

coefs.dv1 = 1;
coefs.dv3 = 1E8;
coefs.dvy2 = 0;
coefs.dy3 = 0;

fs = 10e5;              % frequency sampling
n_t = round(dur*fs);    % length of stimulus in samples
t = (0:n_t-1)/fs;

dx = 0.035/n_osc;
x = (0:n_osc-1)*dx;
f_base_exp_map = 22507;
kappa_exp_map = 65.1;
f = f_base_exp_map * 10.^( -kappa_exp_map * x );  %frequency map

X = a*sin(2*pi*t*f0)';
X = X.*tukeywin(n_t);
X = [X; zeros(fs*0.02,1)];

stimulus = conv(X,[1 -2 1],'same');     %computes second derivative or acceleration

tic
[Y_t V_t] = duifhuis(stimulus,fs,n_osc,rho,coefs);
toc

%   output are displacemtne Y_t and velocity V_t, both matrix of n_osc vs n_t

Y_mean = sqrt(mean(Y_t.^2,2));
plot(f,Y_mean)