function Plot_settings(v, colour)

for i = 1:size(v,2)
    v(i).ViolinColor = colour(i,:);

    v(i).ScatterPlot.MarkerFaceAlpha=1;
    v(i).ScatterPlot.MarkerEdgeColor=[0 0 0];
    v(i).MedianPlot.SizeData=56;
    v(i).MeanPlot.LineWidth=3;
    v(i).MeanPlot.Color='k';
    v(i).WhiskerPlot.Visible='off';
    v(i).BoxWidth=0.025;
end
set(gca, 'FontWeight', 'bold', 'LineWidth', 2);
ylim([-1.2 1.2])
xlim([0.5 12.5])
set(gca, 'Clipping', 'off')
end
% ---eof-------
