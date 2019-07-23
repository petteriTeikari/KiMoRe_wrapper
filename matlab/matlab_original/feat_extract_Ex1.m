%% PRIMARY OUTCOME

shoulder_extR=atan2(Spine_Sh(:,3)-Elbow_R(:,3),Spine_Sh(:,2)-Elbow_R(:,2));
shoulder_extR=(shoulder_extR.*(180/pi));
shoulder_extL=atan2(Spine_Sh(:,3)-Elbow_L(:,3),Spine_Sh(:,2)-Elbow_L(:,2));
shoulder_extL=(shoulder_extL.*(180/pi));

%removing singolarity

for j=1:size(shoulder_extR,1)-1
   if shoulder_extR(j+1,1)-shoulder_extR(j,1)<-100||shoulder_extR(j+1,1)-shoulder_extR(j,1)>100
       shoulder_extR(j+1,1)=-shoulder_extR(j+1,1);
   end
end

for j=1:size(shoulder_extL,1)-1
   if shoulder_extL(j+1,1)-shoulder_extL(j,1)<-100||shoulder_extL(j+1,1)-shoulder_extL(j,1)>100
       shoulder_extL(j+1,1)=-shoulder_extL(j+1,1);
   end
end

% filtraggio P.O.

shoulder_extR=filtering(shoulder_extR);
shoulder_extL=filtering(shoulder_extL);

%% peak detection
%la soglia oltre cui andrò a cercare i picchi sarà in base al valore
%efficace del segnale
sogliaR=max(shoulder_extR)/sqrt(2);
sogliaL=max(shoulder_extL)/sqrt(2);

nsamples=length(shoulder_extR);
samples=1:1:nsamples;

%findpeaks per trovare la posizione dei picchi

% min-max peak R
[maxR,ind_maxR]=findpeaks(shoulder_extR, 'MINPEAKHEIGHT', sogliaR, 'MINPEAKDISTANCE', floor(nsamples/12));
[minR,ind_minR]=findpeaks(max(shoulder_extR)-shoulder_extR, 'MINPEAKHEIGHT', sogliaR, 'MINPEAKDISTANCE', floor(nsamples/12));
minR=max(shoulder_extR)-minR;


% figure;
% plot(samples,shoulder_extR);hold on
% plot(samples(ind_maxR), maxR, 'or'); hold on
% plot(samples(ind_minR), minR, '*g');

% title ('Primary outcome detection exercise 1');
% xlabel ('Number of samples');
% ylabel('Degree');
% legend ('underarm right angle', 'local maxima','local minima');

% min-max peak L
[maxL,ind_maxL]=findpeaks(shoulder_extL, 'MINPEAKHEIGHT', sogliaL, 'MINPEAKDISTANCE', floor(nsamples/12));
[minL,ind_minL]=findpeaks(max(shoulder_extL)-shoulder_extL, 'MINPEAKHEIGHT', sogliaL, 'MINPEAKDISTANCE', floor(nsamples/12));
minL=max(shoulder_extL)-minL;


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

angleHipL=atan2(Spine_B(:,1)-Hip_L(:,1),Spine_B(:,2)-Hip_L(:,2)).*(180/pi); %(METà ANGOLO C)angolo riportato in gradi tra anca sinistra e spina dorsale bassa
angleHipR=atan2(Hip_R(:,1)-Spine_B(:,1),Hip_R(:,2)-Spine_B(:,2)).*(180/pi); %(METà ANGOLO C)angolo riportato in gradi tra anca destra e spina dorsale bassa
angleHipRt=angleHipR(1:end-15,1); %taglio gli ultimi 15 valori del vettore
angleHipLt=angleHipL(1:end-15,1); %taglio gli ultimi 15 valori del vettore

%% AEREA TRONCO

link_shoulder=sqrt((Shoulder_L(:,1)-Shoulder_R(:,1)).^2+(Shoulder_L(:,2)-Shoulder_R(:,2)).^2+(Shoulder_L(:,3)-Shoulder_R(:,3)).^2); %distanza tra spalle
link_hip=sqrt((Hip_L(:,1)-Hip_R(:,1)).^2+(Hip_L(:,2)-Hip_R(:,2)).^2+(Hip_L(:,3)-Hip_R(:,3)).^2); %distanza tra anche
link_shoulderhipR=sqrt((Shoulder_R(:,1)-Hip_R(:,1)).^2+(Shoulder_R(:,2)-Hip_R(:,2)).^2+(Shoulder_R(:,3)-Hip_R(:,3)).^2); %distanza tra spalla anca destra
link_shoulderhipL=sqrt((Shoulder_L(:,1)-Hip_L(:,1)).^2+(Shoulder_L(:,2)-Hip_L(:,2)).^2+(Shoulder_L(:,3)-Hip_L(:,3)).^2); %distanza tra spalla anca sinistra
link_shoulderR_hipL=sqrt((Shoulder_R(:,1)-Hip_L(:,1)).^2+(Shoulder_R(:,2)-Hip_L(:,2)).^2+(Shoulder_R(:,3)-Hip_L(:,3)).^2); %distanza tra spalla destra anca sinistra
semiperimetroR=(link_hip+link_shoulderR_hipL+link_shoulderhipR)./2;
areaeroneR=sqrt(semiperimetroR.*(semiperimetroR-link_hip).*(semiperimetroR-link_shoulderR_hipL).*(semiperimetroR-link_shoulderhipR));
semiperimetroL=(link_shoulder+link_shoulderR_hipL+link_shoulderhipL)./2;
areaeroneL=sqrt(semiperimetroL.*(semiperimetroL-link_shoulder).*(semiperimetroL-link_shoulderR_hipL).*(semiperimetroL-link_shoulderhipL));
sommaaree=areaeroneR+areaeroneL;   %calcolo area tronco metodo erone
sommaareet=sommaaree(1:end-15,1);

%% GIUNTO DELLE MANI 

link_hand=sqrt((Hand_R(:,1)-Hand_L(:,1)).^2+(Hand_R(:,2)-Hand_L(:,2)).^2+(Hand_R(:,3)-Hand_L(:,3)).^2); %distanza tra mani
link_handt=link_hand(1:end-15,1); %taglio gli ultimi 15 valori del vettore

%% LINK TRA LE CAVIGLIE

link_foot=sqrt((Ankle_R(:,1)-Ankle_L(:,1)).^2+(Ankle_R(:,2)-Ankle_L(:,2)).^2+(Ankle_R(:,3)-Ankle_L(:,3)).^2); %distanza tra caviglie
link_foott=link_foot(1:end-15,1);

%% REGOLARITA'

derR=diff(ind_maxR);
derL=diff(ind_maxL);

% figure;
% plot(derR,'r');
% 
% hold on
% plot(derL,'b');
% 
% title ('Derivative: Frequency/velocity Variability');
% xlabel ('Number of interval');
% ylabel('Samples-difference');
% legend('interval P.O. Right','interval P.O. Left')


% Filtering C.F.
angologomitoLt = filtering(angologomitoLt);
angologomitoRt = filtering(angologomitoRt);
angologinocchioLt = filtering(angologinocchioLt);
angologinocchioRt = filtering(angologinocchioRt);
angleHipRt = filtering(angleHipRt);
angleHipLt = filtering(angleHipLt);
sommaareet = filtering(sommaareet);
link_handt = filtering(link_handt);
link_foott=filtering(link_foott);