% Limpar o ambiente e o console
clear;
clc;

% 1. LER O ARQUIVO DE �UDIO PDM (.WAV)
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

% 3. PAR�METROS DO FILTRO CIC E FIR
fs = 5e6;      % Frequ�ncia de amostragem
fc = 110e3;     % Frequ�ncia de corte do FIR
order = 64;    % Ordem do FIR
N = 4;         % N�mero de est�gios do CIC
R = 16;        % Taxa de decima��o do CIC
M = 1;         % Atraso diferencial do CIC

% 4. Criar o filtro CIC
%cicDecim = dsp.CICDecimator('DecimationFactor', R, 'DifferentialDelay', M, 'NumSections', N);
cicDecim = dsp.CICDecimator('DecimationFactor', R, 'NumSections', N);

% 5. Aplicar o filtro CIC
cic_processed = cicDecim(reorganizedData.'); 
fs_cic = fs / R;  % Nova frequ�ncia de amostragem ap�s o CIC

% 6. Criar o filtro FIR
Fc_norm = fc / (fs_cic / 2); % Frequ�ncia de corte normalizada para fs_cic
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

% Espectro do sinal ap�s o filtro CIC
spec_cic = fft(cic_processed, Nfft_filter);
spec_cic = spec_cic(1:Nfft_filter/2+1);
psd_cic = (abs(spec_cic).^2)*(1/(fs_cic*Nfft_filter));
psd_cic(2:end-1) = 2*psd_cic(2:end-1);

% Espectro do sinal ap�s o filtro FIR
spec_fir = fft(fir_processed, Nfft_filter);
spec_fir = spec_fir(1:Nfft_filter/2+1);
psd_fir = (abs(spec_fir).^2)*(1/(fs_cic*Nfft_filter));
psd_fir(2:end-1) = 2*psd_fir(2:end-1);

% VISUALIZA��O
figure;
subplot(2, 2, 1);
semilogx(freq, pow2db(psd_spec));
grid on;
title('Espectro do Sinal Original');
xlabel('Frequ�ncia (Hz)');
ylabel('Pot�ncia (dB/Hz)');

subplot(2, 2, 2);
semilogx(freq_filter, pow2db(psd_cic));
grid on;
title('Espectro ap�s o Filtro CIC');
xlabel('Frequ�ncia (Hz)');
ylabel('Pot�ncia (dB/Hz)');

subplot(2, 2, 3);
semilogx(freq_filter, pow2db(psd_fir));
grid on;
title('Espectro do Filtro CIC + FIR');
xlabel('Frequ�ncia (Hz)');
ylabel('Pot�ncia (dB/Hz)');
