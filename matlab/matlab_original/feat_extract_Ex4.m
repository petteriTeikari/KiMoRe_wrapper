%% PRIMARY OUTCOME

variazioneZ=Spine_B(:,3)-mean(Spine_B(:,3));
variazioneX=Spine_B(:,1)-mean(Spine_B(:,1));


%filtraggio P.O.

variazioneZ=filtering(variazioneZ);
variazioneZt=variazioneZ(30:end-15);

variazioneX=filtering(variazioneX);
variazioneXt=variazioneX(30:end-15);


%% peak detection
%la soglia oltre cui andrò a cercare i picchi sarà in base al valore
%medio del segnale
sogliaMax=mean(variazioneZt);%/sqrt(2);
sogliaMin=mean(max(variazioneZt)-variazioneZt);%/sqrt(2);

nsamples=length(variazioneZt);
samples=1:1:nsamples;

[maxW1,ind_max1]=findpeaks(variazioneZt, 'MINPEAKHEIGHT', sogliaMax, 'MINPEAKDISTANCE', floor(nsamples/20));
[minW1,ind_min1]=findpeaks(max(variazioneZt)-variazioneZt, 'MINPEAKHEIGHT', sogliaMin, 'MINPEAKDISTANCE', floor(nsamples/20));

minW1=max(variazioneZt)-minW1;

% figure;
% %subplot(2,1,1)
% plot(samples,variazioneZt);hold on
% plot(samples(ind_max1), maxW1, 'or'); hold on
% plot(samples(ind_min1), minW1, '*g');
% 
% title ('Primary outcome detection exercise 4');
% xlabel ('Number of samples');
% ylabel('Distance');
% legend ('Spine Base depth variation', 'local maxima','local minima');

%%%%%%

sogliaMax=mean(variazioneXt);%/sqrt(2);
sogliaMin=mean(max(variazioneXt)-variazioneXt);%/sqrt(2);

nsamples=length(variazioneXt);
samples=1:1:nsamples;

[maxW2,ind_max2]=findpeaks(variazioneXt, 'MINPEAKHEIGHT', sogliaMax, 'MINPEAKDISTANCE', floor(nsamples/20));
[minW2,ind_min2]=findpeaks(max(variazioneXt)-variazioneXt, 'MINPEAKHEIGHT', sogliaMin, 'MINPEAKDISTANCE', floor(nsamples/20));

minW2=max(variazioneXt)-minW2;
% figure
% %subplot(2,1,2)
% plot(samples,variazioneXt);hold on
% plot(samples(ind_max2), maxW2, 'or'); hold on
% plot(samples(ind_min2), minW2, '*g');
% 
% title ('Primary outcome detection exercise 4');
% xlabel ('Number of samples');
% ylabel('Distance');
% legend ('Spine Base lateral oscillation', 'local maxima','local minima');





%% Control factor

%% ANGOLO GOMITO 

link_bracciototL=sqrt((Shoulder_L(:,1)-Wrist_L(:,1)).^2+(Shoulder_L(:,2)-Wrist_L(:,2)).^2+(Shoulder_L(:,3)-Wrist_L(:,3)).^2);
link_bracciototR=sqrt((Shoulder_R(:,1)-Wrist_R(:,1)).^2+(Shoulder_R(:,2)-Wrist_R(:,2)).^2+(Shoulder_R(:,3)-Wrist_R(:,3)).^2);
link_braccioL=sqrt((Shoulder_L(:,1)-Elbow_L(:,1)).^2+(Shoulder_L(:,2)-Elbow_L(:,2)).^2+(Shoulder_L(:,3)-Elbow_L(:,3)).^2);
link_braccioR=sqrt((Shoulder_R(:,1)-Elbow_R(:,1)).^2+(Shoulder_R(:,2)-Elbow_R(:,2)).^2+(Shoulder_R(:,3)-Elbow_R(:,3)).^2);
link_avambraccioL=sqrt((Elbow_L(:,1)-Wrist_L(:,1)).^2+(Elbow_L(:,2)-Wrist_L(:,2)).^2+(Elbow_L(:,3)-Wrist_L(:,3)).^2);
link_avambraccioR=sqrt((Elbow_R(:,1)-Wrist_R(:,1)).^2+(Elbow_R(:,2)-Wrist_R(:,2)).^2+(Elbow_R(:,3)-Wrist_R(:,3)).^2);
angologomitoL=acos((link_avambraccioL.^2 + link_braccioL.^2 - link_bracciototL.^2)./(2.*link_avambraccioL.*link_braccioL)).*(180/pi);
angologomitoR=acos((link_avambraccioR.^2 + link_braccioR.^2 - link_bracciototR.^2)./(2.*link_avambraccioR.*link_braccioR)).*(180/pi);
angologomitoLt=angologomitoL(1:end-15,1); %taglio gli ultimi 15 valori del vettore relativo all'acquisizione file
angologomitoRt=angologomitoR(1:end-15,1);


