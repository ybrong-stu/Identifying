function np = mutatePop(p, mutatep,numbits) 

n = numel(p);
for i = 1:numbits
    if rand <= mutatep
        s = randi([1,n]);
        if p(s) == 0
            p(s) = 1;
        elseif p(s) == 1
            p(s) = 0;
        end
    end
end
np = p;

