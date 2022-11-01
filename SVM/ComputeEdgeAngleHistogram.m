function H = ComputeEdgeAngleHistogram(mag_img, angle_img, bins, threshold)

[rows,columns] = size(angle_img);
vals = [];

for i = 1:rows
    for j = 1:columns
        if mag_img(i, j) > threshold
            bin_value = angle_img(i, j) / (2 * pi);
            bin_value = floor(bin_value * bins);
            vals = [vals bin_value];
            
        end
    end
end

if size(vals, 2) == 0
    H = zeros(1, bins);
else
    H= histogram(vals, bins, 'Normalization', 'probability').Values;
end
return; 