function [MAC, Fig3D, Fig2D] = CMAC(phi1, phi2, Colmap, phi1Name, phi2Name, FontSizeVal, NumFig, ShowText)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CMAC function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION DESCRIPTION:
% This function computes the Modal Assurance Criterion (MAC) between
% two sets of mode shapes.
%
% INPUTS:
% phi1 = Mode shape matrix of the first set of modes
% phi2 = Mode shape matrix of the second set of modes
% Colmap = Colormap applied to the 3D graph. Valid options: 'jet', 'turbo',
%          'parula', 'hsv', 'hot', 'cool', 'spring', ...
% phi1Name = Label for phi1 mode axis
% phi2Name = Label for phi2 mode axis
% FontSizeVal = Font size used in figures
% NumFig = Number of figures: 1 = 3D only, 2 = 3D + 2D
% ShowText = 'yes' or 'no', whether to display MAC values on the plots
%
% OUTPUTS:
% MAC = Modal Assurance Criterion matrix
% Fig3D = Handle to 3D MAC figure
% Fig2D = Handle to 2D MAC figure (empty if NumFig = 1)
%
% EXAMPLE:
% phi1 = rand(10,5);
% phi2 = rand(10,5);
% Colmap = 'parula';
% phi1Name = 'Experimental modes';
% phi2Name = 'Numerical modes';
% FontSizeVal = 12;
% NumFig = 2;
% ShowText = 'yes';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Programmed by: Diego Díaz Salamanca  (diazsdiego@uniovi.es)  %%%%%
%%%%%%  Copyright (c) 2025 Diego Díaz Salamanca. All rights reserved %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PRELIMINARY CHECKS

if ~exist('Colmap','var') || isempty(Colmap)
    Colmap = 'default';
end

if ~exist('phi1Name','var') || isempty(phi1Name)
    phi1Name = 'Modes set 1';
end

if ~exist('phi2Name','var') || isempty(phi2Name)
    phi2Name = 'Modes set 2';
end

if ~exist('FontSizeVal','var') || isempty(FontSizeVal)
    FontSizeVal = 12;
end

if ~exist('NumFig','var') || isempty(NumFig) || ~ismember(NumFig,[1,2])
    warning('NumFig should be 1 or 2. Using 1  by default.');
    NumFig = 1;
end

if ~exist('ShowText','var') || isempty(ShowText) || ~ismember(lower(ShowText), {'yes','no'})
    warning('ShowText should be "yes" or "no". Using "no" by default.');
    ShowText = 'no';
end

%% MAIN COMPUTATIONS

% Computation of the MAC matrix
[MAC] = ModalAssuranceCriterion(phi1, phi2);

% 3D representation of the MAC
Fig3D = figure3D(MAC, Colmap, FontSizeVal, phi1Name, phi2Name);

% 2D representation of the MAC
if NumFig == 2
    Fig2D = figure2D(MAC, Colmap, FontSizeVal, phi1Name, phi2Name);
else
    Fig2D = [];
end

%% LOCAL FUNCTIONS DEFINITION

% Modal assurance criterion function
function [MAC] = ModalAssuranceCriterion(modes1, modes2)

    % Evaluation of the modes matrix dimensions
    [~, Numphi1] = size(modes1);
    [~, Numphi2] = size(modes2);

    % Preallocation of the MAC matrix
    MAC = zeros(Numphi1, Numphi2);

    % MAC computation
    for i = 1:Numphi1
        for j = 1:Numphi2
            MAC(i,j) = (abs(modes1(:,i)'*modes2(:,j)))^2/((modes1(:,i)'*modes1(:,i))*(modes2(:,j)'*modes2(:,j)));
        end
    end

end

% 3D representation function
function [Figure3D] = figure3D(data, ColorMapName, FontSize, XLabelName, YLabelName)

    Figure3D = figure;
    b = bar3(data);
    colormap(ColorMapName);
    for k = 1:length(b)
        zdata = b(k).ZData;
        b(k).CData = zdata;
        b(k).FaceColor = 'interp';
    end

    if strcmpi(ShowText,'yes')
        textStrings = cellstr(num2str(data(:), '%0.2f'));
        [x, y] = meshgrid(1:size(data,2), 1:size(data,1));
        text(x(:), y(:), 1.025*data(:), textStrings, ...
            'HorizontalAlignment', 'center', 'FontSize', 10, 'Interpreter', 'latex');
    end
    box on;
    title("Modal Assurance Criterion",'interpreter','latex');
    xlabel(XLabelName,'interpreter','latex');
    ylabel(YLabelName,'interpreter','latex');
    zlabel('MAC','interpreter','latex')
    set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', FontSize);
    axis tight;
    view(3);
    cb = colorbar;         
    cb.Label.Interpreter = 'latex';              
    cb.Label.FontSize = FontSize;    
    cb.TickLabelInterpreter = 'latex';
    clim([0 1]);
end

% 2D representation function
function [Figure2D] = figure2D(data, ColorMapName, FontSize, XLabelName, YLabelName)
    Figure2D = figure;
    h = heatmap(data);   
    h.Interpreter = 'latex';
    h.FontSize = FontSize;
    colormap(ColorMapName);
    h.ColorLimits = [0 1];  
    xlabel(XLabelName);
    ylabel(YLabelName);
    title("Modal Assurance Criterion");
end

end


