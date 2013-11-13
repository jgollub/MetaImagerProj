%%Realtime Image Reconstruction code with GUI format
%Jonah jgollub@gmail.com
%
%%

function varargout = testGUI(varargin)
% TESTGUI MATLAB code for testGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testGUI

% Last Modified by GUIDE v2.5 01-Nov-2013 13:15:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @testGUI_OutputFcn, ...
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



function testGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGUI (see VARARGIN)

% kinect
[handles.colorKinectVid, handles.depthKinectVid] = initializeKinect;

% Choose default command line output for testGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%defaults number of switches
handles.num_RFpaths=6; %six switches per bank
%handles.num_banks=2; %two banks (total of 12 switches)
%default range
handles.rmin_mc=.98;
handles.rmax_mc=1.1;

set(handles.rmin, 'String', num2str(handles.rmin_mc));
set(handles.rmax, 'String', num2str(handles.rmax_mc));

%default azimuth angle
handles.azimuth_min_mc=-21.49;
handles.azimuth_max_mc=21.35;

set(handles.azimuth_min,'String',num2str(handles.azimuth_min_mc));
set(handles.azimuth_max,'String',num2str(handles.azimuth_max_mc));

%default verticlg angle
handles.altitude_min_mc=-26.4134;
handles.altitude_max_mc=25.9671;

set(handles.altitude_min,'String',num2str(handles.altitude_min_mc));
set(handles.altitude_max,'String',num2str(handles.altitude_max_mc));

%default cosine correction constant
handles.range.specularity=0;
set(handles.cosine_Corr_Slider,'Value',handles.range.specularity);
set(handles.Cos_Val_Disp,'String',num2str(handles.range.specularity));

%set IF bandwidth
handles.range.IFbandwidth=1000;
set(handles.IFbandwidth,'String',num2str(handles.range.IFbandwidth));
%set CalFile
handles.range.calfile='SOLT_Cal_S31_S32_S21_p3Coupler_Off_6ft_13dBm_07082013';
%handles.range.calfile='Ecal_3port_3ftpanA_4ftpanB_9ftULLHorn083013';
set(handles.calfile,'String',num2str(handles.range.calfile));

%Background average factor
handles.range.BkGrnd_avg=2;
set(handles.BkGrnd_avg,'String',num2str(handles.range.BkGrnd_avg));

%initiate Pan A & B to 0 isstruct fails
handles.ActivePanels = zeros(4,3);

%default number of frequency points
handles.range.nfreqs=101;
set(handles.nfreqs,'String',num2str(handles.range.nfreqs));

%default regulation value of TwIST
handles.range.reg=1E-3;% 1E-8;
set(handles.reg,'String',num2str(handles.range.reg));

%notes
handles.range.notesTag='Save Notes Here';
set(handles.notesTag,'String',handles.range.notesTag);


%set tolerance parameter for TwIST
handles.range.tol= 1E-5;
set(handles.tol,'String',num2str(handles.range.tol));

%set basis function
 handles.range.basis='Haar';
 set(handles.basis,'String',num2str(handles.range.basis));

%set image constrution to inactive;
set(handles.ConstructImageButtonTag,'Visible','off'); 
set(handles.tol,'String',num2str(handles.range.tol));

handles.MeasMtxPathName='C:\Users\MetaImagerDuo\Documents\MetaImager Project\Measurement Matrix Data\12 Panel 1 Probe Oct 25';
fprintf('%s%s\n','Current measurement matrix folder: ', handles.MeasMtxPathName);
handles.calfilefPathName = 'C:\Users\MetaImagerDuo\Documents\MetaImager Project\RF Switch Path Calibration';
fprintf('%s%s\n','Current cal file folder: ', handles.calfilefPathName);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Executes just before testGUI is made visible.

% --- Outputs from this function are returned to the command line.
function varargout = testGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function rmin_Callback(hObject, eventdata, handles)

handles.rmin_mc=str2double(get(hObject,'String'));

if isnan(handles.rmin_mc)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rmin_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');    
end



function rmax_Callback(hObject, eventdata, handles)

handles.rmax_mc=str2double(get(hObject,'String'));
if isnan(handles.rmax_mc)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);
%msgbox(num2str(handles.rmax_mc))

% --- Executes during object creation, after setting all properties.
function rmax_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function azimuth_min_Callback(hObject, eventdata, handles)

handles.azimuth_min_mc=str2double(get(hObject,'String'));
if isnan(handles.azimuth_min_mc)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function azimuth_min_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function azimuth_max_Callback(hObject, eventdata, handles)

