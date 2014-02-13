function varargout = Trigger(varargin)
% TRIGGER MATLAB code for Trigger.fig
%      TRIGGER, by itself, creates a new TRIGGER or raises the existing
%      singleton*.
%
%      H = TRIGGER returns the handle to a new TRIGGER or the handle to
%      the existing singleton*.
%
%      TRIGGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIGGER.M with the given input arguments.
%
%      TRIGGER('Property','Value',...) creates a new TRIGGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Trigger_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Trigger_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Trigger

% Last Modified by GUIDE v2.5 13-Feb-2014 12:58:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Trigger_OpeningFcn, ...
                   'gui_OutputFcn',  @Trigger_OutputFcn, ...
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


% --- Executes just before Trigger is made visible.
function Trigger_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Trigger (see VARARGIN)

% Choose default command line output for Trigger
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Trigger wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Trigger_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cancel_btn.
function cancel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    config = Configuration(-1,-1,-1);
    
    if get(handles.network_cb,'value') == 1
        config.setNetworkTrigger();
    elseif get(handles.timer_cb,'value') == 1
        config.enableTimerTrigger();
    end
    
    setappdata(0,'config',config);
    MiceSetup;
    close Trigger;

% --- Executes on button press in no_trigger_cb.
function no_trigger_cb_Callback(hObject, eventdata, handles)
% hObject    handle to no_trigger_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no_trigger_cb
    

% --- Executes on button press in sensor_cb.
function sensor_cb_Callback(hObject, eventdata, handles)
% hObject    handle to sensor_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sensor_cb


% --- Executes on button press in network_cb.
function network_cb_Callback(hObject, eventdata, handles)
% hObject    handle to network_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of network_cb
