classdef KalmanInfEng < InfEng
    
    
    properties
        diagnostics;
        verbose;
        model;
    end
    
    
    properties(Access = 'protected')
        X;
        Y;
        LL;
    end
    
    
    methods
        
        function eng = KalmanInfEng(varargin)
            eng.verbose = processArgs(varargin,'-verbose',true);
        end
        
        function eng = enterEvidence(eng,model,D)
            switch class(D)
                case {'DataTable','DataSequence'}
                    eng.Y = unwrap(D);
                case 'DataTableXY'
                    eng.X = D.X;
                    eng.Y = D.Y;
                otherwise
                    error('unsupported data type');
                    
                    
            end
            eng.model = model;
            
        end
        
        function [M,eng] = computeMarginals(eng,Q)
            model = eng.model;
            % obviously we need to deal with Q here
            if ismember('filtered',Q.modifiers)
                fn = @kalman_filter;
            else
                fn = @kalman_smoother;
            end
            
            Z = MvnDist(); ZZ = MvnDist();
            [Z.params.mu, Z.params.Sigma, ZZ.params.Sigma, eng.LL] = fn(eng.Y ,...
                model.params.sysMatrix       , model.params.obsMatrix                 ,...
                cov(model.params.sysNoise)   , cov(model.params.obsNoise)             ,...
                mean(model.params.startDist)' , cov(model.params.startDist)            ,...
                'u',eng.X,'B',model.params.inputMatrix,'model',model.params.modelSwitch  );
            ZZ.params.mu = Z.params.mu;
            M = {Z,ZZ};
        end
        
        
        function L = computeLogPdf(eng,model,D)
            % probably a much better way!
            [Z,eng] = computeMarginals(enterEvidence(eng,model,D));
            L = eng.LL;
        end
        
        
        
        function [Z,Y] = computeSamples(eng,model,nTimeSteps,controlSignal)%#ok
            
            
            if nargin < 4, controlSignal = [];end
            [Z,Y] = sample_lds(...
                model.params.sysMatrix, model.params.obsMatrix           ,...
                cov(model.params.sysNoise)   , cov(model.params.obsNoise) ,...
                mean(model.params.startDist) , nTimeSteps                ,...
                model.params.modelSwitch     , model.params.inputMatrix  ,...
                controlSignal);
            
            
        end
        
        
    end
    
    
    methods(Static = true)
        
        function [xsmooth, Vsmooth, VVsmooth, loglik] = kalman_smoother(y, A, C, Q, R, init_x, init_V, varargin)
            % Kalman/RTS smoother.
            % [xsmooth, Vsmooth, VVsmooth, loglik] = kalman_smoother(y, A, C, Q, R, init_x, init_V, ...)
            %
            % The inputs are the same as for kalman_filter.
            % The outputs are almost the same, except we condition on y(:, 1:T) (and u(:, 1:T) if specified),
            % instead of on y(:, 1:t).
            
            [os T] = size(y);
            ss = length(A);
            
            % set default params
            model = ones(1,T);
            u = [];
            B = [];
            
            args = varargin;
            nargs = length(args);
            for i=1:2:nargs
                switch args{i}
                    case 'model', model = args{i+1};
                    case 'u', u = args{i+1};
                    case 'B', B = args{i+1};
                    otherwise, error(['unrecognized argument ' args{i}])
                end
            end
            
            if isempty(model)
                model = ones(1,T);
            end
            
            
            xsmooth = zeros(ss, T);
            Vsmooth = zeros(ss, ss, T);
            VVsmooth = zeros(ss, ss, T);
            
            % Forward pass
            [xfilt, Vfilt, VVfilt, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, ...
                'model', model, 'u', u, 'B', B);
            
            % Backward pass
            xsmooth(:,T) = xfilt(:,T);
            Vsmooth(:,:,T) = Vfilt(:,:,T);
            %VVsmooth(:,:,T) = VVfilt(:,:,T);
            
            for t=T-1:-1:1
                m = model(t+1);
                if isempty(B)
                    [xsmooth(:,t), Vsmooth(:,:,t), VVsmooth(:,:,t+1)] = ...
                        smooth_update(xsmooth(:,t+1), Vsmooth(:,:,t+1), xfilt(:,t), Vfilt(:,:,t), ...
                        Vfilt(:,:,t+1), VVfilt(:,:,t+1), A(:,:,m), Q(:,:,m), [], []);
                else
                    [xsmooth(:,t), Vsmooth(:,:,t), VVsmooth(:,:,t+1)] = ...
                        smooth_update(xsmooth(:,t+1), Vsmooth(:,:,t+1), xfilt(:,t), Vfilt(:,:,t), ...
                        Vfilt(:,:,t+1), VVfilt(:,:,t+1), A(:,:,m), Q(:,:,m), B(:,:,m), u(:,t+1));
                end
            end
            
            VVsmooth(:,:,1) = zeros(ss,ss);
            
        end
        
        
        
    end
    
