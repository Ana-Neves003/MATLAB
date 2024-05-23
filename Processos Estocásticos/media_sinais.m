clear all;
close all;
clc

%------------------------------Sinais ECG----------------------

load('MIT-BIH Arrhythmia Database/100m.mat');
ecg_signal_100 =(val(1,:));
load('MIT-BIH Arrhythmia Database/101m.mat');
ecg_signal_101 =(val(1,:));
load('MIT-BIH Arrhythmia Database/102m.mat');
ecg_signal_102 =(val(1,:));
load('MIT-BIH Arrhythmia Database/103m.mat');
ecg_signal_103 =(val(1,:));
load('MIT-BIH Arrhythmia Database/104m.mat');
ecg_signal_104 =(val(1,:));
load('MIT-BIH Arrhythmia Database/105m.mat');
ecg_signal_105 =(val(1,:));
load('MIT-BIH Arrhythmia Database/106m.mat');
ecg_signal_106 =(val(1,:));
load('MIT-BIH Arrhythmia Database/107m.mat');
ecg_signal_107 =(val(1,:));
load('MIT-BIH Arrhythmia Database/108m.mat');
ecg_signal_108 =(val(1,:));
load('MIT-BIH Arrhythmia Database/109m.mat');
ecg_signal_109 =(val(1,:));
load('MIT-BIH Arrhythmia Database/111m.mat');
ecg_signal_111 =(val(1,:));
load('MIT-BIH Arrhythmia Database/112m.mat');
ecg_signal_112 =(val(1,:));
load('MIT-BIH Arrhythmia Database/113m.mat');
ecg_signal_113 =(val(1,:));
load('MIT-BIH Arrhythmia Database/114m.mat');
ecg_signal_114 =(val(1,:));
load('MIT-BIH Arrhythmia Database/115m.mat');
ecg_signal_115 =(val(1,:));
load('MIT-BIH Arrhythmia Database/116m.mat');
ecg_signal_116 =(val(1,:));
load('MIT-BIH Arrhythmia Database/117m.mat');
ecg_signal_117 =(val(1,:));
load('MIT-BIH Arrhythmia Database/118m.mat');
ecg_signal_118 =(val(1,:));
load('MIT-BIH Arrhythmia Database/119m.mat');
ecg_signal_119 =(val(1,:));
load('MIT-BIH Arrhythmia Database/121m.mat');
ecg_signal_121 =(val(1,:));
load('MIT-BIH Arrhythmia Database/122m.mat');
ecg_signal_122 =(val(1,:));
load('MIT-BIH Arrhythmia Database/123m.mat');
ecg_signal_123 =(val(1,:));
load('MIT-BIH Arrhythmia Database/124m.mat');
ecg_signal_124 =(val(1,:));
load('MIT-BIH Arrhythmia Database/200m.mat');
ecg_signal_200 =(val(1,:));
load('MIT-BIH Arrhythmia Database/201m.mat');
ecg_signal_201 =(val(1,:));
load('MIT-BIH Arrhythmia Database/202m.mat');
ecg_signal_202 =(val(1,:));
load('MIT-BIH Arrhythmia Database/203m.mat');
ecg_signal_203 =(val(1,:));
load('MIT-BIH Arrhythmia Database/205m.mat');
ecg_signal_205 =(val(1,:));
load('MIT-BIH Arrhythmia Database/207m.mat');
ecg_signal_207 =(val(1,:));
load('MIT-BIH Arrhythmia Database/208m.mat');
ecg_signal_208 =(val(1,:));
load('MIT-BIH Arrhythmia Database/209m.mat');
ecg_signal_209 =(val(1,:));
load('MIT-BIH Arrhythmia Database/210m.mat');
ecg_signal_210 =(val(1,:));
load('MIT-BIH Arrhythmia Database/212m.mat');
ecg_signal_212 =(val(1,:));
load('MIT-BIH Arrhythmia Database/213m.mat');
ecg_signal_213 =(val(1,:));
load('MIT-BIH Arrhythmia Database/214m.mat');
ecg_signal_214 =(val(1,:));
load('MIT-BIH Arrhythmia Database/215m.mat');
ecg_signal_215 =(val(1,:));
load('MIT-BIH Arrhythmia Database/217m.mat');
ecg_signal_217 =(val(1,:));
load('MIT-BIH Arrhythmia Database/219m.mat');
ecg_signal_219 =(val(1,:));
load('MIT-BIH Arrhythmia Database/220m.mat');
ecg_signal_220 =(val(1,:));
load('MIT-BIH Arrhythmia Database/221m.mat');
ecg_signal_221 =(val(1,:));
load('MIT-BIH Arrhythmia Database/222m.mat');
ecg_signal_222 =(val(1,:));
load('MIT-BIH Arrhythmia Database/223m.mat');
ecg_signal_223 =(val(1,:));
load('MIT-BIH Arrhythmia Database/228m.mat');
ecg_signal_228 =(val(1,:));
load('MIT-BIH Arrhythmia Database/230m.mat');
ecg_signal_230 =(val(1,:));
load('MIT-BIH Arrhythmia Database/231m.mat');
ecg_signal_231 =(val(1,:));
load('MIT-BIH Arrhythmia Database/232m.mat');
ecg_signal_232 =(val(1,:));
load('MIT-BIH Arrhythmia Database/233m.mat');
ecg_signal_233 =(val(1,:));
load('MIT-BIH Arrhythmia Database/234m.mat');
ecg_signal_234 =(val(1,:));

