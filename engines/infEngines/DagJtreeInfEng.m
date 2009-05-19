classdef DagJtreeInfEng < JtreeInfEng
%DAGJTREEINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = DagJtreeInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('DagJtreeInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('DagJtreeInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('DagJtreeInfEng.computeSamples()');
		end

		function enterEvidence(eng,varargin)
		%
			notYetImplemented('DagJtreeInfEng.enterEvidence()');
		end


    end
    
    methods(Access = 'protected')
        
        function convertToTabularFactors(eng,varargin)
		%
			notYetImplemented('DagJtreeInfEng.convertToTabularFactors()');
		end
 
        
        
    end

end

