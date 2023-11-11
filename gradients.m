function [g1,g2,g3]=gradients(a1,a2,a3,m,x,omega,rho,side,r)
    y=omega.*(1-(x./m));
    z1=kr(a3,a2);
    z2=kr(a3,a1);
    z3=kr(a2,a1);
    g11=tens2mat(y,1)*z1;
    g21=tens2mat(y,2)*z2;
    g31=tens2mat(y,3)*z3;

    g12=zeros(size(g11));
    g22=zeros(size(g21));
    g32=zeros(size(g31));
    for i=1:(side-1)
        for rr=1:r
            g12(i,rr)=g12(i,rr)+rho(1)*(a1(i,rr)-a1(i+1,rr));
            g12(i+1,rr)=g12(i+1,rr)+rho(1)*(a1(i+1,rr)-a1(i,rr));
            g22(i,rr)=g22(i,rr)+rho(2)*(a2(i,rr)-a2(i+1,rr));
            g22(i+1,rr)=g22(i+1,rr)+rho(2)*(a2(i+1,rr)-a2(i,rr));
        end
    end
    for i=1:2
        for rr=1:r
            g32(i,rr)=g32(i,rr)+rho(3)*(a3(i,rr)-a3(i+1,rr));
            g32(i+1,rr)=g32(i+1,rr)+rho(3)*(a3(i+1,rr)-a3(i,rr));
        end
    end

    g1=g11+g12;
    g2=g21+g22;
    g3=g31+g32;
end
