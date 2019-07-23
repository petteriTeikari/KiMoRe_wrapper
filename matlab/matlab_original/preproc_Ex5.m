index_Spine_Base=1;  % no parent %traslo di 4 xkè in tabella di dati ho le xyz di ogni giunto
index_Spine_Mid=5;
index_Neck=9;
index_Head=13;       % no orientation
index_Shoulder_Left=17;
index_Elbow_Left=21;
index_Wrist_Left=25;
index_Hand_Left=29;
index_Shoulder_Right=33;
index_Elbow_Right=37;
index_Wrist_Right=41;
index_Hand_Right=45;
index_Hip_Left=49;
index_Knee_Left=53;
index_Ankle_Left=57;
index_Foot_Left=61;    % no orientation
index_Hip_Right=65;
index_Knee_Right=69;
index_Ankle_Right=73;
index_Foot_Right=77;   % no orientation
index_Spine_Shoulder=81;
index_Tip_Left=85;     % no orientation
index_Thumb_Left=89;   % no orientation
index_Tip_Right=93;    % no orientation
index_Thumb_Right=97;  % no orientation


Hip_R=[Joint_Position(:,index_Hip_Right) Joint_Position(:,index_Hip_Right+1) Joint_Position(:,index_Hip_Right+2)];%divido dati xyz per ogni giunto
Knee_R=[Joint_Position(:,index_Knee_Right) Joint_Position(:,index_Knee_Right+1) Joint_Position(:,index_Knee_Right+2)];
Ankle_R=[Joint_Position(:,index_Ankle_Right) Joint_Position(:,index_Ankle_Right+1) Joint_Position(:,index_Ankle_Right+2)];
Foot_R=[Joint_Position(:,index_Foot_Right) Joint_Position(:,index_Foot_Right+1) Joint_Position(:,index_Foot_Right+2)];

Hip_L=[Joint_Position(:,index_Hip_Left) Joint_Position(:,index_Hip_Left+1) Joint_Position(:,index_Hip_Left+2)];
Knee_L=[Joint_Position(:,index_Knee_Left) Joint_Position(:,index_Knee_Left+1) Joint_Position(:,index_Knee_Left+2)];
Ankle_L=[Joint_Position(:,index_Ankle_Left) Joint_Position(:,index_Ankle_Left+1) Joint_Position(:,index_Ankle_Left+2)];
Foot_L=[Joint_Position(:,index_Foot_Left) Joint_Position(:,index_Foot_Left+1) Joint_Position(:,index_Foot_Left+2)];

Spine_B=[Joint_Position(:,index_Spine_Base) Joint_Position(:,index_Spine_Base+1) Joint_Position(:,index_Spine_Base+2)];
Spine_M=[Joint_Position(:,index_Spine_Mid) Joint_Position(:,index_Spine_Mid+1) Joint_Position(:,index_Spine_Mid+2)];
Head_C=[Joint_Position(:,index_Head) Joint_Position(:,index_Head+1) Joint_Position(:,index_Head+2)];

Spine_Sh=[Joint_Position(:,index_Spine_Shoulder) Joint_Position(:,index_Spine_Shoulder+1) Joint_Position(:,index_Spine_Shoulder+2)];
Shoulder_R=[Joint_Position(:,index_Shoulder_Right) Joint_Position(:,index_Shoulder_Right+1) Joint_Position(:,index_Shoulder_Right+2)];
Shoulder_L=[Joint_Position(:,index_Shoulder_Left) Joint_Position(:,index_Shoulder_Left+1) Joint_Position(:,index_Shoulder_Left+2)];

Elbow_R=[Joint_Position(:,index_Elbow_Right) Joint_Position(:,index_Elbow_Right+1) Joint_Position(:,index_Elbow_Right+2)];
Wrist_R=[Joint_Position(:,index_Wrist_Right) Joint_Position(:,index_Wrist_Right+1) Joint_Position(:,index_Wrist_Right+2)];
Hand_R=[Joint_Position(:,index_Hand_Right) Joint_Position(:,index_Hand_Right+1) Joint_Position(:,index_Hand_Right+2)];

Elbow_L=[Joint_Position(:,index_Elbow_Left) Joint_Position(:,index_Elbow_Left+1) Joint_Position(:,index_Elbow_Left+2)];
Wrist_L=[Joint_Position(:,index_Wrist_Left) Joint_Position(:,index_Wrist_Left+1) Joint_Position(:,index_Wrist_Left+2)];
Hand_L=[Joint_Position(:,index_Hand_Left) Joint_Position(:,index_Hand_Left+1) Joint_Position(:,index_Hand_Left+2)];