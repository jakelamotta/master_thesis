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

% Last Modified by GUIDE v2.5 06-Mar-2014 15:35:51

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

%set(handles.popaxes1, 'String',enumeration('Plots'));

%If tempdata still exists it means that the last run wasnt finished
%properly, the data is still stored though. 
if exist(getpath('tempdata.txt','data'))
    q = questdlg('Something went wrong during the last recording and temporary data files havent been properly handled, do you want to recover the data?');

    if strcmp(q,'Yes')
        [output] = opentempdata();
        
        if ~strcmp(output,'')
            c = clock;
            filename = strcat(config.savepath,'/recovereddata_',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.mat');
            saveAndDisplayData(handles,output,filename);
        else
            msgbox('No data was recorded!','Failure');
        end
    else
        %Delete temp data files
        delete(getpath('tempdata.txt','data'));
        %delete(getpath('temptime.txt','data'));
    end
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
        if ~strcmp(config.pwd,'') && length(getappdata(0,'pass')) == 0
            setappdata(0,'pass',config.pwd);
        elseif strcmp(config.pwd,'') && length(getappdata(0,'pass')) == 0 
            PwQuery;
        end 
            if ~exist(getpath('pipe','data'),'file')
                arg = ['mkfifo ',getpath('pipe','data')];
                system(arg); %Create named pipe if not existing
            end
            
            
            set(handles.run_btn,'String','Running..');
            drawnow;
            port =  num2str(config.port);

            %Running with network trigger
            if get(handles.network_rdbtn,'value')
                arg = ['echo ',config.pwd,' | sudo -S python ',getpath('DAQ.py','py'),' "network" "port"',' ',port,' &'];
                system(arg);

            %Running with timer
            elseif get(handles.timer_rdbtn,'value')
                c = clock;
                filename = strcat(config.savepath,'/',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.mat');

                input = get(handles.timer_edt,'String');
                if isstrprop(input,'digit')

                    time = num2str(input);
                    arg = ['echo ',config.pwd,' | sudo -S python ',getpath('DAQ.py','py'),' "timer" "time"',' ',time,' &'];
                    system(arg);

                else
                    errordlg('Timer input must be an integer, please try again');
                end

                %output = opentempdata();
                readData(handles,filename);

                set(handles.run_btn,'String','Run');
                drawnow;

%                 if ~strcmp(output,'')
%                     %saveAndDisplayData(handles,output,filename);
%                     
%                 else
%                     msgbox('No data was recorded!','Failure');
%                 end

            %Running with no trigger
            elseif get(handles.no_rdbtn,'value')            
                arg = ['echo ',config.pwd,' | sudo -S python ',getpath('DAQ.py','py'),' "notrigger" &'];
                system(arg);            
            end
            
            
    else
        q = questdlg('Configuration isnt done so no experiments can be run. Would you like to configure the system now?');
        
        if strcmp(q,'Yes')
            MiceSetup;
            close 'FlyTracker 1.0';
        end
    end
        
        
% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    config = getappdata(0,'config')
    
    %Save data to file with current date and time as filename
    c = clock;
    filename = strcat(config.savepath,'/',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.mat');
    
    %Code for communicating with python process
    fid = fopen(getpath('pipe','data'),'w');
    fwrite(fid,'quit');      %Write quit command to the pipe
    fclose(fid);             %Close pipe
            
    %Clean up, deleting the pipe
    arg = ['rm -f ',getpath('pipe','data')]
    system(arg);
    
    output = opentempdata();

    set(handles.run_btn,'String','Run');
    drawnow;
    output   
    if ~strcmp(output,'')
        %saveAndDisplayData(handles,output,filename);
        readData(handles,filename);   
    else
        readData(handles,filename);
        msgbox('No data was recorded!','Failure');
    end
    


% --- Executes on key press with focus on stop_btn and none of its controls.
function stop_btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    config = getappdata(0,'config')
    
    %Save data to file with current date and time as filename
    c = clock;
    filename = strcat(config.savepath,'/',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.mat');
    
    %Code for communicating with python process
    fid = fopen(getpath('pipe','data'),'w');
    fwrite(fid,'quit');      %Write quit command to the pipe
    fclose(fid);             %Close pipe
            
    %Clean up, deleting the pipe
    arg = ['rm -f ',getpath('pipe','data')]
    system(arg);
    
    output = opentempdata();

    set(handles.run_btn,'String','Run');
    drawnow;
       
    if ~strcmp(output,'')
        %saveAndDisplayData(handles,output,filename);
        readData(handles,filename);   
            
    else
        msgbox('No data was recorded!','Failure');
    end

% --------------------------------------------------------------------
function manual_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to manual_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    arg = ['evince ',getpath('helpmanual.pdf',''),' &'];
    system(arg);

% --------------------------------------------------------------------
function about_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to about_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    About;

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
            PwQuery('a');
            close 'FlyTracker 1.0'
        end
        
    else
        clear all;
        MiceSetup;
        close 'FlyTracker 1.0';
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
    if strcmp(config.trigger,'network')
        set(handles.network_rdbtn,'value',1);
        %set(handles.network_menu_item,'Checked','On');

    elseif strcmp(config.trigger,'timer')
        set(handles.timer_rdbtn,'value',1);
        %set(handles.timer_menu_item,'Checked','On');
    else
        set(handles.no_rdbtn,'value',1);
    end

% --------------------------------------------------------------------
function mouse_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to mouse_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(config.trigger,'network')
        set(handles.network_rdbtn,'value',1);
        %set(handles.network_menu_item,'Checked','On');

    elseif strcmp(config.trigger,'timer')
        set(handles.timer_rdbtn,'value',1);
        %set(handles.timer_menu_item,'Checked','On');
    else
        set(handles.no_rdbtn,'value',1);
    end

% --------------------------------------------------------------------
function timer_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to timer_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(config.trigger,'network')
        set(handles.network_rdbtn,'value',1);
        %set(handles.network_menu_item,'Checked','On');

    elseif strcmp(config.trigger,'timer')
        set(handles.timer_rdbtn,'value',1);
        %set(handles.timer_menu_item,'Checked','On');
    else
        set(handles.no_rdbtn,'value',1);
    end    

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


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %Saves GUI settings at shutdown

    config = getappdata(0,'config');
    
    if config.runnable
        config.setTime(get(handles.timer_edt,'String'));
        
        if get(handles.network_rdbtn, 'value') == 1
            config.setNetworkTrigger('network');
        elseif get(handles.timer_rdbtn, 'value') == 1
            config.setNetworkTrigger('timer');
        else
            config.setNetworkTrigger('no');
        end   

        save(getpath('config.mat','data'), 'config');
    end

% --------------------------------------------------------------------
function addr_item_Callback(hObject, eventdata, handles)
% hObject    handle to addr_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    host;
    
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popaxes1.
function popaxes1_Callback(hObject, eventdata, handles)
% hObject    handle to popaxes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popaxes1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popaxes1


% --- Executes during object creation, after setting all properties.
function popaxes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popaxes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
