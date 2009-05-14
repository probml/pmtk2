classdef DirectedGraph < AbstractGraph
   
    
    properties
        adjMat;
    end
    
    methods
        
        function G = DirectedGraph(varargin)
            
        end
        
        function p = parents(G,i)
           notYetImplemented(); 
        end
        
        function c = children(G,i)
           notYetImplemented(); 
        end
        
        function a = ancestors(G,i)
            notYetImplemented();
        end
        
        function d = descendents(G,i)
           notYetImplemented(); 
        end
        
        function f = family(G,i)
            notYetImplemented();
        end
        
        function bool = isroot(G,i)
              notYetImplemented();
        end
        
        function bool = isleaf(G,i)
           notYetImplemented(); 
        end
        
        function UG = moralize(G)
            notYetImplemented(); 
        end
        
        function varargout = dfs(G,varargin)
            notYetImplemented('DirectedGraph.dfs()');
        end
         
        function ac = isAcyclic(G)
           notYetImplemented('DirectedGraph.isAcyclic'); 
        end
        
        function rg = reachabilityGraph(G)
            notYetImplemented('DirectedGraph.reachabilityGraph()');
        end
        
        
    end
    
     methods(Static = true)
        function all = makeAll(varargin)
           notYetImplemented('DirectedGraph.makeAll()'); 
        end
    end
    
end

