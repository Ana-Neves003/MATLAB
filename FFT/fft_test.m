clear;
clc;

%filename = 'GRAVACAO.RAW';
%filename = 'ultrasound_pdm_10_32bitsample_5000000hz';
filename = 'working_silence_pdm_1_32bitsample_3749995hz';
fid = fopen(filename, 'r');
data = fread(fid, '*uint32');
fclose(fid);

Nfft = size(data, 1);
data = data(floor(Nfft/2):Nfft);
binaryData = dec2bin(data) == '1';


reorganizedData = reshape(binaryData.', 1, []);
reorganizedData = 2*reorganizedData-1;
Nfft = size(reorganizedData,2);


subplot(2,1,1);
plot(reorganizedData);
xlim([0 350]);
ylim([-0.2 1.2]);
title('Sinal Trem de Pulso');
xlabel('Amostras');
ylabel('Amplitude');

%fs = 44100;
%fs = 5000000;
fs = 3749995;
%f = [0:Nfft-1]*fs/Nfft;
%X = fftshift(fft(reorganizedData));
%X = fft(reorganizedData);


%XdB = 20*log10(abs(X)/Nfft);

subplot(2,1,2);
%semilogx(f,abs(X)/Nfft,'r');
%semilogx(f, XdB, 'r');
%title('Magnitude da FFT do Sinal Trem de Pulso');
%xlabel('Frequency (log10)');
%ylabel('Magnitude |X(f)| (dB)');

windows = hann(Nfft);
freq = 0:fs/Nfft:fs/2;
spec = fft(reorganizedData);
spec = spec(1:Nfft/2+1);
psd_spec = (abs(spec).^2)*(1/(fs*Nfft));
psd_spec(2:end-1) = 2*psd_spec(2:end-1);

semilogx(freq, pow2db(psd_spec))
grid on
title("Spectrum Power using fft")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")