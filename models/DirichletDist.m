classdef DirichletDist < MultivarDist
%DIRICHLETDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = DirichletDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('DirichletDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('DirichletDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('DirichletDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('DirichletDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('DirichletDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('DirichletDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('DirichletDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('DirichletDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('DirichletDist.var()');
		end


	end


end

