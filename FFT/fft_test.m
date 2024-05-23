clear;
clc;

filename = 'working_silence_pdm_1_32bitsample_3749995hz';
fid = fopen(filename, 'r');
data = fread(fid, '*uint32');
fclose(fid);

binaryData = dec2bin(data) == '1';
reorganizedData = reshape(binaryData.', 1, []);
reorganizedData = 2*reorganizedData-1;


subplot(2,1,1);
plot(reorganizedData);
xlim([0 350]);
ylim([-0.2 1.2]);
title('Sinal Trem de Pulso');
xlabel('Amostras');
ylabel('Amplitude');

fs = 3749995;
Nfft = size(reorganizedData, 2);
f = [0:Nfft-1]*fs/Nfft;
%X = fftshift(fft(reorganizedData));
X = fft(reorganizedData);

XdB = 20*log10(abs(X)/Nfft);

subplot(2,1,2);
%semilogx(f,abs(X)/Nfft,'r');
semilogx(f, XdB, 'r');
title('Magnitude da FFT do Sinal Trem de Pulso');
xlabel('Frequency (log10)');
ylabel('Magnitude |X(f)| (dB)');
