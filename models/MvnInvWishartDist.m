classdef MvnInvWishartDist < MultivarDist
%MVNINVWISHARTDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = MvnInvWishartDist(varargin)
              [model.params.mu, model.params.Sigma, model.params.dofParam, model.params.k]...
                  = processArgs(varargin,'-mu',[],'-Sigma',[],'-dofParam',[],'-k',[]);
              model = initialize(model);
		end


		function cov(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.var()');
		end


    end

    methods(Access = 'protected')
       
        function model = initialize(model)
           model.ndimensions = length(model.params.mu);
           if isempty(model.params.k)
               model.params.k = model.ndimensions;
           end
           model.dof = model.params.dofParam;
        end
        
    end

end

