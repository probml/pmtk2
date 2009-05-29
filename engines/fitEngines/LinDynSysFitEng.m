classdef LinDynSysFitEng < FitEng
    
    properties
        diagnostics;
        verbose;
        maxIter;
        constraintFunc;
        constraintArgs;
    end
    
    
    methods
        
        function eng = LinDynSysFitEng(varargin)
            [eng.verbose,eng.maxIter,eng.constraintFunc,eng.constraintArgs] = processArgs(varargin,...
                '-verbose', true, ...
                '-maxIter'          ,10     ,...
                '-constraintFunc'   ,[]     ,...
                '-constraintArgs'   ,{}     );
        end
        
        function model = fit(eng,model,data)
            
            if iscell(data), model.ndimensions = size(data{1},1);
            else             model.ndimensions = size(data,1);    end
            
            [model,A, C, Q, R, initz, initV,diagQ,diagR,ARmode] = initParams(eng,model);
            [model.params.sysMatrix, model.params.obsMatrix, model.params.sysNoise.params.Sigma,...
                model.params.obsNoise.params.Sigma, model.params.startDist.params.mu, model.params.startDist.params.Sigma, LL]...
                = learn_kalman(data, A, C, Q, R, initz, initV, eng.maxIter, diagQ, diagR, ARmode,eng.verbose,eng.constraintFunc,eng.constraintArgs{:});  
        end
        
    end
    
    
    methods(Access = 'protected')
        
        function [model,A, C, Q, R, initz, initV,diagQ,diagR,ARmode] = initParams(eng,model)
            % Initialize parameters prior to running EM.
            diagQ  =  false; diagR  =  false;
            if ndims(model.params.sysMatrix) > 2, error('Fitting of a switching LDS is not supported'); end
            if (isempty(model.params.obsMatrix) || isempty(model.params.sysMatrix)) && isempty(model.ndimsLatent)
                error('Please specify the dimensionality of the latent state space');
            end
            if isempty(model.params.sysMatrix), A = randn(model.ndimsLatent);
            else                         A = model.params.sysMatrix;   end
            if isempty(model.params.obsMatrix), C = randn(model.ndimensions,model.ndimsLatent);
            else                         C = model.params.obsMatrix;   end
            if isempty(model.params.sysNoise)
                Q = 0.1*eye(model.ndimsLatent);
                model.params.sysNoise = MvnDist(zeros(model.ndimsLatent,1),Q);
            else
                Q = cov(model.params.sysNoise);
                diagQ = ~isempty(model.params.sysNoise.covType) && ~strcmpi(model.params.sysNoise.covType,'full');
            end
            if isempty(model.params.obsNoise)
                R = eye(model.ndimensions);
                model.params.obsNoise = MvnDist(zeros(model.ndimensions,1),R);
            else
                R = cov(model.params.obsNoise);
                diagQ = ~isempty(model.params.obsNoise.covType) && ~strcmpi(model.params.obsNoise.covType,'full');
            end
            if isempty(model.params.startDist)
                initz = 10*rand(model.ndimsLatent,1);
                initV = 10*eye(model.ndimsLatent);
                model.params.startDist = MvnDist(initz,initV);
            else
                initz = mean(model.params.startDist);
                initV = cov(model.params.startDist);
            end
            ARmode = isequal(model.params.obsMatrix,eye(size(model.params.obsMatrix))) && ~any(colvec(cov(model.params.obsNoise)));
        end
        
        
    end
    
end



