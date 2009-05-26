classdef ProbKnn < CondModel & NonFiniteParamModel
    
    properties
        
        dof;
        ndimensions;
        params;
        prior;
        transformer;
        verbose = true;
        
    end
    
    
    properties(Access = 'protected')
        Xsos;
    end
    
    methods
        
        function model = ProbKnn(varargin)
            [ model.params.K        ,...
                model.prior           ,...
                model.transformer     ,...
                model.params.invTemp,...
                model.params.useSoftMax,...
                model.params.localKernel,...
                model.params.distanceFcn] = processArgs(varargin,...
                '-K',1,...
                '-prior',DiscreteDist(),...
                '-transformer',NoOpTransformer(),...
                '-invTemp',1,...
                '-useSoftMax',true,...
                '-localKernel',[],...
                '-distanceFcn','sqdist');
            model = setLocalKernel(model);
            
        end
        
        
        function model = fit(model,varargin)
            % memorize the data
            D = processArgs(varargin,'+-data',DataTableXY());
            X = D.X; y = D.y;
            [X,model.transformer] = trainAndApply(model.transformer,X);
            model.params.X = X;
            if isemtpy(model.params.support)
                model.prior.support = unique(y);
            end
            model.params.y = y;
            model.Xsos = sum(X.^2,2);
        end
        
        
        function [yHat,pY] =  inferOutput(model,D)
            
            Xtest = apply(model.transformer,D.X);
            ntest = ncases(D);
            nclasses = numel(model.prior.support);
            probs = zeros(ntest,nclasses);
            batch = largestBatch(model,1,ntest);
            if(obj.verbose)
                if(batch(end) == ntest)
                    wbar = waitbar(0,sprintf('Classifying all %d examples in a single batch...',ntest));
                else
                    wbar = waitbar(0,sprintf('Classifying first %d of %d',batch(end),ntest));
                end
                tic;
            end
            while ~isempty(batch)
                probs(batch,:) = inferHelper(model,Xtest(batch,:));
                if(obj.verbose),t = toc; waitbar(batch(end)/ntest,wbar,sprintf('%d of %d Classified\nElapsed Time: %.2f seconds',batch(end),ntest,t));end
                batch = largestBatch(model,batch(end)+1,ntest);
            end
            if(model.verbose && ishandle(wbar)),close(wbar);end
            SS.counts = probs';
            pY = fit(DiscreteDist('-suffStat',SS));
            yHat = mode(pY);
        end
        
        
        function L = logPdf(model,D)
            %
            notYetImplemented('ProbKnn.logpdf()');
        end
        
        
        function S = sample(model,varargin)
            %
            notYetImplemented('ProbKnn.sample()');
        end
        
        
    end
    
    methods(Access = 'protected')
        
        function probs = inferHelper(model,data)
            if isequal(model.params.distanceFcn,'sqdist')
                dst = sqDistance(data,model.params.X,sum(data.^2,2),model.Xsos);
            else
                dst = obj.distanceFcn(data,model.params.X);
            end
            support = model.prior.support;
            nclasses = numel(support);
            [sortedDst,kNearest] = minK(dst,model.params.K);
            if ~isempty(model.params.localKernel)
                weights = model.params.localKernel(data,model.params.X,sortedDst,kNearest);
                counts = zeros(size(data,1),nclasses);
                for j=1:nclasses
                    counts(:,j) = counts(:,j) + sum((support(kNearest) == j).*weights,2);
                end
            else
                counts = histc(support(kNearest),1:nclasses,2);
            end
            if(model.params.useSoftMax)
                probs = normalize(exp(counts*model.params.invTemp),2);
            else
                probs = normalize(counts,2);
            end
        end
        
        function batch = largestBatch(model,start,ntest)
            
            if start > ntest
                batch = []; return;
            end
            prop = 0.10; % proportion of largest possible array size to use
            if(ispc)
                batchSize = ceil( (prop*subd(memory,'MaxPossibleArrayBytes')/8) /size(model.params.X,1));
                batch = start:min(start+batchSize-1,ntest);
            else
                maxsize = 6e6;
                batchSize = ceil(maxsize/size(model.params.X,1));
                batch = start:min(start+batchSize-1,ntest);
            end
        end
        
        function model = setLocalKernel(model)
            if ~ischar(model.params.localKernel), return; end
            switch lower(kernelName)
                case 'epanechnikov'
                    model.params.localKernel = @epanechnikovKernel;
                case 'tricube'
                    model.params.localKernel = @tricubeKernel;
                case 'gaussian'
                    model.params.localKernel = @gaussianKernel;
                    
                otherwise
                    error('The %s local kernel has not been implemented, please pass in your own function instead',model.params.localKernel);
            end
        end
    end
end





function weights = gaussianKernel(testData,examples,sqdist,knearest)
    bandwidth = repmatC(sqrt(max(sqdist,[],2))+eps,1,size(knearest,2));
    weights = normalize(eps + (1./((2*pi)*bandwidth)).*exp(-(sqdist./(2*bandwidth.^2))),2);
end

function weights = tricubeKernel(testData,examples,sqdist,knearest)
    bandwidth = repmatC(sqrt(max(sqdist,[],2))+eps,1,size(knearest,2));
    weights = sqrt(sqdist)./bandwidth;
    in = abs(weights) <= 1;
    weights(in)  = (1-weights(in).^3).^3;
    weights(not(in)) = 0;
    weights = normalize(eps + weights,2);
end

function weights = epanechnikovKernel(testData,examples,sqdist,knearest)
    bandwidth = repmatC(sqrt(max(sqdist,[],2))+eps,1,size(knearest,2));
    weights = sqrt(sqdist)./bandwidth;
    in = abs(weights) <= 1;
    weights(in)  = (3/4)*(1-weights(in).^2);
    weights(not(in)) = 0;
    weights = normalize(eps + weights,2);
end








