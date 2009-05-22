classdef Query
% Simple wrapper for queries in calls to infer. 


    properties
        layer;
        variables; 
    end
    
    
    methods
        
        function Q = Query(varargin)
          % Layer defines the level, i.e. visible/latent and variables 
          % defines the portion of that level you want. 
          
          [Q.variables,Q.layer] = processArgs(varargin,'-variables',{},'-layer','default');
        end
        
        function n = nqueries(Q)
           n = 1;
           if iscell(Q.variables)
              n = numel(Q.variables); 
           end
        end
        
        function e = isempty(Q)
           e = nqueries(Q) == 0; 
        end
        
        function r = isRagged(Q)
            if isempty(Q.variables), r = false; return; end
            if ischar(Q.variables)
                r = ~isSubstring('singles',Q.variables,true);
            else
                r = ~(isnumeric(Q.variables) || all(cellfun(@isscalar,Q.variables)));
            end
        end
         
        
    end
   
    
end

