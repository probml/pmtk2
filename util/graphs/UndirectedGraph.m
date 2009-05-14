classdef UndirectedGraph < AbstractGraph
  
    
    properties
        adjMat;
    end
    
    methods
        
        function G = UndirectedGraph(varargin)
            
        end
        
        function varargout = dfs(G,varargin)
            notYetImplemented('UndirectedGraph.dfs()');
        end
        
        function ac = isAcyclic(G)
            notYetImplemented('UndirectedGraph.isAcyclic()');
        end
         
        function rg = reachabilityGraph(G)
             notYetImplemented('UndirectedGraph.reachabilityGraph()');
        end
        
        function T = minSpanTree(G)
           notYetImplemented('UndirectedGraph.minSpanTree()'); 
        end
        
        function C = maximalCliques(G)
           notYetImplemented('UndirectedGraph.minSpanTree()'); 
        end
        
    end
    
    methods(Static = true)
        function all = makeAll(varargin)
           notYetImplemented('UndirectedGraph.makeAll()'); 
        end
    end
end

