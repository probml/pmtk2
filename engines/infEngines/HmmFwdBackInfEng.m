classdef HmmFwdBackInfEng < FwdBackInfEng
    
    properties
        diagnostics;
    end
    
    properties(GetAccess = 'protected')
        pi;
        A;
        localEvidence;
        cachedLogLik;
    end
    
    methods
        
        function eng = enterEvidence(eng,model,D)
            eng.pi = pmf(model.prior);
            eng.A  = pmf(model.params.transDist);
            if nargin < 3 || isempty(D)
                eng.localEvidence = ones(model.nstates,1);
                return;
            end
            assert(ncases(D) == 1);
            localEvidence = zeros(model.nstates,length(D));
            eDists = model.params.emissionDists;
            for i = 1:model.nstates
                localEvidence(i,:) = exp(logPdf(eDists{i},D));
            end
            eng.localEvidence = localEvidence;
        end
        
        
        function M = computeMarginals(eng,Q)
            % This is very ugly, we might be able to clean it up by
            % calculating the queries recursively, but we don't want to
            % recalcuate gamma and friends each time. 
            
            vars = Q.variables;
            if isequal(vars,'viterbi')
                % not used directly by end user - they call computeFunPost
                % and ask for the mode instead, but that code will use
                % this. We could move this to new engine method.
                M = hmmViterbi(eng.pi, eng.A, eng.localEvidence);
                return;
            end
            
            filteredOnly = ismember('filtered',Q.modifiers);
            
            if filteredOnly
                [eng.cachedLogLik,alpha] = hmmFwd(eng.pi,eng.A,eng.localEvidence); % trust that the queries only need alpha!
            else
                [gamma, alpha, beta,eng.cachedLogLik] = hmmFwdBack(eng.pi, eng.A, eng.localEvidence);
            end
            switch class(vars)
                case 'char'
                    switch lower(vars)
                        case 'singles'
                            if filteredOnly
                                M = alpha;
                            else
                                M = gamma;
                            end
                        case 'pairs'
                            M = hmmComputeTwoSlice(alpha, beta, eng.A, eng.localEvidence);
                        otherwise
                            error('%s is not a supported query',vars);
                    end
                case {'cell','double'}
                    if ~iscell(vars), vars = {vars}; unwrap = true; else unwrap = false; end
                    M = cell(numel(vars),1);
                    for i=1:numel(vars)
                        v = vars{i};
                        if numel(v) == 1 && isnumeric(v)
                            if filteredOnly
                                M{i} = alpha(:,v);
                            else
                                M{i} = gamma(:,v);
                            end
                        elseif numel(v) == 2 && isnumeric(v) && diff(v) == 1
                            M{i} = xi_summed(v(1),v(2));
                        elseif ischar(v)
                            switch lower(v)
                                case 'singles'
                                    if filteredOnly
                                        M{i} = alpha;
                                    else
                                        M{i} = gamma;
                                    end
                                case 'pairs'
                                    M{i} = hmmComputeTwoSlice(alpha, beta, eng.A, eng.localEvidence);
                                otherwise
                                    error('%s is not a supported query',vars);
                            end
                        else
                            error('Arbitrary marginals not yet supported'); % in PMTK1 we unrolled to a DGM and used varelim
                        end
                    end
                    if unwrap, M = unwrapCell(M); end
            end
        end
        
        function L = computeLogPdf(eng,varargin)
            [model,D,iscached] = processArgs(varargin,'-model',[],'-data',[],'-iscached',false);
            if iscached
                L = eng.cachedLogLik;
            else
                eng = enterEvidence(eng,model,D);
                L = hmmFwd(eng.pi,eng.A,eng.localEvidence);  % first return arg of hmmFwd is loglik
            end
            
        end
        
        function S = computeSamples(eng,varargin)
            [model,D,nsamples,iscached] = processArgs('-model',[],'-data',[],'-nsamples',1,'-cached',false);
            if ~iscached
                eng = enterEvidence(eng,model,D);
            end
            S = hmmSamplePost(eng.pi, eng.A, eng.localEvidence, nsamples);
        end
    end
    
end

%% Start of helper functions



function path = hmmViterbi(pi, A, localEvidence)
    % Find the most-probable (Viterbi) path through the HMM state trellis.
    % INPUTS:
    % pi(i) = Pr(Q(1) = i)
    % A(i,j) = Pr(Q(t+1)=j | Q(t)=i)
    % localEvidence(i,t) = Pr(y(t) | Q(t)=i)
    % OUTPUT:
    % path(t) = q(t), where q1 ... qT is the argmax of the above
    % expression.
    [K T] = size(localEvidence);
    delta = zeros(K,T);
    psi = zeros(K,T);
    path = zeros(1,T);
    t=1;
    delta(:,t) = normalize(pi(:) .* localEvidence(:,t));
    psi(:,t) = 0; % arbitrary value, since there is no predecessor to t=1
    for t=2:T
        for j=1:K
            [delta(j,t), psi(j,t)] = max(delta(:,t-1) .* A(:,j));
            delta(j,t) = delta(j,t) * localEvidence(j,t);
        end
        delta(:,t) = normalize(delta(:,t));
    end
    
    % Traceback
    [p, path(T)] = max(delta(:,T));
    for t=T-1:-1:1
        path(t) = psi(path(t+1),t+1);
    end
