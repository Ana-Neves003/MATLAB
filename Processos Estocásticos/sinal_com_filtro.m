clear all;
close all;
clc

%Plote do primeiro sinal ECG
%load('MIT-BIH Arrhythmia Database/100m.mat');
load('MIT-BIH Arrhythmia Database/100m.mat');
sinal_original =(val(1,:));
%figure;
%plot(sinal_original);

%Parâmetros do filtro passa alta
fs = 1000;  %Frequência de Amostragem
fc = 40;    %Frequência de Corte
ordem = 2;  %Ordem do filtro

%Calcula os coeficientes do filtro Butterworth
[b, a] = butter(ordem, fc/(fs/2), 'high'); %ordem do filtro, frequencia de corte normalizada, filtro passa-alta

%Resposta de frequência do filtro
%freqz(b, a, 1024, fs);

%Aplica o filtro a sinal
%sinal_filtrado = filter(b, a, sinal_original);
sinal_filtrado = filtfilt(b, a, sinal_original);

% Tempo correspondente ao sinal
t = (0:length(sinal_original)-1) / fs;
%t = (1:length(sinal_original));

% Plota os sinais original e filtrado
figure;
subplot(2,1,1);
plot(sinal_original);
title('Sinal de ECG Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(sinal_filtrado);
title('Sinal de ECG Filtrado');
xlabel('Tempo (s)');
ylabel('Amplitude');

