function removeClassBodies(source)
    error('are you sure you know what you are doing!');
    fprintf('Source = %s\nPress enter to continue, or Ctrl-c to stop\n',source);
    pause;
    
    
    cd(source);
    
    mf = mfiles('-source',source,'-topOnly',true);
    for i=1:numel(mf)
        txt = getText(mf{i});
        if isprefix('classdef',txt{1})
            writeText([txt{1},{'end'}],mf{i});
        end
    end
    clear classes;
    evalin('base','clear(''classes'')');
    
    
end