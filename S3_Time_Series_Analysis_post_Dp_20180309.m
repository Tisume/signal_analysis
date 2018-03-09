%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 功能：1）对床层不同位置差压时序信号的原始信号，统计信息计算（平均值、标准差、偏度、峰度）、频谱分析、功率谱密度、小波分析、能量分布，相关系数等计算
%%% 工况：K:\SimulationResults\UgpressureFB\UgpressureFBpost20180129
%%% 注意：重新提取的仿真数据
%%% 宋加龙
%%% 日期：2018年02月26日
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all; close all; clc;
Path='K:\SimulationResults\UgpressureFB\UgpressureFBpost20180129';



%% 用于确定要进行何种计算
for i0=1:1,
    Output_Original_Signal=0; % 原始信号
    Output_Statistical_Information=0; % 统计信息计算，包括平均值，标准差，偏度，峰度
    Output_Frequency_Analysis=0; % 频谱分析
    Output_Power_Spectrum_Density_Analysis=1; % 功率谱密度分析
    PSD_Method=1;%所采用的方法；%1-PSD_WELCH方法；%2-各种功率谱计算方法对比
    Output_Wavelet_Analysis=0;% 小波分析
    Output_AutoCorrelation_Function =0;% 自相关函数计算
end

%%
count=0; %用于统计计算的工况个数
Excel_title=cell(21,1); %用于存放工况的名称
Bubble2_sum=[]; %用于汇总统计计算结果
Wavelet_Energy_Distribution_sum=[]; %用于汇总小波能量计算结果

