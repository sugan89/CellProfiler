function handles = DisplayGridInfo(handles)

% Help for the Display Grid Information module:
% Category: Other
%
% This module will display text information in a grid pattern.  It requires
% that you define a grid in an earlier module using the DefineGrid module
% and also load text data using the AddTextData module.  The data need to
% have the same number of entries as there are grid locations (grid
% squares).
%
%
% See also DefineGrid.

% CellProfiler is distributed under the GNU General Public License.
% See the accompanying file LICENSE for details.
%
% Developed by the Whitehead Institute for Biomedical Research.
% Copyright 2003,2004,2005.
%
% Authors:
%   Anne Carpenter <carpenter@wi.mit.edu>
%   Thouis Jones   <thouis@csail.mit.edu>
%   In Han Kang    <inthek@mit.edu>
%
% $Revision$

%%%%%%%%%%%%%%%%
%%% VARIABLES %%%
%%%%%%%%%%%%%%%%
drawnow

%%% Reads the current module number, because this is needed to find
%%% the variable values that the user entered.
CurrentModule = handles.Current.CurrentModuleNumber;
CurrentModuleNum = str2double(CurrentModule);

%textVAR01 = What is the already defined grid?
%infotypeVAR01 = gridgroup
GridName = char(handles.Settings.VariableValues{CurrentModuleNum,1});
%inputtypeVAR01 = popupmenu

%textVAR02 = What is the first image you would like to display?
%infotypeVAR02 = imagegroup
ImageName = char(handles.Settings.VariableValues{CurrentModuleNum,2});
%inputtypeVAR02 = popupmenu

%textVAR03 = What is the first data set that you would like to display?
%infotypeVAR03 = datagroup
DataName1 = char(handles.Settings.VariableValues{CurrentModuleNum,3});
%inputtypeVAR03 = popupmenu

%textVAR04 = What is the second data set that you would like to display?
%choiceVAR04 = /
%infotypeVAR04 = datagroup
DataName2 = char(handles.Settings.VariableValues{CurrentModuleNum,4});
%inputtypeVAR04 = popupmenu

%textVAR05 = What is the third data set that you would like to display?
%choiceVAR05 = /
%infotypeVAR05 = datagroup
DataName3 = char(handles.Settings.VariableValues{CurrentModuleNum,5});
%inputtypeVAR05 = popupmenu

%%%VariableRevisionNumber = 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PRELIMINARY CALCULATIONS & FILE HANDLING %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawnow

%%% Retrieve grid info from previously run module.
GridInfo = handles.Pipeline.(['Grid_' GridName]);
%    Rows = GridInfo.Rows;
 %   Columns = GridInfo.Columns;
    YSpacing = GridInfo.YSpacing;
    VertLinesX = GridInfo.VertLinesX;
    VertLinesY = GridInfo.VertLinesY;
    HorizLinesX = GridInfo.HorizLinesX;
    HorizLinesY = GridInfo.HorizLinesY;
    SpotTable = GridInfo.SpotTable;
 %   GridXLocations = GridInfo.GridXLocations;
  %  GridYLocations = GridInfo.GridYLocations;
    YLocations = GridInfo.YLocations;
    XLocations = GridInfo.XLocations;

% GridXLocations = VertLinesX(1,1:end-1);
% GridXLocations = repmat(GridXLocations,Rows,1);
% GridXLocations = reshape(GridXLocations,1,[]);
% 
% GridYLocations = HorizLinesY(1,1:end-1) + YSpacing/2;
% GridYLocations = repmat(GridYLocations',1,Cols);
% GridYLocations = reshape(GridYLocations,1,[]);

%%%%%%%%%%%%%%%%%%%%%%
%%% DISPLAY RESULTS %%%
%%%%%%%%%%%%%%%%%%%%%%

fieldname = ['FigureNumberForModule',CurrentModule];
ThisModuleFigureNumber = handles.Current.(fieldname);
try
    delete(ThisModuleFigureNumber)
end
%%% Opens a new window. Because the whole purpose of this module is to
%%% display info, the user probably doesn't want to overwrite the
%%% figure after each cycle.
FigHandle = CPfigure;
imagesc(handles.Pipeline.(ImageName));
title(['Image #', num2str(handles.Current.SetBeingAnalyzed),', with grid info displayed'])
    
if ~strcmp(DataName1,'/')
    Text1 = handles.Measurements.(DataName1);
    Description1 = handles.Measurements.([DataName1 'Text']);
    
    temp=reshape(SpotTable,1,[]);
    tempText = Text1;
    for i=[1:length(temp)]
        Text1{i} = tempText{temp(i)};
    end
    
    TextHandles1 = text(XLocations,YLocations-floor(YSpacing/4),Text1,'Color','red');
    
    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text1''),'...
            'set(button,''String'',''Show Text1'');'...
            'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
            'set(button,''String'',''Hide Text1'');'...
            'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];
            
    uicontrol(FigHandle,...
        'Units','normalized',...
        'Position',[.5 .02 .13 .04],...
        'String','Hide Text1',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles1,...
        'Callback',ButtonCallback);
end

if ~strcmp(DataName2,'/')
    Text2 = handles.Measurements.(DataName2);
    Description2 = handles.Measurements.([DataName2 'Text']);
    
    temp=reshape(SpotTable,1,[]);
    tempText = Text2;
    for i=[1:length(temp)]
        Text2{i} = tempText{temp(i)};
    end
    
    TextHandles2 = text(XLocations,YLocations,Text2,'Color','green');
    
    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text2''),'...
            'set(button,''String'',''Show Text2'');'...
            'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
            'set(button,''String'',''Hide Text2'');'...
            'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];
            
            
    uicontrol(FigHandle,...
        'Units','normalized',...
        'Position',[.65 .02 .13 .04],...
        'String','Hide Text2',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles2,...
        'Callback',ButtonCallback);
end

if ~strcmp(DataName3,'/')
    Text3 = handles.Measurements.(DataName3);
    Description3 = handles.Measurements.([DataName3 'Text']);
    
    temp=reshape(SpotTable,1,[]);
    tempText = Text3;
    for i=[1:length(temp)]
        Text3{i} = tempText{temp(i)};
    end
    
    TextHandles3 = text(XLocations,YLocations+YSpacing/4,Text3,'Color','blue');
    
    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text3''),'...
            'set(button,''String'',''Show Text3'');'...
            'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
            'set(button,''String'',''Hide Text3'');'...
            'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];
            
    uicontrol(FigHandle,...
        'Units','normalized',...
        'Position',[.8 .02 .13 .04],...
        'String','Hide Text3',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles3,...
        'Callback',ButtonCallback);
end
        
line(VertLinesX,VertLinesY);
line(HorizLinesX,HorizLinesY);
%%% Puts the standard Matlab tool bar back on.
set(FigHandle,'Toolbar','figure');

title(['Image set #', num2str(handles.Current.SetBeingAnalyzed), ' with grid info displayed'],'fontsize',8);  
       
set(findobj('type','line'), 'color',[.15 .15 .15])