end



function [x, V, VV, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, varargin)
    % Kalman filter.
    % [x, V, VV, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, ...)
    %
    % INPUTS:
    % y(:,t)   - the observation at time t
    % A - the system matrix
    % C - the observation matrix
    % Q - the system covariance
    % R - the observation covariance
    % init_x - the initial state (column) vector
    % init_V - the initial state covariance
    %
    % OPTIONAL INPUTS (string/value pairs [default in brackets])
    % 'model' - model(t)=m means use params from model m at time t [ones(1,T) ]
    %     In this case, all the above matrices take an additional final dimension,
    %     i.e., A(:,:,m), C(:,:,m), Q(:,:,m), R(:,:,m).
    %     However, init_x and init_V are independent of model(1).
    % 'u'     - u(:,t) the control signal at time t [ [] ]
    % 'B'     - B(:,:,m) the input regression matrix for model m
    %
    % OUTPUTS (where X is the hidden state being estimated)
    % x(:,t) = E[X(:,t) | y(:,1:t)]
    % V(:,:,t) = Cov[X(:,t) | y(:,1:t)]
    % VV(:,:,t) = Cov[X(:,t), X(:,t-1) | y(:,1:t)] t >= 2
    % loglik = sum{t=1}^T log P(y(:,t))
    %
    % If an input signal is specified, we also condition on it:
    % e.g., x(:,t) = E[X(:,t) | y(:,1:t), u(:, 1:t)]
    % If a model sequence is specified, we also condition on it:
    % e.g., x(:,t) = E[X(:,t) | y(:,1:t), u(:, 1:t), m(1:t)]
    
    [os T] = size(y);
    ss = size(A,1); % size of state space
    
    % set default params
    model = ones(1,T);
    u = [];
    B = [];
    ndx = [];
    
    args = varargin;
    nargs = length(args);
    for i=1:2:nargs
        switch args{i}
            case 'model', model = args{i+1};
            case 'u', u = args{i+1};
            case 'B', B = args{i+1};
            case 'ndx', ndx = args{i+1};
            otherwise, error(['unrecognized argument ' args{i}])
        end
    end
    
    if isempty(model)
        model = ones(1,T);
    end
    
    
    x = zeros(ss, T);
    V = zeros(ss, ss, T);
    VV = zeros(ss, ss, T);
    
    loglik = 0;
    for t=1:T
        m = model(t);
        if t==1
            %prevx = init_x(:,m);
            %prevV = init_V(:,:,m);
            prevx = init_x;
            prevV = init_V;
            initial = 1;
        else
            prevx = x(:,t-1);
            prevV = V(:,:,t-1);
            initial = 0;
        end
        if isempty(u)
            [x(:,t), V(:,:,t), LL, VV(:,:,t)] = ...
                kalman_update(A(:,:,m), C(:,:,m), Q(:,:,m), R(:,:,m), y(:,t), prevx, prevV, 'initial', initial);
        else
            if isempty(ndx)
                [x(:,t), V(:,:,t), LL, VV(:,:,t)] = ...
                    kalman_update(A(:,:,m), C(:,:,m), Q(:,:,m), R(:,:,m), y(:,t), prevx, prevV, ...
                    'initial', initial, 'u', u(:,t), 'B', B(:,:,m));
            else
                i = ndx{t};
                % copy over all elements; only some will get updated
                x(:,t) = prevx;
                prevP = inv(prevV);
                prevPsmall = prevP(i,i);
                prevVsmall = inv(prevPsmall);
                [x(i,t), smallV, LL, VV(i,i,t)] = ...
                    kalman_update(A(i,i,m), C(:,i,m), Q(i,i,m), R(:,:,m), y(:,t), prevx(i), prevVsmall, ...
                    'initial', initial, 'u', u(:,t), 'B', B(i,:,m));
                smallP = inv(smallV);
                prevP(i,i) = smallP;
                V(:,:,t) = inv(prevP);
            end
        end
        loglik = loglik + LL;
    end
    
    
    
    
    
end

