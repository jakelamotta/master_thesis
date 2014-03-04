function [path] = getpath(file,folder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

prefixpy = '/home/kristian/master_thesis/code/python/';
prefixview = '/home/kristian/master_thesis/code/matlab/view/';
prefixmodel = '/home/kristian/master_thesis/code/matlab/model/';
prefix = '/home/kristian/master_thesis/code/data';

if strcmp(folder,'py')
    path = [prefixpy,file];
elseif strcmp(folder,'view')
    path = [prefixview,file];
elseif strcmp(folder,'model')
    path = [prefixmodel,file];
elseif strcmp(folder,'code')
    path = [prefix,file];

end

