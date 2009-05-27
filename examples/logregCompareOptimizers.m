%% Compare speed of different optimizers for logistic regressiion
%#testPMTK
function logregCompareOptimizers()

setSeed(1);

load soy; % n=307, d = 35, C = 3;
methods = { 'bb',  'cg', 'lbfgs', 'newton'};
helper(X,Y, methods);

end

function helper(X,Y,methods)
lambda = 1e-3;
figure; hold on;
[styles] =  plotColors;          
[n,d] = size(X);
C = length(unique(Y));
nmethods = length(methods);
W = zeros(d, C-1, nmethods);
D = DataTableXY(X,Y);
for mi=1:length(methods)
    tic
    m = LogReg('-nclasses',3,'-lambda', lambda, '-fitEng',LogRegL2FitEng('-optMethod', methods{mi}));
    [m, output{mi}] = fit(m, D); %#ok
    T = toc    %#ok                                                           
    time(mi) = T;   %#ok     
    W(:,:,mi) = reshape(m.params.w,d,C-1);                                     
    niter = length(output{mi}.trace.funcCount)     %#ok 
    %ndx = 5:niter;
    h(mi) = plot(linspace(0, T, niter), output{mi}.trace.fval, styles{mi});   %#ok
    legendstr{mi}  = sprintf('%s', methods{mi});           %#ok                
end
legend(legendstr)
title(sprintf('n=%d, d=%d, C=%d', n, d, C));
% set(gca,'ylim',[ylim(1) 0.10*ylim(2)])
squeeze(W(:,1,:))
end
