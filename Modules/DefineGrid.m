function handles = DefineGrid(handles)

% Help for the Define Grid module:
% Category: Other
%
% This module defines a grid that can be used by modules downstream.  If
% you would like the grid to be identified automatically, then you need to
% identify objects in a module before this one.  If you are using manual, you still need some
% type of picture to get height and width of the image.  Note that
% automatic mode will create a skewed grid if there is an object on the far
% left or far right that is not supposed to be there. 
%
% See also IdentifyObjectsInGrid, DisplayGridInfo.

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

%textVAR01 = What would you like to call the grid that you define in this module?
%defaultVAR01 = GridBlue
%infotypeVAR01 = gridgroup indep
GridName = char(handles.Settings.VariableValues{CurrentModuleNum,1});

%textVAR02 = How many rows and columns are in the grid (not counting control spots outside the grid itself)?
%defaultVAR02 = 8,12
RowsCols = char(handles.Settings.VariableValues{CurrentModuleNum,2});
try
    RowsCols = str2num(RowsCols);
    Rows = RowsCols(1);
    Columns = RowsCols(2);
catch
    error('There is an invalid input for the number of rows and columns.  You need two integers seperated by a comma, such as "5,5".');
end

%textVAR03 = For numbering purposes, is the first spot at the left or right?
%choiceVAR03 = Left
%choiceVAR03 = Right
LeftOrRight = char(handles.Settings.VariableValues{CurrentModuleNum,3});
%inputtypeVAR03 = popupmenu

%textVAR04 = For numbering purposes, is the first spot on the top or bottom?
%choiceVAR04 = Top
%choiceVAR04 = Bottom
TopOrBottom = char(handles.Settings.VariableValues{CurrentModuleNum,4});
%inputtypeVAR04 = popupmenu

%textVAR05 = Would you like to count across first (by rows) or up/down first (by columns)?
%choiceVAR05 = Rows
%choiceVAR05 = Columns
RowsOrColumns = char(handles.Settings.VariableValues{CurrentModuleNum,5});
%inputtypeVAR05 = popupmenu

%textVAR06 = Would you like to define a new grid for each image cycle, or define a grid once and use it for all images?
%choiceVAR06 = Each cycle
%choiceVAR06 = Once
EachOrOnce = char(handles.Settings.VariableValues{CurrentModuleNum,6});
%inputtypeVAR06 = popupmenu

%textVAR07 = Would you like to define the grid automatically, based on objects you have identified in a previous module?
%choiceVAR07 = Automatic
%choiceVAR07 = Manual
AutoOrManual = char(handles.Settings.VariableValues{CurrentModuleNum,7});
%inputtypeVAR07 = popupmenu

%textVAR08 = For AUTOMATIC, what are the previously identified objects you want to use to define the grid?
%infotypeVAR08 = objectgroup
ObjectName = char(handles.Settings.VariableValues{CurrentModuleNum,8});
%inputtypeVAR08 = popupmenu

%textVAR09 = For MANUAL, how would you like to specify where the control spot is?
%choiceVAR09 = Coordinates
%choiceVAR09 = Mouse
ControlSpotMode = char(handles.Settings.VariableValues{CurrentModuleNum,9});
%inputtypeVAR09 = popupmenu

%textVAR10 = For MANUAL, what is the original image on which to mark/display the grid?
%infotypeVAR10 = imagegroup
ImageName = char(handles.Settings.VariableValues{CurrentModuleNum,10});
%inputtypeVAR10 = popupmenu

%textVAR11 = For MANUAL + MOUSE, what is the distance from the control spot to the bottom left spot in the grid? (X,Y: specify units or pixels below)
%defaultVAR11 = 0,0
HorizVertOffset = char(handles.Settings.VariableValues{CurrentModuleNum,11});
try
    HorizVertOffset = str2num(HorizVertOffset);%#ok We want to ignore MLint error checking for this line.
    XOffsetFromControlToTopLeft = HorizVertOffset(1);
    YOffsetFromControlToTopLeft = HorizVertOffset(2);
catch
    error('There was an invalid value for the distance from the control spot to the top left spot.  The value needs to be two integers seperated by a comma.');
