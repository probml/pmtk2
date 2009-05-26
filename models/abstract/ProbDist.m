classdef ProbDist
    
    methods(Abstract = true)
        mean;
        mode;
        var;
        cov;
        entropy
        
    end
    
    
    methods
        
        function [h,p] = plotPdf(obj, varargin)
            % plot a density function in 2d
            % handle = plot(pdf, 'name1', val1, 'name2', val2, ...)
            % Arguments are
            % xrange  - [xmin xmax] for 1d or [xmin xmax ymin ymax] for 2d
            % useLog - true to plot log density, default false
            % plotArgs - args to pass to the plotting routine, default {}
            % useContour - true to plot contour, false (default) to plot surface
            % npoints - number of points in each grid dimension (default 50)
            % eg. plot(p,  'useLog', true, 'plotArgs', {'ro-', 'linewidth',2})
            [xrange, useLog, plotArgs, useContour, npoints, scaleFactor] = processArgs(...
                varargin, '-xrange', plotRange(obj), '-useLog', false, ...
                '-plotArgs' ,{}, '-useContour', true, '-npoints', 100, '-scaleFactor', 1);
            if ~iscell(plotArgs), plotArgs = {plotArgs}; end
            if obj.ndimensions == 1
                xs = linspace(xrange(1), xrange(2), npoints);
                p = logPdf(obj, DataTable(xs(:)));
                if ~useLog
                    p = exp(p);
                end
                p = p*scaleFactor;
                h = plot(colvec(xs), colvec(p), plotArgs{:});
            else
                [X1,X2] = meshgrid(linspace(xrange(1), xrange(2), npoints)',...
                    linspace(xrange(3), xrange(4), npoints)');
                [nr] = size(X1,1); nc = size(X2,1);
                X = [X1(:) X2(:)];
                p = logPdf(obj, X);
                if ~useLog
                    p = exp(p);
                end
                p = reshape(p, nr, nc);
                if useContour
                    if~(any(isnan(p)))
                        [c,h] = contour(X1, X2, p, plotArgs{:});
                    end
                else
                    h = surf(X1, X2, p, plotArgs{:});
                end
            end
        end
        
        
        
    end
    
    
    methods(Access = 'protected')
        
        function xrange = plotRange(obj, sf)
            if nargin < 2, sf = 3; end
            mu = mean(obj);
            if obj.ndimensions ==1
                s1 = sqrt(var(obj));
                x1min = mu(1)-sf*s1;   x1max = mu(1)+sf*s1;
                xrange = [x1min x1max];
            else
                C = cov(obj);
                s1 = sqrt(C(1,1));
                s2 = sqrt(C(2,2));
                x1min = mu(1)-sf*s1;   x1max = mu(1)+sf*s1;
                x2min = mu(2)-sf*s2; x2max = mu(2)+sf*s2;
                xrange = [x1min x1max x2min x2max];
            end
        end
        
        
        
    end
    
    
end

