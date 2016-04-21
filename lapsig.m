fork = [];
lfork = [];
for n = 1:30
    lsig = trials_file(n,:,:);
    size(lsig);
    lsig2=permute(lsig, [2 3 1]);
    fork = laplacianSP(lsig2);
    lfork(:,:,(n)) = fork;
end