function directory = PMTKroot
% This function returns the base directory for the PMTK toolkit. This works,
% regardless of where the toolkit is installed; it only requires that this
% function not be moved and in particular, that it lives two directories below the
% PMTK root.



current = pwd;
this = fileparts(which('PMTKroot'));
cd(this);
cd ..;
cd ..;
directory = pwd;
cd(current);


    
    
    
    
    
end