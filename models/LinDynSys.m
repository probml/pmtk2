classdef LinDynSys < ChainModel & LatentVarModel
    
    
    
    properties
        
        dof;
        ndimensions;
        ndimsLatent;
        params;       % stores sysNoise,obsNoise,sysMatrix,obsMatrix,inputMatrix, modelSwitch
        prior;
        fitEng;
        infEng;
    end
    
    methods
        
        function model = LinDynSys(varargin)
            [model.params.startDist,model.params.sysNoise ,model.params.obsNoise ,  ...
                model.params.sysMatrix,model.params.obsMatrix,model.params.inputMatrix,  ...
                model.params.modelSwitch,model.ndimensions,model.ndimsLatent,model.fitEng,model.infEng]...
                = processArgs(varargin ,  ...
                '-startDist'  ,[],'-sysNoise'  ,[],'-obsNoise'   ,[], ...
                '-sysMatrix'  ,[],'-obsMatrix' ,[],'-inputMatrix',[], ...
                '-modelSwitch',[], '-ndimensions'  ,[], '-ndimsLatent',[],...
                '-fitEng',LinDynSysFitEng(),'-infEng',KalmanInfEng());
            if ~isempty(model.params.obsMatrix)
                [model.ndimensions,model.ndimsLatent] = size(model.params.obsMatrix);
            end
        end
        
        
        function computeMapLatent(model,varargin)
            notYetImplemented('LinDynSys.computeMapLatent()');
        end
        
        
        function model = fit(model,varargin)
            D = processArgs(varargin,'-data',DataSequence());
            model = fit(model.fitEng,model,unwrap(D));
        end
        
        function post = inferLatent(model,varargin)
            % same code as Hmm - should be factored up
            [Q,D] = processArgs(varargin,'+-query',Query(),'-data',DataSequence());
            post = computeMarginals(enterEvidence(model.infEng,model,D),Q);
            %             n = max(1,nqueries(Q));
%             d = max(1,ncases(D));
%             post = cell(n,d);
%             for j=1:d
%                 eng = enterEvidence(model.infEng,model,D(j)); 
%                 for i=1:n
%                     post(i,j) = cellwrap(computeMarginals(eng,Q(i)));
%                 end
%             end
%             post = unwrapCell(post);
        end
        
        function L = logPdf(model,D)
            L = computeLogPdf(model.eng,model,unwrap(D));
        end
        
        function [Z,Y] = sample(model,varargin)
            [nTimeSteps,controlSignal] = processArgs(varargin,'-nTimeSteps',1,'-controlSignal',[]);
            [Z,Y] = computeSamples(model.infEng,model,nTimeSteps,controlSignal);
        end
    end
end







