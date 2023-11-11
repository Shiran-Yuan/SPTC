clear;clc;

verbosity=1;
% Verbosity 0: No output until the program is done running
% Verbosity 1 [default]: Outputs PSNR for each iteration
% Verbosity 2: Outputs PSNR and shows a temporary T* for each iteration

% Filename, Side Length, and Missing Rate
filename="house";
side=256;
mr=60;

% Tunable Parameters
epsilon=10^(-3);
rho=[10 10 0];
r=300;
maxiter=4000;

% Manually tuning this parameter is relatively necessary. 
% See Paper for recommendations.
alpha=45*10^(-5);

image=double(imread("dataset/data/"+filename+mr+".tiff"));
ori=imread("dataset/original/"+filename+".tiff");

omega=ones(side,side,3);
for i=1:side
    for j=1:side
        for k=1:3
            if image(i,j,k)==255
                omega(i,j,k)=0;
            end
        end
    end
end

m=util(image,omega,r,side,alpha,ori,epsilon,rho,maxiter,verbosity);
imwrite(uint8(image.*omega+m.*(1-omega)),"results/"+filename+mr+"result.tiff");
imshow("results/"+filename+mr+"result.tiff")
foo=uint8(image.*omega+m.*(1-omega));
