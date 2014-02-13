function varargout = OnStartup(varargin)
% ONSTARTUP MATLAB code for OnStartup.fig
%      ONSTARTUP, by itself, creates a new ONSTARTUP or raises the existing
%      singleton*.
%
%      H = ONSTARTUP returns the handle to a new ONSTARTUP or the handle to
%      the existing singleton*.
%
%      ONSTARTUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONSTARTUP.M with the given input arguments.
%
%      ONSTARTUP('Property','Value',...) creates a new ONSTARTUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OnStartup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OnStartup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OnStartup

% Last Modified by GUIDE v2.5 11-Feb-2014 15:51:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OnStartup_OpeningFcn, ...
                   'gui_OutputFcn',  @OnStartup_OutputFcn, ...
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


% --- Executes just before OnStartup is made visible.
function OnStartup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OnStartup (see VARARGIN)

% Choose default command line output for OnStartup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OnStartup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OnStartup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clear all;
    Trigger;
    close OnStartup;
    

% --- Executes on button press in notnow_btn.
function notnow_btn_Callback(hObject, eventdata, handles)
% hObject    handle to notnow_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    NotNowQuery;
    close OnStartup;

% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clear all;
    configFileFound = true;
    
    %Try loading the config-file, if not successfull an error message is
    %displayed
    try
        load('config.mat');
    catch IOException
        errordlg('Couldnt load the configuration file, it migth be missing or broken. Try running the configuration process again.');
        configFileFound = false;
    end
    
    %If a config file was found 
    if configFileFound
        MainWindow;
        close OnStartup;
    end
 
    