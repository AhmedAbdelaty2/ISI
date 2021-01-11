N = 7; % number of bits 
L = 10; %number of pathes
x = round(rand(1,N)); 
x = (2 * x) - 1 %BPSK symbols
X = ones(L, N);
X = x.*X; %the real message in different channels

h = MultipathChannel(L,1); %channels effect

H = tril(toeplitz(h));
H_inv = inv(H);

n = randn(size(X)); %generating noise with varience = 1, mean = 0

Y = H * X + n;
X_new = H_inv * Y;

counter = size(X_new, 1) * size(X_new, 2);

for i = 1 : counter
  if X_new(i) >= 0
    X_new(i) = 1;
  else
    X_new(i) = -1;
  end
end

%X
%X_new
