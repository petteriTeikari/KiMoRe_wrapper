function joint_tables = re_arrange_data(data_as_struct)

    %% Go through the data    
    subj_codes = fieldnames(data_as_struct);
    for subj = 1 : length(subj_codes)
        subj_code = subj_codes{subj};
        exercises = fieldnames(data_as_struct.(subj_code));
        for ex = 1 : length(exercises)
            
            ex_idx = str2double(strrep(exercises{ex}, 'Es', ''));
            
            data_in = data_as_struct.(subj_codes{subj}).(exercises{ex});
            
            joint_tables.(subj_codes{subj}).(exercises{ex}) = combine_columns(data_in);
            
        end
    end

end


function joint_tables = combine_columns(data_in)

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
            orient = data_in.samples_orient{joint};        
            column_headers = ['time_ms'; data_in.col_headers_pos; data_in.col_headers_orient];
            time_vector = data_in.timestamps;
        else
            pos = NaN;
            orient = NaN;
            column_headers = NaN;
            time_vector = NaN;
        end
        % matrix_per_joint = [time_vector pos orient];      
        
        % Maybe there is more elegant way
        if ~isnan(time_vector)
            table_per_joint = table(time_vector, pos(:,1), pos(:,2), pos(:,3), pos(:,4), ...
                                    orient(:,1), orient(:,2), orient(:,3), orient(:,4), ...
                                    'VariableNames', column_headers);
        else
            % No raw data found for this subject            
            table_per_joint = table(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, ...
                                    'VariableNames', {'Time_ms', ...
                                        'cameraX', 'cameraY', 'cameraZ', 'confidenceState', ...
                                        'AbsQuat_1', 'AbsQuat_2', 'AbsQuat_3', 'AbsQuat_4'});
        end
        
        joint_tables.(joint_names{joint}) = table_per_joint;       
    end
    
end
