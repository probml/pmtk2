classdef SampleDist < ParamFreeDist
%SAMPLEDIST


	properties

		ndimensions;

	end


	methods

		function model = SampleDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('SampleDist.cov()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('SampleDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('SampleDist.mean()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('SampleDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('SampleDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('SampleDist.var()');
		end


	end


end

