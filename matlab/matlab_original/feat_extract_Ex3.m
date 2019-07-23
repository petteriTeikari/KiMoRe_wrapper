%% PRIMARY OUTCOME

linkelbow=abs(Elbow_L(:,1)-Elbow_R(:,1));


%filtraggio P.O.

linkelbow=filtering(linkelbow);
linkelbow=linkelbow(30:end-15);

%% peak detection
%la soglia oltre cui andrò a cercare i picchi sarà in base al valore
%medio del segnale
sogliaMax=mean(linkelbow);%/sqrt(2);
sogliaMin=mean(max(linkelbow)-linkelbow);%/sqrt(2);

nsamples=length(linkelbow);
samples=1:1:nsamples;

[maxW,ind_max]=findpeaks(linkelbow, 'MINPEAKHEIGHT', sogliaMax, 'MINPEAKDISTANCE', floor(nsamples/20));
[minW,ind_min]=findpeaks(max(linkelbow)-linkelbow, 'MINPEAKHEIGHT', sogliaMin, 'MINPEAKDISTANCE', floor(nsamples/20));

minW=max(linkelbow)-minW;

% figure;
% plot(samples,linkelbow);hold on
% %plot(samples(ind_max), maxW, 'or'); hold on
% plot(samples(ind_min), minW, '*g');
% 
% title ('Primary outcome detection exercise 3');
% xlabel ('Number of samples');
% ylabel('Distance');
% legend ('lateral distance wrist', 'local minima');
% 
% figure
% plot(linkelbow)


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


%% ANGOLO C

angoloHipL=atan2(Spine_B(:,1)-Hip_L(:,1),Spine_B(:,2)-Hip_L(:,2)).*(180/pi); %(METà ANGOLO C)angolo riportato in gradi tra anca sinistra e spina dorsale bassa
angoloHipR=atan2(Hip_R(:,1)-Spine_B(:,1),Hip_R(:,2)-Spine_B(:,2)).*(180/pi); %(METà ANGOLO C)angolo riportato in gradi tra anca destra e spina dorsale bassa
angoloHipRt=angoloHipR(1:end-15,1); %taglio gli ultimi 15 valori del vettore
angoloHipLt=angoloHipL(1:end-15,1); %taglio gli ultimi 15 valori del vettore

%% SOMMA ANGOLI BRACCIO SPALLA

link_ElbowSpineshR=sqrt((Elbow_R(:,1)-Spine_Sh(:,1)).^2+(Elbow_R(:,2)-Spine_Sh(:,2)).^2+(Elbow_R(:,3)-Spine_Sh(:,3)).^2);%angolo c di carnot
link_ElbowShoulderR=sqrt((Elbow_R(:,1)-Shoulder_R(:,1)).^2+(Elbow_R(:,2)-Shoulder_R(:,2)).^2+(Elbow_R(:,3)-Shoulder_R(:,3)).^2);
link_ShoulderSpineshR=sqrt((Shoulder_R(:,1)-Spine_Sh(:,1)).^2+(Shoulder_R(:,2)-Spine_Sh(:,2)).^2+(Shoulder_R(:,3)-Spine_Sh(:,3)).^2);%angolo c di carnot

link_ElbowSpineshL=sqrt((Elbow_L(:,1)-Spine_Sh(:,1)).^2+(Elbow_L(:,2)-Spine_Sh(:,2)).^2+(Elbow_L(:,3)-Spine_Sh(:,3)).^2);
link_ElbowShoulderL=sqrt((Elbow_L(:,1)-Shoulder_L(:,1)).^2+(Elbow_L(:,2)-Shoulder_L(:,2)).^2+(Elbow_L(:,3)-Shoulder_L(:,3)).^2);
link_ShoulderSpineshL=sqrt((Shoulder_L(:,1)-Spine_Sh(:,1)).^2+(Shoulder_L(:,2)-Spine_Sh(:,2)).^2+(Shoulder_L(:,3)-Spine_Sh(:,3)).^2);%angolo c di carnot

angolobracciospallaR=acos((link_ElbowShoulderR.^2 + link_ShoulderSpineshR.^2 - link_ElbowSpineshR.^2)./(2.*link_ElbowShoulderR.*link_ShoulderSpineshR)).*(180/pi);
angolobracciospallaL=acos((link_ElbowShoulderL.^2 + link_ShoulderSpineshL.^2 - link_ElbowSpineshL.^2)./(2.*link_ElbowShoulderL.*link_ShoulderSpineshL)).*(180/pi);



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


%% SEGMENTO PELVICO NON BASCULANTE (PIANO FRONTALE)

assezhipR = Joint_Position(:,index_Hip_Right+2);
assezhipL = Joint_Position(:,index_Hip_Left+2);
assezhipRt=assezhipR(1:end-15,1); %taglio gli ultimi 15 valori del vettore
assezhipLt=assezhipL(1:end-15,1); %taglio gli ultimi 15 valori del vettore

%% CONTROLLO ALTEZZA POLSI COSTANTE

controlyR = Wrist_R(:,2).*2-Elbow_R(:,2)-Shoulder_R(:,2);
controlyL = Wrist_L(:,2).*2-Elbow_L(:,2)-Shoulder_L(:,2);
controlyRt=controlyR(30:end-15);
controlyLt=controlyL(30:end-15);

%% SEGMENTO CINTO PELVICO FISSO IN LUNGHEZZA

link_hip=sqrt((Hip_R(:,1)-Hip_L(:,1)).^2+(Hip_R(:,2)-Hip_L(:,2)).^2+(Hip_R(:,3)-Hip_L(:,3)).^2);%distanza euclidea tra le anche
link_hipt=link_hip(1:end-15,1); 


%% REGOLARITA'
der1=diff(ind_max);

% figure;
% plot(der1,'m');


% Filtering C.F.

angolobracciospallaR=filtering(angolobracciospallaR);
angolobracciospallaL=filtering(angolobracciospallaL);

angologomitoRt = filtering(angologomitoRt);
angologomitoLt = filtering(angologomitoLt);
angologinocchioLt = filtering(angologinocchioLt);
angologinocchioRt = filtering(angologinocchioRt);
angoloHipRt = filtering(angoloHipRt);
angoloHipLt = filtering(angoloHipLt);
angoloascellaLt=filtering(angoloascellaLt);
angoloascellaRt=filtering(angoloascellaRt);
assezhipRt=filtering(assezhipRt);
assezhipLt=filtering(assezhipLt);
controlyRt=filtering(controlyRt);
controlyLt=filtering(controlyLt);
link_hipt=filtering(link_hipt);