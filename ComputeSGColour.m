function H = ComputeSGColour(img, grid)

img_size = size(img);
img_rows = img_size(1);
img_cols = img_size(2);
descriptor = [];
%% grids
for i = 1:grid
    for j = 1:grid
        
        %rows
        row_start = round( (i-1)*img_rows/grid + 1);
        row_end = round( i*img_rows/grid );
        
        %columns
        col_start = round( (j-1)*img_cols/grid + 1);
        col_end = round( j*img_cols/grid );
        
        img_cell = img(row_start:row_end, col_start:col_end, :);
        
        %average RGB
        avg_vals = cvpr_computeAvgRGB(img_cell);
        descriptor = [descriptor avg_vals(1) avg_vals(2) avg_vals(3)];
        
    end
end

H = descriptor;
return;