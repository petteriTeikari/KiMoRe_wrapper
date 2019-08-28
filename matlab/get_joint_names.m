function joint_names = get_joint_names() 

    % https://kinectron.github.io/docs/api2.html#accessing-individual-joints
    joint_names = {'spinebase', 'spinemid', 'neck', 'head', 'shoulderleft', ... % 0-4
                   'elbowleft', 'wristleft', 'handleft', 'shoulderright', ... % 5-8
                   'elbowright', 'wristright', 'handright', 'hipleft', ... % 9-12
                   'kneeleft', 'ankleleft', 'footleft', 'hipright', ...  % 13-16
                   'kneeright', 'ankleright', 'footright', 'spineshoulder', ...  % 17-20
                   'handtipleft', 'thumbleft', 'handtipright', 'thumbright'}; % 21-24

    if length(unique(joint_names)) ~= 25
       error(['You should have had 25 joints save to the structure containing the tables ', ...
             'Now only ', num2str(length(unique(joint_names))), ' were defined! In other words you had duplicates']) 
    end
               
end