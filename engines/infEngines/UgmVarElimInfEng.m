classdef UgmVarElimInfEng < VarElimInfEng
%UGMVARELIMINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = UgmVarElimInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('UgmVarElimInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('UgmVarElimInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('UgmVarElimInfEng.computeSamples()');
		end

		function enterEvidence(eng,varargin)
		%
			notYetImplemented('UgmVarElimInfEng.enterEvidence()');
		end


    end
    
    methods(Access = 'protected')

        function convertToTabularFactors(eng,varargin)
		%
			notYetImplemented('UgmVarElimInfEng.convertToTabularFactors()');
		end
 
    end

end