for i=1:1, %对应21个工况
    %*********************1.0MPa****************************
    if i==1,
        name1='p10barug025';
    elseif i==2,
        name1='p10barug0367';
    elseif i==3,
        name1='p10barug050';
    elseif i==4,
        name1='p10barug060';
    elseif i==5,
        name1='p10barug070';
    elseif i==6,
        name1='p10barug080';
    elseif i==7,
        name1='p10barug090';
        %*********************0.6MPa****************************
    elseif i==8,
        name1='p6barug025';
    elseif i==9,
        name1='p6barug0367';
    elseif i==10,
        name1='p6barug050';
    elseif i==11,
        name1='p6barug060';
    elseif i==12,
        name1='p6barug070';
    elseif i==13,
        name1='p6barug085';
    elseif i==14,
        name1='p6barug100';
        %*********************0.1MPa****************************
    elseif i==15,
        name1='ug037p1bar';
    elseif i==16,
        name1='ug500';
    elseif i==17,
        name1='ug062p1bar';
    elseif i==18,
        name1='ug075p1bar';
    elseif i==19,
        name1='ug100p1bar';
    elseif i==20,
        name1='ug115p1bar';
    elseif i==21,
        name1='ug140p1bar';
    end
    
    loadpath_mat=strcat(Path,'\','post数据','\',name1,'-PgLocals.mat'); %'.mat'文件的完整路径
    load(loadpath_mat);%载入“.mat”文件信息
    DpressureVsTime=PgLocalsvsTime; %DPbedvsTime数据信息赋值给DpressureVsTime变量
    
    %% 运行中需要修改的部分
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numi=10; %第2-10列为差压信号数据,共9组，分9次运行，手动修改，分别为2,3,4,5,6,7,8,9,10
    
    Bubble1=DpressureVsTime(:,1);  %第1列为时间数据
    Bubble20=DpressureVsTime(:,numi);  %差压信号数据,共9组，分9次运行，手动修改，分别为2,3,4,5,6,7,8,9,10
    name11=strcat(name1,'_',num2str(numi)); %保存的文件名字
    
    Path2=strcat('K:\SimulationResults\UgpressureFB\UgpressureFBpost20180129','\计算结果','\压力波动');
    mkdir(Path2,num2str(numi)); %用于存放在21个工况中相同位置处的计算结果数据
    Path3=strcat(Path2,'\',num2str(numi));
    mkdir(Path3,'波动图像'); %在Path3文件夹下创建名为“波动图像”文件夹
    
    Bubble21=Bubble20-mean(Bubble20); %差压信号数据,去除平均值后的数据
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %用于定义计算结果的保存路径
    for i1=1,
        Excel_Output_Path_Image=strcat(Path2,'\',num2str(numi),'\','波动图像\');%定义保存原始信号图像路径
        Excel_outputpath_Original_Signal_data=strcat(Path2,'\',num2str(numi),'\','原始信号信息汇总.xlsx');%定义工况的计算统计数据路径
        Excel_outputpath_Statistical_Information_data=strcat(Path2,'\',num2str(numi),'\','统计信息汇总.xlsx');%定义工况的计算统计数据路径
        Excel_outputpath_Frequency_Analysis_data=strcat(Path2,'\',num2str(numi),'\','信号频谱汇总.xlsx');
        Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data=strcat(Path2,'\',num2str(numi),'\','信号功率谱汇总.xlsx');
        Excel_Outputpath_Wavelet_Sum_data=strcat(Path2,'\',num2str(numi),'\','小波变换各频段分布情况汇总.xlsx');%定义保存小波变换能量分布数据路径
        Excel_outputpath_Wavelet_Analysis_data=strcat(Path2,'\',num2str(numi),'\','小波变换能量分布汇总.xlsx');%定义保存小波变换能量分布数据路径
        Excel_outputpath_AutoCorrelation_Function_data=strcat(Path2,'\',num2str(numi),'\','自相关函数汇总.xlsx');%定义保存小波变换能量分布数据路径
    end
    
    Fs=50;%采样频率为50Hz
    N=251;
    xn=Bubble21;%去除差压后的幅值数据赋值给xn
    dt=1/Fs;%采样时间间隔
    n=0:N-1;
    t=n*dt;%采样时间分布
    
    %原始信号
    if  Output_Original_Signal==1;
        Original_data=[Bubble1,Bubble20,Bubble21];%用于存放时间数据，原始幅值数据，去除差压后的幅值数据
        m1={'时间','原始幅值','去除均值后幅值'};
        
        xlswrite(Excel_outputpath_Original_Signal_data,m1,name11,'A1');
        disp(strcat('Excel_outputpath_Original_Signal_data_Excelheader:',name11)); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_Original_Signal_data,Original_data,name11,'A2');
        disp(strcat('Excel_outputpath_Original_Signal_data_Exceldata:',name11)); %Excel数据表的所有数据输入完毕
        
        %         figure,
        %         plot(t,xn,'LineWidth',2);
        %         %axis([0,5,-1000,1500]);
        %         title('原始信号——时域图');
        %         xlabel('时间/s');
        %         ylabel('幅值');
        %         grid on;
        %         %print(gcf,'-dtiff',[Excel_Output_Path_Image,'Original_Signal_Image',name1,'.tiff'])   %保存tiff格式的图片到指定路径
        %         close all;
    end
    
    %统计分析，计算平均值，标准差，峰度，偏度
    if Output_Statistical_Information==1,
        Bubble20_mean=mean(Bubble20);
        Bubble20_length=length(Bubble20);
        
        %计算标准差
        Bubble20_std=std(Bubble20);%标准偏差
        
        %计算平均绝对偏差
        Bubble21_Average_Absolute_Deviation=mean(abs(Bubble21));%平均绝对偏差
        
        %邱桂芝, 大型循环流化床环形炉膛气固流动特性CPFD数值模拟和实验研究, 2015, 中国科学院研究生院(工程热物理研究所).P43
        %计算偏度
        Bubble20_Sk_sum=0;
        for j=1:Bubble20_length,
            Bubble20_Sk_sum=Bubble20_Sk_sum+Bubble21(j)^3;
        end
        Bubble20_Sk=Bubble20_Sk_sum/(N*Bubble20_std^3);
        
        %邱桂芝, 大型循环流化床环形炉膛气固流动特性CPFD数值模拟和实验研究, 2015, 中国科学院研究生院(工程热物理研究所).P43
        %计算峰度
        Bubble20_K_sum=0;
        
        for j=1:Bubble20_length,
            Bubble20_K_sum=Bubble20_K_sum+Bubble21(j)^4;
        end
        
        Bubble20_K=Bubble20_K_sum/(N*Bubble20_std^4);
        
        Bubble2_Temp=[Bubble20_mean,Bubble20_std,Bubble21_Average_Absolute_Deviation,Bubble20_Sk,Bubble20_K];%分别为平均值，标准差，绝对偏差平均值，偏度Sk，峰度K
        Bubble2_sum=[Bubble2_sum;Bubble2_Temp];%汇总计算的结果，输出到Excel的代码在最后，用于汇总后再输出
    end
    
    %频谱分析
    if Output_Frequency_Analysis==1,
        y=fft(xn,N);%傅里叶变换
        mag=abs(y);
        f=(0:length(y)-1)'*Fs/length(y);%横坐标频率的表达式为f=(0:M-1)*Fs/M;
        frequency_data=[f(1:N/2),mag(1:N/2)];
        
        m2={'频率/Hz','幅值'};
        xlswrite(Excel_outputpath_Frequency_Analysis_data,m2,name11,'A1');
        disp(strcat('Excel_outputpath_Frequency_Analysis_data_Excelheader:',name11)); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_Frequency_Analysis_data,frequency_data,name11,'A2');
        disp(strcat('Excel_outputpath_Frequency_Analysis_data_Exceldata:',name11)); %Excel数据表的所有数据输入完毕
        
        figure,
        plot(f(1:N/2),mag(1:N/2),'LineWidth',2);%绘制频谱图
        %axis([0,25,0,40000])
        title('频谱图');
        xlabel('频率/Hz');
        ylabel('幅值');
        grid on;
        
        print(gcf,'-dtiff',[Excel_Output_Path_Image,'Frequency_Analysis_Image_',name11,'.tiff']);  %保存tiff格式的图片到指定路径
        close all;
    end
    
    %功率谱密度分析
    if  Output_Power_Spectrum_Density_Analysis==1,
        switch PSD_Method,
            case 1, %PSD_WELCH方法(改进的周期图功率谱估计方法)——海明窗
                %Matlab中，函数psd()和函数pwelch()均可实现Welch方法的功率谱估计，参考教材：随机信号分析（第3版）郑微，电子工业出版社，2017年
                
                nfft=251; %FFT变换点数
                Nseg=251; %分段间隔
                window1=hamming(length(xn)); %选用的窗口-海明窗
                noverlap=100; %分段序列重叠的采样点数（长度）
                range='half'; %频率间隔为[0 Fs/2]，只计算一半的频率
                f=(0:Nseg/2)*Fs/Nseg; %频率轴坐标
                
                Sx1=psd(xn,Nseg,Fs,window1,noverlap,'none');
                %Sx1=10*log10(Sx1);
                Plot_Pxx11=Sx1;
                Plot_Pxx12=10*log10(Sx1);
                
                Sx2=pwelch(xn,window1,noverlap,nfft,Fs,'oneside')*Fs/2; %pwelch()返回的单边功率谱需乘以Fs/2
                %Sx2=10*log10(Sx2);
                Plot_Pxx21=Sx2;
                Plot_Pxx22=10*log10(Sx2);
                
                window2=boxcar(length(xn));      %PSD_WELCH方法——矩形窗
                Sx3=pwelch(xn,window2,noverlap,N,Fs,'oneside')*Fs/2;
                Plot_Pxx31=Sx3;
                Plot_Pxx32=10*log10(Sx3);
                
                %绘制功率谱曲线图（非对数坐标）
                figure,
                subplot(3,1,1),
                plot(f,Sx1,'LineWidth',2);
                grid on;
                xlabel('频率/Hz');
                ylabel('功率谱');
                title('功率谱-Welch法-psd()函数');
                
                subplot(3,1,2),
                plot(f,Plot_Pxx21,'LineWidth',2);  %绘制功率谱
                %axis([0,25,0,300000])
                xlabel('频率/Hz');
                ylabel('功率谱');
                title('功率谱-Welch法-海明窗-pwelch()函数');
                grid on
                
                subplot(3,1,3),
                plot(f,Plot_Pxx31,'LineWidth',2);
                %axis([0,25,0,300000]);
                xlabel('频率/Hz');
                ylabel('功率谱');
                title('功率谱-Welch法-矩形窗-pwelch()函数');
                grid on
                
                print(gcf,'-dtiff',[Excel_Output_Path_Image,'Power_Spectrum_Density_Analysis_',name11,'_1.tiff'])   %保存tiff格式的图片到指定路径
                close all;
                
                data1_Pxx1=[f',Plot_Pxx21];
                data2_Pxx1=[f',Plot_Pxx22];
                
                m3={'频率/Hz','pwelch()幅值','频率','pwelch()对数值'};
                xlswrite(Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data,m3,name11,'A1');
                disp(strcat('Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data1_Excelheader:',name11)); %Excel数据表的表头输入完毕
                
                xlswrite(Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data,data1_Pxx1,name11,'A2');
                disp(strcat('Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data1_Exceldata:',name11)); %Excel数据表的所有数据输入完毕
                
                xlswrite(Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data,data2_Pxx1,name11,'C2');
                disp(strcat('Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data2_Exceldata:',name11)); %Excel数据表的所有数据输入完毕
                
                %绘制功率谱曲线图（对数坐标）
                figure,
                subplot(3,1,1),
                plot(f,Plot_Pxx12,'LineWidth',2);  %绘制功率谱
                %axis([0,25,0,300000])
                xlabel('频率/Hz');
                ylabel('功率谱');
                title('功率谱-Welch法-psd()函数');
                grid on;
                
                subplot(3,1,2),
                plot(f,Plot_Pxx22,'LineWidth',2);  %绘制功率谱
                %axis([0,25,0,300000])
                xlabel('频率/Hz');
                ylabel('功率谱');
                title('功率谱-Welch法-海明窗-pwelch()函数');
                grid on;
                
                subplot(3,1,3),
                plot(f,Plot_Pxx32,'LineWidth',2);
                %axis([0,25,0,300000]);
                title('功率谱-Welch法-矩形窗-pwelch()函数');
                xlabel('频率/Hz');
                ylabel('功率谱');
                grid on;
                
                print(gcf,'-dtiff',[Excel_Output_Path_Image,'Power_Spectrum_Density_Analysis_Log_',name11,'_2.tiff'])   %保存tiff格式的图片到指定路径
                close all;
                
                %其中窗口的长度N表示每次处理的分段数据长度，Noverlap是指相邻两段数据之间的重叠部分长度。
                %N越大得到的功率谱分辨率越高(越准确)，但方差加大(及功率谱曲线不太平滑)；N越小，结果的方差会变小，
                %但功率谱分辨率较低(估计结果不太准确)。
                %pwelch里面NFFT,即FFT的个数，是可以变化的。但是最大长度不能超过每一段的点数。
                %当然，很多情况下我们把NFFT等于每一段的点数，这样可以得到最高的频域分辨率。
                %如果NFFT = 每一段的一半，频域分辨率低一倍。
            case 2,
                %这里可以添加其它计算功率谱的方法
        end
    end
    
    %小波分析
    if Output_Wavelet_Analysis==1,
        [cA,cD]=wavedec(xn,4,'db2');%%利用db2小波对信号进行4层分解；分别对应的频率为：25——50Hz；12.5——25Hz；6.25——12.5Hz；3.125——6.25Hz；0——3.125Hz；
        %[cA,cD]=wavedec(X,1,’wname’)中返回的近似和细节都存放在cA中，即C=[cA,cD]，L存放是近似和各阶细节系数对应的长度
        
        %信号重构
        %a4=wrcoef('type',cA,cD,'wname',N); %type=a是对低频部分进行重构；type=d是对高频部分进行重构，N为信号的层数
        
        a4=wrcoef('a',cA,cD,'db2',4); %0-3.125Hz，    重构第4层低频信号
        d4=wrcoef('d',cA,cD,'db2',4); %3.125-6.25Hz， 重构第4层高频信号
        d3=wrcoef('d',cA,cD,'db2',3); %6.25-12.5Hz，  重构第3层高频信号
        d2=wrcoef('d',cA,cD,'db2',2); %12.5-25Hz，    重构第2层高频信号
        d1=wrcoef('d',cA,cD,'db2',1); %25-50Hz，      重构第1层高频信号
        
        wavelet_sum_signals=[t',a4,d4,d3,d2,d1,xn];%注意这里的t是行向量，需转换为列向量
        
        m5={'t','a4','d4','d3','d2','d1','xn'};
        xlswrite(Excel_Outputpath_Wavelet_Sum_data,m5,name11,'A1');
        disp(strcat('Excel_Outputpath_Wavelet_Sum_data_Excelheader:',name11)); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_Outputpath_Wavelet_Sum_data,wavelet_sum_signals,name11,'A2');
        disp(strcat('Excel_Outputpath_Wavelet_Sum_data_Exceldata:',name11)); %Excel数据表的所有数据输入完毕
        
        %输出各层的信号信息
        figure,
        subplot(6,1,1),
        plot(t,a4,'linewidth',2);
        %axis([0,5,-200,200]);
        ylabel('a4');
        grid on;%第4层低频信号
        
        subplot(6,1,2),
        plot(t,d4,'linewidth',2);
        %axis([0,5,-500,500]);
        ylabel('d4');
        grid on;%第4层高频信号
        
        subplot(6,1,3),
        plot(t,d3,'linewidth',2);
        %axis([0,5,-1000,1000]);
        ylabel('d3');
        grid on;%第3层高频信号
        
        subplot(6,1,4),
        plot(t,d2,'linewidth',2);
        %axis([0,5,-1000,1000]);
        ylabel('d2');
        grid on;%第2层高频信号
        
        subplot(6,1,5),
        plot(t,d1,'linewidth',2);
        %axis([0,5,-200,200]);
        ylabel('d1');
        grid on;%第1层高频信号
        
        subplot(6,1,6),
        plot(t,xn,'linewidth',2);
        %axis([0,5,-1000,1000]);
        ylabel('xn');
        grid on;%原始信号
        xlabel('t/s');
        
        print(gcf,'-dtiff',[Excel_Output_Path_Image,'Wavelet_Analysis_',name11,'.tiff'])   %保存tiff格式的图片到指定路径
        close all;
        
        %信号的能量计算
        [Ea,Ed]=wenergy(cA,cD);%Ea显示低频能量百分比；%Ed显示高频能量百分比
        Wavelet_Energy_Distribution=[Ed,Ea];%顺序为d1,d2,d3,d4,a4
        Wavelet_Energy_Distribution_sum=[Wavelet_Energy_Distribution_sum;Wavelet_Energy_Distribution];
    end
    
    %自相关函数计算
    if Output_AutoCorrelation_Function==1,
        [acor,lag] = xcorr(xn,'unbiased');%求取互相关函数，lag迟延步数，acor相关系数
        
        lag_t=lag(251:501)*dt;%为行向量
        acor_t=acor(251:501);%为列向量
        AutoCorrelation_Function_data=[lag_t',acor_t];
        
        m4={'迟延时间','相关系数'};
        xlswrite(Excel_outputpath_AutoCorrelation_Function_data,m4,name11,'A1');
        disp(strcat('Excel_outputpath_AutoCorrelation_Function_data_Excelheader:',name11)); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_AutoCorrelation_Function_data,AutoCorrelation_Function_data,name11,'A2');
        disp(strcat('Excel_outputpath_Output_AutoCorrelation_Function_data_Exceldata:',name11)); %Excel数据表的所有数据输入完毕
        
        figure,
        plot(lag(251:501)*dt,acor(251:501),'LineWidth',2);
        title('自相关系数'); xlabel('迟延时间/s'); ylabel('自相关系数');
        %axis([0,5,-100000,100000]);
        grid on;
        
        acor2=abs(acor);
        [A_max,L_max] = max(acor2);%求最大互相关值对应的值Am和索引值Lm
        Delay = lag(L_max)*dt; %迟延时间timedelay
        text(Delay,A_max,['(',num2str(Delay),',',num2str(A_max),')'],'color','b');%标出最大值
        
        print(gcf,'-dtiff',[Excel_Output_Path_Image,'AutoCorrelation_Function_',name11,'.tiff']);   %保存tiff格式的图片到指定路径
        close all;
        
    end
    
    %定义构造表头信息
    Excel_title{i,1}=name11;
    count=count+1,%计数
end

if i==21,
    %原始信号
    if Output_Original_Signal==1,
        
    end
    
    % 统计信息计算，包括平均值，标准差，偏度，峰度
    if Output_Statistical_Information==1,
        %表头及工况信息
        Case_m={'工况名称','平均值','标准差','平均绝对偏差','偏度Sk','峰度K'};
        E22={Case_m};
        E21={Excel_title};
        
        %% 输出数据及表头工况信息1
        %构建表头
        xlswrite(Excel_outputpath_Statistical_Information_data,E22{1,1},num2str(numi),'A1');
        disp('Excelheader output is OK!'); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_Statistical_Information_data,E21{1,1},num2str(numi),'A2');
        disp('Case_name output is OK!'); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_Statistical_Information_data,Bubble2_sum,num2str(numi),'B2');
        disp('Case_data output is OK!'); %Excel数据表的表头输入完毕
    end
    
    % 频谱分析
    if Output_Frequency_Analysis==1,
        
    end
    
    % 功率谱密度分析
    if Output_Power_Spectrum_Density_Analysis==1,
        
    end
    
    % 小波分析
    if Output_Wavelet_Analysis==1,
        %表头及工况信息
        Case_m={'工况名称','d1','d2','d3','d4','a4'};
        E22={Case_m};
        E21={Excel_title};
        
        %% 输出数据及表头工况信息
        %构建表头
        xlswrite(Excel_outputpath_Wavelet_Analysis_data,E22{1,1},num2str(numi),'A1');
        disp('Excelheader output is OK!'); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_Wavelet_Analysis_data,E21{1,1},num2str(numi),'A2');
        disp('Case_name output is OK!'); %Excel数据表的表头输入完毕
        
        xlswrite(Excel_outputpath_Wavelet_Analysis_data,Wavelet_Energy_Distribution_sum,num2str(numi),'B2');
        disp('Case_data output is OK!'); %Excel数据表的表头输入完毕
    end
    
    % 自相关函数计算
    if Output_AutoCorrelation_Function ==1,
        
    end
end
