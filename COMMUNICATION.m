% Step 1: Generate 48 capacitance values (in pF)

C = linspace(10, 100, 48);   % 48 values from 10pF to 100pF

disp('Capacitance Values (pF):');
disp(C);

figure;
plot(C, 'o-');
title('Input Capacitance Values (C1 to C48)');
xlabel('Index');
ylabel('Capacitance (pF)');
grid on;
% Step 2:  ADC Encoding

N = 8;                
Vref = 10;  % refernce voltage 

% Convert capacitance to equivalent voltage
V = (C - min(C)) / (max(C) - min(C)) * Vref;
% Quantization
levels = 2^N;
digital = round((V / Vref) * (levels - 1));

disp('Digital Values:');
disp(digital);

% Plot digital output
figure;
stem(digital);
title('ADC Output (Digital Values)');
xlabel('Index');
ylabel('Digital Level');
grid on;

% Step 3: Convert to Bitstream

bitstream = [];

for i = 1:length(digital)
    bits = de2bi(digital(i), 8, 'left-msb'); % 8-bit binary
    bitstream = [bitstream bits];
end

% Add header AFTER creating bitstream
header = [1 0 1 0 1 0 1 0];
bitstream = [header bitstream];

disp('Bitstream:');
disp(bitstream);

% Plot first 100 bits
figure;
stairs(bitstream(1:100), 'LineWidth', 2);
title('Bitstream (First 100 bits)');
xlabel('Bit Index');
ylabel('Bit Value');
ylim([-0.5 1.5]);
grid on;
% Step 4: ASK Modulation

fs = 1000;      
Tb = 0.01;        
t = 0:1/fs:Tb-1/fs;

fc = 50;         

ask_signal = [];

for i = 1:length(bitstream)
    if bitstream(i) == 1
        signal = sin(2*pi*fc*t);      % for bit 1
    else
        signal = 0*sin(2*pi*fc*t);    % for bit 0
    end
    ask_signal = [ask_signal signal];
end

% Time axis for full signal
t_total = 0:1/fs:Tb*length(bitstream)-1/fs;

% Plot
figure;
plot(t_total(1:1000), ask_signal(1:1000));
title('ASK Modulated Signal (First Part)');
xlabel('Time');
ylabel('Amplitude');
grid on;
% Step 5: Add Noise to the channel

SNR_dB = 10;   % Signal-to-noise ratio (try 10, 15, 20)

noisy_signal = awgn(ask_signal, SNR_dB, 'measured'); %additive white guassian noise

% Plot comparison
figure;
plot(t_total(1:1000), ask_signal(1:1000), 'b');
hold on;
plot(t_total(1:1000), noisy_signal(1:1000), 'r');
title('Original vs Noisy Signal');
xlabel('Time');
ylabel('Amplitude');
legend('Original', 'Noisy');
grid on;
% Step 6: Demodulation

received_bits = [];

samples_per_bit = length(t);

for i = 1:samples_per_bit:length(noisy_signal)
    
    segment = noisy_signal(i:i+samples_per_bit-1);
    
    % Energy detection
    energy = sum(segment.^2);
    
    % Threshold decision
    if energy > 0.5
        received_bits = [received_bits 1];
    else
        received_bits = [received_bits 0];
    end
end

disp('Received Bits:');
disp(received_bits);

% Plot first 100 bits
figure;
stairs(received_bits(1:100), 'LineWidth', 2);
title('Recovered Bitstream');
xlabel('Bit Index');
ylabel('Bit Value');
ylim([-0.5 1.5]);
grid on;
% Step 7: Bit rate error 

original_bits = bitstream(length(header)+1:end);

% Make sure sizes match
min_len = min(length(original_bits), length(received_bits));
original_bits = original_bits(1:min_len);
received_bits = received_bits(1:min_len);

% Count errors
errors = sum(original_bits ~= received_bits);

% BER calculation
BER = errors / length(original_bits);

disp(['Number of Errors: ', num2str(errors)]);
disp(['BER: ', num2str(BER)]);