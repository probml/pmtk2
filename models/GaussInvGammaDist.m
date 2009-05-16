classdef GaussInvGammaDist < MultivarDist
%GAUSSINVGAMMADIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = GaussInvGammaDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('GaussInvGammaDist.var()');
		end


	end


end

