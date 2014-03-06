function [path] = getpath(file,folder)
%Returns correct path for given file and type, only the relative paths are
%hardcoded

tmp = mfilename('fullpath');

prefixpy = [tmp(1:end-length(mfilename)),'python/'];
prefixview = [tmp(1:end-length(mfilename)),'matlab/view/'];
prefixmodel = [tmp(1:end-length(mfilename)),'matlab/model/'];
prefix = [tmp(1:end-length(mfilename)),'data/'];


if strcmp(folder,'py')
    path = [prefixpy,file];
elseif strcmp(folder,'view')
    path = [prefixview,file];
elseif strcmp(folder,'model')
    path = [prefixmodel,file];
elseif strcmp(folder,'data')
    path = [prefix,file];
elseif strcmp(folder,'')
    path = [tmp(1:end-length(mfilename)),file];
end

end

