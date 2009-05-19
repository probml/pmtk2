classdef UgmTabularGibbsInfEng < GibbsInfEng
%UGMTABULARGIBBSINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = UgmTabularGibbsInfEng(varargin)
		%
		end

		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('UgmTabularGibbsInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('UgmTabularGibbsInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('UgmTabularGibbsInfEng.computeSamples()');
		end


		function enterEvidence(eng,varargin)
		%
			notYetImplemented('UgmTabularGibbsInfEng.enterEvidence()');
        end
    end
    
    methods(Access = 'protected')
        
        function computeFullCond(eng,varargin)
		%
			notYetImplemented('UgmTabularGibbsInfEng.computeFullCond()');
        end
        
        function mcmcInit(eng,varargin)
		%
			notYetImplemented('UgmTabularGibbsInfEng.mcmcInit()');
		end
        
        
    end


end

