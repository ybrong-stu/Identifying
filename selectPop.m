function p = selectPop(pop,fitness)

n = size(pop,2);
index = randperm(n);
p1 = pop(:,index(1));
p2 = pop(:,index(2));
if fitness(index(1)) <= fitness(index(2))
    p = p1;
else
    p = p2;
end
