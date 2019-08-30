function [label_index, full_label_string, condition_vector, es_vector] = ...
                                                        define_kimore_classes()

    % the .jsons for the Kinetics labels look like this:
    %     "zzzzE0ncP1Y": {
    %         "has_skeleton": true, 
    %         "label": "changing oil", 
    %         "label_index": 52
    %     }
    
    % 1) some subject identifier
    % 2) "has_skeleton": always tend to be true
    % 3) "label": string for human-readable label
    % 4) "label_index": 0.. y_i labels used for training
    
    %% we can start with 5 classes x 5 exercises which might (25 labels)
    labels_5 = {'CG-E', 'CG-NE', 'GPP-S', 'GPP-P', 'GPP-B'};
    exercs_5 = {'es1_Lifting of the arms', ...
                'es2_Lateral tilt of the trunk with the arms in extension', ...
                'es3_Trunk rotation', ...
                'es4_Pelvis rotations on the transverse plane', ...
                'es5_Squatting'};
            
    label_count = 0;
    
    full_label_string = cell(length(labels_5)*length(exercs_5), 1);
    label_index = zeros(length(labels_5)*length(exercs_5), 1);
    
    % save these as "LUTs"
    condition_vector = cell(length(labels_5)*length(exercs_5), 1);
    es_vector = cell(length(labels_5)*length(exercs_5), 1);
    
    for l = 1 : length(labels_5)        
        for e = 1 : length(exercs_5)   
            label_index(label_count+1) = label_count; % first label index is 0
            label_count = label_count + 1;
            full_label_string{label_count} = [labels_5{l}, '_', exercs_5{e}];
            condition_vector{label_count} = labels_5{l};
            es_vector{label_count} = exercs_5{e};
        end        
    end

end