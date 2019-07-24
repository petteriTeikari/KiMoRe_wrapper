function joints_w_meta = combine_meta_with_joints(joint_matrices, meta_as_struct)

    subj_names = fieldnames(joint_matrices);
    no_of_subject = length(subj_names);    
    joints_w_meta = joint_matrices;
    
    for subj = 1 : no_of_subject 
        joints_w_meta.(subj_names{subj}).meta = meta_as_struct.(subj_names{subj});
    end    

end