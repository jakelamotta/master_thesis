function [] = saveAndDisplayData(handles,output,output_time, filename)
%Function for saving data permanantly and displaying it correctly

[data,fulldata] = calcdata(output,output_time);
save(filename,'data');

%Plot for forward velocity
plot(handles.axes1,fulldata{4,1},fulldata{1,1},'+');
title(handles.axes1,'Forward velocity');

%Plot for sideway velocity
plot(handles.axes2,fulldata{4,1},fulldata{2,1});
title(handles.axes2,'Sideway velocity');

%Plot for yaw velocity
plot(handles.axes3,fulldata{4,1},fulldata{3,1},'.','MarkerSize',5.10);
title(handles.axes3,'Rotational velocity (yaw)');

%Delete temp data files
delete(getpath('tempdata.txt','code'));
delete(getpath('temptime.txt','code'));

end

