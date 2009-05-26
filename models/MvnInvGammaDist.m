classdef MvnInvGammaDist < MultivarDist
%MVNINVGAMMADIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = MvnInvGammaDist(varargin)
             [model.params.mu, model.params.Sigma, model.params.a, model.params.b] = processArgs(varargin,...
                 '-mu', [], '-Sigma', [], '-a', [], '-b', []);
            model.params.b = rowvec(model.params.b);
            
        end
        
        function mm = marginal(model, Q)
            % marginal(obj, 'sigma') or marginal(obj, 'mu')
            queryVar = Q.variables;
            switch lower(queryVar)
                case 'sigma'
                    mm = InvGammaDist(model.params.a, model.params.b);
                case 'mu'
                    v = 2*model.params.a;
                    s2 = 2*model.params.b/v;
                    mm = MultiStudentDist(v, model.params.mu, s2*model.params.Sigma);
                otherwise
                    error(['unrecognized variable ' queryVar])
            end
        end


		function cov(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.logPdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MvnInvGammaDist.var()');
		end


	end


end

