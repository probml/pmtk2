function [tests,npassed,ntotal,html] = runUnitTests(varargin)
% RUNUNITTESTS Run every PMTK unit test and show a report of the results. 
%
% INPUTS:
%
% '-saveReport'        [DEFAULT = false] If true, save the report to file
% '-filename'          filename for the report if saving
% '-maxErrorLength'    [DEFAULT = 40] if an error message is longer than
%                                     this, the error id is displayed
%                                     instead.
%
% OUTPUTS:
%
% tests                a cell array of the test objects
% npassed              the number of tests that passed
% ntotal               the total number of tests run
% html                 the html text from the report. 
%%  SETUP
    [saveReport,filename,maxErrorLength] = processArgs(varargin,'-saveReport',false,'-filename','unitTestReport','-maxErrorLength',40);
    dbclear if error
    dbclear if warning
%%  FIND ALL TEST CLASSES
      
    [dirinfo,mfiles] = mfilelist(fullfile(PMTKroot(),'unitTests'));
    testClasses = mfiles(isprefix(UnitTest.testPrefix,mfiles));
%%  RUN TESTS   
    testObjs = cell(numel(testClasses,1));
    for i=1:numel(testClasses)
        testObjs{i} = feval(testClasses{i}(1:end-2));
    end
%% GENERATE REPORT    
    names = {};  results = {};  classIDX = [];  missingTests = {}; errors = {}; runTimes = [];
    counter = 1;
    tally = zeros(numel(testObjs),2);
    for i=1:numel(testObjs)
       obj = testObjs{i};
       names = [names; obj.targetClass];  %#ok
       classIDX = [classIDX,counter];     %#ok
       if ~isempty(obj.missingTests)
          missingTests{counter} = cellString(obj.missingTests,',');  %#ok
       end
       objresults = struct2cell(obj.results);
       nresults = numel(objresults);
       npassed = sum(cellfun(@(c)strcmpi(c,'passed'),objresults));
       tally(i,1) = npassed; tally(i,2) = nresults;
       results{counter} = sprintf('%d / %d',npassed,nresults); %#ok
       counter = counter + 1;
       errmessages = struct2cell(obj.errors);
       for j=1:numel(objresults)
          if ~isempty(errmessages{j})
             msg = errmessages{j}.message;
             if length(msg) > maxErrorLength, msg = errmessages{j}.identifier;end
             errors{counter+j-1} = msg;; %#ok
          end
       end
       results(counter:counter+nresults-1,1) = colvec(objresults);
       runTimes(counter:counter+nresults-1,1) = colvec(obj.runTimes);
       testNames = fieldnames(obj.results);
       names = [names;colvec(testNames)];   %#ok
       counter = counter + numel(testNames);
    end
    missingTests = [colvec(missingTests);cell(counter-numel(missingTests)-1,1)]; 
    errors = [colvec(errors);cell(counter-numel(errors)-1,1)];
    ntotal = sum(tally(:,2));
    npassed = sum(tally(:,1));
    runTimesCell = repmat({''},size(runTimes));
    for i=1:numel(runTimes)
       if runTimes(i) > 0
          runTimesCell{i} = sprintf('%1.3f',runTimes(i)); 
       end
    end
  
    %% COLOR INFO
    rowColors = repmat({'white'},numel(names),1);
    rowColors(classIDX) = {'yellow'};
    dataColors = repmat({'white'},numel(results),4);
    dataColors(cellfun(@(c)strcmpi(c,'passed'),results),1)    = {'lightgreen' };
    dataColors(cellfun(@(c)strcmpi(c,'failed'),results),1)    = {'red'   };
    
    dataColors(cellfun(@(c)~isempty(c),missingTests),3)  = {'red'   };
    dataColors(runTimes > 10, 4) = {'orange'};
    
    if ntotal == npassed, titleBarColor = 'lightgreen';
    else                  titleBarColor = 'red';
    end
    %%
    title = {sprintf('PMTK Test Results: (%d / %d)',npassed,ntotal);datestr(now)};
    %% Check for missing test classes
    missing = missingTestClasses(PMTKroot());
    if ~isempty(missing)
       caption = sprintf('Missing Test Classes:<br>%s',cellString(missing,' , ')); 
    else
       caption = ''; 
    end
    %% DISPLAY REPORT
    html = htmlTable('-data',[results,errors,missingTests,runTimesCell],'-rowNames',names,'-colNames',{'Results','Error Message','Missing Tests','Run Time (s)'},'-rowNameColors',rowColors,'-dataColors',dataColors,'-title',title,'-titleBarColor',titleBarColor,'-dosave',saveReport,'-filename',filename,'-caption',caption);
    if nargout ~=0
       tests = testObjs';
    end
end