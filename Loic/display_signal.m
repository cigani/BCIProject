function display_signal(trial)


figure;
cmap = colormap(lines);
set(gca, 'Fontsize',20);

offset = linspace(0,750,16);

for i = 1:size(trial,3)
    plot(1:size(trial,2), trial(1,:,i)+offset(i), 'linewidth', 1, 'Color', cmap(i,:));
    hold on
end
xlabel('Time', 'fontsize', 20);
ylabel('Voltage', 'fontsize', 20);
%xlim([0 2500]);
%ylim([-100 800]);

end

