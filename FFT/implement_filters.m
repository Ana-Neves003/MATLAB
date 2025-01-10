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

%cicDecim = dsp.CICDecimator('DecimationFactor', R, 'DifferentialDelay', M, 'NumSections', N);
%cic_processed = cicDecim(reorganizedData.'); 

% Salvar os dados de entrada e saída em arquivos CSV
%csvwrite('reorganizedData.csv', reorganizedData);
%csvwrite('cic_processed.csv', cic_processed);

% Salvar os dados em arquivos de texto
%dlmwrite('reorganizedData.txt', reorganizedData, 'delimiter', '\n');
%dlmwrite('cic_processed.txt', cic_processed, 'delimiter', '\n');


%cic_processed = cic_filter(reorganizedData, R, N, M);
cic_processed = cic_filter(reorganizedData, R, N);

fs_cic = fs / R;  % New sampling frequency after CIC

% 6. Criar o filtro FIR
Fc_norm = fc / (fs_cic / 2); % Frequência de corte normalizada para fs_cic
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

function y = my_filter_FIR(b, x) %coeficientes e sinal de entrada

% Verifica as dimensões
%if length(b) > length(x)
    %error('O vetor de coeficientes deve ser menor ou igual ao sinal de entrada.');
%end

% Inicializa a saída
y = zeros(size(x));

% Implementa a equação de diferença
for n = 1:length(x)
    for k = 1:length(b)
        if n-k+1 > 0
            y(n) = y(n) + b(k) * x(n-k+1);
        end
    end
end
end


function y = cic_filter(x, R, N)
    % x: sinal de entrada
    % R: fator de decimação
    % N: número de estágios do filtro CIC

    % -------------------------
    % Etapa 1: Integração
    % -------------------------
    % Nesta etapa, o sinal de entrada passa por N acumuladores consecutivos.
    % Cada acumulador soma a amostra atual com o valor acumulado anterior.
    integrator = x; % Inicializa com o sinal de entrada
    for stage = 1:N
        % Acumulação (somatório cumulativo)
        for i = 2:length(integrator)
            integrator(i) = integrator(i-1) + integrator(i);
        end
    end

    % -------------------------
    % Etapa 2: Decimação
    % -------------------------
    % A taxa de amostragem do sinal é reduzida por um fator R.
    % Apenas uma a cada R amostras é mantida.
    decimated = integrator(1:R:end); % Seleciona uma amostra a cada R

    % -------------------------
    % Etapa 3: Filtragem Comb
    % -------------------------
    % Nesta etapa, são aplicados N estágios de filtros diferenciais.
    % Cada filtro calcula a diferença entre a amostra atual e uma atrasada por R.
    y = decimated; % Inicializa a saída com o sinal decimado
    for stage = 1:N
        % Cria um vetor para armazenar o sinal filtrado em cada estágio
        comb = zeros(1, length(y));
        for n = 1:length(y)
            if n <= R
                % Para as primeiras amostras, onde o atraso R não é possível,
                % apenas copia a amostra sem subtração
                comb(n) = y(n);
            else
                % Subtrai a amostra atual da amostra atrasada por R
                comb(n) = y(n) - y(n-R);
            end
        end
        % Atualiza y com o resultado do estágio atual do filtro comb
        y = comb;
    end
end









