N = 1000; % Number of bits 
x = randi([0,1], 1, N); 
x = (2 * x) - 1;

L = 10; % Number of paths
h = MultipathChannel(L,N);
