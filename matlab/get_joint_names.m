function joint_names = get_joint_names() 

    % https://medium.com/@lisajamhoury/understanding-kinect-v2-joints-and-coordinate-system-4f4b90b9df16
    joint_names = {'spinebase', 'spinemid', 'neck', 'head', 'shoulderleft', ... % 0-4
                   'elbowleft', 'wristleft', 'handtipleft', 'shoulderright', ... % 5-8
                   'elbowright', 'wristright', 'handtipright', 'hipleft', ... % 9-12
                   'kneeleft', 'ankleleft', 'footleft', 'hipright', ...  % 13-16
                   'kneeright', 'ankleright', 'footright', 'spineshoulder', ...  % 17-20
                   'handtipleft', 'thumbleft', 'handtipright', 'thumbright'}; % 21-24

end