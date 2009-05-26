classdef SampleDist < ParamFreeDist
    
    properties
        
        ndimensions;
        samples;
        domain;  % integer labels for the columns
        
    end
    
    
    methods
        
        function model = SampleDist(varargin)
            [X, model.domain] = processArgs(varargin, ...
                '-samples', [], '-domain', []);
            if isempty(model.domain), model.domain = 1:size(X,2); end
            model.samples = X;
            model.ndimensions = numel(model.domain);
        end
        
        
        function c = cov(model)
            c = cov(model.samples);
        end
        
        
        function logPdf(model,varargin)
            %
            notYetImplemented('SampleDist.logpdf()');
        end
        
        
        function m = mean(model)
            m = mean(model.samples)';
        end
        
        
        function [h,hist_area] = plotPdf(model,varargin)
            [scaleFactor, useHisto,distNDX] = processArgs(...
                varargin, '-scaleFactor', 1, '-useHisto', false, '-distNDX',1);
            samples = model.samples(:,distNDX);
            if useHisto
                [bin_counts, bin_locations] = hist(samples, 20);
                bin_width = bin_locations(2) - bin_locations(1);
                hist_area = (bin_width)*(sum(bin_counts));
                %counts = scaleFactor * normalize(counts);
                %counts = counts / hist_area;
                h=bar(bin_locations, bin_counts);
            else
                [f,xi] = ksdensity(samples);            
                plot(xi,f);
                hist_area = [];
            end
        end
        
        
        function [l,u] = credibleInterval(model, p)
            if nargin < 2, p = 0.95; end
            q= (1-p)/2;
            [Nsamples d] = size(model.samples);
            l = zeros(d,1); u = zeros(d,1);
            for j=1:d
                tmp = sort(model.samples(:,j), 'ascend');
                u(j) = tmp(floor((1-q)*Nsamples));
                l(j) = tmp(floor(q*Nsamples));
            end
        end
        
        
        function v = cdf(model, x)
            [Nsamples Ndims] = size(model.samples);
            for j=1:Ndims
                tmp = sort(model.samples(:,j), 'ascend');
                ndx = find(x <= tmp);
                ndx = ndx(1);
                v(j) = ndx/Nsamples;%#ok
            end
        end
        
        
        function S = sample(model,n)
            NN = size(model.samples, 1);
            if n > NN, error('requesting too many samples'); end
            perm = randperm(NN);
            ndx = perm(1:n); % randi(NN,n,1);
            S = model.samples(ndx,:);
        end
        
        
        function  v = var(model)
            v = var(model.samples)';
        end
        
        
        
        function p = pmf(obj, nstates)
            % p(j) = p(X=j), j=1:nstates of the joint configuration
            % We count the number of unique joint assignments
            % We assume the samples in column j are integers {1,...,nstates(j)}
            % We can optionally specify the number of states
            [Nsamples Ndims] = size(obj.samples);
            XX = obj.samples;
            support = cell(1,Ndims);
            if nargin < 2
                for d=1:Ndims
                    support{d} = unique(XX(:,d));
                    nstates(d) = length(support{d});
                end
            else
                if length(nstates)==1, nstates=nstates*ones(1,Ndims); end
                for d=1:Ndims
                    support{d} = 1:nstates(d);
                end
            end
            if Ndims==1
                p = normalize(hist(XX, support{1}));
                return;
            end
            ndx = subv2ind(nstates, XX);
            K = prod(nstates);
            counts = hist(ndx, 1:K);
            p = reshape(counts,nstates)/Nsamples;
        end
        
        
        
        
        
        
        
        
    end
    
    
end

