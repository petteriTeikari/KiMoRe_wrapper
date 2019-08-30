function json_export_wrapper(joints_structure, meta_as_struct, pathData)

    re_process_data = false;

    %% Static function defining what the Kimore is all about
    [label_index, full_label_string, condition_vector, es_vector] = define_kimore_classes();    
    
    % Check if the output path exists 
    pathData = fullfile(pathData, 'ntu_format');
    if ~exist(pathData, 'dir')
        mkdir(pathData)
    end
    
    %% Go through the subjects
    subject_names = fieldnames(joints_structure);
    
    % init the label .json
    fileID_labels = fopen(fullfile(pathData, 'labels.json'),'w');
    fprintf(fileID_labels,'{\n');


    %%
    subj_count = 1;
    for ind = 1 : length(subject_names)  
        
        subject_name = subject_names{ind};
        data_per_subject = joints_structure.(subject_name);        
        exer_labels = fieldnames(data_per_subject);
        
        for exer = 1 : length(exer_labels)  
            
            exer_label = exer_labels{exer};
            data_per_subj_per_ex = data_per_subject.(exer_label).joints;
            
            last_entry = false;
            if ind == length(subject_names) && exer == length(subject_names)  
                last_entry = true;
            end
            
            label_indx = json_get_idx_matching_subject(subject_name, exer, ...
                                                  condition_vector, es_vector);
            subject_id = [subject_name, exer_label];
            label_string = full_label_string{label_indx};
            label_ind = label_index(label_indx);            
            disp([subject_id, ' | ', num2str(label_ind) , ' | ', label_string])
            
            % write the label data (Kinetics format)
            json_write_labels(fileID_labels, label_string, ...
                              label_ind, subject_id, last_entry)
            
            % this is our individual entry (5 exercises per subject)
            json_process_indiv_ID(data_per_subj_per_ex, ...
                                  label_string, label_ind, ...
                                  subject_id, subj_count, pathData, ...
                                  re_process_data)
            
            subj_count = subj_count + 1;            
            
        end        
        % convert_
    end

    fprintf(fileID_labels,'}');
    fclose(fileID_labels);

    
end



