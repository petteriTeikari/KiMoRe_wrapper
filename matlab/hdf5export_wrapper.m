function hdf5export_wrapper(file_out, joints_structure, meta_as_struct)
       
    %% TODO! Maybe there is a way to directly write the structure as HDF5?
    % https://uk.mathworks.com/help/matlab/import_export/exporting-to-hierarchical-data-format-hdf5-files.html
    
    if exist(file_out, 'file') == 2
        delete(file_out);        
        % otherwise you will get the :
        % "Error using hdf5lib2
        % Unable to create file with specified filename. Filename may have unsupported characters."
    else
        % fileID = H5F.create(file_out,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');
        % not needed
    end
    
    table_counter = 0;
    subj_codes = fieldnames(joints_structure);
    
    for subj = 1 : length(subj_codes)
        
        subj_code = subj_codes{subj};
        data_per_subj = joints_structure.(subj_codes{subj});
        exercises = fieldnames(data_per_subj);
        
        disp(['Writing subject = ', subj_code, ' to the HDF5 file'])
        
        for ex = 1 : length(exercises)
                  
            ex_string = exercises{ex};
            data_per_ex = joints_structure.(subj_codes{subj}).(ex_string).joints;
            % TODO! Placeholder for "derived_features"
            % feats_per_ex = joints_structure.(subj_codes{subj}).(ex_string).deriv_feats;
            joint_names = fieldnames(data_per_ex);
            
            for joint = 1 : length(joint_names)
              
                % DATA
                joint_string = joint_names{joint};
                datatable_per_joint = data_per_ex.(joint_string);
                % feattable_per_joint = feats_per_ex.(joint_string); %TODO!
                table_counter = table_counter + 1; % e.g. a total of 8816 tables to be written
                hdf5_path = ['/', subj_code, '/', 'exercises', '/', ex_string, '/', 'joints', '/', joint_string];
                
                    % WRITE to HDF5
                    table_as_array = table2array(datatable_per_joint);
                    % these are not written with the matrix, so we write
                    % them as metadata then
                    col_headers = datatable_per_joint.Properties.VariableNames;
                    
                    h5create(file_out, hdf5_path, size(table_as_array))
                    h5write(file_out, hdf5_path, table_as_array)
                
                % TODO!
                % Derived Features
                % hdf5_path_feats = ['/', subj_code, '/', 'exercises', '/', ex_string, '/', 'deriv_feats', '/', joint_string]
                
                    % WRITE to HDF5
                    % table_as_array = table2array(feattable_per_joint);
                    % h5create(file_out, hdf5_path_feats, size(table_as_array))
                    % h5write(file_out, hdf5_path_feats, table_as_array)                
                
            end % end of joint
            
        end % end of exercises
        
        % And write the metadata here
        disp(['    and the metadata associated with the data'])
        hdf5_metadata_path = ['/', subj_code, '/', 'metadata'];
        metadata_per_subj = meta_as_struct.(subj_codes{subj}); 
        col_headers_per_subj = col_headers; % well these should be the same for each subject
        hdf5_metadata_wrapper(metadata_per_subj, col_headers_per_subj, hdf5_metadata_path, file_out)
        
    end % end of subj
    
    %% Export just the column headers
    % the joy of Matlab ASCII export :D (at least 2017a)
    c = reshape(col_headers_per_subj, [1, length(col_headers_per_subj)]); % transpose cell array
    d = [c',[repmat({','},numel(c)-1,1);{[]}]]';
    cols_mat_commadelimited = [d{:}];
    filename_csv_column_headers = strrep(file_out, '.h5', '_columnHeaders.csv');
    filePh = fopen(filename_csv_column_headers,'w');
    fprintf(filePh,'%s',cols_mat_commadelimited);
    fclose(filePh);

end

function hdf5_metadata_wrapper(metadata_per_subj, col_headers_per_subj, hdf5_metadata_path, file_out) 

        % col_headers_per_subj
        % all strings, and same for all the subjects, so we write them
        % as .csv now before this wrapper        

        % go through the metadata fields
        metadata_fields = fieldnames(metadata_per_subj);
        for field_meta = 1 : length(metadata_fields)
            
            metadata_field = metadata_fields{field_meta};
            path_temp = [hdf5_metadata_path, '/', metadata_field];
            
            % we need to convert all the char's to numerical format 
            scalar_to_write = metadata_per_subj.(metadata_field);
            map_to_numeric_and_write(scalar_to_write, metadata_field, file_out, path_temp);            
          
        end

end

function map_to_numeric_and_write(scalar_to_write, metadata_field, file_out, path_temp) 

    switch metadata_field
       
        case 'group'
            to_export = true;
            if strcmp(scalar_to_write, 'CG_E') 
                scalar_to_write = 0;
            elseif strcmp(scalar_to_write, 'E') 
                scalar_to_write = 0;               
            elseif strcmp(scalar_to_write, 'CG_NE') 
                scalar_to_write = 1;     
            elseif strcmp(scalar_to_write, 'NE') 
                scalar_to_write = 1;     
            elseif strcmp(scalar_to_write, 'GPP_S') 
                scalar_to_write = 2;
            elseif strcmp(scalar_to_write, 'S') 
                scalar_to_write = 2;
            elseif strcmp(scalar_to_write, 'GPP_P') 
                scalar_to_write = 3;
            elseif strcmp(scalar_to_write, 'P') 
                scalar_to_write = 3;
            elseif strcmp(scalar_to_write, 'GPP_B') 
                scalar_to_write = 4;
            elseif strcmp(scalar_to_write, 'B') 
                scalar_to_write = 4;
            else
                warning(['Your group is not known based on the paper? Group = ', scalar_to_write])
            end
            
        case 'age'
            % this is already numeric
            to_export = true;
            
        case 'gender'
            to_export = true;
            if strcmp(scalar_to_write, 'F') 
                scalar_to_write = 0;
            elseif strcmp(scalar_to_write, 'M') 
                scalar_to_write = 1;
            else
                warning('Your gender is not binary now = ', scalar_to_write)
            end
            
        case 'data_group'
            to_export = false;
            % this is folder name, e.g. data_group: 'CG'
            
        case 'data_subgroup'
            to_export = false;
            % this is folder name, e.g. data_subgroup: 'Expert'
            % these are contained in the group
            
        otherwise
            warning(['No Lookup table is defined for metadata_field = ', metadata_field])            
            
    end
        
    if to_export
        h5create(file_out, path_temp, size(scalar_to_write))
        h5write(file_out, path_temp, scalar_to_write)
    end
        

end