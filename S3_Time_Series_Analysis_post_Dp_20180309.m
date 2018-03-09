%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ���ܣ�1���Դ��㲻ͬλ�ò�ѹʱ���źŵ�ԭʼ�źţ�ͳ����Ϣ���㣨ƽ��ֵ����׼�ƫ�ȡ���ȣ���Ƶ�׷������������ܶȡ�С�������������ֲ������ϵ���ȼ���
%%% ������K:\SimulationResults\UgpressureFB\UgpressureFBpost20180129
%%% ע�⣺������ȡ�ķ�������
%%% �μ���
%%% ���ڣ�2018��02��26��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all; close all; clc;
Path='K:\SimulationResults\UgpressureFB\UgpressureFBpost20180129';



%% ����ȷ��Ҫ���к��ּ���
for i0=1:1,
    Output_Original_Signal=0; % ԭʼ�ź�
    Output_Statistical_Information=0; % ͳ����Ϣ���㣬����ƽ��ֵ����׼�ƫ�ȣ����
    Output_Frequency_Analysis=0; % Ƶ�׷���
    Output_Power_Spectrum_Density_Analysis=1; % �������ܶȷ���
    PSD_Method=1;%�����õķ�����%1-PSD_WELCH������%2-���ֹ����׼��㷽���Ա�
    Output_Wavelet_Analysis=0;% С������
    Output_AutoCorrelation_Function =0;% ����غ�������
end

%%
count=0; %����ͳ�Ƽ���Ĺ�������
Excel_title=cell(21,1); %���ڴ�Ź���������
Bubble2_sum=[]; %���ڻ���ͳ�Ƽ�����
Wavelet_Energy_Distribution_sum=[]; %���ڻ���С������������

