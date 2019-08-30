function json_write_labels(fileID_labels, label_string, label_ind, subject_id, last_entry)

    %% Write 5 lines per subject  
            
        % e.g. "---QUuC4vJs": {
        fprintf(fileID_labels, ['    "', subject_id, '": {\n']);
        % e.g.     "has_skeleton": true, 
        fprintf(fileID_labels,['        "has_skeleton": ', 'true', ',\n']);
        % e.g.     "label": "testifying", 
        fprintf(fileID_labels,['        "label": "', label_string, '",\n']);
        % e.g.     "label_index": 354
        fprintf(fileID_labels,['        "label_index": ', num2str(label_ind), '\n']);
        % e.g. }, 
        if last_entry
            fprintf(fileID_labels,'    {\n'); # TODO! Does not work?
        else % need the comma 
            fprintf(fileID_labels,'    },\n'); 
        end
    
    
end
