function varargout = notYetImplemented(name)
% Provides a level of indirection so that we can do more clever things here 
% in the future.
   if nargin < 1, name = ''; end
   varargout = {};
   throwAsCaller(MException('PMTK:notYetImplemented',sprintf('%s not yet implemented',name)));
end