%---------------------------Sinal Filtrado--------------------

%Parâmetros do filtro passa alta
fs = 1000;  %Frequência de Amostragem
fc = 40;    %Frequência de Corte
ordem = 2;  %Ordem do filtro

%Calcula os coeficientes do filtro Butterworth
[b, a] = butter(ordem, fc/(fs/2), 'high');

%Resposta de frequência do filtro
%freqz(b, a, 1024, fs);

%Aplica o filtro a sinal
ecg_filtrado_100 = filter(b, a, ecg_signal_100);
ecg_filtrado_101 = filter(b, a, ecg_signal_101);
ecg_filtrado_102 = filter(b, a, ecg_signal_102);
ecg_filtrado_103 = filter(b, a, ecg_signal_103);
ecg_filtrado_104 = filter(b, a, ecg_signal_104);
ecg_filtrado_105 = filter(b, a, ecg_signal_105);
ecg_filtrado_106 = filter(b, a, ecg_signal_106);
ecg_filtrado_107 = filter(b, a, ecg_signal_107);
ecg_filtrado_108 = filter(b, a, ecg_signal_108);
ecg_filtrado_109 = filter(b, a, ecg_signal_109);
ecg_filtrado_111 = filter(b, a, ecg_signal_111);
ecg_filtrado_112 = filter(b, a, ecg_signal_112);
ecg_filtrado_113 = filter(b, a, ecg_signal_113);
ecg_filtrado_114 = filter(b, a, ecg_signal_114);
ecg_filtrado_115 = filter(b, a, ecg_signal_115);
ecg_filtrado_116 = filter(b, a, ecg_signal_116);
ecg_filtrado_117 = filter(b, a, ecg_signal_117);
ecg_filtrado_118 = filter(b, a, ecg_signal_118);
ecg_filtrado_119 = filter(b, a, ecg_signal_119);
ecg_filtrado_121 = filter(b, a, ecg_signal_121);
ecg_filtrado_122 = filter(b, a, ecg_signal_122);
ecg_filtrado_123 = filter(b, a, ecg_signal_123);
ecg_filtrado_124 = filter(b, a, ecg_signal_124);
ecg_filtrado_200 = filter(b, a, ecg_signal_200);
ecg_filtrado_201 = filter(b, a, ecg_signal_201);
ecg_filtrado_202 = filter(b, a, ecg_signal_202);
ecg_filtrado_203 = filter(b, a, ecg_signal_203);
ecg_filtrado_205 = filter(b, a, ecg_signal_205);
ecg_filtrado_207 = filter(b, a, ecg_signal_207);
ecg_filtrado_208 = filter(b, a, ecg_signal_208);
ecg_filtrado_209 = filter(b, a, ecg_signal_209);
ecg_filtrado_210 = filter(b, a, ecg_signal_210);
ecg_filtrado_212 = filter(b, a, ecg_signal_212);
ecg_filtrado_213 = filter(b, a, ecg_signal_213);
ecg_filtrado_214 = filter(b, a, ecg_signal_214);
ecg_filtrado_215 = filter(b, a, ecg_signal_215);
ecg_filtrado_217 = filter(b, a, ecg_signal_217);
ecg_filtrado_219 = filter(b, a, ecg_signal_219);
ecg_filtrado_220 = filter(b, a, ecg_signal_220);
ecg_filtrado_221 = filter(b, a, ecg_signal_221);
ecg_filtrado_222 = filter(b, a, ecg_signal_222);
ecg_filtrado_223 = filter(b, a, ecg_signal_223);
ecg_filtrado_228 = filter(b, a, ecg_signal_228);
ecg_filtrado_230 = filter(b, a, ecg_signal_230);
ecg_filtrado_231 = filter(b, a, ecg_signal_231);
ecg_filtrado_232 = filter(b, a, ecg_signal_232);
ecg_filtrado_233 = filter(b, a, ecg_signal_233);
ecg_filtrado_234 = filter(b, a, ecg_signal_234);

