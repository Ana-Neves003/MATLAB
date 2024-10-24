% Limpar o ambiente e o console
clear;
clc;

% 1. LER O ARQUIVO DE ÁUDIO PDM (.WAV)
filename = 'REC_SILENCIO.WAV';
fid = fopen(filename, 'r');
data = fread(fid, '*uint32');
fclose(fid);

% 2. PROCESSAR O SINAL LIDO
Nfft = size(data, 1);
data = data(floor(Nfft/2):Nfft);
%data = data(1:Nfft);
binaryData = dec2bin(data) == '1';
reorganizedData = reshape(binaryData.', 1, []);
reorganizedData = 2*reorganizedData-1;
Nfft = size(reorganizedData,2);

% 4. PARÂMETROS DO FILTRO FIR
fs = 5e6; % Frequência de amostragem
fc = 90e3; % Frequência de corte do filtro FIR
order = 64; % Ordem do filtro FIR
N = 2; % Número de estágios CIC
R = 16; % Taxa de decimação
M = 1; % Atraso diferencial

% 4. Criar o filtro CIC
b_comb = [1 zeros(1, M-1) -1];
b_int = ones(1, R);
cic_filter = b_comb;
for i = 2:N
    cic_filter = conv(cic_filter, b_comb);
end
cic_filter = conv(cic_filter, b_int.^N);

% 5. Aplicar o filtro CIC
cic_processed = filter(cic_filter, 1, reorganizedData);
cic_processed = cic_processed(1:R:end); % Decimação
fs = fs/R;

% 6. Criando o filtro FIR
fir_coeffs = fir1(order, fc/(fs/2));

% 7. Aplicar o filtro FIR
fir_processed = filter(fir_coeffs, 1, cic_processed);

% 8. Calcular os espectros
Nfft_filter = length(cic_processed);
freq = 0:fs/Nfft:fs/2;
freq_filter = 0:fs/Nfft_filter:fs/2;
window = hann(Nfft);

% Espectro do sinal original
spec = fft(reorganizedData);
spec = spec(1:Nfft/2+1);
psd_spec = (abs(spec).^2)*(1/(fs*Nfft));
psd_spec(2:end-1) = 2*psd_spec(2:end-1);


% Espectro do sinal após o filtro CIC
spec_cic = fft(cic_processed);
psd_cic = (abs(spec_cic).^2)*(1/(fs*Nfft_filter));
psd_cic = psd_cic(1:length(freq_filter));

% ESPECTRO DO SINAL APOS O FILTRO FIR
spec_fir = fft(fir_processed);
psd_fir = (abs(spec_fir).^2)*(1/(fs*Nfft_filter));
psd_fir = psd_fir(1:length(freq_filter));

% VISUALIZAÇÃO
figure;
subplot(3, 1, 1);
semilogx(freq, pow2db(psd_spec));
grid on;
title('Espectro do Sinal Original');
xlabel('Frequência (Hz)');
ylabel('Potência (dB/Hz)');

subplot(3, 1, 2);
semilogx(freq_filter, pow2db(psd_cic));
title('Espectro após o Filtro CIC');
xlabel('Frequência (Hz)');
ylabel('Potência (dB/Hz)');

subplot(3, 1, 3);
semilogx(freq_filter, pow2db(psd_fir));
title('Espectro do Filtro CIC + FIR');
xlabel('Frequência (Hz)');
ylabel('Potência (dB/Hz)');