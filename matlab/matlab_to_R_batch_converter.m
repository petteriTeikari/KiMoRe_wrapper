function matlab_to_R_batch_converter() 

    % ORIGINAL PIPELINE defined individually for each folder
    % Joint_Position=csvread('JointPosition...');
    % Joint_Orientation=csvread('JointOrientation...');
    % preproc_Ex5
    % feat_extract_Ex5
    
    % Modified by Petteri Teikari, PhD, London UK, ptik
    % July 23 2019
    
    %% Parameters
    
        re_import_from_folders = false;
    
    %% Define data location    
    
        fileName = mfilename; fullPath = mfilename('fullpath');
        pathCode = strrep(fullPath, fileName, ''); cd(pathCode)        
        pathData = fullfile(pathCode, '..', '..', 'KiMoRe');       
       
    %% Import the raw data from the disk
    
        if re_import_from_folders
            disp('Importing data from the folders')
            [data_as_struct, meta_as_struct] = get_file_listing(pathData);
            disp('Saving imported data to disk as .mat')
            save(fullfile(pathData, 'folder_import.mat'), 'data_as_struct', 'meta_as_struct')
        else
            disp('Skipping the import from folders, and read the pre-imported .mat')
            load(fullfile(pathData, 'folder_import.mat'))
        end
        whos
        
    %% Compute the "derived features"
    
        derived_features = compute_derived_features(data_as_struct, meta_as_struct);
        
    %% Export the data to disk (to be used in R / Python)
        
        export_to_disk(data_as_struct, meta_as_struct, derived_features)

end

function export_to_disk(data_as_struct, meta_as_struct, derived_features) 
    
    %%
    [column_headers, time_vector, joint_matrices] = re_arrange_data(data_as_struct);
    save(fullfile(pathData, 'arranged_data.mat'), ...
        'column_headers', 'time_vector', 'joint_matrices', 'meta_as_struct')

end

