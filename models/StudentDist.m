classdef StudentDist < ScalarDist
%STUDENTDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = StudentDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('StudentDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('StudentDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('StudentDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('StudentDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('StudentDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('StudentDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('StudentDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('StudentDist.var()');
		end


	end


end

