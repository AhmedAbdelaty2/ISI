N = 1; % Number of bits 
L = 5; 
x = round(rand(1,N)); 
x = (2 * x) - 1
X = ones(L, N);
X = x.*X


SNR = [-15:0];
energyPerBit = 1;
BER = cell(L, 1);
h = MultipathChannel(L,N);

H = cell(N, 1); % Path effect cell of matrices
H_inv = cell(N, 1); % inverse path effect cell of matrices

for i = 1 : 1 : N   % Channel effect matrix to every path (N paths)
    
   H{i} = tril(toeplitz(h(:,i))); % Path effect lower triangle toeplitz matrix
   H_inv{i} = inv(H{i}); % Inverse path effect lower triangle toeplitz matrix

end

Y = cell(L, 1);
n = cell(L, 1);
X_new = cell(L, 1);
n{1} = randn(size(x));

Y = H{1} * X + n{1}
X_new = H_inv{1} * Y
