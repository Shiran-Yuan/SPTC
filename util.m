function m=util(image,omega,r,side,alpha,ori,epsilon,rho,maxiter,verbosity)
    pd=makedist('Uniform',0,1);
    a1=random(pd,[side r]);
    a2=random(pd,[side r]);
    a3=random(pd,[3 r]);
    for placeholder=1:maxiter
        m1=a1*(kr(a3,a2)).'+epsilon;
        m=mat2tens(m1,[side side 3],[1],[2 3]); %#ok<NBRAK>
        [g1,g2,g3]=gradients(a1,a2,a3,m,image,omega,rho,side,r);
        a1=max(a1-alpha*g1,0);
        a2=max(a2-alpha*g2,0);
        a3=max(a3-alpha*g3,0);

        if verbosity==1
            disp(psnr(uint8(image.*omega+m.*(1-omega)),ori));
        elseif verbosity==2
            imshow(uint8(image.*omega+m.*(1-omega)));
        end
    end
end
