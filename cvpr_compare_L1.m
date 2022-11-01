function dst=cvpr_compare_L1(F1, F2)

x=abs(F1-F2);
dst=sum(x);

return;