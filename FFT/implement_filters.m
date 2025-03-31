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

%cicDecim = dsp.CICDecimator('DecimationFactor', R, 'DifferentialDelay', M, 'NumSections', N);
%cic_processed = cicDecim(reorganizedData.'); 

% Salvar os dados de entrada e sa�da em arquivos CSV
%csvwrite('reorganizedData.csv', reorganizedData);
%csvwrite('cic_processed.csv', cic_processed);

% Salvar os dados em arquivos de texto
%dlmwrite('reorganizedData.txt', reorganizedData, 'delimiter', '\n');
%dlmwrite('cic_processed.txt', cic_processed, 'delimiter', '\n');


%cic_processed = cic_filter(reorganizedData, R, N, M);
cic_processed = cic_filter(reorganizedData, R, N);

fs_cic = fs / R;  % New sampling frequency after CIC

% 6. Criar o filtro FIR
Fc_norm = fc / (fs_cic / 2); % Frequ�ncia de corte normalizada para fs_cic
coeficientes_fir = [0.000792054770933056,-0.000442986869603646,-0.000346715840607441,0.00105672404464702,-0.00102725323675075,-3.97609216037946e-05,0.00157304669437729,-0.00223131365400529,0.000913291906289769,0.00194681182232756,-0.00410916320834437,0.00307212378248671,0.00143941527024877,-0.00629432948118691,0.00682235964803528,-0.000929276275685085,-0.00791664441517844,0.0121861344621779,-0.00625357547552810,-0.00757308458012768,0.0187253171630382,-0.0157626522477365,-0.00317130531504444,0.0255797271575543,-0.0314843244086080,0.00912596811664657,0.0316404965881606,-0.0600365491481145,0.0419241430420708,0.0358143540096918,-0.151082412771185,0.254374980329710,0.703428798081828,0.254374980329710,-0.151082412771185,0.0358143540096918,0.0419241430420708,-0.0600365491481145,0.0316404965881606,0.00912596811664657,-0.0314843244086080,0.0255797271575543,-0.00317130531504444,-0.0157626522477365,0.0187253171630382,-0.00757308458012768,-0.00625357547552810,0.0121861344621779,-0.00791664441517844,-0.000929276275685085,0.00682235964803528,-0.00629432948118691,0.00143941527024877,0.00307212378248671,-0.00410916320834437,0.00194681182232756,0.000913291906289769,-0.00223131365400529,0.00157304669437729,-3.97609216037946e-05,-0.00102725323675075,0.00105672404464702,-0.000346715840607441,-0.000442986869603646,0.000792054770933056];

% 7. Aplicar o filtro FIR
fir_processed = my_filter_FIR(coeficientes_fir, cic_processed);


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

function y = my_filter_FIR(b, x) %coeficientes e sinal de entrada

% Verifica as dimens�es
%if length(b) > length(x)
    %error('O vetor de coeficientes deve ser menor ou igual ao sinal de entrada.');
%end

% Inicializa a sa�da
y = zeros(size(x));

% Implementa a equa��o de diferen�a
for n = 1:length(x)
    for k = 1:length(b)
        if n-k+1 > 0
            y(n) = y(n) + b(k) * x(n-k+1);
        end
    end
end
end

function y = cic_filter(x, R, N)
    % Variaveis
    L = length(x);
    integrator = zeros(1, L);
    decimated = zeros(1, floor(L / R));
    y = zeros(1, length(decimated));
    
    % Etapa 1: Integra��o
    for stage = 1:N
        for i = 1:L
           if i == 1
               integrator(i) = x(i);
           else
               integrator(i) = integrator(i-1) + x(i);
           end
        end
    end
   
    
    % Etapa 2: Decima��o
    for j = 1:floor(L / R)
        if j * R <= L
            decimated(j) = integrator(j * R);
        end
    end
    
    % Etapa 3: Comb
    for stage = 1:N
        y(1) = decimated(1);
        for k = 2:length(decimated)
            y(k) = decimated(k) - decimated(k-1);            
        end
    end
end



   










