%% PRIMARY OUTCOME

angologinocchioL= atan2((Hip_L(:,2)-Knee_L(:,2)),(Hip_L(:,3)-Knee_L(:,3))).*(180/pi)+atan2((Knee_L(:,2)-Ankle_L(:,2)),(Ankle_L(:,3)-Knee_L(:,3))).*(180/pi);
angologinocchioR=atan2((Hip_R(:,2)-Knee_R(:,2)),(Hip_R(:,3)-Knee_R(:,3))).*(180/pi)+atan2((Knee_R(:,2)-Ankle_R(:,2)),(Ankle_R(:,3)-Knee_R(:,3))).*(180/pi);
angologinocchioL=angologinocchioL(10:end);
angologinocchioR=angologinocchioR(10:end);

%removing singolarity

for j=1:size(angologinocchioR,1)-1
   if angologinocchioR(j+1,1)-angologinocchioR(j,1)<-100||angologinocchioR(j+1,1)-angologinocchioR(j,1)>100
       angologinocchioR(j+1,1)=-angologinocchioR(j+1,1);
   end
end

for j=1:size(angologinocchioL,1)-1
   if angologinocchioL(j+1,1)-angologinocchioL(j,1)<-100||angologinocchioL(j+1,1)-angologinocchioL(j,1)>100
       angologinocchioL(j+1,1)=-angologinocchioL(j+1,1);
   end
end


%filtraggio P.O.

angologinocchioR=filtering(angologinocchioR);
%angologinocchioRt=angologinocchioR(30:end-15);

angologinocchioL=filtering(angologinocchioL);
%angologinocchioLt=angologinocchioL(30:end-15);


%% peak detection
%la soglia oltre cui andrò a cercare i picchi sarà in base al valore
%efficace
nsamples=length(angologinocchioR);

[MaxpeakR, locsmaxR]=findpeaks(angologinocchioR, 'MinPeakHeight',max(angologinocchioR)/sqrt(2),'MinPeakDistance',floor (nsamples/10));
[MinpeakR, locsminR]=findpeaks(max(angologinocchioR)-angologinocchioR, 'MinPeakHeight',max(max(angologinocchioR)-angologinocchioR)/sqrt(2),'MinPeakDistance',floor (nsamples/10));
% 
% figure
% plot(angologinocchioR)
% hold on
% plot(locsmaxR,MaxpeakR, '*g');
% hold on
% plot(locsminR,max(angologinocchioR)-MinpeakR, '*g');
% title ('Primary outcome detection exercise 5');
% xlabel ('Number of samples');
% ylabel('Degree');
% legend ('knee left angle', 'local maxima','local minima');

MinpeakR=max(angologinocchioR)-MinpeakR;
%%%%%%

nsamples=length(angologinocchioL);

[MaxpeakL, locsmaxL]=findpeaks(angologinocchioL, 'MinPeakHeight',max(angologinocchioL)/sqrt(2),'MinPeakDistance',floor (nsamples/10));
[MinpeakL, locsminL]=findpeaks(max(angologinocchioL)-angologinocchioL, 'MinPeakHeight',max(max(angologinocchioL)-angologinocchioL)/sqrt(2),'MinPeakDistance',floor (nsamples/10));
a=max(angologinocchioL)-angologinocchioL
b=max(max(angologinocchioL)-angologinocchioL)/sqrt(2)
MinpeakL=max(angologinocchioL)-MinpeakL;

% figure
% plot(angologinocchioL)
% hold on
% plot(locsmaxL,MaxpeakL, 'or');
% hold on
% plot(locsminL,MinpeakL, '*g');
% figure
% 
% subplot(2,1,1);
% stem(MinpeakL,'or');  hold on
% plot(71*ones(length(MinpeakL)),'--b') 
% plot(92*ones(length(MinpeakL)),'--g')
% plot(50*ones(length(MinpeakL)),'--g')
% 
% title ('Primary outcome detection exercise 5');
% xlabel ('Number of local minima');
% ylabel('Degree');
% legend ('Local minima');


% min(angologinocchioL)
% max(angologinocchioL)
% min(angologinocchioR)
% max(angologinocchioR)


% subplot(2,1,2);
% plot(votoprimaryoutcomelowL,'m');
% title ('Score P.O. Exercise 5');
% xlabel ('Number of local minima');
% ylabel('Score');

