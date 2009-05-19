classdef MvnGibbsInfEng < GibbsInfEng
%MVNGIBBSINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = MvnGibbsInfEng(varargin)
		%
		end

		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('MvnGibbsInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('MvnGibbsInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('MvnGibbsInfEng.computeSamples()');
		end


		function enterEvidence(eng,varargin)
		%
			notYetImplemented('MvnGibbsInfEng.enterEvidence()');
        end

    end
    
    methods(Access = 'protected')
        
        function mcmcInit(eng,varargin)
		%
			notYetImplemented('MvnGibbsInfEng.mcmcInit()');
        end 
        
        function computeFullCond(eng,varargin)
		%
			notYetImplemented('MvnGibbsInfEng.computeFullCond()');
		end


        
        
    end


end

