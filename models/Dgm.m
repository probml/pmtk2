classdef Dgm < GraphicalModel
%DGM


	properties

		dof;
		ndimensions;
		params;
		prior;
		stateInfEng;

	end


	methods

		function model = Dgm(varargin)
		%
		end


		function computeMap(model,varargin)
		%
			notYetImplemented('Dgm.computeMap()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('Dgm.fit()');
		end


		function infer(model,varargin)
		%
			notYetImplemented('Dgm.infer()');
		end


		function inferMissing(model,varargin)
		%
			notYetImplemented('Dgm.inferMissing()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('Dgm.logpdf()');
		end


		function plotTopology(model,varargin)
		%
			notYetImplemented('Dgm.plotTopology()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('Dgm.sample()');
		end


	end


end