%Temporalscore5(MinpeakR, 71*ones(length(MaxpeakR)), 92*ones(length(MaxpeakR)), 50*ones(length(MaxpeakR)), votoprimaryoutcomelowR);


%% Control factor

%% CINTA SCAPOLARE NON BASCULANTE ASSE Z

assezshoulderR = Shoulder_R(:,3);
assezshoulderL = Shoulder_L(:,3);
assezshoulderLt=assezshoulderL(1:end-15,1); %taglio gli ultimi 15 valori del vettore relativo all'acquisizione file
assezshoulderRt=assezshoulderR(1:end-15,1);

%% CINTA SCAPOLARE NON BASCULANTE ASSE X

assexshoulderR = Shoulder_R(:,1);
assexshoulderL = Shoulder_L(:,1);
assexshoulderLt=assexshoulderL(1:end-15,1); %taglio gli ultimi 15 valori del vettore relativo all'acquisizione file
assexshoulderRt=assexshoulderR(1:end-15,1);

%% DISTANZA MANO SPALLA FISSA

link_shoulderhandL=sqrt((Shoulder_L(:,1)-Hand_L(:,1)).^2+(Shoulder_L(:,2)-Hand_L(:,2)).^2+(Shoulder_L(:,3)-Hand_L(:,3)).^2); %distanza tra spalla anca sinistra
link_shoulderhandR=sqrt((Shoulder_R(:,1)-Hand_R(:,1)).^2+(Shoulder_R(:,2)-Hand_R(:,2)).^2+(Shoulder_R(:,3)-Hand_R(:,3)).^2);
link_shoulderhandLt=link_shoulderhandL(1:end-15,1);
link_shoulderhandRt=link_shoulderhandR(1:end-15,1);

%% LINK TRA LE CAVIGLIE

link_foot=sqrt((Ankle_R(:,1)-Ankle_L(:,1)).^2+(Ankle_R(:,2)-Ankle_L(:,2)).^2+(Ankle_R(:,3)-Ankle_L(:,3)).^2); %distanza tra caviglie
link_foott=link_foot(1:end-15,1);

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
sommaaree=areaeroneR+areaeroneL;%calcolo area tronco metodo erone
sommaareet=sommaaree(1:end-15,1);

%% LINK ANCHE

link_hip=sqrt((Hip_R(:,1)-Hip_L(:,1)).^2+(Hip_R(:,2)-Hip_L(:,2)).^2+(Hip_R(:,3)-Hip_L(:,3)).^2);
link_hipt=link_hip(1:end-15,1);

%% LINK SPALLE

link_shoulder=sqrt((Shoulder_R(:,1)-Shoulder_L(:,1)).^2+(Shoulder_R(:,2)-Shoulder_L(:,2)).^2+(Shoulder_R(:,3)-Shoulder_L(:,3)).^2);
link_shouldert=link_shoulder(1:end-15,1);

%% LINK MANI

link_hand=sqrt((Hand_R(:,1)-Hand_L(:,1)).^2+(Hand_R(:,2)-Hand_L(:,2)).^2+(Hand_R(:,3)-Hand_L(:,3)).^2);
link_handt=link_hand(1:end-15,1);

%% DELTA Y GINOCCHI

deltayknee = Knee_R(:,2)-Knee_L(:,2);
deltaykneet=deltayknee(1:end-15,1);


%% REGOLARITA'
derR=diff(locsmaxR);

% figure;
% plot(derR,'m');
% 
 derL=diff(locsmaxL);
% 
% figure;
% plot(derL,'m');


% Filtering C.F.

assezshoulderLt = filtering(assezshoulderLt);
assezshoulderRt = filtering(assezshoulderRt);
assexshoulderLt=filtering(assexshoulderLt);
assexshoulderRt=filtering(assexshoulderRt);
link_shoulderhandLt=filtering(link_shoulderhandLt);
link_shoulderhandRt=filtering(link_shoulderhandRt);
link_foott=filtering(link_foott);
sommaareet=filtering(sommaareet);
link_hipt=filtering(link_hipt);
link_shouldert=filtering(link_shouldert);
link_handt=filtering(link_handt);
deltaykneet=filtering(deltaykneet);