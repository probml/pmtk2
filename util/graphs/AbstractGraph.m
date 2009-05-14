classdef AbstractGraph
    %ABSTRACTGRAPH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Abstract = true)
        adjMat;
    end
    
    methods(Abstract = true)
      
       dfs;
       isAcyclic;
       reachabilityGraph;
       
    end
    
    methods(Abstract = true, Static = true)
       makeAll; 
    end
    
    
    methods
        
        function h = draw(G,varargin)
            h = Graphlayout('adjMatrix',G.adjmat,varargin{:});
        end
        
        function d = nnodes(obj)
            d = length(obj.adjMat);
        end
        
        function ns = neighbors(obj, i)
            ns = union(find(obj.adjMat(i,:)), find(obj.adjMat(:,i))');
        end
        
        
         
    end
    
end

