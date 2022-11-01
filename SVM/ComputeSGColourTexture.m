function H=ComputeSGColourTexture(img, grid, bins, threshold)

img_rows = 140;
img_cols = 140;
descriptor = [];
%% divide image into sectors as defined grid parameters
for i = 1:grid
    for j = 1:grid
        
        %rows
        row_start = round( (i-1)*img_rows/grid + 1);
        row_end = round( i*img_rows/grid );
        
        %columns
        col_start = round( (j-1)*img_cols/grid + 1);
        col_end = round( j*img_cols/grid );
        
        img_cell = img(row_start:row_end, col_start:col_end, :);
        
        %GreyScale
        grey_img_cell = img_cell(:,:,1) * 0.3 + img_cell(:,:,2) * 0.59 + img_cell(:,:,3) * 0.11;
        
        %average RGB
        avg_vals = cvpr_computeAvgRGB(img_cell);
        
        %Edges
        blur = [1 1 1 ; 1 1 1 ; 1 1 1] ./ 9;
        blurredimg = conv2(grey_img_cell, blur, 'same');

        Kx = [1 2 1 ; 0 0 0 ; -1 -2 -1] ./ 4;
        Ky = Kx';
        dx = conv2(blurredimg, Kx, 'same');
        dy = conv2(blurredimg, Ky, 'same');

        mag_img = sqrt(dx.^2 + dy.^2);
        angle_img = atan2(dy,dx);
        % normalise between 0 and 2pi
        angle_img = angle_img - min(reshape(angle_img, 1, []));
        edge_hist = ComputeEdgeAngleHistogram(mag_img, angle_img, bins, threshold);
        
        %concatenate average values into vector
        descriptor = [descriptor edge_hist avg_vals(1) avg_vals(2) avg_vals(3)];
        
    end
end

H=descriptor;
return;