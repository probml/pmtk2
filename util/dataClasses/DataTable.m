classdef DataTable < DataStore
% Wrapper class for names 
    properties
        X
        Xnames;
    end
    
    methods
        function D = DataTable(varargin)
           
            [D.X,Xnames] = processArgs(varargin,'-X', [],'-Xnames',{});
            if isempty(Xnames)
                Xnames = 1:size(D.X,2);
            end
            D.Xnames = Xnames;
            if isa(D.X,'DataTable')
               D.X = D.X.X; 
            end
        end
        
        function X = unwrap(D)
           X = D.X; 
        end
        
        function n = ndimensions(D)
            n = size(D.X,2);
        end
        
        function T = convertToDataSequence(D)
           T = DataSequence(mat2cellRows(D.X)); 
        end
        
        
        function [visVars,visVals] = visible(D)
           idx = (all(~isnan(D.X),1));
           visVars = rowvec(D.Xnames(idx));
           visVals = D.X(:,idx);
        end
        
        function hidVars = hidden(D)
            hidVars = rowvec(D.Xnames(any(isnan(D.X),1)));
        end
         
        function n = ncases(D)
            n = size(D.X,1);
        end
        
        function n = nfeatures(D)
           n = size(D.X,2); 
        end
        
        function e = isempty(D)
           e = ncases(D) == 0; 
        end
        
        function C = horzcat(A,B)
            C = DataTable([A.X B.X], [A.Xnames, B.Xnames]);
            %C = [A;B];
        end
        
        function C = vertcat(A,B)
            
            if ~isequal(A.Xnames, B.Xnames)
                warning('DataTable:colNames','columns have different names');
            end
            C = DataTable([A.X;B.X], A.Xnames);
        end
        
        function D = subsasgn(D, S, value)
            if(numel(S) > 1)   % We have d(1:3,2).X = rand(3,1)  or d.X(1:3,2) = rand(3,1)
                colNDX = ':';
                if(strcmp(S(1).type,'.') && strcmp(S(2).type,'()')) %d.X(1:3,2) = rand(3,1)
                    property = S(1).subs;
                    rowNDX = S(2).subs{1};
                    if(numel(S(2).subs) == 2)
                        colNDX = S(2).subs{2};
                    end
                elseif(strcmp(S(1).type,'()')&& strcmp(S(2).type,'.'))  %d(1:3,2).X = rand(3,1)
                    property = S(2).subs;
                    rowNDX = S(1).subs{1};
                    if(numel(S(1).subs) == 2)
                        colNDX = S(1).subs{2};
                    end
                end
                switch property
                    case 'X'
                        D.X(rowNDX,colNDX) = value;
                    otherwise
                        error([property, ' is not a property of this class']);
                end
            else
                switch S.type
                    case {'()','{}'}
                        if any(cellfun(@isempty,S.subs)), return; end
                        if numel(S.subs) == 1
                            D.X(S.subs{:},:) = value;
                        else
                            D.X(S.subs{:}) = value;
                        end
                    case '.' %Still support full overwrite as in d.X = rand(10,10);
                        D = builtin('subsasgn', D, S, value);
                end
            end
        end
        
        function B = subsref(A, S)
            if(numel(S) > 1)  % We have d(1:3,:).X for example or d.X(1:3,:)
                colNDX = ':';
                if(strcmp(S(1).type,'.') && strcmp(S(2).type,'()')) %d.X(1:3,:)
                    rowNDX = S(2).subs{1};
                    if(numel(S(2).subs) == 2)
                        colNDX = S(2).subs{2};
                    end
                elseif(strcmp(S(1).type,'()')&& strcmp(S(2).type,'.'))  %d(1:3,:).X
                    rowNDX = S(1).subs{1};
                    if(numel(S(1).subs) == 2)
                        colNDX = S(1).subs{2};
                    end
                end
                B = A.X(rowNDX,colNDX);
                return;
            end
            % numel(S)=1
            switch S.type    %d(1:3,:)   for example
                case {'()','{}'}
                    Xnames = {};
                    colNDX = ':';
                    if(numel(S.subs) == 2)
                        colNDX = S.subs{2};
                    end
                    if(~isempty(A.Xnames))
                        Xnames = A.Xnames(colNDX);
                    end
                    B = DataTable(A.X(S.subs{1},colNDX),Xnames);
                case '.' %Still provide access of the form d.X and d.y
                    B = builtin('subsref', A, S);
            end
        end
        
    end
    
    
    
end

