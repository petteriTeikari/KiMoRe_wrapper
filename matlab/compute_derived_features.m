function derived_features = compute_derived_features(data_as_struct, meta_as_struct)

    % preproc_Ex5 % this does basically what we did in get_file_listing
    %             % we put the joints into a structure
    
    %% Go through the data    
    subj_codes = fieldnames(data_as_struct);
    for subj = 1 : length(subj_codes)
        subj_code = subj_codes{subj};
        exercises = fieldnames(data_as_struct.(subj_code));
        for ex = 1 : length(exercises)
            ex_idx = str2num(strrep(exercises{ex}, 'Es', ''));
            data_in = data_as_struct.(subj_codes{subj}).(exercises{ex});
            [CF_feats, PO_feats] = feature_wrapper(data_in, ex_idx, subj_code);
            derived_features.(subj_codes{subj}).(exercises{ex}).CF_feats = CF_feats;
            derived_features.(subj_codes{subj}).(exercises{ex}).CF_feats = PO_feats;
        end
    end
   
end

function [CF_feats, PO_feats] = feature_wrapper(data_in, ex_idx, subj_code)
    
    CF_feats = NaN;
    PO_feats = NaN;
    
    if isempty(ex_idx)
        
        warning(['How come your ex_idx is empty now for subject = ', subj_code])
        
    else
    
        switch ex_idx
            case 1            
                 [CF_feats, PO_feats] = wrapper_Ex1(data_in);
            case 2
                [CF_feats, PO_feats] = wrapper_Ex2(data_in);
            case 3
                [CF_feats, PO_feats] = wrapper_Ex3(data_in);
            case 4
                [CF_feats, PO_feats] = wrapper_Ex4(data_in);
            case 5            
                [CF_feats, PO_feats] = wrapper_Ex5(data_in);
            otherwise
                warning(['You should never have an exercise index of ', num2str(ex_idx)])
        end
        
    end

end

function [CF_feats, PO_feats] = wrapper_Ex1(data_in) 
    PO_feats = NaN;
    CF_feats = NaN;
    
end

function [CF_feats, PO_feats] = wrapper_Ex2(data_in) 
    PO_feats = NaN;
    CF_feats = NaN;
end

function [CF_feats, PO_feats] = wrapper_Ex3(data_in) 
    PO_feats = NaN;
    CF_feats = NaN;
end

function [CF_feats, PO_feats] = wrapper_Ex4(data_in) 
    PO_feats = NaN;
    CF_feats = NaN;
end

function [CF_feats, PO_feats] = wrapper_Ex5(data_in) 
    PO_feats = NaN;
    CF_feats = NaN;
end



