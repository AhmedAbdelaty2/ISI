N = 1000; % number of bits 
L = 10; %number of pathes
x = round(rand(1,N)); 
x = (2 * x) - 1; %BPSK symbols
X = ones(L, N);
X = x.*X; %the real message in different pathes

h = MultipathChannel(L,1); %channel pathes effect

H = tril(toeplitz(h));
H_inv = inv(H);

Eb = 1; %energy per bit
SNR = [-15 : 0]; %different values for signal to noise ratio

for l = 1 : length(SNR)
  
  No = Eb/(10**(SNR(l)/10))
  n = No/2 * randn(size(X)); %generating noise element

  Y = H * X + n;             %deleverd message
  X_new = H_inv * Y;         %deleverd message after removing pathes effect

  counter = size(X_new, 1) * size(X_new, 2);

  %making desision part
  for i = 1 : counter
    if X_new(i) >= 0
      X_new(i) = 1;
    else
      X_new(i) = -1;
    end
  end

  %computing bit error rate
  Error = abs(X - X_new);
  cnt_Error = sum(Error(Error==2)) / 2;
  BER(l) = cnt_Error / counter;
end

figure;
plot(SNR, BER,'d-r','linewidth',3);
xlabel("SNR",'fontsize',20);
xlim([-15,0]);
ylabel("BER",'fontsize',20);