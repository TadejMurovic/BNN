% Tool flow:
    % Datasets Configuration a.k.a. binarization scripts  ==================================================
    %  1. Read Sets
    %  2. Partition Sets to Training, Validation and Testing Subsets
    %  3. Binarize Features
    %  4. Format Subsets

    % Train Networks ==========================================================
    %   Trains the BNN and outputs its weights.
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
    %   Takes the last weight dump and formats it for further processes.
    %   Arguments: 
    %       1.) Output weights path.
    
%% ------------------------------------------------------------------------
% Imaging

    % Dataset config:
    imaging_dataset_mnist;  
        
    % Train Network
    batch_size = 100;
    layer_size = 150;
    layer_nb   = 1;
    epoch_nb   = 100;
    outputs    = 1;
    
    call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\imaging\fds_mnist_valid.txt formatted_datasets\imaging\fds_mnist_train.txt formatted_datasets\imaging\fds_mnist_test.txt'));
    call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));     
    [status,cmdout] = system(call_str,'-echo');
        
    % Format Parameters
    call_str   = char(strcat({'bin_set.py bin_set\imaging '},num2str(1)));
    call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
    [status,cmdout] = system(call_str,'-echo');

    % Make standard combinational BNN verilog model
    make_model('bin_set\imaging',0,[400 1 150]);
    % Make optimized combinational BNN verilog model
    make_model('bin_set\imaging',1,[400 1 150]);

    
%% ------------------------------------------------------------------------
% Cybersecurity

    % Dataset config:
    cybersecurity_dataset_unswb15;  
        
    % Train Network
    batch_size = 100;
    layer_size = 100;
    layer_nb   = 1;
    epoch_nb   = 100;
    outputs    = 1;
    
    call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\cybersecurity\fds_unswb15_valid.txt formatted_datasets\cybersecurity\fds_unswb15_train.txt formatted_datasets\cybersecurity\fds_unswb15_test.txt'));
    call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
    [status,cmdout] = system(call_str,'-echo');
        
    % Format Parameters
    call_str   = char(strcat({'bin_set.py bin_set\cybersecurity '},num2str(1)));
    call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
    [status,cmdout] = system(call_str,'-echo');

    % Make standard combinational BNN verilog model
    make_model('bin_set\cybersecurity',0,[593 1 100]);
    % Make optimized combinational BNN verilog model
    make_model('bin_set\cybersecurity',1,[593 1 100]);
    
    
%% ------------------------------------------------------------------------
% High Energy Physics

    % Dataset config:
    hep_dataset_susy;  
        
    % Train Network
    batch_size = 100;
    layer_size = 75;
    layer_nb   = 2;
    epoch_nb   = 2000;
    outputs    = 1;
    
    call_str   = char(strcat({'bnn_train.py '},num2str(batch_size),{' '},num2str(layer_size),{' '},num2str(outputs),{' '},num2str(layer_nb),{' '},num2str(epoch_nb),{' '},'formatted_datasets\hep\fds_susy_valid.txt formatted_datasets\hep\fds_susy_train.txt formatted_datasets\hep\fds_susy_test.txt'));
    call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
    [status,cmdout] = system(call_str,'-echo');
        
    % Format Parameters
    call_str   = char(strcat({'bin_set.py bin_set\hep '},num2str(1)));
    call_str   = char(strcat({'set PATH=%PATH:C:\Program Files\MATLAB\R2017a\bin\win64;=% && '}, call_str));
    [status,cmdout] = system(call_str,'-echo');

    % Make standard combinational BNN verilog model
    make_model('bin_set\hep',0,[301 2 75]);
    % Make optimized combinational BNN verilog model
    make_model('bin_set\hep',1,[301 2 75]);
    