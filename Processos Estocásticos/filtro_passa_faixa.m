% Carregar sinal de ECG a partir do arquivo .mat
load('MIT-BIH Arrhythmia Database/101m.mat');
sinal_original =(val(1,:));

% Frequência de amostragem
fs = 1000;  % Supondo uma frequência de amostragem de 1000 Hz

% Projetar o filtro passa-faixa para Taquicardia Ventricular
f_low = 100;  % Frequência de corte inferior
f_high = 250; % Frequência de corte superior

% Normalizar as frequências
Wn = [f_low f_high] / (fs / 2);

% Ordem do filtro (ajuste conforme necessário)
order = 4;

% Projetar filtro passa-faixa Butterworth
[b, a] = butter(order, Wn, 'bandpass');

% Aplicar o filtro ao sinal de ECG
ecg_filtrado = filtfilt(b, a, sinal_original);

% Tempo correspondente ao sinal
t = (0:length(sinal_original)-1) / fs;

% Plotar resultados
figure;

% Plotar sinal de ECG original
subplot(2,1,1);
plot(t, sinal_original);
title('Sinal de ECG Original');
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plotar sinal de ECG filtrado para Taquicardia Ventricular
subplot(2,1,2);
plot(t, ecg_filtrado);
title('Sinal de ECG Filtrado para Taquicardia Ventricular');
xlabel('Tempo (s)');
ylabel('Amplitude');