for i=1:1, %��Ӧ21������
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
    
    loadpath_mat=strcat(Path,'\','post����','\',name1,'-PgLocals.mat'); %'.mat'�ļ�������·��
    load(loadpath_mat);%���롰.mat���ļ���Ϣ
    DpressureVsTime=PgLocalsvsTime; %DPbedvsTime������Ϣ��ֵ��DpressureVsTime����
    
    %% ��������Ҫ�޸ĵĲ���
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numi=10; %��2-10��Ϊ��ѹ�ź�����,��9�飬��9�����У��ֶ��޸ģ��ֱ�Ϊ2,3,4,5,6,7,8,9,10
    
    Bubble1=DpressureVsTime(:,1);  %��1��Ϊʱ������
    Bubble20=DpressureVsTime(:,numi);  %��ѹ�ź�����,��9�飬��9�����У��ֶ��޸ģ��ֱ�Ϊ2,3,4,5,6,7,8,9,10
    name11=strcat(name1,'_',num2str(numi)); %������ļ�����
    
    Path2=strcat('K:\SimulationResults\UgpressureFB\UgpressureFBpost20180129','\������','\ѹ������');
    mkdir(Path2,num2str(numi)); %���ڴ����21����������ͬλ�ô��ļ���������
    Path3=strcat(Path2,'\',num2str(numi));
    mkdir(Path3,'����ͼ��'); %��Path3�ļ����´�����Ϊ������ͼ���ļ���
    
    Bubble21=Bubble20-mean(Bubble20); %��ѹ�ź�����,ȥ��ƽ��ֵ�������
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %���ڶ���������ı���·��
    for i1=1,
        Excel_Output_Path_Image=strcat(Path2,'\',num2str(numi),'\','����ͼ��\');%���屣��ԭʼ�ź�ͼ��·��
        Excel_outputpath_Original_Signal_data=strcat(Path2,'\',num2str(numi),'\','ԭʼ�ź���Ϣ����.xlsx');%���幤���ļ���ͳ������·��
        Excel_outputpath_Statistical_Information_data=strcat(Path2,'\',num2str(numi),'\','ͳ����Ϣ����.xlsx');%���幤���ļ���ͳ������·��
        Excel_outputpath_Frequency_Analysis_data=strcat(Path2,'\',num2str(numi),'\','�ź�Ƶ�׻���.xlsx');
        Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data=strcat(Path2,'\',num2str(numi),'\','�źŹ����׻���.xlsx');
        Excel_Outputpath_Wavelet_Sum_data=strcat(Path2,'\',num2str(numi),'\','С���任��Ƶ�ηֲ��������.xlsx');%���屣��С���任�����ֲ�����·��
        Excel_outputpath_Wavelet_Analysis_data=strcat(Path2,'\',num2str(numi),'\','С���任�����ֲ�����.xlsx');%���屣��С���任�����ֲ�����·��
        Excel_outputpath_AutoCorrelation_Function_data=strcat(Path2,'\',num2str(numi),'\','����غ�������.xlsx');%���屣��С���任�����ֲ�����·��
    end
    
    Fs=50;%����Ƶ��Ϊ50Hz
    N=251;
    xn=Bubble21;%ȥ����ѹ��ķ�ֵ���ݸ�ֵ��xn
    dt=1/Fs;%����ʱ����
    n=0:N-1;
    t=n*dt;%����ʱ��ֲ�
    
    %ԭʼ�ź�
    if  Output_Original_Signal==1;
        Original_data=[Bubble1,Bubble20,Bubble21];%���ڴ��ʱ�����ݣ�ԭʼ��ֵ���ݣ�ȥ����ѹ��ķ�ֵ����
        m1={'ʱ��','ԭʼ��ֵ','ȥ����ֵ���ֵ'};
        
        xlswrite(Excel_outputpath_Original_Signal_data,m1,name11,'A1');
        disp(strcat('Excel_outputpath_Original_Signal_data_Excelheader:',name11)); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_Original_Signal_data,Original_data,name11,'A2');
        disp(strcat('Excel_outputpath_Original_Signal_data_Exceldata:',name11)); %Excel���ݱ�����������������
        
        %         figure,
        %         plot(t,xn,'LineWidth',2);
        %         %axis([0,5,-1000,1500]);
        %         title('ԭʼ�źš���ʱ��ͼ');
        %         xlabel('ʱ��/s');
        %         ylabel('��ֵ');
        %         grid on;
        %         %print(gcf,'-dtiff',[Excel_Output_Path_Image,'Original_Signal_Image',name1,'.tiff'])   %����tiff��ʽ��ͼƬ��ָ��·��
        %         close all;
    end
    
    %ͳ�Ʒ���������ƽ��ֵ����׼���ȣ�ƫ��
    if Output_Statistical_Information==1,
        Bubble20_mean=mean(Bubble20);
        Bubble20_length=length(Bubble20);
        
        %�����׼��
        Bubble20_std=std(Bubble20);%��׼ƫ��
        
        %����ƽ������ƫ��
        Bubble21_Average_Absolute_Deviation=mean(abs(Bubble21));%ƽ������ƫ��
        
        %���֥, ����ѭ������������¯��������������CPFD��ֵģ���ʵ���о�, 2015, �й���ѧԺ�о���Ժ(�����������о���).P43
        %����ƫ��
        Bubble20_Sk_sum=0;
        for j=1:Bubble20_length,
            Bubble20_Sk_sum=Bubble20_Sk_sum+Bubble21(j)^3;
        end
        Bubble20_Sk=Bubble20_Sk_sum/(N*Bubble20_std^3);
        
        %���֥, ����ѭ������������¯��������������CPFD��ֵģ���ʵ���о�, 2015, �й���ѧԺ�о���Ժ(�����������о���).P43
        %������
        Bubble20_K_sum=0;
        
        for j=1:Bubble20_length,
            Bubble20_K_sum=Bubble20_K_sum+Bubble21(j)^4;
        end
        
        Bubble20_K=Bubble20_K_sum/(N*Bubble20_std^4);
        
        Bubble2_Temp=[Bubble20_mean,Bubble20_std,Bubble21_Average_Absolute_Deviation,Bubble20_Sk,Bubble20_K];%�ֱ�Ϊƽ��ֵ����׼�����ƫ��ƽ��ֵ��ƫ��Sk�����K
        Bubble2_sum=[Bubble2_sum;Bubble2_Temp];%���ܼ���Ľ���������Excel�Ĵ�����������ڻ��ܺ������
    end
    
    %Ƶ�׷���
    if Output_Frequency_Analysis==1,
        y=fft(xn,N);%����Ҷ�任
        mag=abs(y);
        f=(0:length(y)-1)'*Fs/length(y);%������Ƶ�ʵı��ʽΪf=(0:M-1)*Fs/M;
        frequency_data=[f(1:N/2),mag(1:N/2)];
        
        m2={'Ƶ��/Hz','��ֵ'};
        xlswrite(Excel_outputpath_Frequency_Analysis_data,m2,name11,'A1');
        disp(strcat('Excel_outputpath_Frequency_Analysis_data_Excelheader:',name11)); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_Frequency_Analysis_data,frequency_data,name11,'A2');
        disp(strcat('Excel_outputpath_Frequency_Analysis_data_Exceldata:',name11)); %Excel���ݱ�����������������
        
        figure,
        plot(f(1:N/2),mag(1:N/2),'LineWidth',2);%����Ƶ��ͼ
        %axis([0,25,0,40000])
        title('Ƶ��ͼ');
        xlabel('Ƶ��/Hz');
        ylabel('��ֵ');
        grid on;
        
        print(gcf,'-dtiff',[Excel_Output_Path_Image,'Frequency_Analysis_Image_',name11,'.tiff']);  %����tiff��ʽ��ͼƬ��ָ��·��
        close all;
    end
    
    %�������ܶȷ���
    if  Output_Power_Spectrum_Density_Analysis==1,
        switch PSD_Method,
            case 1, %PSD_WELCH����(�Ľ�������ͼ�����׹��Ʒ���)����������
                %Matlab�У�����psd()�ͺ���pwelch()����ʵ��Welch�����Ĺ����׹��ƣ��ο��̲ģ�����źŷ�������3�棩֣΢�����ӹ�ҵ�����磬2017��
                
                nfft=251; %FFT�任����
                Nseg=251; %�ֶμ��
                window1=hamming(length(xn)); %ѡ�õĴ���-������
                noverlap=100; %�ֶ������ص��Ĳ������������ȣ�
                range='half'; %Ƶ�ʼ��Ϊ[0 Fs/2]��ֻ����һ���Ƶ��
                f=(0:Nseg/2)*Fs/Nseg; %Ƶ��������
                
                Sx1=psd(xn,Nseg,Fs,window1,noverlap,'none');
                %Sx1=10*log10(Sx1);
                Plot_Pxx11=Sx1;
                Plot_Pxx12=10*log10(Sx1);
                
                Sx2=pwelch(xn,window1,noverlap,nfft,Fs,'oneside')*Fs/2; %pwelch()���صĵ��߹����������Fs/2
                %Sx2=10*log10(Sx2);
                Plot_Pxx21=Sx2;
                Plot_Pxx22=10*log10(Sx2);
                
                window2=boxcar(length(xn));      %PSD_WELCH�����������δ�
                Sx3=pwelch(xn,window2,noverlap,N,Fs,'oneside')*Fs/2;
                Plot_Pxx31=Sx3;
                Plot_Pxx32=10*log10(Sx3);
                
                %���ƹ���������ͼ���Ƕ������꣩
                figure,
                subplot(3,1,1),
                plot(f,Sx1,'LineWidth',2);
                grid on;
                xlabel('Ƶ��/Hz');
                ylabel('������');
                title('������-Welch��-psd()����');
                
                subplot(3,1,2),
                plot(f,Plot_Pxx21,'LineWidth',2);  %���ƹ�����
                %axis([0,25,0,300000])
                xlabel('Ƶ��/Hz');
                ylabel('������');
                title('������-Welch��-������-pwelch()����');
                grid on
                
                subplot(3,1,3),
                plot(f,Plot_Pxx31,'LineWidth',2);
                %axis([0,25,0,300000]);
                xlabel('Ƶ��/Hz');
                ylabel('������');
                title('������-Welch��-���δ�-pwelch()����');
                grid on
                
                print(gcf,'-dtiff',[Excel_Output_Path_Image,'Power_Spectrum_Density_Analysis_',name11,'_1.tiff'])   %����tiff��ʽ��ͼƬ��ָ��·��
                close all;
                
                data1_Pxx1=[f',Plot_Pxx21];
                data2_Pxx1=[f',Plot_Pxx22];
                
                m3={'Ƶ��/Hz','pwelch()��ֵ','Ƶ��','pwelch()����ֵ'};
                xlswrite(Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data,m3,name11,'A1');
                disp(strcat('Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data1_Excelheader:',name11)); %Excel���ݱ�ı�ͷ�������
                
                xlswrite(Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data,data1_Pxx1,name11,'A2');
                disp(strcat('Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data1_Exceldata:',name11)); %Excel���ݱ�����������������
                
                xlswrite(Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data,data2_Pxx1,name11,'C2');
                disp(strcat('Excel_outputpath_Output_Power_Spectrum_Density_Analysis_data2_Exceldata:',name11)); %Excel���ݱ�����������������
                
                %���ƹ���������ͼ���������꣩
                figure,
                subplot(3,1,1),
                plot(f,Plot_Pxx12,'LineWidth',2);  %���ƹ�����
                %axis([0,25,0,300000])
                xlabel('Ƶ��/Hz');
                ylabel('������');
                title('������-Welch��-psd()����');
                grid on;
                
                subplot(3,1,2),
                plot(f,Plot_Pxx22,'LineWidth',2);  %���ƹ�����
                %axis([0,25,0,300000])
                xlabel('Ƶ��/Hz');
                ylabel('������');
                title('������-Welch��-������-pwelch()����');
                grid on;
                
                subplot(3,1,3),
                plot(f,Plot_Pxx32,'LineWidth',2);
                %axis([0,25,0,300000]);
                title('������-Welch��-���δ�-pwelch()����');
                xlabel('Ƶ��/Hz');
                ylabel('������');
                grid on;
                
                print(gcf,'-dtiff',[Excel_Output_Path_Image,'Power_Spectrum_Density_Analysis_Log_',name11,'_2.tiff'])   %����tiff��ʽ��ͼƬ��ָ��·��
                close all;
                
                %���д��ڵĳ���N��ʾÿ�δ���ķֶ����ݳ��ȣ�Noverlap��ָ������������֮����ص����ֳ��ȡ�
                %NԽ��õ��Ĺ����׷ֱ���Խ��(Խ׼ȷ)��������Ӵ�(�����������߲�̫ƽ��)��NԽС������ķ�����С��
                %�������׷ֱ��ʽϵ�(���ƽ����̫׼ȷ)��
                %pwelch����NFFT,��FFT�ĸ������ǿ��Ա仯�ġ�������󳤶Ȳ��ܳ���ÿһ�εĵ�����
                %��Ȼ���ܶ���������ǰ�NFFT����ÿһ�εĵ������������Եõ���ߵ�Ƶ��ֱ��ʡ�
                %���NFFT = ÿһ�ε�һ�룬Ƶ��ֱ��ʵ�һ����
            case 2,
                %�����������������㹦���׵ķ���
        end
    end
    
    %С������
    if Output_Wavelet_Analysis==1,
        [cA,cD]=wavedec(xn,4,'db2');%%����db2С�����źŽ���4��ֽ⣻�ֱ��Ӧ��Ƶ��Ϊ��25����50Hz��12.5����25Hz��6.25����12.5Hz��3.125����6.25Hz��0����3.125Hz��
        %[cA,cD]=wavedec(X,1,��wname��)�з��صĽ��ƺ�ϸ�ڶ������cA�У���C=[cA,cD]��L����ǽ��ƺ͸���ϸ��ϵ����Ӧ�ĳ���
        
        %�ź��ع�
        %a4=wrcoef('type',cA,cD,'wname',N); %type=a�ǶԵ�Ƶ���ֽ����ع���type=d�ǶԸ�Ƶ���ֽ����ع���NΪ�źŵĲ���
        
        a4=wrcoef('a',cA,cD,'db2',4); %0-3.125Hz��    �ع���4���Ƶ�ź�
        d4=wrcoef('d',cA,cD,'db2',4); %3.125-6.25Hz�� �ع���4���Ƶ�ź�
        d3=wrcoef('d',cA,cD,'db2',3); %6.25-12.5Hz��  �ع���3���Ƶ�ź�
        d2=wrcoef('d',cA,cD,'db2',2); %12.5-25Hz��    �ع���2���Ƶ�ź�
        d1=wrcoef('d',cA,cD,'db2',1); %25-50Hz��      �ع���1���Ƶ�ź�
        
        wavelet_sum_signals=[t',a4,d4,d3,d2,d1,xn];%ע�������t������������ת��Ϊ������
        
        m5={'t','a4','d4','d3','d2','d1','xn'};
        xlswrite(Excel_Outputpath_Wavelet_Sum_data,m5,name11,'A1');
        disp(strcat('Excel_Outputpath_Wavelet_Sum_data_Excelheader:',name11)); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_Outputpath_Wavelet_Sum_data,wavelet_sum_signals,name11,'A2');
        disp(strcat('Excel_Outputpath_Wavelet_Sum_data_Exceldata:',name11)); %Excel���ݱ�����������������
        
        %���������ź���Ϣ
        figure,
        subplot(6,1,1),
        plot(t,a4,'linewidth',2);
        %axis([0,5,-200,200]);
        ylabel('a4');
        grid on;%��4���Ƶ�ź�
        
        subplot(6,1,2),
        plot(t,d4,'linewidth',2);
        %axis([0,5,-500,500]);
        ylabel('d4');
        grid on;%��4���Ƶ�ź�
        
        subplot(6,1,3),
        plot(t,d3,'linewidth',2);
        %axis([0,5,-1000,1000]);
        ylabel('d3');
        grid on;%��3���Ƶ�ź�
        
        subplot(6,1,4),
        plot(t,d2,'linewidth',2);
        %axis([0,5,-1000,1000]);
        ylabel('d2');
        grid on;%��2���Ƶ�ź�
        
        subplot(6,1,5),
        plot(t,d1,'linewidth',2);
        %axis([0,5,-200,200]);
        ylabel('d1');
        grid on;%��1���Ƶ�ź�
        
        subplot(6,1,6),
        plot(t,xn,'linewidth',2);
        %axis([0,5,-1000,1000]);
        ylabel('xn');
        grid on;%ԭʼ�ź�
        xlabel('t/s');
        
        print(gcf,'-dtiff',[Excel_Output_Path_Image,'Wavelet_Analysis_',name11,'.tiff'])   %����tiff��ʽ��ͼƬ��ָ��·��
        close all;
        
        %�źŵ���������
        [Ea,Ed]=wenergy(cA,cD);%Ea��ʾ��Ƶ�����ٷֱȣ�%Ed��ʾ��Ƶ�����ٷֱ�
        Wavelet_Energy_Distribution=[Ed,Ea];%˳��Ϊd1,d2,d3,d4,a4
        Wavelet_Energy_Distribution_sum=[Wavelet_Energy_Distribution_sum;Wavelet_Energy_Distribution];
    end
    
    %����غ�������
    if Output_AutoCorrelation_Function==1,
        [acor,lag] = xcorr(xn,'unbiased');%��ȡ����غ�����lag���Ӳ�����acor���ϵ��
        
        lag_t=lag(251:501)*dt;%Ϊ������
        acor_t=acor(251:501);%Ϊ������
        AutoCorrelation_Function_data=[lag_t',acor_t];
        
        m4={'����ʱ��','���ϵ��'};
        xlswrite(Excel_outputpath_AutoCorrelation_Function_data,m4,name11,'A1');
        disp(strcat('Excel_outputpath_AutoCorrelation_Function_data_Excelheader:',name11)); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_AutoCorrelation_Function_data,AutoCorrelation_Function_data,name11,'A2');
        disp(strcat('Excel_outputpath_Output_AutoCorrelation_Function_data_Exceldata:',name11)); %Excel���ݱ�����������������
        
        figure,
        plot(lag(251:501)*dt,acor(251:501),'LineWidth',2);
        title('�����ϵ��'); xlabel('����ʱ��/s'); ylabel('�����ϵ��');
        %axis([0,5,-100000,100000]);
        grid on;
        
        acor2=abs(acor);
        [A_max,L_max] = max(acor2);%��������ֵ��Ӧ��ֵAm������ֵLm
        Delay = lag(L_max)*dt; %����ʱ��timedelay
        text(Delay,A_max,['(',num2str(Delay),',',num2str(A_max),')'],'color','b');%������ֵ
        
        print(gcf,'-dtiff',[Excel_Output_Path_Image,'AutoCorrelation_Function_',name11,'.tiff']);   %����tiff��ʽ��ͼƬ��ָ��·��
        close all;
        
    end
    
    %���幹���ͷ��Ϣ
    Excel_title{i,1}=name11;
    count=count+1,%����
end

if i==21,
    %ԭʼ�ź�
    if Output_Original_Signal==1,
        
    end
    
    % ͳ����Ϣ���㣬����ƽ��ֵ����׼�ƫ�ȣ����
    if Output_Statistical_Information==1,
        %��ͷ��������Ϣ
        Case_m={'��������','ƽ��ֵ','��׼��','ƽ������ƫ��','ƫ��Sk','���K'};
        E22={Case_m};
        E21={Excel_title};
        
        %% ������ݼ���ͷ������Ϣ1
        %������ͷ
        xlswrite(Excel_outputpath_Statistical_Information_data,E22{1,1},num2str(numi),'A1');
        disp('Excelheader output is OK!'); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_Statistical_Information_data,E21{1,1},num2str(numi),'A2');
        disp('Case_name output is OK!'); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_Statistical_Information_data,Bubble2_sum,num2str(numi),'B2');
        disp('Case_data output is OK!'); %Excel���ݱ�ı�ͷ�������
    end
    
    % Ƶ�׷���
    if Output_Frequency_Analysis==1,
        
    end
    
    % �������ܶȷ���
    if Output_Power_Spectrum_Density_Analysis==1,
        
    end
    
    % С������
    if Output_Wavelet_Analysis==1,
        %��ͷ��������Ϣ
        Case_m={'��������','d1','d2','d3','d4','a4'};
        E22={Case_m};
        E21={Excel_title};
        
        %% ������ݼ���ͷ������Ϣ
        %������ͷ
        xlswrite(Excel_outputpath_Wavelet_Analysis_data,E22{1,1},num2str(numi),'A1');
        disp('Excelheader output is OK!'); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_Wavelet_Analysis_data,E21{1,1},num2str(numi),'A2');
        disp('Case_name output is OK!'); %Excel���ݱ�ı�ͷ�������
        
        xlswrite(Excel_outputpath_Wavelet_Analysis_data,Wavelet_Energy_Distribution_sum,num2str(numi),'B2');
        disp('Case_data output is OK!'); %Excel���ݱ�ı�ͷ�������
    end
    
    % ����غ�������
    if Output_AutoCorrelation_Function ==1,
        
    end
end
