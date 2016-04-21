stdnmean = zeros(1,58);
for k = 1 : 16
    stdnmean(1,:) = nonmeandata(:,:,k);
    takstd = std(stdnmean);
    hold on
    figure1 = figure;
    axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on',...
        'XTick',[0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60],...
        'Position',[0.0715710344238083 0.11 0.901918976545842 0.815]);
    hold(axes1,'on');
    stem(1:58, takstd,'Marker','diamond','LineStyle','none','Color',[1 0 1], 'DisplayName', 'MaxPos')
    
    ylabel('Electrode')
    xlabel('Trial')
    legend toggle
    hold off
end

