function [np1,np2] = crossPop(p1,p2,crossp)

if isequal(p1,p2)
    np1 = p1;
    np2 = p2;
else
     if rand <= crossp
        xp = find(p1~=p2);
        if xp(end) == numel(p1)
            xp(end) = [];
        end
        n = numel(xp);
        if n ~= 0
           s = randi([1,n]);
           np1 = [p1(1:xp(s),1);p2(xp(s)+1:end,1)];
           np2 = [p2(1:xp(s),1);p1(xp(s)+1:end,1)];
             
        else
           np1 = p1;
           np2 = p2;
        end
       
     else
         np1 = p1;
         np2 = p2;
     end
end
