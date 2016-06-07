function [ q, r ] = myDivision( num, den )
r = mod(num,den);
q = (num-r)/den;
end

