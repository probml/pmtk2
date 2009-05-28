classdef Hmm < ChainModel & LatentVarModel
    %HMM
    
    
    properties
        
        dof;
        ndimensions;     % dimensionality of the observation model
        ndimsLatent = 1;
        params;          % stores transition dist and emission dists
        prior;           % starting distribution over hidden states
        nstates;         % number of hidden states
        fitEng;
        infEng;
    end
    
    
    methods
        
        function model = Hmm(varargin)
            if nargin == 0; return; end
            [   model.params.emissionDists , model.prior            ,...              
                model.params.transDist     , model.nstates          ,...
                emissionTemplate           , model.fitEng           ,...
                model.infEng]              = processArgs(varargin   ,...
                '-emissionDists'    , {} ,...
                '-startDist'        , [] ,...
                '-transDist'        , [] ,...
                '-nstates'          , [] ,...
                '-emissionTemplate' , [],...
                '-fitEng'           , HmmEmFitEng() ,...
                '-infEng'           , HmmFwdBackInfEng());
            
            if isempty(model.nstates)
                if ~isempty(model.params.emissionDists)
                   model.nstates = numel(model.params.emissionDists); 
                elseif ~isempty(model.prior.support)
                    model.nstates = numel(model.prior.support);
                else
                    error('You must specify the number of hidden states -nstates');
                end
            end
            if ~isempty(emissionTemplate)
                model.params.emissionDists = copy(emissionTemplate,model.nstates);
            end
            if isempty(model.prior)
                model.prior = DiscreteDist('-support',1:model.nstates);
            end
            if isempty(model.params.transDist)
                model.params.transDist = FactoredDist(DiscreteDist('-support',1:model.nstates,'-ndistributions',model.nstates));
            end
            model.ndimensions = model.params.emissionDists{1}.ndimensions;
        end
        
        
        function [model,success] =  fit(model,varargin)
            [model,success] = fit(model.fitEng,model,varargin{:});
        end
        
        
        function post = inferLatent(model,varargin)
            [Q,D] = processArgs(varargin,'+-query',Query(),'-data',DataSequence());
            n = max(1,nqueries(Q));
            d = max(1,ncases(D));
            post = cell(n,d);
            for j=1:d
                eng = enterEvidence(model.infEng,model,D(j)); % now reuse this eng for all of the queries
                for i=1:n
                    post(i,j) = cellwrap(computeMarginals(eng,Q(i)));
                end
            end
%             if n == 1 && d == 1
                post = unwrapCell(post);
%             end
        end
        
        function varargout = computeFunPost(model,varargin)
            [Q,D,funcs,funcArgs] = processArgs(varargin,'+-query',Query(),'-data',DataSequence(),'-funcs','mode','-funcArgs',{});
            varargout = cell(1,numel(funcs));
            if ncases(D) > 1 ; notYetImplemented('not yet vectorized w.r.t. data - call once for each data case'); end
            if ~isempty(Q)   ; notYetImplemented('queries not yet supported'); end 
            eng = enterEvidence(model.infEng,model,D);
            for f=1:numel(funcs)
                switch funcs{f}
                    case 'mode'
                        M = computeMarginals(eng,Query('viterbi'));
                    case 'sample'
                        try nsamples = funcArgs{f}; % faster to beg for forgiveness than to ask for permission!
                        catch %#ok
                            nsamples  = 1;
                        end
                        M = computeSamples(eng,'-cached',true,'-nsamples',nsamples);
                end 
                varargout{f} = M; 
            end
        end
        
        function L = logPdf(model,D)
            nc = ncases(D);
            L = zeros(nc,1);
            for i=1:nc
                L(i) = computeLogPdf(model.infEng,model,D(i));
            end
        end
        
        
        function [observed,hidden] = sample(model,nsamples,lens)
        % Sample nsamples from this HMM, each with length specified in
        % the corresponding entry of lens. This returns data in the format
        % expected by fit, inferLatent, etc. 
            
            if numel(lens) < nsamples, lens = repmat(lens(1),nsamples); end
            eDists = model.params.emissionDists;
            hid = cell(nsamples,1);
            obs = cell(nsamples,1);
            pi = pmf(model.prior);
            A = pmf(model.params.transDist);
            for i=1:nsamples
                hid{i} = mc_sample(pi,A,lens(i),1);
                for t = 1:lens(i)
                    obs{i}(:,t) = colvec(sample(eDists{hid{i}(1,t)}));
                end
                
            end
            observed = DataSequence(obs);
            hidden   = DataSequence(obs);
        end
        
        
    end
    
end





function S = mc_sample(pi, A, len, numex)
    % SAMPLE_MC Generate random sequences from a Markov chain.
    % STATE = SAMPLE_MC(PRIOR, TRANS, LEN) generates a sequence of length LEN.
    %
    % STATE = SAMPLE_MC(PRIOR, TRANS, LEN, N) generates N rows each of
    % length LEN.
    if nargin==3, numex = 1; end
    S = zeros(numex,len);
    for i=1:numex
        S(i, 1) = sampleDiscrete(pi);
        for t=2:len
            S(i, t) = sampleDiscrete(A(S(i,t-1),:));
        end
    end
end

