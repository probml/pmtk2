classdef Query
% Simple wrapper for queries in calls to infer. 


    properties
        
        name;
        subdomain;
        
    end
    
    
    methods
        
        function Q = Query(varargin)
          % Name defines the level, i.e. visible/latent and subdomain 
          % defines the portion of that level you want. If the elements of 
          % subdomain are numeric, each cell represents a joint query so
          % that {[1,2,3],[1],[2,3]} is requsting three distributions, the
          % joint on [1,2,3], the marginal on 1, and the joint on [2,3].
          
          [Q.subdomain,Q.name] = processArgs(varargin,'-subdomain',{},'-name','visible');
        end
        
        function n = nqueries(Q)
           n = 1;
           if iscell(Q.subdomain)
              n = numel(Q.subdomain); 
           end
        end
        
        function e = isempty(Q)
           e = nqueries(Q) == 0; 
        end
       
        
        
    end
   
    
end

