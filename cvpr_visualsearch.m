%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'D:/Docs_Matlab/CV-assignment/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'D:/Docs_Matlab/CV-assignment/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
%DESCRIPTOR_SUBFOLDER='globalRGBhisto';
%DESCRIPTOR_SUBFOLDER='spatialColour';
 %DESCRIPTOR_SUBFOLDER='spatialTexture'
 DESCRIPTOR_SUBFOLDER='spatialColourTexture'

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
Rough_CATS = [];
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    split_string = split(fname, '_');
    Rough_CATS(filenum) = str2double(split_string(1));
    ctr=ctr+1;
end

CATS_HIST = histogram(Rough_CATS).Values;
CATS_TOTAL = length(CATS_HIST);           

AP_values = zeros([1, CATS_TOTAL]);
for iteration=1:CATS_TOTAL
    %% 2) Pick an image at random to be the query
    NIMG=size(ALLFEAT,1);           % number of images in collection
    queryimg=floor(rand()*NIMG);    % index of a random image
     %queryimg = 132;
    %% PCA
    ALLDESCS = ALLFEAT;
    [E,ALLDESCS] = cvpr_EigenModel(ALLDESCS);
    
    %% 3) Compute the distance of image to the query
    dst=[];
    for i=1:NIMG
        candidate=ALLDESCS(i,:);
        query=ALLDESCS(queryimg,:);
        thedst=Eigen_Mahalanobis(E, query, candidate);
        %thedst=cvpr_compare_L2(query,candidate);
        %thedst=cvpr_compare_L1(query,candidate);
        category=Rough_CATS(i);
        dst=[dst ; [thedst i category]];
    end
    dst=sortrows(dst,1);  % sort the results
    
    %% PR
    precision_values=zeros([1, NIMG-1]);
    recall_values=zeros([1, NIMG-1]);
    correct_at_n=zeros([1, NIMG-1]);

    query_row = dst(1,:);
    query_category = query_row(1,3);
    % Remove query image from list of distance sorted images    
    dst = dst(2:NIMG, :);
    
    %calculate PR for each n
    for i=1:size(dst, 1)     
        rows = dst(1:i, :);
        correct_results = 0;
        incorrect_results = 0;

        if i > 1    
            for n=1:i - 1
                row = rows(n, :);
                category = row(3);

                if category == query_category
                    correct_results = correct_results + 1;
                else
                    incorrect_results = incorrect_results + 1;
                end

            end
        end

        % LAST ROW
        row = rows(i, :);
        category = row(3);

        if category == query_category
            correct_results = correct_results + 1;
            correct_at_n(i) = 1;
        else
            incorrect_results = incorrect_results + 1;
        end

        precision = correct_results / i;
        recall = correct_results / (CATS_HIST(1,query_category) - 1);

        precision_values(i) = precision;
        recall_values(i) = recall;
    end

    
    %% 4) Visualise the results
    %% These may be a little hard to see using imgshow
    %% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

    SHOW=20; % Show top 20 results
    dst=dst(1:SHOW,:);
    outdisplay=[];
    for i=1:size(dst,1)
        img=imread(ALLFILES{dst(i,2)});
        img=img(1:2:end,1:2:end,:); % make image a quarter size
        img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
        outdisplay=[outdisplay img];%populate confusion matrix
        
    end
     figure(1)
     imshow(outdisplay);
     axis off;

     %% cumulative PR curve
     figure(2)
     plot(recall_values, precision_values,'LineWidth',1.5);
     hold on;
     title('PR Curve');
     xlabel('Recall');
     ylabel('Precision');
     xlim([0 1]);
     ylim([0 1]);

     %% AP
    average_precision = sum(precision_values .* correct_at_n) / CATS_HIST(1,query_category);
    AP_values(iteration) = average_precision;
end

%% Calculate MAP

MAP = mean(AP_values);
AP_sd = std(AP_values);

 figure(3)
 plot(1:CATS_TOTAL, AP_values);
 title('Average Precision Per Run');
 xlabel('Run');
 ylabel('Average Precision');

