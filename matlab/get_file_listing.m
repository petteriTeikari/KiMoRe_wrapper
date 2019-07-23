function [data_as_struct, meta_as_struct] = get_file_listing(pathData)
    
    %% https://uk.mathworks.com/matlabcentral/answers/32038-can-you-use-dir-to-list-files-in-subfolders
    
        % You need one dir() call on the current folder, and you look 
        % at the isdir() field of the results to see which names 
        % correspond to folders:
        dirinfo = dir_script(pathData);
        files_data = 0;

        % CG - NotExpert - NE_ID2 - ES5 - Label (4 subfolders inside the dirinfo)
        % GPP - BackPain - B_ID3 - ES2 - Label (4 subfolders)
        % only the last folder has some files to read, the previous one just
        % give you metadata
               
        
    %% Go through the subfolders    
        
        subjCount = 0;
    
        for group = 1 : length(dirinfo)
          thisdir = dirinfo(group).name;
          dirinfo2 = dir_script(fullfile(pathData, thisdir));
          
            for subgroup = 1 : length(dirinfo2)
                thisdir2 = dirinfo2(subgroup).name;
                dirinfo3 = dir_script(fullfile(pathData, thisdir, thisdir2));
            
                for subject = 1 : length(dirinfo3)
                    subjCount = subjCount + 1;
                    thisdir3 = dirinfo3(subject).name;
                    disp(['SUBJECT ', thisdir3, ' (', num2str(subjCount), ' out of 78 subjects)'])
                    dirinfo4 = dir_script(fullfile(pathData, thisdir, thisdir2, thisdir3));
                
                    for exercise = 1 : length(dirinfo4)
                        thisdir4 = dirinfo4(exercise).name;
                        dirinfo5 = dir_script(fullfile(pathData, thisdir, thisdir2, thisdir3, thisdir4));
                    
                        % Now we are in the folder with Label/Raw/Script
                        for data_folder = 1 : length(dirinfo5)
                            
                           thisdir5 = dirinfo5(data_folder).name;
                           full_path = fullfile(pathData, thisdir, thisdir2, thisdir3, thisdir4, thisdir5);
                           dirinfo6 = dir(full_path);
                           
                           if strcmp(thisdir5, 'Label') 
                               [TS, PO, CF, meta] = ...
                                   import_label_data(full_path, dirinfo6, ' ', exercise, subject);
                           elseif strcmp(thisdir5, 'Raw') 
                               [samples_pos, samples_orient, col_headers_pos, col_headers_orient, timestamps, fps] = ...
                                   import_raw_data(full_path, dirinfo6, ' ', exercise, subject);
                           else
                               % disp(['No specific action defined for subfolder name = ', thisdir5])
                           end                            
                            
                        end
                        
                        data_as_struct.(thisdir3).(thisdir4).samples_pos = samples_pos;
                        data_as_struct.(thisdir3).(thisdir4).samples_orient = samples_orient;
                        data_as_struct.(thisdir3).(thisdir4).col_headers_pos = col_headers_pos;
                        data_as_struct.(thisdir3).(thisdir4).col_headers_orient = col_headers_orient;
                        data_as_struct.(thisdir3).(thisdir4).TS = TS;
                        data_as_struct.(thisdir3).(thisdir4).PO = PO;
                        data_as_struct.(thisdir3).(thisdir4).CF = CF;
                        data_as_struct.(thisdir3).(thisdir4).fps = fps;
                        data_as_struct.(thisdir3).(thisdir4).timestamps = timestamps;                        
                        
                        meta_as_struct.(thisdir3) = meta;
                        meta_as_struct.(thisdir3).data_group = thisdir;
                        meta_as_struct.(thisdir3).data_subgroup = thisdir2;
                                                
                    end
                end
            end   
        end

end


