classdef GridDist < ParamFreeDist
%GRIDDIST


	properties

		ndimensions;

	end


	methods

		function model = GridDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('GridDist.cov()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('GridDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('GridDist.mean()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('GridDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('GridDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('GridDist.var()');
		end


	end


end

