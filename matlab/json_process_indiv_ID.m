function json_process_indiv_ID(data_per_subj_per_ex, ...
                                  label_string, label_ind, ...
                                  subject_id, subj_count, pathData, ...
                                  re_process_data)

    % TODO! Not probably the fastest to process, as
    % data_per_subj_per_ex is a matlab structure with n entries (n number
    % of joints) with each containing a table (rows are frames, and columns
    % are joint positions/orientations/etc)
    
    % Make this match NTU-RGBD Dataset(s) so that all the existing
    % preprocess / gendata scripts can be used for KiMoRe data without all
    % the associated wrangling

    % The default implementation only care about the x,y,z pose
    % coordinates, and not orientation (and not about the color, depth,
    % etc. information)
    
    %%
    format = 'ntu';
    no_of_frames = height(data_per_subj_per_ex.spinebase);
    joint_names = fieldnames(data_per_subj_per_ex);
    no_of_joints = length(joint_names);    
    col_headers = data_per_subj_per_ex.spinebase.Properties.VariableNames;
    
    
    %%       
    
    if (strcmp(format, 'ntu'))
        filename = fullfile(pathData, [subject_id, '.skeleton']);
    else
        error(['Format = ', format, ' not implemented yet'])
    end        
    
    file_already_done = false;
    if exist(filename, 'file') == 2
        file_already_done = true;
    end
    
    if file_already_done && ~re_process_data        
        disp(' skipping the re-process!')
        
    else
    
        fileID_data = fopen(filename,'w');
        fprintf(fileID_data,[num2str(no_of_frames), '\n']);

        %%    
        disp('FRAME:')
        fprintf('%s', '   '); 
        for fr = 1 : no_of_frames

            fprintf('%s ', num2str(fr))
            if rem(fr,30) == 0
                fprintf('%s\n', ' '); fprintf('%s', '   '); 
            end
            numBody = 1; % only 1 person per video in Kimore
            fprintf(fileID_data,[num2str(numBody), '\n']);

            cols = 12; % joint_info_key in ntu_gendata
            joints_per_frame = zeros(no_of_joints, cols);
            for j = 1 : no_of_joints            
                joint_name = joint_names{j};
                joint_as_table = data_per_subj_per_ex.(joint_name);
                [joints_per_frame(j,:), missing_value] = json_joints_from_struct_to_mat(joint_as_table, fr, cols);    
            end        

            % placeholder atm to comply with the "format"
            json_write_bodyInfo(fileID_data, subject_id, subj_count, joints_per_frame)

            % number of joints
            fprintf(fileID_data,[num2str(no_of_joints), '\n']);

            % write the joints
            json_write_frame(fileID_data, joints_per_frame, no_of_joints, cols)

        end    
        fprintf('%s\n\n', ' ')
        
    end

end
