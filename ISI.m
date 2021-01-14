N = 1000;         %number of bits 
L = 10;           %number of pathes
fs = 5;           %number of samples per bit

x = round(rand(1,N)); 
x = (2 * x) - 1;          %BPSK symbols
X = ones(L, N);
X = x.*X;                 %the real message in different pathes

x_rep = zeros(1, N*fs);   %the inistialization of the repeated the message
X_rep = ones(L, N*fs);    %the inistialization of the repeated message in different pathes

c = 1;              %counter 
for i = 1 : N
  for j = 1 : fs
    x_rep(c) = x(i);
    c = c + 1;
  end
end

X_rep = x_rep.*X_rep;         %the repeated message in different pathes

h = MultipathChannel(L,1);    %channel pathes effect

H = tril(toeplitz(h));        %channel pathes effect lower triangle toeplitz matrix
H_inv = inv(H);               %the invers lower triangle toeplitz matrix of channel pathes effect

Eb = 1;             %energy per bit
SNR = [-15 : 0];    %different values for signal to noise ratio

MF = 2 * ones(1, fs);         %matched filter pulse
X_new1 = zeros(size(X));      %the deleverd message after demodulating without matched filter
X_new2 = zeros(size(X_rep)); 
X_new3 = zeros(size(X));      %the deleverd message after demodulating using matched filter
Y1 = zeros(size(X));          %the deleverd message before demodulating without matched filter technique
Y2 = zeros(size(X_rep));      %the deleverd message before demodulating using matched filter technique
BER1 = zeros(size(SNR));      %bit error rate for no matched filter technique
BER2 = zeros(size(SNR));      %bit error rate for matched filter technique

for l = 1 : length(SNR)
  
  %decoding the message without matched filter
  No1 = Eb/(10^(SNR(l)/10));
  n1 = No1/2 * randn(size(X));   %generating noise element
  Y1 = H * X + n1;               %deleverd message
  X_new1 = H_inv * Y1;           %deleverd message after removing pathes effect

  counter = size(X_new1, 1) * size(X_new1, 2);

  %making desision part
  for i = 1 : counter
    if X_new1(i) >= 0
      X_new1(i) = 1;
    else
      X_new1(i) = -1;
    end
  end

  %computing bit error rate
  Error1 = abs(X - X_new1);
  cnt_Error1 = sum(Error1(Error1==2)) / 2;
  BER1(l) = cnt_Error1 / counter;
  
  %decoding the message usnig matched filter
  No2 = Eb/(10^(SNR(l)/10));
  n2 = No2/2 * randn(size(X_rep));
  Y2 = H * X_rep + n2;
  X_new2 = H_inv * Y2;
  
  %computing the convolution of the recieved message and the matched filter pulse
  Z = zeros(L, size(X_new2, 2)+length(MF)-1);  %inistialization for the convolution matrix
  for p = 1 : L
    Z(p, :) = conv(X_new2(p, :), MF);
  end
  
  %making desision part
  for p = 1 : L
    k = 1;
    for o = fs :fs :fs*N
      if Z(p, o) >= 0
        X_new3(p,k) = 1;
      else
        X_new3(p,k) = -1;
      end
      k = k + 1;
    end
  end
  X_new3 = X_new3(:, 1:N);
  
  %computing bit error rate for matched filter technique
  Error2 = abs(X - X_new3);
  cnt_Error2 = sum(Error2(Error2==2)) / 2;
  BER2(l) = cnt_Error2 / counter;
  
end

%plotting the outputs of both technique
figure;
plot(SNR, BER1,'d-r','linewidth',3); hold on;
plot(SNR, BER2,'x-b','linewidth',3); hold on;
xlabel("SNR",'fontsize',20);
xlim([-15,0]);
ylabel("BER",'fontsize',20);