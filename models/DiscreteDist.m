classdef DiscreteDist < ScalarDist & ParallelizableDist
%DISCRETEDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = DiscreteDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('DiscreteDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('DiscreteDist.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('DiscreteDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('DiscreteDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('DiscreteDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('DiscreteDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('DiscreteDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('DiscreteDist.var()');
		end


	end


end

