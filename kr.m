function X = kr(U,varargin)
if ~iscell(U), U = [{U} varargin];
else U = [U varargin];
end

[J,K] = size(U{end});
if any(cellfun('size',U,2) ~= K)
    error('kr:U','Input matrices should have the same number of columns.');
end

X = reshape(U{end},[J 1 K]);
for n = length(U)-1:-1:1
    I = size(U{n},1);
    A = reshape(U{n},[1 I K]);
    X = reshape(bsxfun(@times,A,X),[I*J 1 K]);
    J = I*J;
end
X = reshape(X,[size(X,1) K]);
