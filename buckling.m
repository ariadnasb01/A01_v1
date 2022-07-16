function buckling(sig, mat, Tmat, n_el, x, Tn)

for e = 1:n_el
    x1 = x(Tn(e,1),1);
    y1 = x(Tn(e,1),2);
    x2 = x(Tn(e,2),1);
    y2 = x(Tn(e,2),2);
    l = sqrt((x2-x1)^2+(y2-y1)^2);
    sig_cr(e,1) = (pi^2*mat(Tmat(e),1)*mat(Tmat(e),4))/(l^2*mat(Tmat(e),2));

    if -sig_cr(e,1) > sig(e,1)
        disp(['The bar ' num2str(e(:).') ' presents buckling.']);
    end
end

end