handles.azimuth_max_mc=str2double(get(hObject,'String'));
if isnan(handles.azimuth_max_mc)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function azimuth_max_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function altitude_min_Callback(hObject, eventdata, handles)

handles.altitude_min_mc=str2double(get(hObject,'String'));
%check to see that entered value is a number
if isnan(handles.altitude_min_mc) 
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function altitude_min_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function altitude_max_Callback(hObject, eventdata, handles)

handles.altitude_max_mc=str2double(get(hObject,'String'));
%check to see that entered value is a number
if isnan(handles.altitude_max_mc) 
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function altitude_max_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in basis.
function basis_Callback(hObject, eventdata, handles)
% hObject    handle to basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles.range.basis = cellstr(get(hObject,'String'))
%        contents{get(hObject,'Value')} returns selected item from basis


% --- Executes during object creation, after setting all properties.
function basis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nfreqs_Callback(hObject, eventdata, handles)

handles.range.nfreqs = str2double(get(hObject,'String'));
%check to see that entered value is a number
if isnan(handles.nfreqs) 
  errordlg('You must enter an integer value','Bad Input','modal')
  uicontrol(hObject)
	%return
end

set(handles.ConstructImageButtonTag,'Visible','off');
set(handles.reconstruct_Only,'Visible','off');
set(handles.Reconstruct_onlyA,'Visible','off');
set(handles.Reconstruct_onlyB,'Visible','off');
set(handles.SaveAs,'Visible','off');
set(handles.Save_add_to_file,'Visible','off');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function nfreqs_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function reg_slider_Callback(hObject, eventdata, handles)
% hObject    handle to reg_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get Value
handles.range.reg=get(hObject,'Value')
set(handles.reg,'String',num2str((10^handles.range.reg)));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function reg_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reg_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ConstructImageButtonTag. 
%%COLLECT IMAGE DATA
function ConstructImageButtonTag_Callback(hObject, eventdata, handles) 

%set(handles.reconstruct_Only,'Visible','off');
%set(handles.ConstructImageButtonTag,'Visible','off');
cla(handles.axes2)
drawnow
% %reset abort button
set(handles.AbortButtonTag,'UserData',0); 

%%%%%%%%%%%%%%%%%%%%%
tic
if get(handles.Bistatic_Config,'Value')
%     [handles.g] = acquire_Measurement_Bistatic(hObject,handles,handles.vobj_switch,handles.vobj_vna,handles.axes1,...
%     handles.F,handles.num_RFpaths,handles.num_banks, handles.buffersize, handles.background);

    [handles.g] = acquire_Measurement_Overlap_Bistatic(hObject,handles,handles.vobj_switch,handles.vobj_vna,handles.axes1,...
    handles.F,handles.num_RFpaths,handles.num_banks, handles.buffersize, handles.background);
else
    [handles.g] = acquire_Measurement(hObject,handles,handles.vobj_switch,handles.vobj_vna,handles.axes1,...
    handles.F,handles.ActivePanels,handles.num_RFpaths, handles.calData, handles.buffersize, handles.background);
end
fprintf('%s%3.2f%s\n', 'Measurement collected in ', toc, 'seconds.')

%reconstruct
fprintf('%s\n','Reconstructing image...')
[handles.obj3D objfunc]=reconstruct_image(hObject, handles, handles.g, handles.range.reg, handles.range.tol, handles.range.basis,handles.H, handles.Az, handles.El, handles.Z);
fprintf('%s\n','done.')
fprintf('%s%3.2f%s\n', 'Image reconstructed in ', toc, 'seconds.')

reconstruction_plotting(hObject,handles, handles.obj3D, objfunc);

set(handles.reconstruct_Only,'Visible','on');
set(handles.ConstructImageButtonTag,'Visible','on');

guidata(hObject, handles);

set(handles.reconstruct_Only,'Visible','on');
set(handles.Reconstruct_onlyA,'Visible','on');
set(handles.Reconstruct_onlyB,'Visible','on');
set(handles.SaveAs,'Visible','on');
set(handles.SavedFileName,'Visible','on');

set(handles.Save_add_to_file,'Visible','on');

% --- Executes on button press in BackgroundButtonTag.
function BackgroundButtonTag_Callback(hObject, eventdata, handles)

%%temp
%ActivePanelsPosition=find(handles.ActivePanels);
%load data files using default naming scheme
handles.calData=[]; %data files
    
