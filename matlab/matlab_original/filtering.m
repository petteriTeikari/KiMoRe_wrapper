function [ media ] = filtering( x)
%media mobile: funzione che calcola la media su una finestra di valori pari
%a passo, media con shift pari a passo
filtCutOff = 1;
sample=30;
[b, a] = butter(3, (2*filtCutOff)/sample, 'low');
media = filtfilt(b, a, x);

end

    
  