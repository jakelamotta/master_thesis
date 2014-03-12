function [] = saveAndDisplayData(handles,output,output_time, filename)
%Function for saving data permanantly and displaying it correctly

[data,fulldata] = calcdata(output,output_time);
save(filename,'data');

%Plot for forward velocity
plot(handles.axes1,fulldata{4,1},cumsum(fulldata{1,1}));
title(handles.axes1,'Forward velocity');

%Plot for sideway velocity
plot(handles.axes2,fulldata{4,1},cumsum(fulldata{2,1}));
title(handles.axes2,'Sideway velocity');

%Plot for yaw velocity
plot(handles.axes3,fulldata{4,1},cumsum(fulldata{3,1}));
title(handles.axes3,'Rotational velocity (yaw)');


[x,y] = calc2DPath(fulldata);

%Plot for yaw velocity
plot(handles.axes4,x,y);
title(handles.axes4,'2D-map');

min_ = min(min(y,x));
max_ = max(max(y,x));

axis([min_ max_ min_ max_]);
axis square;


%Delete temp data files
delete(getpath('tempdata.txt','data'));
delete(getpath('temptime.txt','data'));

end