end

%textVAR12 = For MANUAL + MOUSE, did you specify the distance to the control spot (above) in units or pixels?
%choiceVAR12 = Spots
%choiceVAR12 = Pixels
DistanceUnits = char(handles.Settings.VariableValues{CurrentModuleNum,12});
%inputtypeVAR12 = popupmenu

%textVAR13 = For MANUAL + ONCE or MANUAL + MOUSE, what is the spacing between columns (=horizontal = X) and rows (=vertical = Y)?
%defaultVAR13 = 57,57
HorizVertSpacing = char(handles.Settings.VariableValues{CurrentModuleNum,13});
try
    HorizVertSpacingNumerical = str2num(HorizVertSpacing);%#ok We want to ignore MLint error checking for this line.
    XSpacing = HorizVertSpacingNumerical(1);
    YSpacing = HorizVertSpacingNumerical(2);
catch error('Image processing was canceled because your entry for the spacing between columns, rows (horizontal spacing, vertical spacing) was not understood.')
end

%textVAR14 = For MANUAL + ONCE + COORDINATES, where is the center of the control spot (X,Y pixel location)?
%defaultVAR14 = 57,57
ControlSpot = char(handles.Settings.VariableValues{CurrentModuleNum,14});
try
    ControlSpot = str2num(ControlSpot);%#ok We want to ignore MLint error checking for this line.
    XControlSpot = ControlSpot(1);
    YControlSpot = ControlSpot(2);
catch
    error('There was an invalid value for the location of the control spot.  The value needs to be two integers seperated by a comma.');
end

%%%VariableRevisionNumber = 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PRELIMINARY CALCULATIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawnow

%%% The image to display is retrieved from the handles.
if strcmp(AutoOrManual,'Automatic')
%%% For automatic mode, the previously identified objects are
%%% retrieved from the handles structure.
    try
        ImageToDisplay = handles.Pipeline.(['Segmented' ObjectName]);
    catch error(['Image processing was canceled during the Define Grid module because you specified automatic mode using the objects you called ', ObjectName, ' and these objects were not found by CellProfiler. Perhaps there is a typo.'])
    end
elseif strcmp(AutoOrManual,'Manual')
    ImageToDisplay = handles.Pipeline.(ImageName);
else error('This shoulde never happen. Check the code in Define Grid module.')
end

%%% If we are in 'Once' mode and this is not the first image cycle,
%%% then we only need to retrieve values from the handles structure
%%% rather than calculating/asking the user for the values.
if strncmp(EachOrOnce,'Once',4) == 1 && handles.Current.SetBeingAnalyzed ~= 1
    GridInfo = handles.Pipeline.(['Grid_' GridName]);
    XLocationOfLowestXSpot = GridInfo.XLocationOfLowestXSpot;
    YLocationOfLowestYSpot = GridInfo.YLocationOfLowestYSpot;
    XSpacing = GridInfo.XSpacing;
    YSpacing = GridInfo.YSpacing;
    Rows = GridInfo.Rows;
    Columns = GridInfo.Columns;
    VertLinesX = GridInfo.VertLinesX;
    VertLinesY = GridInfo.VertLinesY;
    HorizLinesX = GridInfo.HorizLinesX;
    HorizLinesY = GridInfo.HorizLinesY;
    SpotTable = GridInfo.SpotTable;
    TotalHeight = GridInfo.TotalHeight;
    TotalWidth = GridInfo.TotalWidth;
    GridXLocations = GridInfo.GridXLocations;
    GridYLocations = GridInfo.GridYLocations;
    YLocations = GridInfo.YLocations;
    XLocations = GridInfo.XLocations;

