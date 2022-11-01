clear all;
close all;

DATASET_FOLDER = 'D:/Docs_Matlab/CV-assignment/SVM/Images/';
%OUT_FOLDER = 'D:/Docs_Matlab/CV-assignment/SVM/Data/';

df=[];
cd Images
for i = 1:355
    x=imread(strcat(int2str(i),'.bmp'));
    x = imresize(x,[140,140]);
    %%%%%%%texture features%%%%%%%%
    F = ComputeRGBHistogram(x, 7);
   %F = ComputeSGColour(x, 4);
   %F = ComputeSGTexture(x, 10, 8, 0.09);
   %F = ComputeSGColourTexture(x, 10, 8, 0.09);
    df=[df;F];
end
cd ..
%%%%%%%%%%%%get test image %%%%%%%%%%
    [f,p]=uigetfile('*.*');
    test=imread(strcat(p,f));
    test = imresize(test,[140,140]);
  T = ComputeRGBHistogram(test, 7);
  % T = ComputeSGColour(test, 4);
  %T = ComputeSGTexture(test, 10, 8, 0.09);
  %T = ComputeSGColourTexture(test, 10, 8, 0.09);

  
   %%%%%%%%%%%%%%%%%%%%%%%training
   TrainingSet=df;
   v = [1 2 3 4 5 6 7 8 9 10 11 12];
   u = repelem(v,[40 30 25 55 25 25 30 25 30 25 20 25]);
   GroupTrain = string(u);
   TestSet=T;
   
   %%%%%%%%%%SVM
   Y=GroupTrain;
   classes=unique(u,'sorted');
   classes = string(classes);
   SVMModels=cell(length(classes),1);
   rng(1);   %Reproductivity
   
   for j=1:numel(classes)
      idx=strcmp(Y',classes(j));
      SVMModels{j}=fitcsvm(df,idx,'ClassNames',[false true],'Standardize',true,'KernelFunction','rbf','BoxConstraint',1);
      
   end
   xGrid=T;
   for j=1:numel(classes)
    [~,score]=predict(SVMModels{j},xGrid);
    Scores(:,j)=score(:,2);
   end
  
   [~,maxScore]=max(Scores,[],2);
   result=maxScore;
   
   if result == 1
       msgbox('Cow');
   elseif result == 2
       msgbox('Sheep');
   elseif result == 3
       msgbox('Plane');
   elseif result == 4
       msgbox('People');
   elseif result == 5
       msgbox('Car');
   elseif result == 6
       msgbox('Bike');
   elseif result == 7
       msgbox('Flower');
   elseif result == 8
       msgbox('Sign');
   elseif result == 9
       msgbox('Bird');
   elseif result == 10
       msgbox('Book');
   elseif result == 11
       msgbox('Cat');
   elseif result == 12
       msgbox('Bench');
   else
       msgbox('None');
   end    
   Class = zeros(1,12);
   activeClass =  ;
   %cm = confusionchart(activeClass,Scores);
   