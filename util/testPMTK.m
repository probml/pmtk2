%% Test PMTK

try


bernoulliDistTest;                       pclear(0);
chainTransformerTest;                    pclear(0);
dataTableDemo;                           pclear(0);
dirichletHistPlotDemo;                   pclear(0);
discreteDistTest;                        pclear(0);
graphClassDemo;                          pclear(0);
invWIplot2D;                             pclear(0);
knn3ClassHeatMaps;                       pclear(0);
linregBayesHousePrices;                  pclear(0);
logregFitCrabs;                          pclear(0);
logregSAT;                               pclear(0);
mixMvnEmOldFaithfulDemo;                 pclear(0);
mvn1dDemo;                               pclear(0);
mvn2dDemo;                               pclear(0);

objectCreationTest; % try instantiating every class...
pclear(0);

catch ME
clc; close all
fprintf('PMTK Tests FAILED!\npress enter to see the error...\n\n');
pause
rethrow(ME)
end

cls
fprintf('PMTK Tests Passed\n')