function [xsmooth, Vsmooth, VVsmooth, loglik] = kalman_smoother(y, A, C, Q, R, init_x, init_V, varargin)
    % Kalman/RTS smoother.
    % [xsmooth, Vsmooth, VVsmooth, loglik] = kalman_smoother(y, A, C, Q, R, init_x, init_V, ...)
    %
    % The inputs are the same as for kalman_filter.
    % The outputs are almost the same, except we condition on y(:, 1:T) (and u(:, 1:T) if specified),
    % instead of on y(:, 1:t).
    
    [os T] = size(y);
    ss = length(A);
    
    % set default params
    model = ones(1,T);
    u = [];
    B = [];
    
    args = varargin;
    nargs = length(args);
    for i=1:2:nargs
        switch args{i}
            case 'model', model = args{i+1};
            case 'u', u = args{i+1};
            case 'B', B = args{i+1};
            otherwise, error(['unrecognized argument ' args{i}])
        end
    end
    
    if isempty(model)
        model = ones(1,T);
    end
    
    
    xsmooth = zeros(ss, T);
    Vsmooth = zeros(ss, ss, T);
    VVsmooth = zeros(ss, ss, T);
    
    % Forward pass
    [xfilt, Vfilt, VVfilt, loglik] = kalman_filter(y, A, C, Q, R, init_x, init_V, ...
        'model', model, 'u', u, 'B', B);
    
    % Backward pass
    xsmooth(:,T) = xfilt(:,T);
    Vsmooth(:,:,T) = Vfilt(:,:,T);
    %VVsmooth(:,:,T) = VVfilt(:,:,T);
    
    for t=T-1:-1:1
        m = model(t+1);
        if isempty(B)
            [xsmooth(:,t), Vsmooth(:,:,t), VVsmooth(:,:,t+1)] = ...
                smooth_update(xsmooth(:,t+1), Vsmooth(:,:,t+1), xfilt(:,t), Vfilt(:,:,t), ...
                Vfilt(:,:,t+1), VVfilt(:,:,t+1), A(:,:,m), Q(:,:,m), [], []);
        else
            [xsmooth(:,t), Vsmooth(:,:,t), VVsmooth(:,:,t+1)] = ...
                smooth_update(xsmooth(:,t+1), Vsmooth(:,:,t+1), xfilt(:,t), Vfilt(:,:,t), ...
                Vfilt(:,:,t+1), VVfilt(:,:,t+1), A(:,:,m), Q(:,:,m), B(:,:,m), u(:,t+1));
        end
    end
    
    VVsmooth(:,:,1) = zeros(ss,ss);
    
end

