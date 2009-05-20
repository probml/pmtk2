classdef InvGammaDist < ScalarDist
%INVGAMMADIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = InvGammaDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('InvGammaDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('InvGammaDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('InvGammaDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('InvGammaDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('InvGammaDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('InvGammaDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('InvGammaDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('InvGammaDist.var()');
		end


	end


end

