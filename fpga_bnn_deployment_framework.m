% Datasets Configuration ==================================================
%  1. Read Sets
%  2. Partition Sets to Training, Validation and Testing Subsets
%  3. Binarize Features
%  4. Format Subsets

% Train Networks ==========================================================
% Trains the BNN and outputs its weights.
%   Arguments: 
%       1.) Batch size.
%       2.) Number of neurons in a layer.
%       3.) Output vector width.
%       4.) Number of layers.
%       5.) Epochs.
%       6.) Valid set path.
%       7.) Train set path.
%       8.) Test set path.

% Format weights ==========================================================
% Takes the last weight dump and formats it for further processes.
%   Arguments: 
%       1.) Output weights path.



%% ------------------------------------------------------------------------
% Imaging --> MNIST dataset -----------------------------------------------
%%
% Dataset config:
    imaging_dataset_mnist;  
%%
for layer_n = 1%1:1:3
    id = 0;
    for layer_s = 150%5:20:250
        id = id + 1;
        % BNN Train: (set PATH command is added for my system only, it should be removed)
        batch_size = 100;
        layer_size = layer_s;
        layer_nb   = layer_n;
        epoch_nb   = 100;
        outputs    = 1;
        call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\imaging\fds_mnist_valid.txt formatted_datasets\imaging\fds_mnist_train.txt formatted_datasets\imaging\fds_mnist_test.txt'));

        call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
        [status,cmdout] = system(call_str,'-echo');

        k = strfind(cmdout,'ACCURACY: ');
        for i = 1:length(k)
            str = cmdout((k(i)+11):(k(i)+15));
            num = str2num(str);
            res(i) = num;
        end
        outo(layer_n,id) = res(end);
    end
    pause(1);
    figure(10);
    plot(res); hold on
    xlabel('Epoch');
    ylabel('Accuracy');
    title(['MNIST Dataset Performance']);
    pause(2); 
%     figure(100);
%     plot([5:20:250],outo(layer_n,:)); hold on
%     legend('L:1','L:2','L:3','L:4');
%     xlabel('Layer Size');
%     ylabel('Test Set Accuracy');
%     title(['MNIST Dataset Performance']);
%     pause(2);          
end
   
call_str   = char(strcat({'bin_set.py bin_set\imaging '},num2str(1)));
call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
[status,cmdout] = system(call_str,'-echo');

make_model('bin_set\imaging',0,[400 1 150]);
make_model('bin_set\imaging',1,[400 1 150]);
 
%% ------------------------------------------------------------------------
% Cybersecurity --> UNSWB15 dataset -----------------------------------------------
%%
% Dataset config:
    cybersecurity_dataset_unswb15;  
%%
for layer_n = 1%1:1:3
    id = 0;
    for layer_s = 100%5:20:250
    id = id + 1;
    % BNN Train: (set PATH command is added for my system only, it should be removed)
        batch_size = 100;
        layer_size = layer_s;%100;
        layer_nb   = layer_n;%1;
        epoch_nb   = 100;
        outputs    = 1;
        call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\cybersecurity\fds_unswb15_valid.txt formatted_datasets\cybersecurity\fds_unswb15_train.txt formatted_datasets\cybersecurity\fds_unswb15_test.txt'));

        call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
        [status,cmdout] = system(call_str,'-echo');

        k = strfind(cmdout,'ACCURACY: ');
        for i = 1:length(k)
            str = cmdout((k(i)+11):(k(i)+15));
            num = str2num(str);
            res(i) = num;
        end
        outo(layer_n,id) = res(end);
    end
    pause(1);
    figure(20);
    plot(res); hold on
    xlabel('Epoch');
    ylabel('Accuracy');
    title(['UNSWB15 Dataset Performance']);
    pause(2); 
%     figure(200);
%     plot([5:20:250],outo(layer_n,:)); hold on
%     legend('L:1','L:2','L:3','L:4');
%     xlabel('Layer Size');
%     ylabel('Test Set Accuracy');
%     title(['UNSWB15 Dataset'])
%     pause(2);
end
      
