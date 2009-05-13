function Csmall = filterCell(Cbig,fn)
% Returns in Csmall only those cells c, from Cbig, for which fn(c) is true.    
    Csmall = Cbig(cellfun(fn,Cbig));
end