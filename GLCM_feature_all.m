clear
clc

root_path = 'D:\time-frequency-firstDataset\';
feature_path = [root_path,'Data\feature\'];
CWT_Result_path = [root_path,'CWT\CWT_Result\'];
CWT_figure_path = [root_path,'CWT\CWT_figure\'];


for count=1:100
    name1 = num2str(count); 
    load([CWT_Result_path,'S_Graph_', num2str(count), '.mat']);
    load([CWT_Result_path,'N_Graph_', num2str(count), '.mat']);
    load([CWT_Result_path,'F_Graph_', num2str(count), '.mat']);
    load([CWT_Result_path,'O_Graph_', num2str(count), '.mat']);
    load([CWT_Result_path,'Z_Graph_', num2str(count), '.mat']);
    S{1}=S_DeltaGraph;
    S{2}=S_ThetaGraph;
    S{3}=S_AlphaGraph;
    S{4}=S_BetaGraph;
    S{5}=S_GammaGraph;
    
    N{1}=N_DeltaGraph;
    N{2}=N_ThetaGraph;
    N{3}=N_AlphaGraph;
    N{4}=N_BetaGraph;
    N{5}=N_GammaGraph;
    
    F{1}=F_DeltaGraph;
    F{2}=F_ThetaGraph;
    F{3}=F_AlphaGraph;
    F{4}=F_BetaGraph;
    F{5}=F_GammaGraph;
    
    O{1}=O_DeltaGraph;
    O{2}=O_ThetaGraph;
    O{3}=O_AlphaGraph;
    O{4}=O_BetaGraph;
    O{5}=O_GammaGraph;
    
    Z{1}=Z_DeltaGraph;
    Z{2}=Z_ThetaGraph;
    Z{3}=Z_AlphaGraph;
    Z{4}=Z_BetaGraph;
    Z{5}=Z_GammaGraph;
    
    
    % 只对S进行特征提取，同理N
    for count1=1:5
    figure('visible','off');
    imagesc(10*log10(S{count1}));
    caxis([-10,40]);
    
    name=num2str(count1);
    filename2=[CWT_figure_path,'S_pictures\wt_S_',name1,'_',name,'.jpg'];
    saveas(gcf,filename2); 
    close all
    ddd=imread(filename2,'jpg');

    fig1=imcrop(ddd,[157 70 (976-157) (801-70)]);
    gray=rgb2gray(fig1);
    %%%提取特征
    glcms1 = graycomatrix(gray,'NumLevels',256,'Offset',[0,1]);
    stats1 = graycoprops(glcms1);
    feature_GLCM_S(count,(count1-1)*16+1)=stats1.Contrast;
    feature_GLCM_S(count,(count1-1)*16+2)=stats1.Correlation;
    feature_GLCM_S(count,(count1-1)*16+3)=stats1.Energy;
    feature_GLCM_S(count,(count1-1)*16+4)=stats1.Homogeneity;
    
    glcms2 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,1]);
    stats2 = graycoprops(glcms2);
    feature_GLCM_S(count,(count1-1)*16+5)=stats2.Contrast;
    feature_GLCM_S(count,(count1-1)*16+6)=stats2.Correlation;
    feature_GLCM_S(count,(count1-1)*16+7)=stats2.Energy;
    feature_GLCM_S(count,(count1-1)*16+8)=stats2.Homogeneity;
    
    glcms3 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,0]);
    stats3 = graycoprops(glcms3);
    feature_GLCM_S(count,(count1-1)*16+9)=stats3.Contrast;
    feature_GLCM_S(count,(count1-1)*16+10)=stats3.Correlation;
    feature_GLCM_S(count,(count1-1)*16+11)=stats3.Energy;
    feature_GLCM_S(count,(count1-1)*16+12)=stats3.Homogeneity;
    
    glcms4 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,-1]);
    stats4 = graycoprops(glcms4);
    feature_GLCM_S(count,(count1-1)*16+13)=stats4.Contrast;
    feature_GLCM_S(count,(count1-1)*16+14)=stats4.Correlation;
    feature_GLCM_S(count,(count1-1)*16+15)=stats4.Energy;
    feature_GLCM_S(count,(count1-1)*16+16)=stats4.Homogeneity;
    end

   
     % 对N进行特征提取
    for count1=1:5
    figure('visible','off');
    imagesc(10*log10(N{count1}));
    caxis([-10,40]);
    
    name=num2str(count1);
    filename2=[CWT_figure_path,'N_pictures\wt_N_',name1,'_',name,'.jpg'];
    saveas(gcf,filename2); 
    close all
    ddd=imread(filename2,'jpg');

    fig1=imcrop(ddd,[157 70 (976-157) (801-70)]);
    gray=rgb2gray(fig1);
    %%%提取特征
    glcms1 = graycomatrix(gray,'NumLevels',256,'Offset',[0,1]);
    stats1 = graycoprops(glcms1);
    feature_GLCM_N(count,(count1-1)*16+1)=stats1.Contrast;
    feature_GLCM_N(count,(count1-1)*16+2)=stats1.Correlation;
    feature_GLCM_N(count,(count1-1)*16+3)=stats1.Energy;
    feature_GLCM_N(count,(count1-1)*16+4)=stats1.Homogeneity;
    
    glcms2 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,1]);
    stats2 = graycoprops(glcms2);
    feature_GLCM_N(count,(count1-1)*16+5)=stats2.Contrast;
    feature_GLCM_N(count,(count1-1)*16+6)=stats2.Correlation;
    feature_GLCM_N(count,(count1-1)*16+7)=stats2.Energy;
    feature_GLCM_N(count,(count1-1)*16+8)=stats2.Homogeneity;
    
    glcms3 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,0]);
    stats3 = graycoprops(glcms3);
    feature_GLCM_N(count,(count1-1)*16+9)=stats3.Contrast;
    feature_GLCM_N(count,(count1-1)*16+10)=stats3.Correlation;
    feature_GLCM_N(count,(count1-1)*16+11)=stats3.Energy;
    feature_GLCM_N(count,(count1-1)*16+12)=stats3.Homogeneity;
    
    glcms4 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,-1]);
    stats4 = graycoprops(glcms4);
    feature_GLCM_N(count,(count1-1)*16+13)=stats4.Contrast;
    feature_GLCM_N(count,(count1-1)*16+14)=stats4.Correlation;
    feature_GLCM_N(count,(count1-1)*16+15)=stats4.Energy;
    feature_GLCM_N(count,(count1-1)*16+16)=stats4.Homogeneity;
    end
    
    % 对F进行特征提取
    for count1=1:5
    figure('visible','off');
    imagesc(10*log10(F{count1}));
    caxis([-10,40]);
    
    name=num2str(count1);
    filename2=[CWT_figure_path,'F_pictures\wt_F_',name1,'_',name,'.jpg'];
    saveas(gcf,filename2); 
    close all
    ddd=imread(filename2,'jpg');

    fig1=imcrop(ddd,[157 70 (976-157) (801-70)]);
    gray=rgb2gray(fig1);
    %%%提取特征
    glcms1 = graycomatrix(gray,'NumLevels',256,'Offset',[0,1]);
    stats1 = graycoprops(glcms1);
    feature_GLCM_F(count,(count1-1)*16+1)=stats1.Contrast;
    feature_GLCM_F(count,(count1-1)*16+2)=stats1.Correlation;
    feature_GLCM_F(count,(count1-1)*16+3)=stats1.Energy;
    feature_GLCM_F(count,(count1-1)*16+4)=stats1.Homogeneity;
    
    glcms2 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,1]);
    stats2 = graycoprops(glcms2);
    feature_GLCM_F(count,(count1-1)*16+5)=stats2.Contrast;
    feature_GLCM_F(count,(count1-1)*16+6)=stats2.Correlation;
    feature_GLCM_F(count,(count1-1)*16+7)=stats2.Energy;
    feature_GLCM_F(count,(count1-1)*16+8)=stats2.Homogeneity;
    
    glcms3 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,0]);
    stats3 = graycoprops(glcms3);
    feature_GLCM_F(count,(count1-1)*16+9)=stats3.Contrast;
    feature_GLCM_F(count,(count1-1)*16+10)=stats3.Correlation;
    feature_GLCM_F(count,(count1-1)*16+11)=stats3.Energy;
    feature_GLCM_F(count,(count1-1)*16+12)=stats3.Homogeneity;
    
    glcms4 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,-1]);
    stats4 = graycoprops(glcms4);
    feature_GLCM_F(count,(count1-1)*16+13)=stats4.Contrast;
    feature_GLCM_F(count,(count1-1)*16+14)=stats4.Correlation;
    feature_GLCM_F(count,(count1-1)*16+15)=stats4.Energy;
    feature_GLCM_F(count,(count1-1)*16+16)=stats4.Homogeneity;
    end
     
     
    % 对O进行特征提取
    for count1=1:5
    figure('visible','off');
    imagesc(10*log10(O{count1}));
    caxis([-10,40]);
    
    name=num2str(count1);
    filename2=[CWT_figure_path,'O_pictures\wt_O_',name1,'_',name,'.jpg'];
    saveas(gcf,filename2); 
    close all
    ddd=imread(filename2,'jpg');

    fig1=imcrop(ddd,[157 70 (976-157) (801-70)]);
    gray=rgb2gray(fig1);
    %%%提取特征
    glcms1 = graycomatrix(gray,'NumLevels',256,'Offset',[0,1]);
    stats1 = graycoprops(glcms1);
    feature_GLCM_O(count,(count1-1)*16+1)=stats1.Contrast;
    feature_GLCM_O(count,(count1-1)*16+2)=stats1.Correlation;
    feature_GLCM_O(count,(count1-1)*16+3)=stats1.Energy;
    feature_GLCM_O(count,(count1-1)*16+4)=stats1.Homogeneity;
    
    glcms2 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,1]);
    stats2 = graycoprops(glcms2);
    feature_GLCM_O(count,(count1-1)*16+5)=stats2.Contrast;
    feature_GLCM_O(count,(count1-1)*16+6)=stats2.Correlation;
    feature_GLCM_O(count,(count1-1)*16+8)=stats2.Homogeneity;
    
    glcms3 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,0]);
    stats3 = graycoprops(glcms3);
    feature_GLCM_O(count,(count1-1)*16+9)=stats3.Contrast;
    feature_GLCM_O(count,(count1-1)*16+10)=stats3.Correlation;
    feature_GLCM_O(count,(count1-1)*16+11)=stats3.Energy;
    feature_GLCM_O(count,(count1-1)*16+12)=stats3.Homogeneity;
    
    glcms4 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,-1]);
    stats4 = graycoprops(glcms4);
    feature_GLCM_O(count,(count1-1)*16+13)=stats4.Contrast;
    feature_GLCM_O(count,(count1-1)*16+14)=stats4.Correlation;
    feature_GLCM_O(count,(count1-1)*16+15)=stats4.Energy;
    feature_GLCM_O(count,(count1-1)*16+16)=stats4.Homogeneity;
    end 
    
    % 对Z进行特征提取
    for count1=1:5
    figure('visible','off');
    imagesc(10*log10(Z{count1}));
    caxis([-10,40]);
    
    name=num2str(count1);
    filename2=[CWT_figure_path,'Z_pictures\wt_Z_',name1,'_',name,'.jpg'];
    saveas(gcf,filename2); 
    close all
    ddd=imread(filename2,'jpg');

    fig1=imcrop(ddd,[157 70 (976-157) (801-70)]);
    gray=rgb2gray(fig1);
    
    time_begin=clock;
    %%%提取特征
    glcms1 = graycomatrix(gray,'NumLevels',256,'Offset',[0,1]);
    stats1 = graycoprops(glcms1);
    feature_GLCM_Z(count,(count1-1)*16+1)=stats1.Contrast;
    feature_GLCM_Z(count,(count1-1)*16+2)=stats1.Correlation;
    feature_GLCM_Z(count,(count1-1)*16+3)=stats1.Energy;
    feature_GLCM_Z(count,(count1-1)*16+4)=stats1.Homogeneity;
    
    glcms2 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,1]);
    stats2 = graycoprops(glcms2);
    feature_GLCM_Z(count,(count1-1)*16+5)=stats2.Contrast;
    feature_GLCM_Z(count,(count1-1)*16+6)=stats2.Correlation;
    feature_GLCM_Z(count,(count1-1)*16+7)=stats2.Energy;
    feature_GLCM_Z(count,(count1-1)*16+8)=stats2.Homogeneity;
    
    glcms3 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,0]);
    stats3 = graycoprops(glcms3);
    feature_GLCM_Z(count,(count1-1)*16+9)=stats3.Contrast;
    feature_GLCM_Z(count,(count1-1)*16+10)=stats3.Correlation;
    feature_GLCM_Z(count,(count1-1)*16+11)=stats3.Energy;
    feature_GLCM_Z(count,(count1-1)*16+12)=stats3.Homogeneity;
    
    glcms4 = graycomatrix(gray,'NumLevels',256,'Offset',[-1,-1]);
    stats4 = graycoprops(glcms4);
    feature_GLCM_Z(count,(count1-1)*16+13)=stats4.Contrast;
    feature_GLCM_Z(count,(count1-1)*16+14)=stats4.Correlation;
    feature_GLCM_Z(count,(count1-1)*16+15)=stats4.Energy;
    feature_GLCM_Z(count,(count1-1)*16+16)=stats4.Homogeneity;
    
    time_end=clock;
    etime(time_end,time_begin);
    end
    
end    
clearvars -EXCEPT feature_GLCM_S feature_GLCM_N feature_GLCM_F feature_GLCM_O feature_GLCM_Z 

save([feature_path,'feature_GLCM_SNFOZ_All.mat']);
