classdef FactoredDist < MultivarDist



	properties

		dof;
		ndimensions;
		params;
		prior;         
        ndistributions;
        parallelized;
        support;
	end


	methods

		function model = FactoredDist(varargin)
            if nargin == 0; return; end
            [model.params.distributions,template,model.ndistributions,model.ndistributions,model.prior] = processArgs(varargin,'-distributions',{},'-template',[],'-ndistributions',[],'-ndimensions',[],'-prior',NoPrior());
            
            if numel(model.params.distributions) == 1, template = model.params.distributions; end
            if ~isempty(template) 
                if isa(template,'ParallelizableDist')
                    model.params.distributions = template;
                else
                    model.params.distributions = copy(template,model.ndistributions);
                end
            elseif iscell(model.params.distributions)
                model.ndistributions = numel(model.params.distributions);
            elseif isempty(model.ndistributions)
                error('you must specify the number of distributions');
            end
            model.parallelized = isa(model.params.distributions,'ParallelizableDist');
            try  %#ok
                if model.parallelized
                    model.support = model.params.distributions.support; 
                else
                    model.support = model.params.distributions{1}.support;  
                end
            end
        end
        
        function I = infer(model,D,Q)
           notYetImplemented('FactoredDist.infer()');
        end
        
        function D = inferMissing(model,D)
           notYetImplemented('FactoredDist.inferMissing'); 
        end
        
		function cov(model,varargin)
		%
			notYetImplemented('FactoredDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('FactoredDist.entropy()');
        end
        
        function T = pmf(model)
            if model.parallelized
                T = pmf(model.params.distributions);
            else
                notYetImplemented;
            end
        end

        function [model,success] =  fit(model,varargin)
            if model.parallelized
                [model.params.distributions,success] = fit(model.params.distributions,varargin{:});
            else
                [D,SS] = processArgs(varargin,'-data',DataTable(),'-suffStat',[]);
                dists = model.params.distributions;
                successArray = false(model.ndistributions,1);
                for i=1:model.ndistributions;
                   [dists{i},successArray(i)] = fit(dists{i},D(:,i)); 
                end
                success = all(successArray);
                model.params.distributions = dists;
            end
		end


		function L = logPdf(model,D)
            if model.parallelized
                L = logPdf(model.params.distributions,D);
            else
                L = zeros(ncases(D),nfeatures(D));
                dists = model.params.distributions;
                for i=1:model.ndistributions
                   L(:,i) = colvec(logPdf(dists{i},D(:,i))); 
                end
                L = sum(L,2);
            end
        end

        function S = mkSuffStat(model,varargin)
            
            if model.parallelized
                S = mkSuffStat(model.params.distributions,varargin{:});
            else
               notYetImplemented(); 
            end
            
        end
        
        
        
		function mean(model,varargin)
		%
			notYetImplemented('FactoredDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('FactoredDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('FactoredDist.plotPdf()');
		end


		function S = sample(model,n)
            if model.parallelized
                S = sample(model.params.distributions,n);
            else
                notYetImplemented();
            end
		end


		function var(model,varargin)
		%
			notYetImplemented('FactoredDist.var()');
		end


	end


end