function dirinfo = dir_script(pathData) 

    dirinfo = dir(pathData);
    dirinfo(~[dirinfo.isdir]) = [];  %remove non-directories
    tf = ismember( {dirinfo.name}, {'.', '..'});
    dirinfo(tf) = [];  %remove current and parent directory.

end

function [TS, PO, CF, meta] = import_label_data(thisdir, dirinfo, specifier, exercise, subject)
    % disp(['Importing LABEL data of ', specifier])
    % There should be two files now
    % * ClinicalAssessment_X_XXX.xlsx
    % * SuppInfo_X_XXX.xlsx
    tf = ismember( {dirinfo.name}, {'.', '..'});
    dirinfo(tf) = [];  %remove current and parent directory.
        
    for file_idx = 1 : length(dirinfo)        
        filename_in = fullfile(thisdir, dirinfo(file_idx).name);
        [num,txt,raw] = xlsread(filename_in);
        if contains(dirinfo(file_idx).name, 'ClinicalAssessment')
            [TS, PO, CF] = parse_clin_assment(raw, exercise);
        elseif contains(dirinfo(file_idx).name, 'SuppInfo')
            meta = parse_supp_info(raw, subject);
        else
            disp(['Should not go here, or you have extra files?: ', dirinfo(file_idx).name])
        end
    end
    
end


function [samples_pos, samples_orient, col_headers_pos, col_headers_orient, timestamps, fps] = ...
            import_raw_data(thisdir, dirinfo, specifier, exercise, subject)

    % disp(['Importing RAW data of ', specifier])
    
    % There are now 3 files:
    % * JointOrientation011214_103748.csv
    % * JointPosition011214_103748.csv
    % * TimeStamp011214_103748.csv
    % (TimeStampDDMMYY XXXXXX), where DDMMYY refers to the acquisition date 
    % and XXXXXX are associated numbers for each recording;
    
    % TODO! If you want to process the RGB and D videos!
    tf = ismember( {dirinfo.name}, {'.', '..'});
    dirinfo(tf) = [];  %remove current and parent directory.
    
    no_of_files_and_dirs = length(tf);
    no_of_valid_files_and_dirs = sum(~tf);
    
    if no_of_valid_files_and_dirs >= 3
        
        for file_idx = 1 : length(dirinfo)        

            filename_in = fullfile(thisdir, dirinfo(file_idx).name);        
            mat = csvread(filename_in);              

            % Note! If you open the .csv files in Excel, you notice that there
            % are some empty rows in the beginning of the files, csvread
            % ignores them automatically (it seems like it at least on 2017a) s
            % so no need for special filtering here        
            % mat = remove_empty_rows(mat);
            size_in = size(mat);

            if contains(dirinfo(file_idx).name, 'JointPosition')
                type_of_data = 'JointPosition';
                [samples_pos, col_headers_pos] = parse_joints(dirinfo(file_idx).name, mat, exercise, size_in, type_of_data);
            elseif contains(dirinfo(file_idx).name, 'JointOrientation')
                type_of_data = 'JointOrientation';
                [samples_orient, col_headers_orient] = parse_joints(dirinfo(file_idx).name, mat, exercise, size_in, type_of_data);       
            elseif contains(dirinfo(file_idx).name, 'TimeStamp')
                [timestamps, delta_ms, fps] = parse_timestamps(dirinfo(file_idx).name, mat, size_in);
            elseif contains(dirinfo(file_idx).name, 'depth')
                % TODO!            
            elseif contains(dirinfo(file_idx).name, 'RGB')
                % TODO!
            else
                disp(['Should not go here, or you have extra files?: ', dirinfo(file_idx).name])
            end

        end 
        
    else
        
        warning(['No RAW files found from = ', thisdir])
        samples_pos = NaN;
        samples_orient = NaN;
        col_headers_pos = NaN;
        col_headers_orient = NaN;
        timestamps = NaN;
        fps = NaN;
        
    end

end

