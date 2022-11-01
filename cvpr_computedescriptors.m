%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Select Code to Run


%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'D:/Docs_Matlab/CV-assignment/MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'D:/Docs_Matlab/CV-assignment/descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
%OUT_SUBFOLDER='globalRGBhisto';
% OUT_SUBFOLDER='spatialColour';
%OUT_SUBFOLDER='spatialTexture';
OUT_SUBFOLDER='spatialColourTexture';

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    %F = ComputeRGBHistogram(img, 12);
  %F = ComputeSGColour(img, 4);
   %F = ComputeSGTexture(img, 4, 8, 0.15);
   F = ComputeSGColourTexture(img, 4, 8, 0.15);
    save(fout,'F');
    toc
end
