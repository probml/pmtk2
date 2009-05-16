classdef Ugm < GraphicalModel
%UGM


	properties

		dof;
		ndimensions;
		params;
		prior;
		stateInfEng;

	end


	methods

		function model = Ugm(varargin)
		%
		end


		function computeMap(model,varargin)
		%
			notYetImplemented('Ugm.computeMap()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('Ugm.fit()');
		end


		function infer(model,varargin)
		%
			notYetImplemented('Ugm.infer()');
		end


		function inferMissing(model,varargin)
		%
			notYetImplemented('Ugm.inferMissing()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('Ugm.logpdf()');
		end


		function plotTopology(model,varargin)
		%
			notYetImplemented('Ugm.plotTopology()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('Ugm.sample()');
		end


	end


end

