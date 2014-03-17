function [] = saveAndDisplayData(handles,output, filename)
%Function for saving data permanantly and displaying it correctly

tic;
[data,fulldata] = calcdata(output);
toc;
save(filename,'data');

%Plot for forward velocity
plot(handles.axes1,fulldata{4,1},cumsum(fulldata{1,1}));
title(handles.axes1,'Forward position');
xlabel(handles.axes1,'Time (ms)');
ylabel(handles.axes1,'Position (mm)');

%Plot for sideway velocity
plot(handles.axes2,fulldata{4,1},cumsum(fulldata{2,1}));
title(handles.axes2,'Sideway position');
xlabel(handles.axes2,'Time (ms)');
ylabel(handles.axes2,'Position (mm)');

%Plot for yaw velocity
plot(handles.axes3,fulldata{4,1},cumsum(fulldata{3,1}));
title(handles.axes3,'Angle position');
xlabel(handles.axes3,'Time (ms)');
ylabel(handles.axes3,'Position (mm)');

[x,y] = calc2DPath(fulldata);

%Plot for yaw velocity
plot(handles.axes4,x,y);
title(handles.axes4,'2D-map');
xlabel(handles.axes4,'Forward position (mm)');
ylabel(handles.axes4,'Sideway position (mm)');

min_ = min(min(y,x));
max_ = max(max(y,x));

axis([min_ max_ min_ max_]);
axis square;


%Delete temp data files
delete(getpath('tempdata.txt','data'));

end