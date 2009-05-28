classdef DataSequence < DataStore
    
    
    properties
        X;
    end
    
    methods
        
        
        function T = DataSequence(X)
            if nargin == 0; return; end
            if isa(X,'DataSequence')
                X = X.X;
            end
            if ~iscell(X)
                X = mat2cellRows(X);
            end
            T.X = X;
            
        end
        
        function n = ncases(T)
            n = numel(T.X);
        end
        
        function l = length(T,i)
            if nargin < 2, i = 1;end
            l = length(unwrap(T(i)));
        end
        
        function l = sequenceLengths(T)
           l = cellfun(@length,T.X); 
        end
        
        function d = convertToDataTable(T)
            try
            d = DataTable(cell2mat(T.X));
            catch ME
               error('all sequences must be of the same length to convert to a DataTable'); 
            end
        end
        
        
        function [X,ndx] = stackData(T)
        % used by the HMM class for instance
        
        % T.X is a cell array of sequences of different length but with the
        % same dimensionality. X is a matrix of all of these sequences stacked
        % together in an n-by-d matrix where n is the sum of the lengths of all
        % of the sequences and d is the shared dimensionality. Within each cell
        % of data, the first dimension is d and the second is the length of the
        % observation. ndx stores the indices into X corresponding to the start
        % of each new sequence. 
              
              X = cell2mat(cellfuncell(@colvec,T.X));
              ndx = cumsum([1,rowvec(cell2mat(cellfuncell(@(seq)size(seq,2),T.X)))]);
              ndx = ndx(1:end-1);
        end
        
        function X = unwrap(T)
           if ncases(T) == 1
               X = T.X{1};
           else
               X = T.X; 
           end
        end
        
        function D = subsasgn(D, S, value)
            if ~iscell(value)
                value = mat2cellRows(value);
            end
            if(numel(S) > 1)
                if(strcmp(S(1).type,'.') && strcmp(S(2).type,'()'))
                    property = S(1).subs;
                    rowNDX = S(2).subs{1};
                elseif(strcmp(S(1).type,'()')&& strcmp(S(2).type,'.'))
                    property = S(2).subs;
                    rowNDX = S(1).subs{1};
                end
                switch property
                    case 'X'
                        D.X(rowNDX) = value;d
                    otherwise
                        error([property, ' is not a property of this class']);
                end
            else
                switch S.type
                    case {'()','{}'}
                        if any(cellfun(@isempty,S.subs)), return; end
                        if numel(S.subs) == 1 && numel(value) > 1, value = {cell2mat(value)}; end
                        D.X(S.subs{:}) = value;
                    case '.' %Still support full overwrite as in d.X = rand(10,10);
                        D = builtin('subsasgn', D, S, value);
                end
            end
        end
        
        function B = subsref(A, S)
            if(numel(S) > 1)  % We have d(1:3,:).X for example or d.X(1:3,:)
                if(strcmp(S(1).type,'.') && strcmp(S(2).type,'()')) %d.X(1:3,:)
                    rowNDX = S(2).subs{1};
                elseif(strcmp(S(1).type,'()')&& strcmp(S(2).type,'.'))  %d(1:3,:).X
                    rowNDX = S(1).subs{1};
                end
                if numel(rowNDX) == 1
                    B = A.X{rowNDX};
                else
                    B = A.X(rowNDX);
                end
                return;
            end
            % numel(S)=1
            switch S.type    %d(1:3,:)   for example
                case {'()','{}'}
                    B = DataSequence(A.X(S.subs{1}));
                case '.' %Still provide access of the form d.X and d.y
                    B = builtin('subsref', A, S);
            end
        end
    end
end

