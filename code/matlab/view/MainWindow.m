function varargout = MainWindow(varargin)
% MAINWINDOW MATLAB code for MainWindow.fig
%      MAINWINDOW, by itself, creates a new MAINWINDOW or raises the existing
%      singleton*.
%
%      H = MAINWINDOW returns the handle to a new MAINWINDOW or the handle to
%      the existing singleton*.
%
%      MAINWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWINDOW.M with the given input arguments.
%
%      MAINWINDOW('Property','Value',...) creates a new MAINWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 27-Feb-2014 11:35:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @MainWindow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MainWindow is made visible.
function MainWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainWindow (see VARARGIN)

% Choose default command line output for MainWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

config = getappdata(0,'config');

set(handles.timer_edt,'String',config.time);

if strcmp(config.trigger,'network')
    set(handles.network_rdbtn,'value',1);
    %set(handles.network_menu_item,'Checked','On');

elseif strcmp(config.trigger,'timer')
    set(handles.timer_rdbtn,'value',1);
    %set(handles.timer_menu_item,'Checked','On');
else
    set(handles.no_rdbtn,'value',1);
end


% --- Outputs from this function are returned to the command line.
function varargout = MainWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% --- Executes on button press in run_btn.
function run_btn_Callback(hObject, eventdata, handles)
% hObject    handle to run_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    config = getappdata(0,'config')
    
    if config.runnable
        
        if exist('/home/kristian/master_thesis/code/python/tempdata.txt','file')
            delete('/home/kristian/master_thesis/code/python/tempdata.txt');
        end
        if exist('/home/kristian/master_thesis/code/python/temptime.txt','file')
            delete('/home/kristian/master_thesis/code/python/temptime.txt');
        end        
        
        %Save data to file with current date and time as filename
        c = clock;
        filename = strcat(config.savepath,'/',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.mat');
        
        set(handles.run_btn,'String','Running..');
        drawnow;    
        arg = '';
        port =  num2str(config.port);
        if get(handles.network_rdbtn,'value')
            
            arg = ['echo "hoverfly" | sudo -S python /home/kristian/master_thesis/code/python/DAQ.py "network" "port"',' ',port,' host stimuli-hp'];%,getIPAddress];
            system(arg);
            
        elseif get(handles.timer_rdbtn,'value')
            input = get(handles.timer_edt,'String');
            if isstrprop(input,'digit')
                
                time = num2str(input);
                arg = ['echo "hoverfly" | sudo -S python /home/kristian/master_thesis/code/python/DAQ.py "timer" "time"',' ',time];
                system(arg)
            else
                errordlg('Timer input must be an integer, please try again');
            end
        elseif get(handles.no_rdbtn,'value')
            
            arg = ['echo "hoverfly" | sudo -S python /home/kristian/master_thesis/code/python/DAQ.py "notrigger" &'];
            system(arg);
            
            pause(.2);
            
            if ~exist('/home/kristian/master_thesis/pipe','file')
                system('mkfifo "/home/kristian/master_thesis/pipe"'); %Create named pipe if not existing
            end
            
            h = msgbox('Data aquisition has started, press ok (Enter) to stop it');
                        
            waitfor(h);
            
            %Code for communicating with python process
            fid = fopen('/home/kristian/master_thesis/pipe','w');
            fwrite(fid,'quit');      %Write correct command to the pipe
            fclose(fid);             %Close pipe
        end
        
        try
            fid = fopen('/home/kristian/master_thesis/code/python/tempdata.txt','r');
            output = fread(fid,'uint8=>char');
            
            fid = fopen('/home/kristian/master_thesis/code/python/temptime.txt','r');
            output_time = fread(fid,'uint8=>char');            
        catch e
            errordlg('Data file couldnt be found');
        end

        set(handles.run_btn,'String','Run');
        drawnow;
       
        [data,fulldata] = calcdata(output,output_time);
        
        save(filename,'data');
        
        plot(handles.axes1,fulldata{4,1},fulldata{1,1});
        plot(handles.axes2,fulldata{4,1},fulldata{2,1});
        plot(handles.axes3,fulldata{4,1},fulldata{3,1});
        
    else
        q = questdlg('Configuration isnt done so no experiments can be run. Would you like to configure the system now?');
        
        if strcmp(q,'Yes')
            MiceSetup;
            close MainWindow;
        end
    end
        
        
% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    msgbox('Not yet implemented');
    


% --- Executes on key press with focus on stop_btn and none of its controls.
function stop_btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    msgbox('Not yet implemented');

% --------------------------------------------------------------------
function manual_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to manual_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to about_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function confgiure_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to confgiure_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    if exist('config.mat','file') == 2
        button = questdlg('Are you sure you want to configure the system? Finishing it will overwrite the current one.');
        
        if strcmp(button,'Yes')
            clear all;
            MiceSetup;
            close MainWindow;
        end
        
    else
        clear all;
        MiceSetup;
        close MainWindow;
    end

% --------------------------------------------------------------------
function reset_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to reset_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %Clear all graphs from data
    cla(handles.axes1);
    cla(handles.axes2);
    cla(handles.axes3);
    cla(handles.axes4);

% --------------------------------------------------------------------
function save_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
    
    %Code that allows the user to set save path
    config = getappdata(0,'config');
    dir = uigetdir();
    
    if dir
        config.setPath(dir);
    end
    
    setappdata(0,'config',config);


% --------------------------------------------------------------------
function exit_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to exit_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    q = questdlg('Are you sure you want to exit?');
    
    if strcmp(q,'Yes')
        close all;
    end
% --------------------------------------------------------------------
function no_trigger_menu_Callback(hObject, eventdata, handles)
% hObject    handle to no_trigger_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mouse_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to mouse_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function timer_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to timer_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function timer_edt_Callback(hObject, eventdata, handles)
% hObject    handle to timer_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timer_edt as text
%        str2double(get(hObject,'String')) returns contents of timer_edt as a double


% --- Executes during object creation, after setting all properties.
function timer_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timer_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function stop_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to stop_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function run_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to run_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %Saves GUI settings at shutdown

    config = getappdata(0,'config');
    
    config.setTime(get(handles.timer_edt,'String'));
    
    
    if get(handles.network_rdbtn, 'value') == 1
        config.setNetworkTrigger('network');
    elseif get(handles.timer_rdbtn, 'value') == 1
        config.setNetworkTrigger('timer');
    else
        config.setNetworkTrigger('no');
    end   
    
    save('/home/kristian/master_thesis/code/matlab/view/config.mat', 'config');


% --------------------------------------------------------------------
function addr_item_Callback(hObject, eventdata, handles)
% hObject    handle to addr_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    host;
    