for i=1:length(handles.ActivePanels(:))
    if handles.ActivePanels(i) == 1
        filenameFragment=[char(65+floor(i/size(handles.ActivePanels,1))), num2str(mod(i,size(handles.ActivePanels,1)))];
        fileName=dir([handles.calfilefPathName,'\',filenameFragment(1,:),'*.mat']);
        handles.calData{i} = load([handles.calfilefPathName,'\',fileName.name]); %load data structure
        fprintf('%s%s\n','Using cal files: ',[handles.calfilefPathName,'\',fileName.name]);
    end
end

%choose Calfile
% defaultCalFile=handles.range.calfile;
% handles.index_selected=get(handles.CalFile_listbox,'Value');
% handles.CalfileNames = get(handles.CalFile_listbox,'String');
% if isempty(handles.CalfileNames);
%     handles.range.calfile=defaultCalFile;
% else
%     handles.range.calfile = handles.CalfileNames{handles.index_selected};
% end

%reset abort button
set(handles.AbortButtonTag,'UserData',0); 

%% what panels do we already have background meas for? do we even need to make any measurements?

fprintf('%s','Currently have backgrounds for panels: ')
needtomeasbkg = false;
for i=1:12
    try 
        havebkg = ~isempty(handles.backgroundData{i});
    catch
        havebkg = false;
    end

    if havebkg
        [r, c]=ind2sub([4,3],i);
        Cols = 'ABC';
        fprintf('%s',[num2str(r),Cols(c),' '])
    elseif handles.ActivePanels(i) && ~havebkg
        needtomeasbkg = true;
    end
end
fprintf('\n')

if ~needtomeasbkg
    fprintf('%s\n','All needed backgrounds are measured.')
else
    fprintf('%s','Initializing VNA for background measurements...')
    %use first panel to set frequency points
    firstPanel=find(handles.ActivePanels(:),1);

    %select frequency points
    findexes = unique(round(linspace(1,length(handles.data{firstPanel}.F),handles.range.nfreqs)));
    handles.F = handles.data{firstPanel}.F;
    handles.F=handles.F(1,findexes);

    fsamples = length(handles.F);
    fstart = handles.F(1)/1E9;
    fstop = handles.F(end)/1E9;

    %%% initialize instruments
    power=13; %hard setting power after cal reset (in dB)  
    [handles.vobj_switch, handles.vobj_vna, handles.buffersize,handles.VNASweepFreqs]=...
         initialize_MetaImager_Instr(fsamples, fstart, fstop,handles.range.IFbandwidth, power,handles.range.calfile);

     %%%%single panel only test !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
     %open VNA path to horn

     fprintf(handles.vobj_switch,'ROUT:CLOS (@1271)')

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     %get list of calibration files from VNA
     handles.CalfileNames=strsplit(strtok(query(handles.vobj_vna, 'CSET:CAT? '),'"'),',');
     pause(1) %if no pause we see VNA error here
     set(handles.CalFile_listbox,'String',handles.CalfileNames);
     
     fprintf('%s\n','done.')
     
     fprintf('%s','Collecting background data...')

     if get(handles.Bistatic_Config,'Value')
    % %     [handles.background]=...
    % %          measure_MetaImager_Background_Bistatic(hObject,handles,handles.vobj_switch,handles.vobj_vna, handles.axes1, handles.range.BkGrnd_avg,...
    % %          handles.F,handles.num_RFpaths,handles.num_banks, handles.buffersize,handles.dataA); 

         [handles.background]=...
             measure_MetaImager_Background_Overlap_Bistatic(hObject,handles,handles.vobj_switch,handles.vobj_vna, handles.axes1, handles.range.BkGrnd_avg,...
             handles.F,handles.num_RFpaths,handles.num_banks, handles.buffersize,handles.dataA); 

     else
         for i=1:length(handles.ActivePanels(:))
            if handles.ActivePanels(i) == 1
                try 
                    nohavebkg = isempty(handles.backgroundData{i});
                catch
                    nohavebkg = true;
                end

                if nohavebkg
                handles.backgroundData{i} = measure_MetaImager_Background(hObject,handles,handles.vobj_switch,handles.vobj_vna, handles.axes1, handles.range.BkGrnd_avg,...
                                                handles.VNASweepFreqs, i, handles.num_RFpaths, handles.calData,handles.buffersize);
                end
            end
         end
     end
     fprintf('%s\n','done.')
end

fprintf('%s','Compiling needed background measurments...')
activepanelnum = 1;
for i=1:length(handles.ActivePanels(:))
    if handles.ActivePanels(i) == 1
        handles.background(:,:,activepanelnum) = handles.backgroundData{i};
        activepanelnum = activepanelnum+1;
    end
end
fprintf('%s\n','done.')

%Allow imaging button to be seen now 
set(handles.BuildMeasMtrx,'Visible','on')

%%%%%%%
guidata(hObject, handles);


function reg_Callback(hObject, eventdata, handles)

handles.range.reg = str2double(get(hObject,'String'));
if isnan(handles.range.reg)
  errordlg('You must enter a numeric value','Bad Input','modal')
  %uicontrol(hObject)
	%return
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function reg_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%Matrix nearfield Propagated fields 
function measuredFieldsPathTag_Callback(hObject, eventdata, handles)

%Load progated measurment matrix
handles.measuredFieldsPathTag=get(hObject,'String');

% --- Executes during object creation, after setting all properties.
function measuredFieldsPathTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in AbortButtonTag.
function AbortButtonTag_Callback(hObject, eventdata, handles)
% hObject    handle to AbortButtonTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.AbortButtonTag,'UserData',1); 

% --- Executes on button press in reconstruct_Only.
function reconstruct_Only_Callback(hObject, eventdata, handles)
set(handles.reconstruct_Only,'Visible','off');
set(handles.ConstructImageButtonTag,'Visible','off');
cla(handles.axes2)
drawnow

fprintf('%s','Repeating TwIST reconstruction...')

[handles.obj3D, objfunc]=reconstruct_image(hObject, handles, handles.g, handles.range.reg, handles.range.tol, handles.range.basis,handles.H, handles.Az, handles.El, handles.Z);

reconstruction_plotting(hObject,handles, handles.obj3D, objfunc);
fprintf('%s\n','done.')

set(handles.reconstruct_Only,'Visible','on');
set(handles.ConstructImageButtonTag,'Visible','on');
set(handles.Save_add_to_file,'Visible','on');
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to nfreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfreqs as text
%        str2double(get(hObject,'String')) returns contents of nfreqs as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadMeasuredDataA.
function LoadMeasuredData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMeasuredDataA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in LoadMeasuredMatrix.

%Load Measured(and propagated) Matrix Data


FileSpec='C:\Users\MetaImagerDuo\Documents\MetaImager Project\Measurement Matrix Data\12 Panel 1 Probe Oct 25';
[handles.MeasMtxfPath,fName,fExt]=fileparts(FileSpec);
BackDir=cd; 
cd(handles.MeasMtxfPath);
[handles.MeasMtxPathName] = uigetdir(handles.MeasMtxfPath,'Select folder with measurement files (.mat)'); %open file finder window
if (handles.MeasMtxPathName==0) %cancel is pressed
    return;
end
cd(BackDir);

guidata(hObject, handles);

% --- Executes on button press in BuildMeasMtrx.
function BuildMeasMtrx_Callback(hObject, eventdata, handles)
% hObject    handle to BuildMeasMtrx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% load meas matrix path


%% build measurement matrix
fprintf('%s','Extracting measurement matrix data...')

if get(handles.Bistatic_Config,'Value')
% % 
% %     [handles.H, F_dummy, handles.Az, handles.El, handles.Z] =...
% %     measurement_matrix_build_two_Bistatic(...
% %     handles.rmin_mc,handles.rmax_mc,...
% %     handles.range.nfreqs,...
% %     handles.azimuth_min_mc*pi/180,handles.azimuth_max_mc*pi/180,...
% %     -handles.altitude_max_mc*pi/180,-handles.altitude_min_mc*pi/180,...
% %     handles.dataA,handles.dataB); %note data name change to handles.dataA.H from handles.dataA
handles.H=[];

    [handles.H, F_dummy, handles.Az, handles.El, handles.Z] =...
    measurement_matrix_build_two_Overlap_Bistatic(...
    handles.rmin_mc,handles.rmax_mc,...
    handles.range.nfreqs,...
    handles.azimuth_min_mc*pi/180,handles.azimuth_max_mc*pi/180,...
    handles.altitude_min_mc*pi/180,handles.altitude_max_mc*pi/180,...
    handles.dataA,handles.dataB); %note data name change to handles.dataA.H from handles.dataA

 %%%Correct for Phase propagation down horn (waveguide)
 handles.H=hornPhaseCorr(handles.H,handles.F); %should there be a 2x for both measurement phase and probe
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

else 

    [handles.H, handles.F, handles.Az, handles.El, handles.Z] =...
    measurement_matrix_build_3D_4port_12chan_allPolarizations(...
    handles.rmin_mc,handles.rmax_mc,...
    handles.range.nfreqs,...
    handles.azimuth_min_mc*pi/180,handles.azimuth_max_mc*pi/180,...
    handles.altitude_min_mc*pi/180,handles.altitude_max_mc*pi/180,...
    handles.data,handles.ActivePanels,handles.num_RFpaths);

    %now modify H to include specularity weighting
    [handles.H] = specular_reflection_matrix(handles.H,handles.F,handles.Az, handles.El,handles.Z,handles.range.specularity);

end
%now modify H to include horn gain
%[handles.H] = horn_gain_matrix(handles.H,handles.F,handles.Az, handles.El,handles.Z);

fprintf('%s\n','done.')
 
set(handles.ConstructImageButtonTag,'Visible','on');
set(handles.BuildMeasMtrx,'Visible','off');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MeasuredDataFile_PanelA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeasuredDataFile_PanelA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in debug_tag.
function debug_tag_Callback(hObject, eventdata, handles)
% hObject    handle to debug_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard



function IFbandwidth_Callback(hObject, eventdata, handles)

handles.range.IFbandwidth=str2double(get(hObject,'String'));

if isfield(handles,'vobj_vna') %if the vna has been initialized already, then update the IF
    set_VNA_IFBandwidth(handles.vobj_vna,handles.range.IFbandwidth);
    fprintf('%s%3.2f%s\n','IF bandwidth set to ', handles.range.IFbandwidth/1E3, 'kHz.')
end

if isnan(handles.range.IFbandwidth)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function IFbandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IFbandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function calfile_Callback(hObject, eventdata, handles)

handles.range.calfile=get(hObject,'String');

% if isnan(handles.range.calfile)
%   errordlg('You must enter a numeric value','Bad Input','modal')
%   uicontrol(hObject)
% 	%return
% end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function calfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BkGrnd_avg_Callback(hObject, eventdata, handles)

handles.range.BkGrnd_avg=str2double(get(hObject,'String'));

if isnan(handles.range.BkGrnd_avg)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BkGrnd_avg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BkGrnd_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tol_Callback(hObject, eventdata, handles)
handles.range.tol=str2double(get(hObject,'String'));

if isnan(handles.range.tol)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
	%return
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save_add_to_file.
function Save_add_to_file_Callback(hObject, eventdata, handles)
%increase data counter
%counter 


if handles.newkinect
    handles.newkinect = false;
    handles.nk = handles.nk+1;
  %Matrix info     
            handles.scene_data(handles.nk).F = handles.F;
            handles.scene_data(handles.nk).Az = handles.Az;
            handles.scene_data(handles.nk).El = handles.El;
            handles.scene_data(handles.nk).Z = handles.Z;
            handles.scene_data(handles.nk).H = handles.H;
else
    handles.ns=length(handles.scene_data(handles.nk).obj_saved)+1;
end
 %Measured data
        
        handles.scene_data(handles.nk).obj_saved(handles.ns).measurement = handles.g;
        handles.scene_data(handles.nk).obj_saved(handles.ns).regularization = handles.range.reg;
        handles.scene_data(handles.nk).obj_saved(handles.ns).tolerance = handles.range.tol;
        handles.scene_data(handles.nk).obj_saved(handles.ns).specularity = handles.range.specularity;
        handles.scene_data(handles.nk).obj_saved(handles.ns).notes = handles.range.notesTag;
        handles.scene_data(handles.nk).obj_saved(handles.ns).IFBandWidth=handles.range.IFbandwidth;
        handles.scene_data(handles.nk).obj_saved(handles.ns).reconstructed = handles.obj3D;

%save kinect info

if isfield(handles,'rgb')
        handles.scene_data(handles.nk).Az_extent =  [handles.azimuth_min_mc handles.azimuth_max_mc];
        handles.scene_data(handles.nk).El_extent = [handles.altitude_min_mc handles.altitude_max_mc];
        handles.scene_data(handles.nk).Z_extent = [handles.rmin_mc handles.rmax_mc];
        handles.scene_data(handles.nk).objs = handles.objs;
        handles.scene_data(handles.nk).xyz = handles.xyz_mc;
        handles.scene_data(handles.nk).rgb = handles.rgb;
end
  
        
set(handles.Save_add_to_file,'Enable','off')  %disable until done saving

save(fullfile(handles.PathName,handles.FileName),'-struct','handles','scene_data');

set(handles.Save_add_to_file,'Enable','on')  %disable until done saving

set(handles.Save_add_to_file,'Visible','off');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Save_add_to_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_add_to_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in SaveAs.
function SaveAs_Callback(hObject, eventdata, handles)
handles.nk = 1;  
handles.ns=1;
handles.newkinect = false;

if isfield(handles,'scene_data')
    handles.scene_data = [];
end
 %Matrix info     
            handles.scene_data(handles.nk).F = handles.F;
            handles.scene_data(handles.nk).Az = handles.Az;
            handles.scene_data(handles.nk).El = handles.El;
            handles.scene_data(handles.nk).Z = handles.Z;
            handles.scene_data(handles.nk).H = handles.H;
            handles.scene_data(handles.nk).background = handles.background(:);
 %Measured data
 
%         if isstruct('handles.scene_data.obj_saved')
%             handles.scene_data.obj_saved(1:end) = [];
%         end
        %handles.scene_data.obj_saved(1).dummy = 'dummy';
        %handles.scene_data.obj_saved(1:end) = [];
        
        handles.scene_data(handles.nk).obj_saved(handles.ns).measurement = handles.g;
        handles.scene_data(handles.nk).obj_saved(handles.ns).regularization = handles.range.reg;
        handles.scene_data(handles.nk).obj_saved(handles.ns).tolerance = handles.range.tol;
        handles.scene_data(handles.nk).obj_saved(handles.ns).specularity = handles.range.specularity;
        handles.scene_data(handles.nk).obj_saved(handles.ns).notes = handles.range.notesTag;
        handles.scene_data(handles.nk).obj_saved(handles.ns).IFBandWidth=handles.range.IFbandwidth;
        handles.scene_data(handles.nk).obj_saved(handles.ns).reconstructed = handles.obj3D;

%save kinect info

if isfield(handles,'rgb')
        handles.scene_data(handles.nk).Az_extent =  [handles.azimuth_min_mc handles.azimuth_max_mc];
        handles.scene_data(handles.nk).El_extent = [handles.altitude_min_mc handles.altitude_max_mc];
        handles.scene_data(handles.nk).Z_extent = [handles.rmin_mc handles.rmax_mc];
        handles.scene_data(handles.nk).objs = handles.objs;
        handles.scene_data(handles.nk).xyz = handles.xyz_mc;
        handles.scene_data(handles.nk).rgb = handles.rgb;
end
        
%Load Measured(and propagated) Matrix Data
FileSpec='D:\Dropbox\MetaImager Project\MetaImager Data\MetaImager Scenes\*.mat';
[fPath,fName,fExt]=fileparts(FileSpec);
BackDir=cd;
cd(fPath);

[handles.FileName,handles.PathName] = uiputfile([fName fExt],'save mat file'); %open file finder window
if (handles.FileName==0) %cancel is pressed
    return;
end
cd(BackDir);
%change color of text while loading
set(handles.SavedFileName,'ForegroundColor', [1 0 0]);
set(handles.SavedFileName,'String', '...Saving'); %update filepath

%save data structure
save(fullfile(handles.PathName,handles.FileName),'-struct','handles','scene_data');

%reset color after loading
set(handles.SavedFileName,'ForegroundColor', [0 0 0]);
set(handles.SavedFileName,'String', handles.FileName); %update filepath

fprintf('\n...file saved to "%s". \n',handles.FileName);

%allow data to be added to the same file
set(handles.Save_add_to_file,'Visible','on');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ConstructImageButtonTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConstructImageButtonTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function MeasuredDataFile_PanelB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeasuredDataFile_PanelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Save_add_to_file.


% --- Executes on button press in Reconstruct_onlyA.
function Reconstruct_onlyA_Callback(hObject, eventdata, handles)
% hObject    handle to Reconstruct_onlyA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.obj3D, objfunc]=reconstruct_image(hObject, handles, handles.g(1:end/2,:), ...
    handles.range.reg, handles.range.tol, handles.range.basis,handles.H(1:end/2,:), ...
    handles.Az, handles.El, handles.Z);

reconstruction_plotting(hObject,handles, handles.obj3D, objfunc);
fprintf('%s\n','done.')

guidata(hObject, handles);
% --- Executes on button press in Reconstruct_onlyB.
function Reconstruct_onlyB_Callback(hObject, eventdata, handles)
% hObject    handle to Reconstruct_onlyB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.obj3D, objfunc]=reconstruct_image(hObject, handles, handles.g((end/2+1):end,:), ...
    handles.range.reg, handles.range.tol, handles.range.basis,handles.H((end/2+1):end,:), ...
    handles.Az, handles.El, handles.Z);

reconstruction_plotting(hObject,handles, handles.obj3D, objfunc);
fprintf('%s\n','done.')

guidata(hObject, handles);


% --- Executes on slider movement.
function cosine_Corr_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to cosine_Corr_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.range.specularity=get(hObject,'Value');

%set disp value (adjacent to slider) to read value
set(handles.Cos_Val_Disp,'String',num2str(handles.range.specularity))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.BuildMeasMtrx,'Visible','on');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cosine_Corr_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cosine_Corr_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function Cos_Val_Disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cos_Val_Disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function notesTag_Callback(hObject, eventdata, handles)
% hObject    handle to notesTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.range.notesTag=get(hObject,'String');
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of notesTag as text
%        str2double(get(hObject,'String')) returns contents of notesTag as a double


% --- Executes during object creation, after setting all properties.
function notesTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Get_Kin_Extent.
function Get_Kin_Extent_Callback(hObject, eventdata, handles)
[Az_extent, El_extent, Z_extent, objs, xyz, rgb] = niImage_getImage_multiobjects_RangeConstraints_fun(handles.colorKinectVid, handles.depthKinectVid);

if isfield(handles,'nk')
    handles.newkinect = true;
    handles.ns=1;
else
    handles.nk = 1;
end


%plot kinect 3Doptical scene
figure(10)
if isfield(handles,'h3Dorfaxes')
    if ishghandle(handles.h3Dorfaxes) 
        cla(handles.h3Dorfaxes);
    else
        handles.h3Dorfaxes = axes('pos', [0,0.5,1,0.5]);
        view(-27,34)
        drawnow
        set(gca,'CameraViewAngleMode','manual')
    end
else 
    handles.h3Dorfaxes = axes('pos', [0,0.5,1,0.5]);
    view(-27,34)
    drawnow
    set(gca,'CameraViewAngleMode','manual')
end

axes(handles.h3Dorfaxes)
rgb = flipdim(rgb,2);
draw_Kinect_object_scene(xyz,rgb,objs,1:size(objs,3))
%draw_Kinect_object_scene(xyz,rgb,objs,2)
%draw_extent_box(Az_extent_kc,El_extent_kc,Z_extent_kc,2:nobj,[0 1 0])

% range


box_front_offset = -0.05;
box_depth = 0.15;
handles.rmin_mc = min(Z_extent(:,1))+box_front_offset;
handles.rmax_mc = handles.rmin_mc+box_depth;

handles.azimuth_min_mc = 180/pi*min(Az_extent(:,1))-5;
handles.azimuth_max_mc = 180/pi*max(Az_extent(:,2))+5;

handles.altitude_min_mc = 180/pi*min(El_extent(:,1))-10; 
handles.altitude_max_mc = 180/pi*max(El_extent(:,2))+10; 

draw_extent_box([handles.azimuth_min_mc handles.azimuth_max_mc]*(pi/180),[handles.altitude_min_mc handles.altitude_max_mc]*(pi/180),[handles.rmin_mc handles.rmax_mc],1,[0 0 1],0)

set(handles.rmin, 'String', num2str(handles.rmin_mc));
set(handles.rmax, 'String', num2str(handles.rmax_mc));
set(handles.azimuth_min,'String',num2str(handles.azimuth_min_mc));
set(handles.azimuth_max,'String',num2str(handles.azimuth_max_mc));
set(handles.altitude_min,'String',num2str(handles.altitude_min_mc));
set(handles.altitude_max,'String',num2str(handles.altitude_max_mc));

handles.xyz_mc = xyz;
handles.rgb = rgb;
handles.objs = objs;

set(handles.Save_add_to_file,'Visible','on');
set(handles.BuildMeasMtrx,'Visible','on');
%set(gca,'CameraTarget',[(xmax_mc+xmin_mc)/2 (ymax_mc+ymin_mc)/2 (handles.range.rmax_mc+handles.range.rmin_mc)/2]);
guidata(hObject, handles);
% hObject    handle to Get_Kin_Extent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function reconstruction_plotting(hObject,handles, obj3D, objfunc)

%plot twist objective function convergence in GUI window axes 
cla(handles.axes2);
axes(handles.axes2);
title('Object Function (Convergence)')
semilogy(abs(objfunc(2:end)-objfunc(1:(end-1))))
%plot reconstructed scene in separate figure
% figure(7)
% clf
% plot_range_slices(handles.obj3D,handles.Az,handles.El,handles.Z,3,1:size(handles.obj3D,3),'y')

%plot rf scene on 3Doptical
figure(10)
if isfield(handles,'hrfsurface')
    if ishghandle(handles.hrfsurface)
        delete(handles.hrfsurface)
    end
end
axes(handles.h3Dorfaxes)
handles.hrfsurface = plot_recon_surface(handles.obj3D,handles.Az,handles.El,handles.Z,0,4);

%plot rf scene alone

figure(10)
if isfield(handles,'hrfaxes')
    if ishghandle(handles.hrfaxes) 
        cla(handles.hrfaxes);
    else
        axes('pos', [0,0,1,0.5])
        image(zeros(1,1,3));axis off
        handles.hrfaxes = axes('pos', [0,0.05,1,0.4]);
        view(-27,34)
        drawnow
        set(gca,'CameraViewAngleMode','manual')
    end
else 
    axes('pos', [0,0,1,0.5])
    image(zeros(1,1,3));axis off
    handles.hrfaxes = axes('pos', [0,0.05,1,0.4]);
    view(-27,34)
    drawnow
    set(gca,'CameraViewAngleMode','manual')
end
axes(handles.hrfaxes)
plot_recon_surface(handles.obj3D,handles.Az,handles.El,handles.Z,0,4);

%set(gcf,'Color',[0 0 0])
set(gca,'Color',[0 0 0],'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1],'DataAspectRatio',[1 1 1])
axis equal
axis tight
box on
colormap jet

guidata(hObject, handles);


% --- Executes on button press in Bistatic_Config.
function Bistatic_Config_Callback(hObject, eventdata, handles)
% hObject    handle to Bistatic_Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.BuildMeasMtrx,'Visible','on');
guidata(hObject, handles);

    


% --- Executes on button press in LoadMtxIntoMemTag.
function LoadMtxIntoMemTag_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMtxIntoMemTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LoadMtxIntoMemTag


% --- Executes on selection change in CalFile_listbox.
function CalFile_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to CalFile_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.index_selected=get(handles.CalFile_listbox,'Value');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns CalFile_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CalFile_listbox


% --- Executes during object creation, after setting all properties.
function CalFile_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CalFile_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadCalFiles.
function LoadCalFiles_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCalFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('Loading calibration files... \n');
FileSpec='C:\Users\MetaImagerDuo\Documents\MetaImager Project\Measurement Matrix Data';
[fPath,fName,fExt]=fileparts(FileSpec);
BackDir=cd;
cd(fPath);

[handles.calfilefPathName] = uigetdir(fPath,'Select folder with calibration files'); %open file finder window
if (handles.calfilefPathName==0) %cancel is pressed
    return;
end
cd(BackDir);

guidata(hObject, handles);


% --- Executes on button press in checkboxA4.
function checkboxA4_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxA4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(4,1)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxA4


% --- Executes on button press in checkboxA3.
function checkboxA3_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxA3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(3,1)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxA3


% --- Executes on button press in checkboxA2.
function checkboxA2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(2,1)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
%preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxA2


% --- Executes on button press in checkboxA1.
function checkboxA1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(1,1)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxA1


% --- Executes on button press in checkboxB4.
function checkboxB4_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxB4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(4,2)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxB4


% --- Executes on button press in checkboxB3.
function checkboxB3_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxB3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(3,2)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxB3


% --- Executes on button press in checkboxB2.
function checkboxB2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(2,2)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxB2


% --- Executes on button press in checkboxB1.
function checkboxB1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(1,2)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxB1


% --- Executes on button press in checkboxC4.
function checkboxC4_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(4,3)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxC4


% --- Executes on button press in checkboxC3.
function checkboxC3_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(3,3)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxC3


% --- Executes on button press in checkboxC2.
function checkboxC2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(2,3)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxC2


% --- Executes on button press in checkboxC1.
function checkboxC1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ActivePanels(1,3)=get(hObject,'Value');
guidata(hObject, handles);
preloadMeasMtx(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkboxC1

function preloadMeasMtx(hObject, eventdata, handles)

%%temp
%ActivePanelsPosition=find(handles.ActivePanels);
%load data files using default naming scheme
handles.data=[]; %data files
fprintf('Loading files... \n');
if 0%get(handles.LoadMtxIntoMemTag,'Value')
    
    for i=1:length(handles.ActivePanels(:))
        if handles.ActivePanels(i) == 1
            handles.data{i} = load( fullfile(handles.MeasMtxPathName,['Panel_',char(65+floor(i/size(handles.ActivePanels,1))), num2str(mod(i,size(handles.ActivePanels,1))),'.mat'] )); %load data structure
        end
    end
    
else
    for i=1:length(handles.ActivePanels(:))
        if handles.ActivePanels(i) == 1
            filenameFragment=[char(65+floor(i/size(handles.ActivePanels,1))), num2str(mod(i,size(handles.ActivePanels,1)))];
            fileName=dir([handles.MeasMtxPathName,'\',filenameFragment(1,:),'*.mat']);
            handles.data{i} = matfile([handles.MeasMtxPathName,'\',fileName.name]); %load data structure
            fprintf('%s\n',[handles.MeasMtxPathName,'\',fileName.name]);
        end
    end  
end
guidata(hObject, handles);
fprintf('Loading finished\n');


% --- Executes during object creation, after setting all properties.
function LoadMtxIntoMemTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadMtxIntoMemTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