call_str   = char(strcat({'bin_set.py bin_set\cybersecurity '},num2str(1)));
call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
[status,cmdout] = system(call_str,'-echo');
 
make_model('bin_set\cybersecurity',0,[593 1 100]);
make_model('bin_set\cybersecurity',1,[593 1 100]);

%% ------------------------------------------------------------------------
% Internet of Things --> UJI dataset -----------------------------------------------
%%
% Dataset config:
    iot_dataset_uji;  
%%
for layer_n = 3%1:1:3
    id = 0;
    for layer_s = 100%5:20:250
    id = id + 1;
    % BNN Train: (set PATH command is added for my system only, it should be removed)
        batch_size = 100;
        layer_size = layer_s;%100;
        layer_nb   = layer_n;%1;
        epoch_nb   = 100;
        outputs    = 1;
        call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\iot\fds_uji_valid.txt formatted_datasets\iot\fds_uji_train.txt formatted_datasets\iot\fds_uji_test.txt'));

        call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
        [status,cmdout] = system(call_str,'-echo');

        k = strfind(cmdout,'ACCURACY: ');
        for i = 1:length(k)
            str = cmdout((k(i)+11):(k(i)+15));
            num = str2num(str);
            res(i) = num;
        end
        outo(layer_n,id) = res(end);
    end
    pause(1);
    figure(30);
    plot(res); hold on
    xlabel('Epoch');
    ylabel('Accuracy');
    title(['UJI Dataset Performance']);
    pause(2); 
%     figure(300);
%     plot([5:20:250],outo(layer_n,:)); hold on
%     legend('L:1','L:2','L:3','L:4');
%     xlabel('Layer Size');
%     ylabel('Test Set Accuracy');
%     title(['UJI Dataset Performance']);
%     pause(2);  
end

call_str   = char(strcat({'bin_set.py bin_set\iot '},num2str(3)));
call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
[status,cmdout] = system(call_str,'-echo');
 
make_model('bin_set\iot',0,[253 3 100]);
make_model('bin_set\iot',1,[253 3 100]);

%% ------------------------------------------------------------------------
% High Energy Physics --> SUSY dataset -----------------------------------------------
%%
% Dataset config:
    hep_dataset_susy;  
%%
for layer_n = 2%1:1:3
    id = 0;
    for layer_s = 75%5:20:250
    id = id + 1;
% BNN Train: (set PATH command is added for my system only, it should be removed)
        batch_size = 100;
        layer_size = layer_s;
        layer_nb   = layer_n;
        epoch_nb   = 2000;
        outputs    = 1;
        call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\hep\fds_susy_valid.txt formatted_datasets\hep\fds_susy_train.txt formatted_datasets\hep\fds_susy_test.txt'));

        call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
        [status,cmdout] = system(call_str,'-echo');

        k = strfind(cmdout,'ACCURACY: ');
        for i = 1:length(k)
            str = cmdout((k(i)+11):(k(i)+15));
            num = str2num(str);
            res(i) = num;
        end
        outo(layer_n,id) = res(end);
    end
    pause(1);
    figure(40);
    plot(res); hold on
    xlabel('Epoch');
    ylabel('Accuracy');
    title(['SUSY Dataset Performance']);
    pause(2); 
%     figure(400);
%     plot([5:20:250],outo(layer_n,:)); hold on
%     legend('L:1','L:2','L:3','L:4');
%     xlabel('Layer Size');
%     ylabel('Test Set Accuracy');
%     title(['SUSY Dataset Performance']);
%     pause(2);         
end

call_str   = char(strcat({'bin_set.py bin_set\hep '},num2str(2)));
call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
[status,cmdout] = system(call_str,'-echo');

make_model('bin_set\hep',0,[301 2 75]);
make_model('bin_set\hep',1,[301 2 75]);