end


function samples = hmmSamplePost(pi, A, localEvidence, nsamples)
    % Forwards filtering, backwards sampling for HMMs
    % OUTPUT:
    % samples(t,s) = value of S(t)  in sample s
    
    [K T] = size(localEvidence);
    [loglik, alpha] = hmmFwd(pi, A, localEvidence);
    samples = zeros(T, nsamples);
    dist = normalize(alpha(:,T));
    samples(T,:) = sampleDiscrete(dist, 1,nsamples);
    for t=T-1:-1:1
        tmp = localEvidence(:,t+1) ./ (alpha(:,t+1)+eps); % b_{t+1}(j) / alpha_{t+1}(j)
        xi_filtered = A .* (alpha(:,t) * tmp');
        for n=1:nsamples
            dist = normalize(xi_filtered(:,samples(t+1,n)));
            samples(t,n) = sampleDiscrete(dist);
        end
    end
end


function [gamma, alpha, beta, loglik] = hmmFwdBack(pi, A, localEvidence)
    % INPUT:
    % pi(i) = p(S(1) = i)
    % A(i,j) = p(S(t) = j | S(t-1)=i)
    % localEvidence(i,t) = p(y(t)| S(t)=i)
    %
    % OUTPUT
    % gamma(i,t) = p(S(t)=i | y(1:T))
    % alpha(i,t)  = p(S(t)=i| y(1:t))
    % beta(i,t) propto p(y(t+1:T) | S(t=i))
    % loglik = log p(y(1:T))
    [loglik, alpha] = hmmFwd(pi, A, localEvidence);
    beta = hmmBackwards(A, localEvidence);
    gamma = normalize(alpha .* beta, 1);% make each column sum to 1
    
end


function [loglik, alpha] = hmmFwd(pi, A, localEvidence)
    % INPUT:
    % pi(i) = p(S(1) = i)
    % A(i,j) = p(S(t) = j | S(t-1)=i)
    % localEvidence(i,t) = p(y(t)| S(t)=i)
    %
    % OUTPUT
    % loglik = log p(y(1:T))
    % alpha(i,t)  = p(S(t)=i| y(1:t))
    [K T] = size(localEvidence);
    scale = zeros(T,1);
    AT = A';
    if nargout >= 2
        alpha = zeros(K,T);
        [alpha(:,1), scale(1)] = normalize(pi(:) .* localEvidence(:,1));
        for t=2:T
            [alpha(:,t), scale(t)] = normalize((AT * alpha(:,t-1)) .* localEvidence(:,t));
        end
    else
        % save some memory
        [alpha, scale(1)] = normalize(pi(:) .* localEvidence(:,1));
        for t=2:T
            [alpha, scale(t)] = normalize((AT * alpha) .* localEvidence(:,t));
        end
    end
    loglik = sum(log(scale)+eps);
end


function beta = hmmBackwards(A, localEvidence)
    [K T] = size(localEvidence);
    beta = zeros(K,T);
    beta(:,T) = ones(K,1);
    for t=T-1:-1:1
        beta(:,t) = normalize(A * (beta(:,t+1) .* localEvidence(:,t+1)));
    end
end

function [xi_summed, xi] = hmmComputeTwoSlice(alpha, beta, A, localEvidence)
    % INPUT:
    % alpha(i,t) computed using forwards
    % beta(i,t) computed using backwards
    % A(i,j) = Pr(Q(t) = j | Q(t-1)=i)
    % localEvidence(i,t) = Pr(Y(t)| Q(t)=i)
    %
    % OUTPUT:
    % xi(i,j,t)  = p(Q(t)=i, Q(t+1)=j | y(1:T)) , t=2:T
    % xi_summed(i,j) = sum_{t=2}^{T} xi(i,j,t)
    
    [K T] = size(localEvidence);
    if nargout < 2
        computeXi = 0;
    else
        computeXi = 1;
        xi = zeros(K,K,T-1);
    end
    
    xi_summed = zeros(size(A));
    for t=T-1:-1:1
        b = beta(:,t+1) .* localEvidence(:,t+1);
        tmpXi = normalize((A .* (alpha(:,t) * b')));
        xi_summed = xi_summed + tmpXi;
        if computeXi
            xi(:,:,t) = tmpXi;
        end
    end
end




