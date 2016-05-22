function [ data, label ] = removeNaN( data, label )

for i = size(data,1):-1:1
	obs = find(isnan(data(i,:,:)));
	if length(obs) > 0
        fprintf('One trial with NaN values has been removed')
        data = data([1:i-1 i+1:end],:,:);
        label = label([1:i-1 i+1:end]);
    end
end

end