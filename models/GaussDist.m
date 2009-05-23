classdef GaussDist < ScalarDist & ParallelizableDist
%GAUSSDIST


	properties

		dof;
		
		params;
		prior;

	end


	methods

		function model = GaussDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('GaussDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('GaussDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('GaussDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('GaussDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('GaussDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('GaussDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('GaussDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('GaussDist.var()');
		end


	end


end

