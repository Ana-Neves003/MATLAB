% Limpar o ambiente e o console
clear;
clc;

% 1. LER O ARQUIVO DE ÁUDIO PDM (.WAV)
filename = 'REC_5kHz_4.WAV';
fid = fopen(filename, 'r');
data = fread(fid, '*uint32');
fclose(fid);

% 2. PROCESSAR O SINAL LIDO
Nfft = size(data, 1);
data = data(floor(Nfft/2):Nfft);  % Usa metade dos dados
binaryData = dec2bin(data) == '1';
reorganizedData = reshape(binaryData.', 1, []);
reorganizedData = 2*reorganizedData-1;
Nfft = length(reorganizedData);

% 3. PARÂMETROS DO FILTRO CIC E FIR
fs = 5e6;      % Frequência de amostragem
fc = 110e3;     % Frequência de corte do FIR
order = 64;    % Ordem do FIR
N = 4;         % Número de estágios do CIC
R = 16;        % Taxa de decimação do CIC
M = 1;         % Atraso diferencial do CIC

% 4. Criar o filtro CIC
%cicDecim = dsp.CICDecimator('DecimationFactor', R, 'DifferentialDelay', M, 'NumSections', N);
cicDecim = dsp.CICDecimator('DecimationFactor', R, 'NumSections', N);

% 5. Aplicar o filtro CIC
cic_processed = cicDecim(reorganizedData.'); 
fs_cic = fs / R;  % Nova frequência de amostragem após o CIC

% 6. Criar o filtro FIR
Fc_norm = fc / (fs_cic / 2); % Frequência de corte normalizada para fs_cic
firFilt = designfilt('lowpassfir', 'FilterOrder', order, 'CutoffFrequency', Fc_norm);
%coeficientes_fir = firFilt.Coefficients;

% 7. Aplicar o filtro FIR
fir_processed = filter(firFilt, cic_processed);

% 8. Calcular os espectros
Nfft_filter = length(cic_processed);
freq = 0:fs/Nfft:fs/2;
freq_filter = 0:fs_cic/Nfft_filter:fs_cic/2;

% Espectro do sinal original
spec = fft(reorganizedData, Nfft);
spec = spec(1:Nfft/2+1);
psd_spec = (abs(spec).^2)*(1/(fs*Nfft));
psd_spec(2:end-1) = 2*psd_spec(2:end-1);

% Espectro do sinal após o filtro CIC
spec_cic = fft(cic_processed, Nfft_filter);
spec_cic = spec_cic(1:Nfft_filter/2+1);
psd_cic = (abs(spec_cic).^2)*(1/(fs_cic*Nfft_filter));
psd_cic(2:end-1) = 2*psd_cic(2:end-1);

% Espectro do sinal após o filtro FIR
spec_fir = fft(fir_processed, Nfft_filter);
spec_fir = spec_fir(1:Nfft_filter/2+1);
psd_fir = (abs(spec_fir).^2)*(1/(fs_cic*Nfft_filter));
psd_fir(2:end-1) = 2*psd_fir(2:end-1);

% VISUALIZAÇÃO
figure;
subplot(2, 2, 1);
semilogx(freq, pow2db(psd_spec));
grid on;
title('Espectro do Sinal Original');
xlabel('Frequência (Hz)');
ylabel('Potência (dB/Hz)');

subplot(2, 2, 2);
semilogx(freq_filter, pow2db(psd_cic));
grid on;
title('Espectro após o Filtro CIC');
xlabel('Frequência (Hz)');
ylabel('Potência (dB/Hz)');

subplot(2, 2, 3);
semilogx(freq_filter, pow2db(psd_fir));
grid on;
title('Espectro do Filtro CIC + FIR');
xlabel('Frequência (Hz)');
ylabel('Potência (dB/Hz)');