%%% Otherwise, everything needs to be asked to the user and/or
%%% calculated. Each of these options should ultimately produce these
%%% variables: XLocationOfLowestXSpot, YLocationOfLowestYSpot,
%%% XSpacing, YSpacing
else
    %%% In Automatic mode, the objects' locations are used to define
    %%% the outer edges of the grid and the proper spacing.
    if strcmp(AutoOrManual,'Automatic')
        tmp = regionprops(ImageToDisplay,'Centroid');
        Location = cat(1,tmp.Centroid);
        %%% Chooses the coordinates of the objects at the farthest edges
        %%% of the incoming image.
        x = sort(Location(:,1));
        y = sort(Location(:,2));
        XLocationOfLowestXSpot = floor(min(x));
        YLocationOfLowestYSpot = floor(min(y));
        XLocationOfHighestXSpot = ceil(max(x));
        YLocationOfHighestYSpot = ceil(max(y));
        %%% Calculates the horizontal and vertical spacing based on the
        %%% grid extending from the furthest objects in each direction.
        XSpacing = round((XLocationOfHighestXSpot - XLocationOfLowestXSpot)/(Columns - 1));
        YSpacing = round((YLocationOfHighestYSpot - YLocationOfLowestYSpot)/(Rows - 1));
    elseif strcmp(AutoOrManual,'Manual')
        if strcmp(ControlSpotMode,'Coordinates')
            if strncmp(EachOrOnce,'Once',4) == 1
                %%% In 'Manual' + 'Coordinates' mode + 'Once' mode,
                %%% the values from the main GUI are used for
                %%% XControlSpot and YControlSpot and XSpacing and
                %%% YSpacing, so they aren't retrieved here.
            elseif strncmp(EachOrOnce,'Each',4) == 1
                answers = inputdlg({'Enter the X,Y location of the center of the bottom, left spot in the grid.''Enter the vertical and horizontal spacing, separated by a comma.'});
                ControlSpot = str2num(answers{1});
                try
                    XLocationOfLowestXSpot = ControlSpot(1);
                    YLocationOfLowestYSpot = ControlSpot(2);
                catch
                    error('The values entered for the the X,Y location of the center of the bottom, left spot in the grid do not make sense.  Note that you need two values separated by a comma.');
                end
                Spacing = str2num(answers{2});
                try
                    YSpacing = Spacing(1);
                    XSpacing = Spacing(2);
                catch
                    error('The values entered for the spacing do not make sense.  Note that you need two values separated by a comma.');
                end
            end
        elseif strcmp(ControlSpotMode,'Mouse')
            %%% Opens the figure and displays the image so user can
            %%% click on it to mark the control spot.
            fieldname = ['FigureNumberForModule',CurrentModule];
            ThisModuleFigureNumber = handles.Current.(fieldname);
            CPfigure(handles,ThisModuleFigureNumber);
            imagesc(ImageToDisplay);
            %%% Sets the top, left of the grid based on mouse clicks.
            title({'Click on the center of the top left control spot, then press Enter.','If you make an error, the Delete or Backspace key will delete the previously selected point.','If multiple points are clicked, the last point clicked will be used. BE PATIENT!'})
            drawnow
            %pixval
            [x,y] = getpts(ThisModuleFigureNumber);
            if length(x) < 1
                error('Image processing was canceled during the Define Grid module because you must click on one point then press enter.')
            end
            title('')
            XControlSpot = x(end);
            YControlSpot = y(end);
            %%% Converts units to pixels if they were given in spot
            %%% units.
            if strcmp(DistanceUnits,'Spots') == 1
                XOffsetFromControlToTopLeft = XOffsetFromControlToTopLeft * XSpacing;
                YOffsetFromControlToTopLeft = YOffsetFromControlToTopLeft * YSpacing;
            end
            XLocationOfLowestXSpot = XControlSpot + XOffsetFromControlToTopLeft;
            YLocationOfLowestYSpot = YControlSpot + YOffsetFromControlToTopLeft;
        end
    end

    %%% Calculates and arranges the integer numbers for labeling.
    LinearNumbers = 1:Rows*Columns;
    if strcmp(RowsOrColumns,'Columns')
        SpotTable = reshape(LinearNumbers,Rows,Columns);
    elseif strcmp(RowsOrColumns,'Rows')
        SpotTable = reshape(LinearNumbers,Columns,Rows);
        SpotTable = SpotTable';
    end
    if strcmp(LeftOrRight,'Right')
        SpotTable = fliplr(SpotTable);
    end
    if strcmp(TopOrBottom,'Bottom')
        SpotTable = flipud(SpotTable);
    end

    %%% Calculates the locations for all the sample labelings (whether it is
    %%% numbers, spot identifying information, or coordinates).
    GridXLocations = SpotTable;
    for g = 1:size(GridXLocations,2)
        GridXLocations(:,g) = XLocationOfLowestXSpot + (g-1)*XSpacing - floor(XSpacing/2);
    end
    %%% Converts to a single column.
    XLocations = reshape(GridXLocations, 1, []);
    %%% Same routine for Y.
    GridYLocations = SpotTable;
    for h = 1:size(GridYLocations,1)
        GridYLocations(h,:) = YLocationOfLowestYSpot + (h-1)*YSpacing - floor(YSpacing/2);
    end
    YLocations = reshape(GridYLocations, 1, []);

    %%% Calculates the lines.
    TotalHeight = size(ImageToDisplay,1);
    TotalWidth = size(ImageToDisplay,2);
    VertLinesX(1,:) = [GridXLocations(1,:),GridXLocations(1,end)+XSpacing];
    VertLinesX(2,:) = [GridXLocations(1,:),GridXLocations(1,end)+XSpacing];
    VertLinesY(1,:) = repmat(0,1,size(GridXLocations,2)+1);
    VertLinesY(2,:) = repmat(TotalHeight,1,size(GridXLocations,2)+1);
    HorizLinesY(1,:) = [GridYLocations(:,1)',GridYLocations(end,1)+YSpacing];
    HorizLinesY(2,:) = [GridYLocations(:,1)',GridYLocations(end,1)+YSpacing];
    HorizLinesX(1,:) = repmat(0,1,size(GridXLocations,1)+1);
    HorizLinesX(2,:) = repmat(TotalWidth,1,size(GridXLocations,1)+1);
end

%%%%%%%%%%%%%%%%%%%%%%
%%% DISPLAY RESULTS %%%
%%%%%%%%%%%%%%%%%%%%%%

fieldname = ['FigureNumberForModule',CurrentModule];
ThisModuleFigureNumber = handles.Current.(fieldname);

if any(findobj == ThisModuleFigureNumber)    
    %%% Deletes the figure to be sure that the text and such is not
    %%% retained in memory.
    delete(ThisModuleFigureNumber)
    %%% Recreates the figure.
    CPfigure(handles,ThisModuleFigureNumber);    
    imagesc(ImageToDisplay);  
    %%% Draws the lines.
    line(VertLinesX,VertLinesY);
    line(HorizLinesX,HorizLinesY);
    set(findobj('type','line'), 'color',[.15 .15 .15])
    TextToShow = cellstr(num2str(LinearNumbers'))';
    TextHandles = text((floor(XLocations+XSpacing/3)),(YLocations+floor(YSpacing/4)),TextToShow,'color','yellow');
    drawnow

    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text''),'...
            'set(button,''String'',''Show Text'');'...
            'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
            'set(button,''String'',''Hide Text'');'...
            'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];
            
    uicontrol(ThisModuleFigureNumber,...
        'Units','normalized',...
        'Position',[.5 .02 .13 .04],...
        'String','Hide Text',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles,...
        'Callback',ButtonCallback);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SAVE DATA TO HANDLES STRUCTURE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GridInfo.XLocationOfLowestXSpot = XLocationOfLowestXSpot;
GridInfo.YLocationOfLowestYSpot = YLocationOfLowestYSpot;
GridInfo.XSpacing = XSpacing;
GridInfo.YSpacing = YSpacing;
GridInfo.Rows = Rows;
GridInfo.Columns = Columns;
GridInfo.VertLinesX = VertLinesX;
GridInfo.VertLinesY = VertLinesY;
GridInfo.HorizLinesX = HorizLinesX;
GridInfo.HorizLinesY = HorizLinesY;
GridInfo.SpotTable = SpotTable;
GridInfo.TotalHeight = TotalHeight;
GridInfo.TotalWidth = TotalWidth;
GridInfo.GridXLocations = GridXLocations;
GridInfo.GridYLocations = GridYLocations;
GridInfo.YLocations = YLocations;
GridInfo.XLocations = XLocations;

handles.Pipeline.(['Grid_' GridName]) = GridInfo;