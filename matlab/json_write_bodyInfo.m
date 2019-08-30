function json_write_bodyInfo(fileID_data, subject_id, subj_count, joints_per_frame)

    %%
     keys = {'bodyID', 'clippedEdges', 'handLeftConfidence', 'handLeftState', 'handRightConfidence', 'handRightState', 'isRestricted', 'leanX', 'leanY', 'trackingState'};
     fprintf(fileID_data, [num2str(subj_count), ' ']);
     % TODO Lookup table to match the subj_count (integer) with the actual
     % subject_id (if needed)
     
     %% TODO! Derive the bodyInfo for the "frame_matrix" (joints_per_frame)?
     body_info_mat = repmat(NaN, 1, 9);
     for i = 1 : length(body_info_mat)
        fprintf(fileID_data, [num2str(body_info_mat(i)), ' ']); 
     end
     fprintf(fileID_data, '\n');
          
     
end