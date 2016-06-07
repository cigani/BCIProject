function display_signal(trials, strTitle)

trial = zeros(size(trials,1)*size(trials,2),size(trials,3));
for j = 1:size(trials,3)
    for i = 1:size(trials,1)
        trial((i-1)*size(trials,2)+1:i*size(trials,2),j) = trials(i,:,j)';
    end
end

figure;
cmap = colormap(lines);
set(gca, 'Fontsize',20);

offset = linspace(0,750,16);
for i = 1:size(trial,2)
    plot(1:size(trial,1), trial(:,i)+offset(i), 'linewidth', 1, 'Color', cmap(i,:));
    hold on
end
xlabel('Time', 'fontsize', 20);
ylabel('Voltage', 'fontsize', 20);
title(strTitle);
xlim([0 size(trial,1)]);
ylim([-100 850]);

end

