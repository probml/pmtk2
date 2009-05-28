classdef Query
% Simple wrapper for queries in calls to infer. 


    properties
        layer;
        variables; 
        modifiers; % sometimes useful e.g. HMM asking for filtered rather than smoothed marginals etc. 
    end
    
    
    methods
        
        function Q = Query(varargin)
          % Layer defines the level, i.e. visible/latent and variables 
          % defines the portion of that level you want. 
          
          [Q.variables,Q.layer,Q.modifiers] = processArgs(varargin,'-variables',{},'-layer','default','-modifiers',{});
          if iscell(Q.variables),Q.variables = colvec(Q.variables); end
          if ~isempty(Q.modifiers), Q.modifiers = cellwrap(Q.modifiers); end
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
        
        
        function B = subsref(A, S)
            if numel(S) == 1
                switch S.type
                    case {'()','{}'}
                        if ~ischar(A.variables)
                            if numel(A.modifiers) == numel(A.variables)
                                mod = A.modifiers(S.subs{1});
                            else
                                mod = A.modifiers; 
                            end
                            B = Query(A.variables(S.subs{1}),A.layer,mod);
                        elseif S.subs{1}==1
                            B = Query(A.variables,A.layer,A.modifiers); 
                        else
                            error('invalid index');
                        end
                    case '.'
                        B = builtin('subsref', A, S);
                end
            else
                B = builtin('subsref', A, S);
            end
        end
    end
end

