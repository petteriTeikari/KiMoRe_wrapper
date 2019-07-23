%% PRIMARY OUTCOME

angolobustoL=atan2((Shoulder_L(:,1)-Hip_L(:,1)),(Shoulder_L(:,2)-Hip_L(:,2))).*(180/pi);%+atan2((Hip_R(:,1)-Hip_L(:,1)),abs(Hip_R(:,2)-Hip_L(:,2))).*(180/pi);;
angolobustoR=atan2((Shoulder_R(:,1)-Hip_R(:,1)),(Shoulder_R(:,2)-Hip_R(:,2))).*(180/pi);%+atan2((Hip_R(:,1)-Hip_L(:,1)),abs(Hip_R(:,2)-Hip_L(:,2))).*(180/pi);;
figure

plot(angolobustoL,'m')

% %removing singolarity
% 
% for j=1:size(angolobustoR,1)-1
%    if angolobustoR(j+1,1)-angolobustoR(j,1)<-100||angolobustoR(j+1,1)-angolobustoR(j,1)>100
%        angolobustoR(j+1,1)=-angolobustoR(j+1,1);
%    end
% end
% 
% for j=1:size(angolobustoL,1)-1
%    if angolobustoL(j+1,1)-angolobustoL(j,1)<-100||angolobustoL(j+1,1)-angolobustoL(j,1)>100
%        angolobustoL(j+1,1)=-angolobustoL(j+1,1);
%    end
% end


%filtraggio P.O.

angolobustoL=-filtering(angolobustoL); %% rescale angolo
angolobustoR=filtering(angolobustoR);

angolobustoL=angolobustoL(30:end);
angolobustoR=angolobustoR(30:end);

%% peak detection
%la soglia oltre cui andrò a cercare i picchi sarà in base al valore
%medio del segnale
sogliaR=mean(angolobustoR);%/sqrt(2);
sogliaL=mean(angolobustoL);%/sqrt(2);

nsamples=length(angolobustoR);
samples=1:1:nsamples;

[maxR,ind_maxR]=findpeaks(angolobustoR, 'MINPEAKHEIGHT', sogliaR, 'MINPEAKDISTANCE', floor(nsamples/10));
[minR,ind_minR]=findpeaks(max(angolobustoR)-angolobustoR, 'MINPEAKHEIGHT', mean(max(angolobustoR)-angolobustoR), 'MINPEAKDISTANCE', floor(nsamples/8));
minR=max(angolobustoR)-minR;


% figure;
% plot(samples,angolobustoR);hold on
% plot(samples(ind_maxR), maxR, 'or'); hold on
% plot(samples(ind_minR), minR, '*g');
% 
% title ('Primary outcome detection exercise 2');
% xlabel ('Number of samples');
% ylabel('Degree');
% legend ('shoulder right inclination', 'local maxima', 'local minima');

% figure
% plot(angolobustoL)

% min-max peak L
[maxL,ind_maxL]=findpeaks(angolobustoL, 'MINPEAKHEIGHT', sogliaL, 'MINPEAKDISTANCE', floor(nsamples/10));
[minL,ind_minL]=findpeaks(max(angolobustoL)-angolobustoL, 'MINPEAKHEIGHT', mean(max(angolobustoL)-angolobustoL), 'MINPEAKDISTANCE', floor(nsamples/8));
minL=max(angolobustoL)-minL;
% minL
% maxL

% figure;
% plot(samples,angolobustoL);hold on
% plot(samples(ind_maxL), maxL, 'or'); hold on
% plot(samples(ind_minL), minL, '*g');
% 
% title ('Primary outcome detection exercise 2');
% xlabel ('Number of samples');
% ylabel('Degree');
% legend ('shoulder left inclination', 'local maxima', 'local minima');


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

%% ALTEZZA BRACCIA
Wrist_R=[Joint_Position(:,index_Wrist_Right) Joint_Position(:,index_Wrist_Right+1) Joint_Position(:,index_Wrist_Right+2)]; 
Wrist_L=[Joint_Position(:,index_Wrist_Left) Joint_Position(:,index_Wrist_Left+1) Joint_Position(:,index_Wrist_Left+2)];  
Spine_Shoulder=[Joint_Position(:,index_Spine_Shoulder) Joint_Position(:,index_Spine_Shoulder+1) Joint_Position(:,index_Spine_Shoulder+2)];
assezR=Wrist_R(15:end-15,3)-Spine_Shoulder(15:end-15,3);
assezL=Wrist_L(15:end-15,3)-Spine_Shoulder(15:end-15,3);

