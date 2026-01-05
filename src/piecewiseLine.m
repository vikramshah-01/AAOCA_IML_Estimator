function y = piecewiseLine(x,a,b,c,k)
    % PIECEWISELINE   A line made of two pieces
    y = zeros(size(x));
    
    % This example includes a for-loop and if statement
    % purely for example purposes.
    for i = 1:length(x)
        if x(i) < k
            y(i) = a + b.*x(i);
        else
            y(i) = a + b*k + c.*(x(i)-k); 
        end
    end
end