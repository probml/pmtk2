function classDocumentation(varargin)
% Generate an html page showing class details
    
    doshow  = true;
    doprint = true;
    
    
    [source,saveDir,includeProtected,fileName,mainTitle] = ...
        processArgs(varargin,'-source',fullfile(PMTKroot(),'models'),'-saveDir',fullfile(PMTKroot(),'docs'),'-includeProtected',false,'-fileName','classDocs.html','-title','Classes');
    
    classes = getClasses(source,'-ignoreDirs',{'unitTests',fullfile('util','graphs','graphlayout')});
    classes = filterCell(classes,@(c)~hasTag(which(c),'%#NotYetImplemented'));
    
    
    % we stack class info vertically before passing it to htmlTable
    htmlText      = cell(0,4);
    cellColors    = cell(0,4);
    columnSpan    = zeros(0,1);
    cellAlignment = cell(0,4);
    
    
    
    for c=1:numel(classes)
        %% Gather Class Info 
        className = classes{c};
        title = className;
        if isabstract(className),   
            title = ['<i>',title,'</i>  (Abstract)']; %#ok
        end
        title = ['<b><font size=4>',title,'</b></font>']; %#ok
        classDoc = help(className);
        supers = superclasses(className);
        props = properties(className);
        meths = localMethods(className,true);
        if includeProtected
            meths = [meths;protectedMethods(className)]; %#ok
        end
        %% Local Allocation
        data = cell(8+numel(meths),4);
        colSpan = zeros(8+numel(meths),1);
        cellAlign = cell(8+numel(meths),4);
        %% Cell Alignment
        % corresponding entries in table, (relative to this class) will be
        % have their text centered
        cellAlign{1,1} = 'center';
        cellAlign{6,1} = 'center';
        cellAlign(7,:) = {'center'};
        %% Column Merging
        % corresponding entries in table, (relative to this class) will
        % have subsequent cells on the same row merged together
        colSpan(1) = 1;   % for class name
        colSpan(2:5) = 2; % for description, superclasses, properties
        colSpan(6) = 1;   % for METHODS heading
        colSpan(end) = 1; % for divider between classes
        %% Cell Colors
        dataColors = repmat({'white'},size(data,1),size(data,2));  % default cell color
        dataColors(1,1:end) = {'yellow'};                          % title color
        dataColors{2,1} = 'lightgreen';
        dataColors{3,1} = 'sandyBrown';
        dataColors{4,1} = 'orange';
        dataColors{5,1} = 'red';
        dataColors{6,1} = 'blue';
        dataColors(2:5,2:end) = {'lightblue'};                     
        dataColors(7:7+numel(meths),:) = {'lightblue'};  
        %% Cell Data
        data{1,1} = title;
        data(2:6,1) = {'<b>DESCRIPTION</b>';'<b>SUPER CLASSES</b>';'<b>PROPERTIES</b>'; '<b>CONSTRUCTOR</b>';'<b>METHODS</b>'};
        data(7,1:end) = {'<b>NAME</b>','<b>INPUTS</b>','<b>OUTPUTS</b>','<b>COMMENTS</b>'};
        data{2,2} = classDoc;
        data{3,2} = catString(supers);
        data{4,2} = catString(props);
        cinfo = methodInfo(className,className,'full');
        if ~isempty(cinfo.methodHeader)
            if ~isempty(cinfo.inputs)
                data{5,2} = [className,'(',cinfo.inputStr,')'];
            end
            data{5,3} = htmlBreak(cinfo.methodComment);
        end 
        %% Process The Methods
        for m=1:numel(meths)
            meth = meths{m};
            info = methodInfo(className,meth,'full');
            if info.isAbstract
                name =  ['<i>',meth,'</i> (Abstract)'];
            elseif info.isStatic
                name = [meth,' (Static)'];
            elseif info.isProtected
                name = [meth, ' (Protected'];
            else
                name = meth;
            end
            if info.isUnfinished
                comment = 'not yet implemented';
            else
                comment = htmlBreak(catString(info.methodComment, ' '));
            end
            data(m+7,1:4) = {name,info.inputStr,catString(info.outputs),comment};
        end
        %% Add info to the stack
        htmlText = [htmlText;data];                %#ok
        cellColors = [cellColors;dataColors];      %#ok
        columnSpan = [columnSpan;colSpan];         %#ok
        cellAlignment = [cellAlignment;cellAlign]; %#ok
    end
    
    %cellColors(cellfun(@isempty,cellColors)) = {'white'};
    
    fullHTMLtext = htmlTable('-title',mainTitle,'-data',htmlText,'-dataAlign','left','-dataColors',cellColors,'-borderColor','black','-dataFontSize',4,'-titleFontSize',4,'-colSpan',columnSpan,'-customCellAlign',cellAlignment,'-doshow',doshow,'-dosave',doprint,'-filename',fullfile(saveDir,fileName));
    
   
    
    
    
    
    
    
    
end