function [xnew, Vnew, loglik, VVnew] = kalman_update(A, C, Q, R, y, x, V, varargin)
    % KALMAN_UPDATE Do a one step update of the Kalman filter
    % [xnew, Vnew, loglik] = kalman_update(A, C, Q, R, y, x, V, ...)
    %
    % INPUTS:
    % A - the system matrix
    % C - the observation matrix
    % Q - the system covariance
    % R - the observation covariance
    % y(:)   - the observation at time t
    % x(:) - E[X | y(:, 1:t-1)] prior mean
    % V(:,:) - Cov[X | y(:, 1:t-1)] prior covariance
    %
    % OPTIONAL INPUTS (string/value pairs [default in brackets])
    % 'initial' - 1 means x and V are taken as initial conditions (so A and Q are ignored) [0]
    % 'u'     - u(:) the control signal at time t [ [] ]
    % 'B'     - the input regression matrix
    %
    % OUTPUTS (where X is the hidden state being estimated)
    %  xnew(:) =   E[ X | y(:, 1:t) ]
    %  Vnew(:,:) = Var[ X(t) | y(:, 1:t) ]
    %  VVnew(:,:) = Cov[ X(t), X(t-1) | y(:, 1:t) ]
    %  loglik = log P(y(:,t) | y(:,1:t-1)) log-likelihood of innovatio
    
    % set default params
    u = [];
    B = [];
    initial = 0;
    
    args = varargin;
    for i=1:2:length(args)
        switch args{i}
            case 'u', u = args{i+1};
            case 'B', B = args{i+1};
            case 'initial', initial = args{i+1};
            otherwise, error(['unrecognized argument ' args{i}])
        end
    end
    
    %  xpred(:) = E[X_t+1 | y(:, 1:t)]
    %  Vpred(:,:) = Cov[X_t+1 | y(:, 1:t)]
    
    if initial
        if isempty(u)
            xpred = x;
        else
            xpred = x + B*u;
        end
        Vpred = V;
    else
        if isempty(u)
            xpred = A*x;
        else
            xpred = A*x + B*u;
        end
        Vpred = A*V*A' + Q;
    end
    
    e = y - C*xpred; % error (innovation)
    n = length(e);
    ss = length(A);
    S = C*Vpred*C' + R;
    Sinv = inv(S);
    ss = length(V);
    loglik  = logPdf(MvnDist(zeros(1,length(e)),S),DataTable(abs(e')));
    %loglik = gaussian_prob(e, zeros(1,length(e)), S, 1);
    K = Vpred*C'*Sinv; % Kalman gain matrix
    % If there is no observation vector, set K = zeros(ss).
    xnew = xpred + K*e;
    Vnew = (eye(ss) - K*C)*Vpred;
    VVnew = (eye(ss) - K*C)*A*V;
end


function [xsmooth, Vsmooth, VVsmooth_future] = smooth_update(xsmooth_future, Vsmooth_future, ...
        xfilt, Vfilt,  Vfilt_future, VVfilt_future, A, Q, B, u)
    % One step of the backwards RTS smoothing equations.
    % function [xsmooth, Vsmooth, VVsmooth_future] = smooth_update(xsmooth_future, Vsmooth_future, ...
    %    xfilt, Vfilt,  Vfilt_future, VVfilt_future, A, B, u)
    %
    % INPUTS:
    % xsmooth_future = E[X_t+1|T]
    % Vsmooth_future = Cov[X_t+1|T]
    % xfilt = E[X_t|t]
    % Vfilt = Cov[X_t|t]
    % Vfilt_future = Cov[X_t+1|t+1]
    % VVfilt_future = Cov[X_t+1,X_t|t+1]
    % A = system matrix for time t+1
    % Q = system covariance for time t+1
    % B = input matrix for time t+1 (or [] if none)
    % u = input vector for time t+1 (or [] if none)
    %
    % OUTPUTS:
    % xsmooth = E[X_t|T]
    % Vsmooth = Cov[X_t|T]
    % VVsmooth_future = Cov[X_t+1,X_t|T]
    
    %xpred = E[X(t+1) | t]
    if isempty(B)
        xpred = A*xfilt;
    else
        xpred = A*xfilt + B*u;
    end
    Vpred = A*Vfilt*A' + Q; % Vpred = Cov[X(t+1) | t]
    J = Vfilt * A' * inv(Vpred); % smoother gain matrix
    xsmooth = xfilt + J*(xsmooth_future - xpred);
    Vsmooth = Vfilt + J*(Vsmooth_future - Vpred)*J';
    VVsmooth_future = VVfilt_future + (Vsmooth_future - Vfilt_future)*inv(Vfilt_future)*VVfilt_future;
    
    
end







function [x,y] = sample_lds(F, H, Q, R, init_state, T, models, G, u)
    % SAMPLE_LDS Simulate a run of a (switching) stochastic linear dynamical system.
    % [x,y] = switching_lds_draw(F, H, Q, R, init_state, models, G, u)
    %
    %   x(t+1) = F*x(t) + G*u(t) + w(t),  w ~ N(0, Q),  x(0) = init_state
    %   y(t) =   H*x(t) + v(t),  v ~ N(0, R)
    %
    % Input:
    % F(:,:,i) - the transition matrix for the i'th model
    % H(:,:,i) - the observation matrix for the i'th model
    % Q(:,:,i) - the transition covariance for the i'th model
    % R(:,:,i) - the observation covariance for the i'th model
    % init_state(:,i) - the initial mean for the i'th model
    % T - the num. time steps to run for
    %
    % Optional inputs:
    % models(t) - which model to use at time t. Default = ones(1,T)
    % G(:,:,i) - the input matrix for the i'th model. Default = 0.
    % u(:,t)   - the input vector at time t. Default = zeros(1,T)
    %
    % Output:
    % x(:,t)    - the hidden state vector at time t.
    % y(:,t)    - the observation vector at time t.
    
    
    if ~iscell(F)
        F = num2cell(F, [1 2]);
        H = num2cell(H, [1 2]);
        Q = num2cell(Q, [1 2]);
        R = num2cell(R, [1 2]);
    end
    
    M = length(F);
    %T = length(models);
    
    if nargin < 7 || isempty(models),
        models = ones(1,T);
    end
    if nargin < 8 || isempty(G) || isempty(u),
        G = num2cell(repmat(0, [1 1 M]));
        u = zeros(1,T);
    end
    
    [os ss] = size(H{1});
    state_noise_samples = cell(1,M);
    obs_noise_samples = cell(1,M);
    for i=1:M
        state_noise_samples{i} = sample(MvnDist(zeros(length(Q{i}),1),Q{i}),T)';
        obs_noise_samples{i} =   sample(MvnDist(zeros(length(R{i}),1),R{i}),T)';
        %state_noise_samples{i} = sample_gaussian(zeros(length(Q{i}),1), Q{i}, T)';
        %obs_noise_samples{i} = sample_gaussian(zeros(length(R{i}),1), R{i}, T)';
    end
    
    x = zeros(ss, T);
    y = zeros(os, T);
    
    m = models(1);
    x(:,1) = init_state(:,m);
    y(:,1) = H{m}*x(:,1) + obs_noise_samples{m}(:,1);
    
    for t=2:T
        m = models(t);
        x(:,t) = F{m}*x(:,t-1) + G{m}*u(:,t-1) + state_noise_samples{m}(:,t);
        y(:,t) = H{m}*x(:,t)  + obs_noise_samples{m}(:,t);
    end
end
