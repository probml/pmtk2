classdef HyperInvWishart < GraphicalModel
%HYPERINVWISHART


	properties

		dof;
		ndimensions;
		params;
		prior;
		stateInfEng;

	end


	methods

		function model = HyperInvWishart(varargin)
		%
		end


		function computeMap(model,varargin)
		%
			notYetImplemented('HyperInvWishart.computeMap()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('HyperInvWishart.fit()');
		end


		function infer(model,varargin)
		%
			notYetImplemented('HyperInvWishart.infer()');
		end


		function inferMissing(model,varargin)
		%
			notYetImplemented('HyperInvWishart.inferMissing()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('HyperInvWishart.logpdf()');
		end


		function plotTopology(model,varargin)
		%
			notYetImplemented('HyperInvWishart.plotTopology()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('HyperInvWishart.sample()');
		end


	end


end

