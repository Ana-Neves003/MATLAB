clear all;
close all;
clc

% Carregar sinal de ECG a partir do arquivo .mat
load('MIT-BIH Arrhythmia Database/101m.mat');
sinal_original =(val(1,:));

% Frequência de amostragem
fs = 1000;  % Supondo uma frequência de amostragem de 1000 Hz

% Calcular PSD usando FFT
N = length(sinal_original);
frequencias = (0:N-1) * fs / N;

% Aplicar FFT e calcular PSD
psd = abs(fft(sinal_original)).^2 / N;

% Plotar o espectro de frequência
figure;
plot(frequencias, 10*log10(psd));
title('Espectro de Frequência do Sinal de ECG');
xlabel('Frequência (Hz)');
ylabel('Potência (dB)');
grid on;

% Encontrar a frequência que corresponde ao pico máximo no espectro
[~, idx_max] = max(psd);
best_frequency = frequencias(idx_max);

fprintf('A frequência dominante no sinal é aproximadamente %.2f Hz.\n', best_frequency);
