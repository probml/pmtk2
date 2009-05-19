classdef UgmJtreeInfEng < JtreeInfEng
%UGMJTREEINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = UgmJtreeInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('UgmJtreeInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('UgmJtreeInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('UgmJtreeInfEng.computeSamples()');
		end

		function enterEvidence(eng,varargin)
		%
			notYetImplemented('UgmJtreeInfEng.enterEvidence()');
		end


    end

    methods(Access = 'protected')
        
        function convertToTabularFactors(eng,varargin)
		%
			notYetImplemented('UgmJtreeInfEng.convertToTabularFactors()');
        end 
        
    end
    

end