%% ANGOLO GINOCCHIO

link_gambatotL=sqrt((Hip_L(:,1)-Ankle_L(:,1)).^2+(Hip_L(:,2)-Ankle_L(:,2)).^2+(Hip_L(:,3)-Ankle_L(:,3)).^2);
link_gambatotR=sqrt((Hip_R(:,1)-Ankle_R(:,1)).^2+(Hip_R(:,2)-Ankle_R(:,2)).^2+(Hip_R(:,3)-Ankle_R(:,3)).^2);
link_femoreR=sqrt((Hip_R(:,1)-Knee_R(:,1)).^2+(Hip_R(:,2)-Knee_R(:,2)).^2+(Hip_R(:,3)-Knee_R(:,3)).^2);
link_femoreL=sqrt((Hip_L(:,1)-Knee_L(:,1)).^2+(Hip_L(:,2)-Knee_L(:,2)).^2+(Hip_L(:,3)-Knee_L(:,3)).^2);
link_tibiaR=sqrt((Knee_R(:,1)-Ankle_R(:,1)).^2+(Knee_R(:,2)-Ankle_R(:,2)).^2+(Knee_R(:,3)-Ankle_R(:,3)).^2);
link_tibiaL=sqrt((Knee_L(:,1)-Ankle_L(:,1)).^2+(Knee_L(:,2)-Ankle_L(:,2)).^2+(Knee_L(:,3)-Ankle_L(:,3)).^2);
angologinocchioL=acos((link_tibiaL.^2 + link_femoreL.^2 - link_gambatotL.^2)./(2.*link_tibiaL.*link_femoreL)).*(180/pi);
angologinocchioR=acos((link_tibiaR.^2 + link_femoreR.^2 - link_gambatotR.^2)./(2.*link_tibiaR.*link_femoreR)).*(180/pi);
angologinocchioLt=angologinocchioL(1:end-15,1); %taglio gli ultimi 15 valori del vettore
angologinocchioRt=angologinocchioR(1:end-15,1); %taglio gli ultimi 15 valori del vettore


%% CONTROLLO CINTO SCAPOLARE NON BASCULANTE

assezShoulderR = Joint_Position(:,index_Shoulder_Right+2);
assezShoulderL = Joint_Position(:,index_Shoulder_Left+2);
assezShoulderRt=assezShoulderR(1:end-15,1);
assezShoulderLt=assezShoulderL(1:end-15,1);


%% ANGOLO ASCELLA

