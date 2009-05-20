classdef MultiStudentDist < MultivarDist
%MULTISTUDENTDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = MultiStudentDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('MultiStudentDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MultiStudentDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MultiStudentDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('MultiStudentDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MultiStudentDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MultiStudentDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('MultiStudentDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MultiStudentDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MultiStudentDist.var()');
		end


	end


end