function [A, C, Q, R, initx, initV, LL] = ...
        learn_kalman(data, A, C, Q, R, initx, initV, max_iter, diagQ, diagR, ARmode, verbose, constr_fun, varargin)
    % LEARN_KALMAN Find the ML parameters of a stochastic Linear Dynamical System using EM.
    %
    % [A, C, Q, R, INITX, INITV, LL] = LEARN_KALMAN(DATA, A0, C0, Q0, R0, INITX0, INITV0) fits
    % the parameters which are defined as follows
    %   x(t+1) = A*x(t) + w(t),  w ~ N(0, Q),  x(0) ~ N(init_x, init_V)
    %   y(t)   = C*x(t) + v(t),  v ~ N(0, R)
    % A0 is the initial value, A is the final value, etc.
    % DATA(:,t,l) is the observation vector at time t for sequence l. If the sequences are of
    % different lengths, you can pass in a cell array, so DATA{l} is an O*T matrix.
    % LL is the "learning curve": a vector of the log lik. values at each iteration.
    % LL might go positive, since prob. densities can exceed 1, although this probably
    % indicates that something has gone wrong e.g., a variance has collapsed to 0.
    %
    % There are several optional arguments, that should be passed in the following order.
    % LEARN_KALMAN(DATA, A0, C0, Q0, R0, INITX0, INITV0, MAX_ITER, DIAGQ, DIAGR, ARmode)
    % MAX_ITER specifies the maximum number of EM iterations (default 10).
    % DIAGQ=1 specifies that the Q matrix should be diagonal. (Default 0).
    % DIAGR=1 specifies that the R matrix should also be diagonal. (Default 0).
    % ARMODE=1 specifies that C=I, R=0. i.e., a Gauss-Markov process. (Default 0).
    % This problem has a global MLE. Hence the initial parameter values are not important.
    %
    % LEARN_KALMAN(DATA, A0, C0, Q0, R0, INITX0, INITV0, MAX_ITER, DIAGQ, DIAGR, F, P1, P2, ...)
    % calls [A,C,Q,R,initx,initV] = f(A,C,Q,R,initx,initV,P1,P2,...) after every M step. f can be
    % used to enforce any constraints on the params.
    %
    % For details, see
    % - Ghahramani and Hinton, "Parameter Estimation for LDS", U. Toronto tech. report, 1996
    % - Digalakis, Rohlicek and Ostendorf, "ML Estimation of a stochastic linear system with the EM
    %      algorithm and its application to speech recognition",
    %       IEEE Trans. Speech and Audio Proc., 1(4):431--442, 1993.
    
    
    %    learn_kalman(data, A, C, Q, R, initx, initV, max_iter, diagQ, diagR, ARmode, constr_fun, varargin)
    if nargin < 8, max_iter = 10; end
    if nargin < 9, diagQ = 0; end
    if nargin < 10, diagR = 0; end
    if nargin < 11, ARmode = 0; end
    if nargin < 12, verbose = false; end
    if nargin < 13, constr_fun = []; end
    thresh = 1e-4;
    
    
    if ~iscell(data)
        N = size(data, 3);
        data = num2cell(data, [1 2]); % each elt of the 3rd dim gets its own cell
    else
        N = length(data);
    end
    
    N = length(data);
    ss = size(A, 1);
    os = size(C,1);
    
    alpha = zeros(os, os);
    Tsum = 0;
    for ex = 1:N
        %y = data(:,:,ex);
        y = data{ex};
        T = length(y);
        Tsum = Tsum + T;
        alpha_temp = zeros(os, os);
        for t=1:T
            alpha_temp = alpha_temp + y(:,t)*y(:,t)';
        end
        alpha = alpha + alpha_temp;
    end
    
    previous_loglik = -inf;
    loglik = 0;
    converged = 0;
    num_iter = 1;
    LL = [];
    
    % Convert to inline function as needed.
    if ~isempty(constr_fun)
        constr_fun = fcnchk(constr_fun,length(varargin));
    end
    
    
    while ~converged & (num_iter <= max_iter)
        
        %%% E step
        
        delta = zeros(os, ss);
        gamma = zeros(ss, ss);
        gamma1 = zeros(ss, ss);
        gamma2 = zeros(ss, ss);
        beta = zeros(ss, ss);
        P1sum = zeros(ss, ss);
        x1sum = zeros(ss, 1);
        loglik = 0;
        
        for ex = 1:N
            y = data{ex};
            T = length(y);
            [beta_t, gamma_t, delta_t, gamma1_t, gamma2_t, x1, V1, loglik_t] = ...
                Estep(y, A, C, Q, R, initx, initV, ARmode);
            beta = beta + beta_t;
            gamma = gamma + gamma_t;
            delta = delta + delta_t;
            gamma1 = gamma1 + gamma1_t;
            gamma2 = gamma2 + gamma2_t;
            P1sum = P1sum + V1 + x1*x1';
            x1sum = x1sum + x1;
            %fprintf(1, 'example %d, ll/T %5.3f\n', ex, loglik_t/T);
            loglik = loglik + loglik_t;
        end
        LL = [LL loglik];
        if verbose, fprintf(1, 'iteration %d, loglik = %f\n', num_iter, loglik); end
        %fprintf(1, 'iteration %d, loglik/NT = %f\n', num_iter, loglik/Tsum);
        num_iter =  num_iter + 1;
        
        %%% M step
        
        % Tsum =  N*T
        % Tsum1 = N*(T-1);
        Tsum1 = Tsum - N;
        A = beta * inv(gamma1);
        %A = (gamma1' \ beta')';
        Q = (gamma2 - A*beta') / Tsum1;
        if diagQ
            Q = diag(diag(Q));
        end
        if ~ARmode
            C = delta * inv(gamma);
            %C = (gamma' \ delta')';
            R = (alpha - C*delta') / Tsum;
            if diagR
                R = diag(diag(R));
            end
        end
        initx = x1sum / N;
        initV = P1sum/N - initx*initx';
        
        if ~isempty(constr_fun)
            [A,C,Q,R,initx,initV] = feval(constr_fun, A, C, Q, R, initx, initV, varargin{:});
        end
        
        converged = em_converged(loglik, previous_loglik, thresh);
        previous_loglik = loglik;
    end
end


%%%%%%%%%

function [beta, gamma, delta, gamma1, gamma2, x1, V1, loglik] = ...
        Estep(y, A, C, Q, R, initx, initV, ARmode)
    %
    % Compute the (expected) sufficient statistics for a single Kalman filter sequence.
    %
    
    [os T] = size(y);
    ss = length(A);
    
    if ARmode
        xsmooth = y;
        Vsmooth = zeros(ss, ss, T); % no uncertainty about the hidden states
        VVsmooth = zeros(ss, ss, T);
        loglik = 0;
    else
        [xsmooth, Vsmooth, VVsmooth, loglik] = KalmanInfEng.kalman_smoother(y, A, C, Q, R, initx, initV);
    end
    
    delta = zeros(os, ss);
    gamma = zeros(ss, ss);
    beta = zeros(ss, ss);
    for t=1:T
        delta = delta + y(:,t)*xsmooth(:,t)';
        gamma = gamma + xsmooth(:,t)*xsmooth(:,t)' + Vsmooth(:,:,t);
        if t>1 beta = beta + xsmooth(:,t)*xsmooth(:,t-1)' + VVsmooth(:,:,t); end
    end
    gamma1 = gamma - xsmooth(:,T)*xsmooth(:,T)' - Vsmooth(:,:,T);
    gamma2 = gamma - xsmooth(:,1)*xsmooth(:,1)' - Vsmooth(:,:,1);
    
    x1 = xsmooth(:,1);
    V1 = Vsmooth(:,:,1);
end


function [converged, decrease] = em_converged(loglik, previous_loglik, threshold, check_increased)
    % EM_CONVERGED Has EM converged?
    % [converged, decrease] = em_converged(loglik, previous_loglik, threshold)
    %
    % We have converged if the slope of the log-likelihood function falls below 'threshold',
    % i.e., |f(t) - f(t-1)| / avg < threshold,
    % where avg = (|f(t)| + |f(t-1)|)/2 and f(t) is log lik at iteration t.
    % 'threshold' defaults to 1e-4.
    %
    % This stopping criterion is from Numerical Recipes in C p423
    %
    % If we are doing MAP estimation (using priors), the likelihood can decrase,
    % even though the mode of the posterior is increasing.
    
    if nargin < 3, threshold = 1e-4; end
    if nargin < 4, check_increased = 1; end
    
    converged = 0;
    decrease = 0;
    
    if check_increased
        if loglik - previous_loglik < -1e-3 % allow for a little imprecision
            fprintf(1, '******likelihood decreased from %6.4f to %6.4f!\n', previous_loglik, loglik);
            decrease = 1;
            converged = 0;
            return;
        end
    end
    
    delta_loglik = abs(loglik - previous_loglik);
    avg_loglik = (abs(loglik) + abs(previous_loglik) + eps)/2;
    if (delta_loglik / avg_loglik) < threshold, converged = 1; end
end






