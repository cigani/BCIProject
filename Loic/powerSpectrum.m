function ps1 = powerSpectrum(data, window, freq, samplefreq)

ps1 = ones([size(data,1) size(freq',1) size(data,3)]);

str = 'On electrode: ';
fprintf('%s',str)
str3 = '1';
for k=1:(size(data,3)) %loop through all electrodes  
    str2 = num2str(k);
    fprintf([repmat('\b',1,length(str3)), '%s'],str2 );
    str3 = str2;
    pause(.01)
    for m = 1:(size(data,1))       
        pdata = data(m,:,k);
        [ppxx, ~] = pwelch(pdata, 512, window,freq, samplefreq);
        ps1(m,:,k) = abs(ppxx);             
    end
end
fprintf('\n')