%--------------------------------Média-----------------------------------

% Média ponto a ponto
%ecg_media = (ecg_filtrado1 + ecg_filtrado2 + ecg_filtrado3 + ecg_filtrado4 + ecg_filtrado5) / 5;


% Matriz de amostras_ecg
%amostras_ecg = [ecg_filtrado1; ecg_filtrado2; ecg_filtrado3; ecg_filtrado4; ecg_filtrado5];

% Inicialização da matriz amostras_ecg
amostras_ecg = [
    ecg_filtrado_100;
    ecg_filtrado_101;
    ecg_filtrado_102;
    ecg_filtrado_103;
    ecg_filtrado_104;
    ecg_filtrado_105;
    ecg_filtrado_106;
    ecg_filtrado_107;
    ecg_filtrado_108;
    ecg_filtrado_109;
    ecg_filtrado_111;
    ecg_filtrado_112;
    ecg_filtrado_113;
    ecg_filtrado_114;
    ecg_filtrado_115;
    ecg_filtrado_116;
    ecg_filtrado_117;
    ecg_filtrado_118;
    ecg_filtrado_119;
    ecg_filtrado_121;
    ecg_filtrado_122;
    ecg_filtrado_123;
    ecg_filtrado_124;
    ecg_filtrado_200;
    ecg_filtrado_201;
    ecg_filtrado_202;
    ecg_filtrado_203;
    ecg_filtrado_205;
    ecg_filtrado_207;
    ecg_filtrado_208;
    ecg_filtrado_209;
    ecg_filtrado_210;
    ecg_filtrado_212;
    ecg_filtrado_213;
    ecg_filtrado_214;
    ecg_filtrado_215;
    ecg_filtrado_217;
    ecg_filtrado_219;
    ecg_filtrado_220;
    ecg_filtrado_221;
    ecg_filtrado_222;
    ecg_filtrado_223;
    ecg_filtrado_228;
    ecg_filtrado_230;
    ecg_filtrado_231;
    ecg_filtrado_232;
    ecg_filtrado_233;
    ecg_filtrado_234;
];



% Média ao longo das amostras
media_amostras_ecg = mean(amostras_ecg, 1);

% Plote das amostras originais e da média
%figure;
%subplot(2,1,1);
%plot(amostras_ecg);
%title('Amostras de ECG Filtrado');         

%subplot(2,1,2);
%plot(media_amostras_ecg, 'r', 'LineWidth', 2);
%title('Média das Amostras de ECG Filtrado');


% Plote dos sinais originais e da média
t = (1:length(ecg_filtrado_100));  % Tempo em amostras
figure;
subplot(2,1,1);
plot(t, ecg_filtrado_100);
title('Sinal ECG 1');

subplot(2,1,2);
plot(t, ecg_filtrado_101);
title('Sinal ECG 2');

%subplot(6,1,3);
%plot(t, ecg_filtrado3);
%title('Sinal ECG 3');

%subplot(6,1,4);
%plot(t, ecg_filtrado4);
%title('Sinal ECG 4');

%subplot(6,1,5);
%plot(t, ecg_filtrado5);
%title('Sinal ECG 5');

figure;
subplot(1,1,1);
plot(t, media_amostras_ecg);
title('Média dos Sinais ECG');

xlabel('Amostras');

figure;
subplot(1,1,1);
plot(t, amostras_ecg);
title('Amostras de ECG Filtrado');

legend('Sinal 1', 'Sinal 2', 'Sinal 3', 'Sinal 4', 'Sinal 5');

% Teste ADF para estacionariedade da média
[h, p, ~] = adftest(media_amostras_ecg);
disp(['Resultado do Teste ADF - p-valor: ', num2str(p)]);

