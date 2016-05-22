function [] = myFigures( data )

figure(1);
for tr = 1:size(data.spectra.VIS,1)
    for ch = 1:size(data.spectra.VIS,3)
        subplot(4,4,ch)
        plot(log(data.spectra.VIS(tr,:,ch)),'color',[0.8 0.8 1],'linewidth',0.5)
        hold on
    end
end

figure(2)
for tr = 1:size(data.spectra.FES,1)
    for ch = 1:size(data.spectra.FES,3)
        subplot(4,4,ch)
        plot(log(data.spectra.VIS(tr,:,ch)),'color',[1 0.8 0.8],'linewidth',0.5)
        hold on
    end
end

figure(3)
for ch = 1:size(data.spectra.VIS,3)
    mu_VIS(:,ch) = log(mean(data.spectra.VIS(:,:,ch),1));
    mu_FES(:,ch) = log(mean(data.spectra.FES(:,:,ch),1));
    subplot(4,4,ch)
    plot(mu_VIS(:,ch),'color','b','linewidth',2)
    hold on
    plot(mu_FES(:,ch),'color','r','linewidth',2)
end
end
