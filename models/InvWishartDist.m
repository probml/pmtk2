classdef InvWishartDist < MultivarDist
%INVWISHARTDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = InvWishartDist(varargin)
            [model.params.Sigma,model.params.dofParam] = processArgs('-Sigma',[],'-dofParam',[]);
            model = initialize(model);
		end


		function cov(model,varargin)
		%
			notYetImplemented('InvWishartDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('InvWishartDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('InvWishartDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('InvWishartDist.logpdf()');
		end


		function m = mean(model)
            m = model.params.Sigma / (model.params.dofParam - model.ndimensions(model) - 1);
		end


		function mode(model,varargin)
		%
			notYetImplemented('InvWishartDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('InvWishartDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('InvWishartDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('InvWishartDist.var()');
		end


    end
    
    


end

