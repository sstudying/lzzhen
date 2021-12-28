clear
clc
%% run 运行前需要根据需要设置
chb_number = 13;   % 改变进行分类的特征数据集的文件名字，如feature_chb02


%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=fix(clock);
str=strtrim(cellstr(num2str(x'))');
strs_spaces = sprintf('-%s' ,str{:});
trimmed = strtrim(strs_spaces);
filename=strcat(['E:\code\HHO_Harris hawks optimization\code+result\test_results\','Experiments-'],trimmed);
filenameACC= strcat(filename,'-Acc.xlsx');
filenameSens= strcat(filename,'-Sens.xlsx');
filenameSpec= strcat(filename,'-Spec.xlsx');
filenamePre= strcat(filename,'-Pre.xlsx');
filenameRec= strcat(filename,'-Rec.xlsx');
filenameTime= strcat(filename,'-Time.xlsx');
filenameFea= strcat(filename,'-fea.xlsx');

filenameACC1= strcat(filename,'-Acc1.xlsx');
filenameSens1= strcat(filename,'-Sens1.xlsx');
filenameSpec1= strcat(filename,'-Spec1.xlsx');
filenamePre1= strcat(filename,'-Pre1.xlsx');
filenameRec1= strcat(filename,'-Rec1.xlsx');
filenameTime1= strcat(filename,'-Time1.xlsx');
filenameFea1= strcat(filename,'-fea1.xlsx');


filenameACC2= strcat(filename,'-Acc2.xlsx');
filenameSens2= strcat(filename,'-Sens2.xlsx');
filenameSpec2= strcat(filename,'-Spec2.xlsx');
filenamePre2= strcat(filename,'-Pre2.xlsx');
filenameRec2= strcat(filename,'-Rec2.xlsx');
filenameTime2= strcat(filename,'-Time2.xlsx');
filenameFea2= strcat(filename,'-fea2.xlsx');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
root_path1 = 'E:\code\HHO_Harris hawks optimization\';
% results_path1 = 'E:\code\HHO_Harris hawks optimization\code+result\me_results\ictal_noictal\';
feature_path1 = [root_path1,'time-frequency-twoDataset\Data\feature data2\feature_chb', num2str(chb_number), '\'];   % 改变进行分类的特征数据集的文件名字，如feature_chb02
%%导入数据
load([feature_path1,'feature_LBPGLCM_flatten_ictal.mat']); 
load([feature_path1,'random_feature_LBPGLCM_flatten_noictal.mat']);  
% load([feature_path1,'random_feature_LBPGLCM_flatten_noictal.mat']);  

data_ictal = [feature_LBPGLCM_flatten_ictal,ones(size(feature_LBPGLCM_flatten_ictal,1),1)];
data_noictal = [feature_LBPGLCM_flatten_noictal,zeros(size(feature_LBPGLCM_flatten_noictal,1),1)];



data_ictal_noictal = [data_ictal;data_noictal];

Data_input = data_ictal_noictal;
TF_input = 1
% D = {'data_ictal_noictal'};


folds = 10;
AgentsNum=20;
MaxIteration=50;
NumberOfRuns=10;





%% 未改进 BHHO

%% 
Acc = zeros(folds+1,1);
Sens = zeros(folds+1,1);
Spec = zeros(folds+1,1);
Pre = zeros(folds+1,1);
Rec = zeros(folds+1,1);
Time = zeros(folds+1,1);
feature_num = zeros(folds+1,1);

for tf=TF_input 
	TFid=tf;
	data = Data_input; %%xiugaishujuji 
	target= data(:,end);
	nVar=size(data,2)-1;
	A=data;
	cvFolds = crossvalind('Kfold', target, folds);   %# get indices of 10-fold CV
	testIdx={};
	for k=1:folds % create array of training and testing folds                          
        testIdx{k} = (cvFolds == k); %# get indices of test instances
    end
    
	for k=1:folds
        display(['Fold: ', num2str(k), ' ---------']);
        %------------
        %############ Handle Folds
        testIx = testIdx{k};
        trainIdx = ~testIx; %# get indices training instances
%       TrainingData_File=data(trainIdx,:);
%       TestingData_File=data(testIx,:);
        [findonetest,~]=find(testIx==1);
        [findonetrain,~]=find(trainIdx==1);
        %############
        % neurons is the number of neurons returened by OP-ELM
%       [TargetFitness,TargetPosition,convergence,acc, Time,cmtest,Cost,Gamma]=optimizeall(a,AgentsNum,MaxIteration,nVar,A,TrainingData_File,TestingData_File,TFid);
        [TargetFitness,TargetPosition,convergence,acc,time,sens,spec,pre,rec]=BHHO(AgentsNum,MaxIteration,nVar,A,findonetrain,findonetest,TFid);
        Acc(k,1) =acc;
        Sens(k,1) = sens;
        Spec(k,1) = spec;
        Pre(k,1) = pre;
        Rec(k,1) = rec;
        Time(k,1) = time;
        Covergences(k,:)=convergence;
        %NumberOfNeuronsCurvePrint(k,:)=NumberOfNeuronsCurve;
        redDim  = sum(TargetPosition(:));%相当于核心集
        feature_num(k,1) = redDim;
%         bestResults(k,:)=[TargetFitness acc redDim  Time ];
%                             
%         bestSolutionss(k,:)=TargetPosition;
%         AlgoLabel{k}=algorithm{a};
%         BenchMarkLabel{k}=Dataset{d};
        TranFunc{k}=TFid;
    end
    
    Acc(folds+1,1) =sum(Acc(1:folds))/folds;
    Sens(folds+1,1) = sum(Sens(1:folds))/folds;
    Spec(folds+1,1) = sum(Spec(1:folds))/folds;
    Pre(folds+1,1) = sum(Pre(1:folds))/folds;
    Rec(folds+1,1) = sum(Rec(1:folds))/folds;
    Time(folds+1,1) = sum(Time(1:folds))/folds;
    feature_num(folds+1,1) = sum(feature_num(1:folds))/folds;
    
%     xlswrite('Acc1.xlsx',Acc1);
%     xlswrite('Sens1.xlsx',Sens1);
%     xlswrite('Spec1.xlsx',Spec1);
%     xlswrite('Pre1.xlsx',Pre1);
%     xlswrite('Rec1.xlsx',Rec1);
%     xlswrite('Time1.xlsx',Time1);
%     xlswrite('feature_num1.xlsx',feature_num1);
    xlswrite(filenameACC,Acc);
    xlswrite(filenameSens,Sens);
    xlswrite(filenameSpec,Spec);
    xlswrite(filenamePre,Pre);
    xlswrite(filenameRec,Rec);
    xlswrite(filenameTime,Time);
    xlswrite(filenameFea,feature_num);
%     display(sum(Acc)/folds);
%     display(sum(Sens)/folds);
%     display(sum(Spec)/folds);
%     display(sum(Pre)/folds);
%     display(sum(Rec)/folds);
%     display(sum(Time)/folds);
%     display(sum(feature_num)/folds);
end




%% 改进后的 BILHHO1

%%
Acc1 = zeros(folds+1,1);
Sens1 = zeros(folds+1,1);
Spec1 = zeros(folds+1,1);
Pre1 = zeros(folds+1,1);
Rec1 = zeros(folds+1,1);
Time1 = zeros(folds+1,1);
feature_num1 = zeros(folds+1,1);
for tf=TF_input 
	TFid=tf;
	data = Data_input; %%xiugaishujuji 
	target= data(:,end);
	nVar=size(data,2)-1;
	A=data;
	cvFolds = crossvalind('Kfold', target, folds);   %# get indices of 10-fold CV
	testIdx={};
	for k=1:folds % create array of training and testing folds
                          
        testIdx{k} = (cvFolds == k); %# get indices of test instances
    end
	for k=1:folds
        display(['Fold: ', num2str(k), ' ---------']);
        %------------
        %############ Handle Folds
        testIx = testIdx{k};
        trainIdx = ~testIx; %# get indices training instances
%       TrainingData_File=data(trainIdx,:);
%       TestingData_File=data(testIx,:);
        [findonetest,~]=find(testIx==1);
        [findonetrain,~]=find(trainIdx==1);
        %############
        % neurons is the number of neurons returened by OP-ELM
%       [TargetFitness,TargetPosition,convergence,acc, Time,cmtest,Cost,Gamma]=optimizeall(a,AgentsNum,MaxIteration,nVar,A,TrainingData_File,TestingData_File,TFid);
        [TargetFitness,TargetPosition,convergence,acc,time,sens,spec,pre,rec]=BILHHO1(AgentsNum,MaxIteration,nVar,A,findonetrain,findonetest,TFid);
        Acc1(k,1) =acc;
        Sens1(k,1) = sens;
        Spec1(k,1) = spec;
        Pre1(k,1) = pre;
        Rec1(k,1) = rec;
        Time1(k,1) = time;
        Covergences1(k,:)=convergence;
        %NumberOfNeuronsCurvePrint(k,:)=NumberOfNeuronsCurve;
        redDim1  = sum(TargetPosition(:));%相当于核心集
        feature_num1(k,1) = redDim1;
%         bestResults(k,:)=[TargetFitness acc redDim  Time ];
%                             
%         bestSolutionss(k,:)=TargetPosition;
%         AlgoLabel{k}=algorithm{a};
%         BenchMarkLabel{k}=Dataset{d};
        TranFunc{k}=TFid;
    end
    
    Acc1(folds+1,1) =sum(Acc1(1:folds))/folds;
    Sens1(folds+1,1) = sum(Sens1(1:folds))/folds;
    Spec1(folds+1,1) = sum(Spec1(1:folds))/folds;
    Pre1(folds+1,1) = sum(Pre1(1:folds))/folds;
    Rec1(folds+1,1) = sum(Rec1(1:folds))/folds;
    Time1(folds+1,1) = sum(Time1(1:folds))/folds;
    feature_num1(folds+1,1) = sum(feature_num1(1:folds))/folds;

    xlswrite(filenameACC1,Acc1);
    xlswrite(filenameSens1,Sens1);
    xlswrite(filenameSpec1,Spec1);
    xlswrite(filenamePre1,Pre1);
    xlswrite(filenameRec1,Rec1);
    xlswrite(filenameTime1,Time1);
    xlswrite(filenameFea1,feature_num1);
%     display(sum(Acc)/folds);
%     display(sum(Sens)/folds);
%     display(sum(Spec)/folds);
%     display(sum(Pre)/folds);
%     display(sum(Rec)/folds);
%     display(sum(Time)/folds);
%     display(sum(feature_num)/folds);
end



%% 改进后的 BILHHO2 (最终通过传递函数进行随机化)

%%
Acc2 = zeros(folds+1,1);
Sens2 = zeros(folds+1,1);
Spec2 = zeros(folds+1,1);
Pre2 = zeros(folds+1,1);
Rec2 = zeros(folds+1,1);
Time2 = zeros(folds+1,1);
feature_num2 = zeros(folds+1,1);
for tf=TF_input 
	TFid=tf;
	data = Data_input; %%xiugaishujuji 
	target= data(:,end);
	nVar=size(data,2)-1;
	A=data;
	cvFolds = crossvalind('Kfold', target, folds);   %# get indices of 10-fold CV
	testIdx={};
	for k=1:folds % create array of training and testing folds
                          
        testIdx{k} = (cvFolds == k); %# get indices of test instances
    end
	for k=1:folds
        display(['Fold: ', num2str(k), ' ---------']);
        %------------
        %############ Handle Folds
        testIx = testIdx{k};
        trainIdx = ~testIx; %# get indices training instances
%       TrainingData_File=data(trainIdx,:);
%       TestingData_File=data(testIx,:);
        [findonetest,~]=find(testIx==1);
        [findonetrain,~]=find(trainIdx==1);
        %############
        % neurons is the number of neurons returened by OP-ELM
%       [TargetFitness,TargetPosition,convergence,acc, Time,cmtest,Cost,Gamma]=optimizeall(a,AgentsNum,MaxIteration,nVar,A,TrainingData_File,TestingData_File,TFid);
        [TargetFitness,TargetPosition,convergence,acc,time,sens,spec,pre,rec]=BILHHO2(AgentsNum,MaxIteration,nVar,A,findonetrain,findonetest,TFid);
        Acc2(k,1) =acc;
        Sens2(k,1) = sens;
        Spec2(k,1) = spec;
        Pre2(k,1) = pre;
        Rec2(k,1) = rec;
        Time2(k,1) = time;
        Covergences2(k,:)=convergence;
        %NumberOfNeuronsCurvePrint(k,:)=NumberOfNeuronsCurve;
        redDim2  = sum(TargetPosition(:));%相当于核心集
        feature_num2(k,1) = redDim2;
%         bestResults(k,:)=[TargetFitness acc redDim  Time ];
%                             
%         bestSolutionss(k,:)=TargetPosition;
%         AlgoLabel{k}=algorithm{a};
%         BenchMarkLabel{k}=Dataset{d};
        TranFunc{k}=TFid;
    end
    
    Acc2(folds+1,1) =sum(Acc2(1:folds))/folds;
    Sens2(folds+1,1) = sum(Sens2(1:folds))/folds;
    Spec2(folds+1,1) = sum(Spec2(1:folds))/folds;
    Pre2(folds+1,1) = sum(Pre2(1:folds))/folds;
    Rec2(folds+1,1) = sum(Rec2(1:folds))/folds;
    Time2(folds+1,1) = sum(Time2(1:folds))/folds;
    feature_num2(folds+1,1) = sum(feature_num2(1:folds))/folds;

    xlswrite(filenameACC2,Acc2);
    xlswrite(filenameSens2,Sens2);
    xlswrite(filenameSpec2,Spec2);
    xlswrite(filenamePre2,Pre2);
    xlswrite(filenameRec2,Rec2);
    xlswrite(filenameTime2,Time2);
    xlswrite(filenameFea2,feature_num2);
%     display(sum(Acc)/folds);
%     display(sum(Sens)/folds);
%     display(sum(Spec)/folds);
%     display(sum(Pre)/folds);
%     display(sum(Rec)/folds);
%     display(sum(Time)/folds);
%     display(sum(feature_num)/folds);
end


toc