function [samples, col_headers] = parse_joints(filename, mat, exercise, size_in, type_of_data)

    % KiMoRe paper:
    % "the Raw folder includes raw data acquired directly from the 
    %  Kinect v2 sensor that are related to the RGB video, depth video, 
    %  the joint positions and orientations, and the time stamp 
    %  with the acquisition times."

    % https://docs.microsoft.com/en-us/previous-versions/windows/kinect/dn758665(v%3Dieb.10)
    % https://github.com/kinect/docs
    
    % See Understanding Kinect V2 Joints and Coordinate System
    % https://medium.com/@lisajamhoury/understanding-kinect-v2-joints-and-coordinate-system-4f4b90b9df16
    
    % The Kinect can track up to six skeletons at one time. Each of these skeletons has 25 joints.
    NO_OF_JOINTS = 25;
    NO_OF_VARS_PER_JOINT = 4;
    % Each joint has 11 properties: color (x, y); 
    %                               depth (x, y); 
    %                               camera (x, y, z); 
    %                               and orientation( x, y, z, w).

    no_of_timepoints = size_in(1); % samples, e.g. 1134
    no_of_measures_per_sample = size_in(2); % 100

    % Hmmm... TODO! there are for some reason 101 columns now, 1 extra
    % 0 at the end. Some Windows/Unix line end thing?
    if size_in(2) == 101
        mat = mat(:,1:100);
    elseif size_in(2) == 100
        % the correct number of columns 4x no_of_joints
    else
        disp([filename, ' - YOU HAVE NOW unexpected number of columns! no_of_columns = ', num2str(size_in(2))])
        mat = mat(:,1:100);
    end
    size_in = size(mat);
    
    % disp([filename, ': no of rows (samples) = ', num2str(size_in(1)), ', no of cols (joints) = ', num2str(size_in(2))])        
    
    idxs = cell(NO_OF_JOINTS,1);
    samples = cell(NO_OF_JOINTS,1);
    
    for joint = 1 : NO_OF_JOINTS
        start_idx = ((joint-1)*NO_OF_VARS_PER_JOINT)+1;
        idxs{joint} = [start_idx:(start_idx+NO_OF_VARS_PER_JOINT-1)];
        samples{joint} = mat(:,idxs{joint});
    end
    
    if strcmp(type_of_data, 'JointOrientation')
        
        % Kinect uses quaternions to deliver joint orientation. 
        % A common pitfall here is to assume that orientation 
        % coordinates (x, y, z) are equal to yaw, pitch and roll, 
        % and coordinate w can be conveniently discarded. 
        % In fact, quaternions are a 4D way to store the 3D orientation, 
        % and they need to be converted to be useful.
        
        % [Quaternions] are a way to describe an orientation in 
        % 3d space and are used to avoid gimbal-lock related problems, 
        % which arise from using Euler angles for rotation. 
        % They provide a great way to store and animate rotations, 
        % but ultimately are converted back to matrix form and your 
        % graphics programming environment most-likely 
        % provides functions to do this.
        col_headers = {'AbsQuat_1'; 'AbsQuat_2'; 'AbsQuat_3'; 'AbsQuat_4'};
        
    elseif strcmp(type_of_data, 'JointPosition')        
        
        % The Kinect’s camera coordinates use the Kinect’s infrared sensor 
        % to find 3D points of the joints in space. These are the 
        % coordinates to use for joint positioning in 3D projects.  
        % In camera space, the coordinates are measured in meters. 
        % The coordinates (x, y) can be positive or negative, as they 
        % extend in both direction from the sensor. The z coordinate will 
        % always be positive, as it grows out from the sensor.
        
        % We’ll use the values from the joint example above to understand 
        % what the camera values represent. In this example cameraX is 
        % -0.05251733213663101, cameraY is -0.4374599754810333 and 
        % cameraZ is 2.19180965423584. The x and y values are negative, 
        % which means the joint is about 0.05 meters to the right of the sensor, 
        % 0.43 meters below the sensor and 2.19 meters in front of the sensor.
        col_headers = {'cameraX'; 'cameraY'; 'cameraZ'; 'confidenceState'};
        % Confidence state (2 if the joints is tracked, 
        %                   1 if the joint is estimated).
        
    end
        
    
    
