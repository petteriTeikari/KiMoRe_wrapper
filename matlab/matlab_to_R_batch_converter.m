function matlab_to_R_batch_converter() 

    % ORIGINAL PIPELINE defined individually for each folder
    % Joint_Position=csvread('JointPosition...');
    % Joint_Orientation=csvread('JointOrientation...');
    % preproc_Ex5
    % feat_extract_Ex5
    
    % Modified by Petteri Teikari, PhD, London UK, ptik
    % July 23 2019
    
    %% Parameters
    
        re_import_from_folders = true;
    
    %% Define data location    
    
        fileName = mfilename; fullPath = mfilename('fullpath');
        pathCode = strrep(fullPath, fileName, '');
        cd(pathCode)        
        pathData = fullfile(pathCode, '..', '..', 'KiMoRe');
        
       
    %% Import the raw data from the disk
    
        if re_import_from_folders
            disp('Importing data from the folders')
            plot_ON_to_disk = true;
            [data_as_struct, meta_as_struct] = get_file_listing(pathData, plot_ON_to_disk);
            disp('Saving imported data to disk as .mat')
            save(fullfile(pathData, 'folder_import.mat'), 'data_as_struct', 'meta_as_struct')
        else
            disp('Skipping the import from folders, and read the pre-imported .mat')
            load(fullfile(pathData, 'folder_import.mat'))
        end
        
    %% Compute the "derived features"
    
        derived_features = compute_derived_features(data_as_struct, meta_as_struct);
    
    %% Re-arrange the joint data
        
        joint_tables = re_arrange_data(data_as_struct);
    
    %% Combine the meta data with the arranged joint data
        
        % joints_w_meta = combine_meta_with_joints(joint_tables, meta_as_struct);
    
    %% Combine the derived features
    
        % TODO!    
        % joints_meta_feats = combine_derived_feats(joint_matrices, meta_as_struct);
        
    %% Export the data to disk (to be used in R / Python)
        
        export_to_disk(joint_tables, meta_as_struct, pathData)

end

function export_to_disk(joints_structure, meta_as_struct, pathData) 
    
    %% Quick'n'dirty .mat export (if you continue with Matlab analysis)
    save(fullfile(pathData, 'arranged_data.mat'), 'joints_structure')
    
    %% HDF5 export
    hdf5export_wrapper(fullfile(pathData, 'KiMoRe.h5'), joints_structure, meta_as_struct)


end

