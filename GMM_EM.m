function GMM_EM( X )
%GMM Summary of this function goes here
%   Detailed explanation goes here

% N : the number of data instances
% D : dimension of each data instance
% X : N * D
% mu : D * 1
% sigma : (D * N) * (N * D) = D * D

D = size(X, 2); 
N = size(X, 1);
K = 2;               % the number of cluster

% params
mu1 = [-1 1];
sigma1 = eye(K);
pi1 = 0.5;
resp1 = ones(1,N);
resp1_prev = resp1;

mu2 = [1 -1];
sigma2 = eye(K);
pi2 = 0.5;
resp2 = ones(1,N);
resp2_prev = resp2;

Q = 0;

% Counter
counter = 0;

while 1
    counter = counter + 1;
    
    %% Expectation step
    resp1_prev = resp1;
    resp2_prev = resp2;
    
    for i = 1:N
       x = X(i,:);
       norm = pi1 * mvnpdf(x, mu1, sigma1) + pi2 * mvnpdf(x, mu2, sigma2);
       resp1(1,i) = (pi1 * mvnpdf(x, mu1, sigma1)) / norm;
       resp2(1,i) = (pi2 * mvnpdf(x, mu2, sigma2)) / norm;
    end
    
    %% Maximization step
    % new pi
    pi1 = sum(resp1) / N;
    pi2 = sum(resp2) / N;
   
    % new mu
    mu1 = (resp1*X) / sum(resp1);
    mu2 = (resp2*X) / sum(resp2);
%     mu1
    
    % new covariance matrix
    wsm1 = zeros(D);
    wsm2 = zeros(D);
    for i = 1:N
        x = X(i,:);
        wsm1 = wsm1 + resp1(1,i)*x'*x;
        wsm2 = wsm2 + resp2(1,i)*x'*x;
    end
    sigma1 = (wsm1 / sum(resp1)) - (mu1'*mu1);
    sigma2 = (wsm2 / sum(resp2)) - (mu2'*mu2);
    
    % calculate Q
    for i = 1:N
       x = X(i,:);
       Q = Q + sum(resp1_prev(1,i)*log(pi1) + resp2_prev(1,i)*log(pi2)) + sum(resp1_prev(1,i)*mvnpdf(x, mu1, sigma1) + resp2_prev(1,i)*mvnpdf(x, mu2, sigma2) );
    end
%     Q

%     draw_result_graph(X, resp1, resp2);
end


end

function draw_result_graph(X, resp1, resp2)
    N = size(X,1);
    
    figure;
    
    x = X(:,1);
    y = X(:,2);
    colors = zeros(N,3);
    
    % fill color matrix
    for i = 1:N
       colors(i,:) = [1*resp2(1,i) 0 1*resp1(1,i)];
    end
    
    % draw graph
    for i = 1:N
        scatter(x, y, 10, colors);
    end
end


