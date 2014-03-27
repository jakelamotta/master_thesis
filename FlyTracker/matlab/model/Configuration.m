%Configuration class, singleton object that encapsulates configuration
%parameters. 
classdef Configuration < handle
    %CONFIGURATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'public',SetAccess = 'private')
        trigger;
        port;
        timer;
        runnable;
        time;
        savepath;
        pwd;
        alpha_;
        theta; %In radians
        plotting;
        radius;
    end
    
    methods (Access = 'public')
        
        %Constructor for the config object setting default values which are
        %later updated to user custom values
        function this = Configuration()
            this.port = 4444;
            this.trigger = 'no';
            this.runnable = true;
            this.time = 3000;
            this.savepath = getpath('','data');
            this.pwd = '';
            this.alpha_ = 1;
            this.theta = pi/2;
            this.plotting = 'cumsum';
        end   
        
        %%%%%%%%%%SETTERS%%%%%%%%%%%%%%%%
        function setNetworkTrigger(this,t)
            this.trigger = t;
        end
        
        function setRadius(this,r)
            if r > 0
                this.radius = r;
            else
                errordlg('Radius must be a positive real number');
            end
        end
        
        function setAngle(this,a)
            if r > 0
                this.theta = a*(pi/180); %Convert to radians for future calculations
            else
                errordlg('Angle must be a positive real number');
            end
        end
        
        function setRunnable(this,bool)
            this.runnable = bool;
        end
        
        function setPath(this,path)
            %Path must exist
            if exist(path,'dir')
                this.savepath = path;
            end
        end
        
        function setPw(this,p)
            this.pwd = p;
        end
        
        function setTime(this,t)
            %Time must be a positive integer
            if str2num(t) > 1
                this.time = t;
            else
                this.time = 3000;
            end
            
        end
        
        function setPlotting(this,p)
            
            this.plotting = p;
        end
        function setPort(this,p)
            %Validates portnumber before setting it
            if str2num(p) > 1024 && str2num(p) < 65535    
                this.port = str2num(p);
            else
                this.port = 4444;
            end
        end
        
        function setAlpha(this,a)
            this.alpha_ = a;
        end
        
        function setTheta(this,t)
            this.theta = t;
        end
    end
    
end

