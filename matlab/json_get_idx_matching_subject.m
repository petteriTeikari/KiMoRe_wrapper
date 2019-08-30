function label_indx = json_get_idx_matching_subject(subject_name, exer, ...
                                                  condition_vector, es_vector)
   
    %% stupid data wrangling
    cell_split = split(subject_name, '_');
    group = cell_split{1};
    
    switch group
        case 'E'
            lab_ind = 1;
        case 'NE'
            lab_ind = 2;                      
        case 'S'
            lab_ind = 3;                        
        case 'P'
            lab_ind = 4;                        
        case 'B'
            lab_ind = 5;                        
        otherwise            
    end
    
    label_indx = (lab_ind-1)*5 + exer;
    
end