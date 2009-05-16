load smallExample 
nodeColors = {'g','b','r','c'}; % if too few specified, it will cycle through
Graphlayout('-adjMat',adj,'-nodeLabels',names,'-layout',Treelayout,'-nodeColors',nodeColors);