%% ANGOLO C

angoloHipL=atan2(Spine_B(:,1)-Hip_L(:,1),Spine_B(:,2)-Hip_L(:,2)).*(180/pi); %(METà ANGOLO C)angolo riportato in gradi tra anca sinistra e spina dorsale bassa
angoloHipR=atan2(Hip_R(:,1)-Spine_B(:,1),Hip_R(:,2)-Spine_B(:,2)).*(180/pi); %(METà ANGOLO C)angolo riportato in gradi tra anca destra e spina dorsale bassa
angoloHipRt=angoloHipR(1:end-15,1); %taglio gli ultimi 15 valori del vettore
angoloHipLt=angoloHipL(1:end-15,1); %taglio gli ultimi 15 valori del vettore

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
if (sum(isnan(angoloascellaLt))~=0)
angoloascellaLt(isnan(angoloascellaLt))=[];
end

if (sum(isnan(angoloascellaRt))~=0)
angoloascellaRt(isnan(angoloascellaRt))=[];
end

% figure 
% plot(angoloascellaRt)

%% SEGMENTO PELVICO NON BASCULANTE (PIANO FRONTALE)

assezhipR = Joint_Position(:,index_Hip_Right+2);
assezhipL = Joint_Position(:,index_Hip_Left+2);
assezhipRt=assezhipR(1:end-15,1); %taglio gli ultimi 15 valori del vettore
assezhipLt=assezhipL(1:end-15,1); %taglio gli ultimi 15 valori del vettore

%% SEGMENTO PELVICO NON BASCULANTE (PIANO PARALLELO)

assexhipR = Joint_Position(:,index_Hip_Right);
assexhipL = Joint_Position(:,index_Hip_Left);
assexhipRt=assexhipR(1:end-15,1); %taglio gli ultimi 15 valori del vettore
assexhipLt=assexhipL(1:end-15,1); %taglio gli ultimi 15 valori del vettore

%% GIUNTO DELLE MANI COSTANTE

link_hand=sqrt((Hand_R(:,1)-Hand_L(:,1)).^2+(Hand_R(:,2)-Hand_L(:,2)).^2+(Hand_R(:,3)-Hand_L(:,3)).^2);
link_handt=link_hand(1:end-15,1);

%% SEGMENTO CINTO SCAPOLARE FISSO IN LUNGHEZZA

link_shoulder=sqrt((Shoulder_R(:,1)-Shoulder_L(:,1)).^2+(Shoulder_R(:,2)-Shoulder_L(:,2)).^2+(Shoulder_R(:,3)-Shoulder_L(:,3)).^2);%distanza euclidea tra le spalle
link_shouldert=link_shoulder(1:end-15,1);

%% SEGMENTO CINTO PELVICO FISSO IN LUNGHEZZA

link_hip=sqrt((Hip_R(:,1)-Hip_L(:,1)).^2+(Hip_R(:,2)-Hip_L(:,2)).^2+(Hip_R(:,3)-Hip_L(:,3)).^2);%distanza euclidea tra le anche
link_hipt=link_hip(1:end-15,1); 


%% REGOLARITA'
derR=diff(ind_maxR);

% figure;
% plot(derR,'m');
% 
% derL=diff(ind_maxL);
% 
% figure;
% plot(derL,'m');

% Filtering C.F.

angologomitoLt = filtering(angologomitoLt);
angologomitoRt = filtering(angologomitoRt);
angologinocchioLt = filtering(angologinocchioLt);
angologinocchioRt = filtering(angologinocchioRt);
assezR=filtering(assezR);
assezL=filtering(assezL);
angoloHipRt = filtering(angoloHipRt);
angoloHipLt = filtering(angoloHipLt);
angoloascellaLt=filtering(angoloascellaLt);
angoloascellaRt=filtering(angoloascellaRt);
assezhipRt=filtering(assezhipRt);
assezhipLt=filtering(assezhipLt);
assexhipRt=filtering(assexhipRt);
assexhipLt=filtering(assexhipLt);
link_handt=filtering(link_handt);
link_shouldert=filtering(link_shouldert);
link_hipt=filtering(link_hipt)