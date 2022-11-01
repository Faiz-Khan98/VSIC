function dst=cvpr_compare_L2(F1, F2)

x=F1-F2;
x=x.^2;
x=sum(x);
dst=sqrt(x);

return;
