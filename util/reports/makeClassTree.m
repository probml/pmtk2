function makeClassTree(location)
% Use viewClassTree to generate a class UML diagram for PMTK and save it
% to a file. 
    filename = 'classDiagram';
    if(nargin == 0)
        location = 'C:\kmurphy\pmtkLocal\doc\';
    end
    
    cd(PMTKroot());
    h = viewClassTree();
    %print('-dpng',fullfile(location,filename));
    print_pdf(fullfile(location,filename));
    close all;
end