classdef LogRegL2FitEng < CondModelFitEng
%LOGREGL2FITENG


	properties
        
        diagnostics;
        
    end

    properties(Access = 'protected')
       verbose; 
    end

	methods

		function eng = LogRegL2FitEng(varargin)
		%
        end
    
        function eng = fit(eng,varargin)
            notYetImplemented('LogRegL2FitEng.fit');
        end

	end


end

