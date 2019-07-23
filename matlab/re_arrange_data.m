function [column_headers, time_vector, joint_matrices] = re_arrange_data(data_as_struct)

    %% Go through the data    
    subj_codes = fieldnames(data_as_struct);
    for subj = 1 : length(subj_codes)
        subj_code = subj_codes{subj};
        exercises = fieldnames(data_as_struct.(subj_code));
        for ex = 1 : length(exercises)
            
            ex_idx = str2double(strrep(exercises{ex}, 'Es', ''));
            
            data_in = data_as_struct.(subj_codes{subj}).(exercises{ex});
            
            [column_headers.(subj_codes{subj}).(exercises{ex}), ...
                time_vector.(subj_codes{subj}).(exercises{ex}), ...
                joint_matrices.(subj_codes{subj}).(exercises{ex})] = combine_columns(data_in);
            
        end
    end

end


function [column_headers, time_vector, joint_matrices] = combine_columns(data_in)

    %   data_in = 
    % 
    %   struct with fields:
    % 
    %            samples_pos: {25×1 cell}
    %         samples_orient: {25×1 cell}
    %        col_headers_pos: {4×1 cell}
    %     col_headers_orient: {4×1 cell}
    %                     TS: 35.3333
    %                     PO: 9.6667
    %                     CF: 25.6667
    %                    fps: 30
    %             timestamps: [462×1 double]
    
    %%
    no_of_joints = length(data_in.samples_pos);
    joint_names = get_joint_names();
    
    for joint = 1 : no_of_joints
               
        if iscell(data_in.samples_pos)
            pos = data_in.samples_pos{joint};
            orient = data_in.samples_pos{joint};        
            column_headers = ['Time [ms]'; data_in.col_headers_pos; data_in.col_headers_orient];
            time_vector = data_in.timestamps;
        else
            pos = NaN;
            orient = NaN;
            column_headers = NaN;
            time_vector = NaN;
        end
        matrix_per_joint = [pos orient];       
        
        joint_matrices.(joint_names{joint}) = matrix_per_joint;       
    end

    joint_matrices   
    
end
