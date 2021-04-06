function [Acc, Gyro, name_list,p_status,vel,id_ls] = readDataFromPattern(folderpath_p,filePattern_3,f_patient)
%% LR = 1: right hand, LR = 2: left hand, LR = 0 ( 0 means not patients, don t have status)
p_status = [];
id_ls = [];
    filelinkfig = ['../data_im/'];
    filename = 'ID_Name.txt';
    IDname = importfilename(filename);
    name_list = [];
    %%
    files_3 = dir([folderpath_p '/' filePattern_3]);
    numfiles_3 = length(files_3);
    
    for m = 1:numfiles_3
        
        filename_3 = {files_3(m).name};
        myfilename_3 = char(filename_3);
        [pathstr_3,name_3,ext_3] = fileparts(myfilename_3);
        t = [folderpath_p name_3 '.txt'];
        mydataraw_3{m,1} = dlmread([folderpath_p name_3 '.txt']);
        mydata_3{m,1} = mydataraw_3{m,1};
        token = regexp(name_3,'\_','split');
        id = [token{1,1} token{1,4}];
        name_list{m} = getNameFromID(id,IDname);
        i_stat = 0;
        if(f_patient > 0) % patient
            i_stat = getLowerLimbStatusFromID(token{1,4},2);
            i_stat = str2num(i_stat);
        end
        p_status{m} = [' (' num2str(i_stat) ')'];
        id_ls{m,1} = id;
        id_ls{m,2} = i_stat;
        %% Normalize data
        mydata_3{m,1} = removeBATap([name_3], mydata_3{m,1});
        [Acc{m,1} Gyro{m,1}] = plotrawdata(mydata_3{m,1},filelinkfig,getNameFromID(id,IDname),name_3,'(Left Hand)');
        %
              %% Mean substraction
        Gyro{m,1} = Gyro{m,1} - mean(Gyro{m,1});
        Acc{m,1} = Acc{m,1} - mean(Acc{m,1});
        
        Fs = 50;
%         % resampling data to 5 Hz
%         Acc{m,1} = resample(Acc{m,1},5,50);
%         Fs = 5;
        %
        fc = 5;
        fc_g = 20;
        t = 1/Fs;
        %%
        org = Gyro{m,1};
%         Gyro{m,1}(:,1) = lowpass(Gyro{m,1}(:,1),Fs,fc_g);
%         Gyro{m,1}(:,2) = lowpass(Gyro{m,1}(:,2),Fs,fc_g);
%         Gyro{m,1}(:,3) = lowpass(Gyro{m,1}(:,3),Fs,fc_g);
        %%
%         org = mydata_3{m,1}(:,3:5);
%         Acc{m,1}(:,1) = lowpass(Acc{m,1}(:,1),Fs,fc);
%         Acc{m,1}(:,2) = lowpass(Acc{m,1}(:,2),Fs,fc);
%         Acc{m,1}(:,3) = lowpass(Acc{m,1}(:,3),Fs,fc);

        velocityx_3 = intergrationdata(Acc{m,1}(:,1),t);
        velocityy_3 = intergrationdata(Acc{m,1}(:,2),t);
        velocityz_3 = intergrationdata(Acc{m,1}(:,3),t);
        vel{m,1} = [velocityx_3';velocityy_3';velocityz_3']';
 %       
    %%
    %
    
%         figure;plot(Gyro{m,1});legend('gyro_x','gyro_y','gyro_z');
%         saveas(gcf,['./data_im/' name_3 '.png']);
         close all;
        figure;
        subplot(3,1,1);
        plot(Gyro{m,1});legend('gyro_x','gyro_y','gyro_z');
        %ylim([-500 500]);
        hold on
        title(filename_3);
        grid on
        subplot(3,1,2);
        plot(Acc{m,1});legend('acc_x','acc_y','acc_z');
        ylim([-10 10]);
        grid on
        subplot(3,1,3);
        plot(vel{m,1});legend('vel_x','vel_y','vel_z');
        grid on
        saveas(gcf,['./data_im_3/' name_3 name_list{m} '.png']);
        close all
        %}
    %
    end

end