function T = mat2tens(M,size_tens,mode_row,mode_col)
N = length(size_tens);
size_tens = [size_tens 1];
if nargin <= 3, mode_col = []; end
if isempty(mode_row) && isempty(mode_col)
    error('mat2tens:InvalidModes', ...
          'Either mode_row or mode_col must be non-empty.');
end
mode_row = mode_row(mode_row <= N);
mode_col = mode_col(mode_col <= N);
if isempty(mode_col),
    mode_col = 1:N;
    mode_col(mode_row) = [];
end
if isempty(mode_row),
    mode_row = 1:N;
    mode_row(mode_col) = [];
end
if isempty(mode_col), mode_col = N+1; end
if isempty(mode_row), mode_row = N+1; end
if size(M,1) ~= prod(size_tens(mode_row)) || ...
   size(M,2) ~= prod(size_tens(mode_col))
    error('mat2tens:InvalidDimensions', ...
          'Invalid matrix dimensions for the requested tensorization.');
end

mode_row = mode_row(:).';
mode_col = mode_col(:).';
if issparse(M)
    idx = find(M);
    sub = cell(1, length(size_tens));
    [sub{:}] = ind2sub(size_tens([mode_row mode_col]), idx);
    T = struct;
    T.size = size_tens;
    iperm([mode_row mode_col]) = 1:length(mode_row)+length(mode_col);
    T.sub = sub(iperm);
    T.val = M(idx);
    T.sparse = 1;
    T = fmt(T);
else 
    T = reshape(M,size_tens([mode_row mode_col]));
    if any(mode_row ~= 1:length(mode_row)) || ...
            any(mode_col ~= length(mode_row)+(1:length(mode_col)))
        iperm([mode_row mode_col]) = 1:length(mode_row)+length(mode_col);
        T = permute(T,iperm);
    end
end

end