end

function [timestamps, delta_ms, fps] = parse_timestamps(filename, mat, size_in)

    % Hmmm... TODO! there are for some reason 2 columns now, 1 extra
    % 0 at the end. Some Windows/Unix line end thing?
    if size_in(2) == 2
        mat = mat(:,1);
    elseif size_in(2) == 1
        % the correct number of columns 4x no_of_joints
    else
        disp([filename, ' - YOU HAVE NOW unexpected number of columns for timestamps! no_of_columns = ', num2str(size_in(2))])
        mat = mat(:,1);
    end
    
    size_in = size(mat);    
    timestamps = mat;
    
    % https://social.msdn.microsoft.com/Forums/en-US/a8f16ce2-c217-442b-aeb3-93731426cd15/whats-the-timestamp-actually-mean?forum=kinectv2sdk
    % The timestamp is just a reference time value for the frame. 
    % You cannot deduce anything from it other than it is a uniquely timed 
    % alue in relation to the Kinect runtime. The value represents a TimeSpan 
    % 1value that is measured in 100ns increments.

    % Its uses can be to determine delta time between frames to ensure you 
    % are getting 30fps(or 15fps color) since the delta should be 33ms. 
    % Also, if you are comparing against depth/ir/body data and the color 
    % frames if there is a large delta to know if the color frame is ahead 
    % or behind the current frame you are analyzing. 
    
    % timestamps(2)-timestamps(1) % 330,047 (33 * 10^4)
    delta_ms = (timestamps(2)-timestamps(1)) / 10^4;
    fps = round(1000 / delta_ms);
    
    % start from zero, and convert from 100 ns -> ms
    timestamps = (timestamps - min(timestamps(:))) / 10^4;
    

end

function [TS, PO, CF] = parse_clin_assment(raw, exercise) 

    % exercise
    offset = 1;    
    TS_col_idx = offset+exercise;
    PO_col_idx = offset+5+exercise;
    CF_col_idx = offset+5+5+exercise;
    
    TS = raw{2, TS_col_idx};
    PO = raw{2, PO_col_idx};
    CF = raw{2, CF_col_idx};

    % raw =
    % 
    %   2×16 cell array
    % 
    %   Columns 1 through 4
    % 
    %     'Subject ID'    'clinical TS Ex#1'    'clinical TS Ex#2'    'clinical TS Ex#3'
    %     'E_ID1'         [         48.3333]    [              45]    [         48.3333]
    % 
    %   Columns 5 through 8
    % 
    %     'clinical TS Ex#4'    'clinical TS Ex#5'    'clinical PO Ex#1'    'clinical PO Ex#2'
    %     [              50]    [         48.3333]    [         14.6667]    [         13.6667]
    % 
    %   Columns 9 through 12
    % 
    %     'clinical PO Ex#3'    'clinical PO Ex#4'    'clinical PO Ex#5'    'clinical CF Ex#1'
    %     [              15]    [              15]    [              15]    [         33.6667]
    % 
    %   Columns 13 through 16
    % 
    %     'clinical CF Ex#2'    'clinical CF Ex#3'    'clinical CF Ex#4'    'clinical CF Ex#5'
    %     [         31.3333]    [         33.3333]    [              35]    [         33.3333]

end

function meta = parse_supp_info(raw, subject) 

    meta.group = raw{2,2};
    meta.age = raw{2,3};
    meta.gender = raw{2,4};
    
    %     raw =
    % 
    %       2×4 cell array
    % 
    %     'Subject ID'    'Group'    'Age '    'Gender'
    %     'E_ID1'         'E'        [  50]    'F'   

end