link_fiancoavamL=sqrt((Elbow_L(:,1)-Hip_R(:,1)).^2+(Elbow_L(:,2)-Hip_R(:,2)).^2+(Elbow_L(:,3)-Hip_R(:,3)).^2);  %controllo angoli F e G (sotto le spalle) 
link_fiancoavamR=sqrt((Elbow_R(:,1)-Hip_L(:,1)).^2+(Elbow_R(:,2)-Hip_L(:,2)).^2+(Elbow_R(:,3)-Hip_L(:,3)).^2);
link_braccioL=sqrt((Shoulder_L(:,1)-Elbow_L(:,1)).^2+(Shoulder_L(:,2)-Elbow_L(:,2)).^2+(Shoulder_L(:,3)-Elbow_L(:,3)).^2); 
link_braccioR=sqrt((Shoulder_R(:,1)-Elbow_R(:,1)).^2+(Shoulder_R(:,2)-Elbow_R(:,2)).^2+(Shoulder_R(:,3)-Elbow_R(:,3)).^2);
link_fiancoL=sqrt((Shoulder_L(:,1)-Hip_R(:,1)).^2+(Shoulder_L(:,2)-Hip_R(:,2)).^2+(Shoulder_L(:,3)-Hip_R(:,3)).^2); 
link_fiancoR=sqrt((Shoulder_R(:,1)-Hip_L(:,1)).^2+(Shoulder_R(:,2)-Hip_L(:,2)).^2+(Shoulder_R(:,3)-Hip_L(:,3)).^2);
angoloascellaL=acos((link_braccioL.^2 + link_fiancoL.^2 - link_fiancoavamL.^2)./(2.*link_braccioL.*link_fiancoL)).*(180/pi);
angoloascellaR=acos((link_braccioR.^2 + link_fiancoR.^2 - link_fiancoavamR.^2)./(2.*link_braccioR.*link_fiancoR)).*(180/pi);
angoloascellaLt=angoloascellaL(1:end-15,1);
angoloascellaRt=angoloascellaR(1:end-15,1);


%% SEGMENTO CINTO SCAPOLARE FISSO IN LUNGHEZZA

Shoulder_R=[Joint_Position(:,index_Shoulder_Right) Joint_Position(:,index_Shoulder_Right+1) Joint_Position(:,index_Shoulder_Right+2)];
Shoulder_L=[Joint_Position(:,index_Shoulder_Left) Joint_Position(:,index_Shoulder_Left+1) Joint_Position(:,index_Shoulder_Left+2)];

link_shoulder=sqrt((Shoulder_R(:,1)-Shoulder_L(:,1)).^2+(Shoulder_R(:,2)-Shoulder_L(:,2)).^2+(Shoulder_R(:,3)-Shoulder_L(:,3)).^2);%distanza euclidea tra le spalle
link_shouldert=link_shoulder(1:end-15,:);



%% ALLINEAMENTO ANCA SX DX Z
deltazhip = abs(Joint_Position(:,index_Hip_Left+2)-Joint_Position(:,index_Hip_Right+2));
deltazhipt=deltazhip(1:end-15,1);


%% ALLINEAMENTO ANCA SX DX Y
deltayhip = abs(Joint_Position(:,index_Hip_Left+1)-Joint_Position(:,index_Hip_Right+1));
deltayhipt=deltayhip(1:end-15,1);

%% DISTANZA CINTO SCAPOLARE Z FISSA
deltazShoulder = abs(Joint_Position(:,index_Shoulder_Left+2)-Joint_Position(:,index_Shoulder_Right+2));
deltazShouldert=deltazShoulder(1:end-15,1);


%% REGOLARITA'
derZ=diff(ind_max1);

% figure;
% plot(derZ,'m');
% 
% derX=diff(ind_max2);
% 
% figure;
% plot(derX,'m');


% Filtering C.F.

angologomitoRt = filtering(angologomitoRt);
angologomitoLt = filtering(angologomitoLt);
angologinocchioLt = filtering(angologinocchioLt);
angologinocchioRt = filtering(angologinocchioRt);
assezShoulderRt = filtering(assezShoulderRt);
assezShoulderLt = filtering(assezShoulderLt);
angoloascellaLt=filtering(angoloascellaLt);
angoloascellaRt=filtering(angoloascellaRt);
link_shouldert=filtering(link_shouldert);
deltazhipt=filtering(deltazhipt);
deltayhipt=filtering(deltayhipt);
deltazShouldert=filtering(deltazShouldert);
