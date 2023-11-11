function M = tens2mat(T,mode_row,mode_col)
if isnumeric(T), size_tens = size(T); 
else size_tens = getsize(T); end
N = length(size_tens);
size_tens = [size_tens 1];
if nargin <= 2, mode_col = []; end
if isempty(mode_row) && isempty(mode_col)
    error('tens2mat:InvalidModes', ...
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

if isnumeric(T)
    % full tensor
    if any(mode_row(:).' ~= 1:length(mode_row)) || ...
            any(mode_col(:).' ~= length(mode_row)+(1:length(mode_col)))
        T = permute(T,[mode_row(:).' mode_col(:).']);
    end
    M = reshape(T,prod(size_tens(mode_row)),[]);

elseif isstruct(T) && isfield(T, 'sparse') && T.sparse
    if ~isfield(T, 'sub'), T = fmt(T); end
    if mode_row == N+1
        rows = 1;
        size_row = 1;
    elseif length(mode_row) == 1 && mode_row == 1 && isfield(T, 'matrix') && ...
            ~isempty(T.matrix)
        M = T.matrix;
        return;
    else 
        rows = double(T.sub{mode_row(1)});
        cumsize = cumprod([1 T.size(mode_row)]);
        for n = 2:length(mode_row)
            rows = rows + double(T.sub{mode_row(n)}-1)*cumsize(n);
        end
        size_row = cumsize(end);
    end
    if mode_col == N+1
        cols = 1;
        size_col = 1;
    else 
        cols = double(T.sub{mode_col(1)});
        cumsize = cumprod([1 T.size(mode_col)]);
        for n = 2:length(mode_col)
            cols = cols + double(T.sub{mode_col(n)}-1)*cumsize(n);
        end
        size_col = cumsize(end);
    end 
    if length(rows) > 1
        [rows, j] = sort(rows);
        rows = double(rows);
        if length(cols) > 1, cols = cols(j); end
        vals = T.val(j);
    else 
        [cols, j] = sort(cols);
        vals = T.val(j);        
    end 
    M = sparse(rows(:), cols(:), vals(:), size_row, size_col);
else
    error('tens2mat:invalidTensor', ['Only full and sparse tensors are supported. ' ...
                        'Use tens2mat(ful(T),mode_row,mode_col) for other types.']);
end
end
