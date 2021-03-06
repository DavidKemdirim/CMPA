% PA 8 for ELEC 4700

format short
close all
clear 
clc

pA = 1e-12; % picoamps

is = 0.01*pA;
ib = 0.1*pA;
vb = 0.3; % Volts
gp = 0.1; % 1/ohms

Eq = @(v) is*(exp(1.2*v/0.025)-1) + gp*v - ib*(exp(-1.2/0.25*(v+vb))-1);
% Eq = @(v) is*(exp(1.2*v/0.025)-1) + gp*v - ib*(exp(-1.2/0.025*(v+vb))-1);
% Keeping the exp denominator in teh breakdown term as 0.025 would make
% horrible fits where the y axis magnitude as on the order of 10^21

V = linspace(-1.95,0.7,200)';
I = Eq(V);

% Current noise
% for i = 1:length(V)
%     r = (rand*0.2-0.1);
%     I(i) = I(i)*(1+r);
% end


% ployfit/polyval
fit4 = polyfit(V,I,4);
fit8 = polyfit(V,I,8);
xvals = linspace(V(1),V(length(V)));
poly4 = polyval(fit4,xvals);
poly8 = polyval(fit8,xvals);

% fit
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1*x - C*(exp(1.2*(-(x+0.3))/25e-2)-1)');
ff2 = fit(V,I,fo2);
fit2 = ff2(V);

fo3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+0.3))/25e-2)-1)');
ff3 = fit(V,I,fo3);
fit3 = ff3(V);

fo4 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-2)-1)');
ff4 = fit(V,I,fo4);
fit4 = ff4(V);

% Neural Network
inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net)
Inn = outputs;


% Linear Poly Plots
figure(1)
subplot(3,2,1),plot(V,I,'r')
grid on
hold on
subplot(3,2,1),plot(xvals,poly4,'g--')
subplot(3,2,1),plot(xvals,poly8,'b--')
legend('data','poly4','poly8')
title('Diode I-V Curve')
xlabel('V (V)'),ylabel('I (A)')

% Log Poly Plots
figure(1)
subplot(3,2,2),semilogy(V,abs(I),'r')
grid on
hold on
subplot(3,2,2),semilogy(xvals,abs(poly4),'g--')
subplot(3,2,2),semilogy(xvals,abs(poly8),'b--')
legend('data','poly4','poly8')
title('Diode I-V Curve')
xlabel('V (V)'),ylabel('abs(I) (A)')

% Linear Fit Plots
figure(1)
subplot(3,2,3),plot(V,I,'r')
grid on
hold on
subplot(3,2,3),plot(V,fit2,'k--')
subplot(3,2,3),plot(V,fit3,'b--')
subplot(3,2,3),plot(V,fit4,'g--')
legend('data','fit2','fit3','fit4')
title('Diode I-V Curve')
xlabel('V (V)'),ylabel('I (A)')

% Log Fit Plots
figure(1)
subplot(3,2,4),semilogy(V,abs(I),'r')
grid on
hold on
subplot(3,2,4),plot(V,abs(fit2),'k--')
subplot(3,2,4),plot(V,abs(fit3),'b--')
subplot(3,2,4),plot(V,abs(fit4),'g--')
legend('data','fit2','fit3','fit4')
title('Diode I-V Curve')
xlabel('V (V)'),ylabel('abs(I) (A)')

% Linear NN Plots
figure(1)
subplot(3,2,5),plot(V,I,'r')
grid on
hold on
subplot(3,2,5),plot(inputs,outputs,'k--')
legend('data','nn')
title('Diode I-V Curve')
xlabel('V (V)'),ylabel('I (A)')

% Log NN Plots
figure(1)
subplot(3,2,6),semilogy(V,abs(I),'r')
grid on
hold on
subplot(3,2,6),plot(inputs,abs(outputs),'k--')
legend('data','nn')
title('Diode I-V Curve')
xlabel('V (V)'),ylabel('abs(I) (A)')

plotbrowser('toggle')

