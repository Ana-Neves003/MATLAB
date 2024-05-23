clear all;
close all;
clc

%------------------------------Sinais ECG----------------------

load('MIT-BIH Arrhythmia Database/101m.mat');
ecg_signal1 =(val(1,:));
load('MIT-BIH Arrhythmia Database/102m.mat');
ecg_signal2 =(val(1,:));
load('MIT-BIH Arrhythmia Database/103m.mat');
ecg_signal3 =(val(1,:));
load('MIT-BIH Arrhythmia Database/104m.mat');
ecg_signal4 =(val(1,:));
load('MIT-BIH Arrhythmia Database/105m.mat');
ecg_signal5 =(val(1,:));

% Plote dos sinais originais e da média
t = (1:length(ecg_signal1));  % Tempo em amostras
figure;
subplot(5,1,1);
plot(t, ecg_signal1);
title('Sinal ECG 1');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(5,1,2);
plot(t, ecg_signal2);
title('Sinal ECG 2');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(5,1,3);
plot(t, ecg_signal3);
title('Sinal ECG 3');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(5,1,4);
plot(t, ecg_signal4);
title('Sinal ECG 4');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(5,1,5);
plot(t, ecg_signal5);
title('Sinal ECG 5');
xlabel('Tempo (s)');
ylabel('Amplitude');
