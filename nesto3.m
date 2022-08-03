clc; clear all; close all;

%% Import data

data = readtable("winequality-red.csv");

%% Konvertovanje iz char formata 
%  i raspodela po klasama

N = height(data);
klasa = zeros(N,1);

for i = 1:N
    switch data{i,12}
        case 0
            klasa(i,1) = 0;
        case 1
            klasa(i,1) = 1;
        case 2
            klasa(i,1) = 2;
        case 3
            klasa(i,1) = 3;
        case 4
            klasa(i,1) = 4;
        case 5
            klasa(i,1) = 5;
        case 6
            klasa(i,1) = 6;
        case 7
            klasa(i,1) = 7;
        case 8
            klasa(i,1) = 8;
        case 9
            klasa(i,1) = 9;
        case 10
            klasa(i,1) = 10;
    end
end

matrica = zeros(N,12);

for i = 1:N
    for j = 1:12
       matrica(i,j)=data{i,j};
    end 
end

%% Vizuelizacija broja podataka po klasama


figure;
    histogram(klasa);
    title('Prikaz po kvalitetu');
    xlabel('0 = najgore dok je 10 = najbolje');
    ylabel('koliko ima razlicitih vina');
    

%% Podela podataka na train i test

klasa_0 = matrica(klasa == 0,:);
klasa_1 = matrica(klasa == 1,:);
klasa_2 = matrica(klasa == 2,:);
klasa_3 = matrica(klasa == 3,:);
klasa_4 = matrica(klasa == 4,:);
klasa_5 = matrica(klasa == 5,:);
klasa_6 = matrica(klasa == 6,:);
klasa_7 = matrica(klasa == 7,:);
klasa_8 = matrica(klasa == 8,:);
klasa_9 = matrica(klasa == 9,:);
klasa_10 = matrica(klasa == 10,:);

procenat_trening = 0.8;
%ovde se uzima iz svake klase 80posto pa se dole uzima iz svake klase deo
index_trening0 = floor(length(klasa_0)*procenat_trening);
index_trening1 = floor(length(klasa_1)*procenat_trening);
index_trening2 = floor(length(klasa_2)*procenat_trening);
index_trening3 = floor(length(klasa_3)*procenat_trening);
index_trening4 = floor(length(klasa_4)*procenat_trening);
index_trening5 = floor(length(klasa_5)*procenat_trening);
index_trening6 = floor(length(klasa_6)*procenat_trening);
index_trening7 = floor(length(klasa_7)*procenat_trening);
index_trening8 = floor(length(klasa_8)*procenat_trening);
index_trening9 = floor(length(klasa_9)*procenat_trening);
index_trening10 = floor(length(klasa_10)*procenat_trening);

%%
% Spajanje u jedinstven trening skup

input_trening = [klasa_0(1:index_trening0,:);...
                 klasa_1(1:index_trening1,:);...
                 klasa_2(1:index_trening2,:);...
                 klasa_3(1:index_trening3,:);...
                 klasa_4(1:index_trening4,:);...
                 klasa_5(1:index_trening5,:);...
                 klasa_6(1:index_trening6,:);...
                 klasa_7(1:index_trening7,:);...
                 klasa_8(1:index_trening8,:);...
                 klasa_9(1:index_trening9,:);...
                 klasa_10(1:index_trening10,:)]';
             
output_trening = [zeros(1,index_trening0),...
                  ones(1,index_trening1),...
                  2.*ones(1,index_trening2)...
                  3.*ones(1,index_trening3)...
                  4.*ones(1,index_trening4)...
                  5.*ones(1,index_trening5)...
                  6.*ones(1,index_trening6)...
                  7.*ones(1,index_trening7)...
                  8.*ones(1,index_trening8)...
                  9.*ones(1,index_trening9)...
                  10.*ones(1,index_trening10)];

Ntrening = size(input_trening,2);
%%


input_test = [klasa_0(index_trening0+1:end,:);...
              klasa_1(index_trening1+1:end,:);...
              klasa_2(index_trening2+1:end,:);...
              klasa_3(index_trening3+1:end,:);...
              klasa_4(index_trening4+1:end,:);...
              klasa_5(index_trening5+1:end,:);...
              klasa_6(index_trening6+1:end,:);...
              klasa_7(index_trening7+1:end,:);...
              klasa_8(index_trening8+1:end,:);...
              klasa_9(index_trening9+1:end,:);...
              klasa_10(index_trening10+1:end,:)]';
output_test = [zeros(1,length(klasa_0)-index_trening0),...
               ones(1,length(klasa_1)-index_trening1),...
               2.*ones(1,length(klasa_2)-index_trening2),...
               3.*ones(1,length(klasa_3)-index_trening3),...
               4.*ones(1,length(klasa_4)-index_trening4),...
               5.*ones(1,length(klasa_5)-index_trening5),...
               6.*ones(1,length(klasa_6)-index_trening6),...
               7.*ones(1,length(klasa_7)-index_trening7),...
               8.*ones(1,length(klasa_8)-index_trening8),...
               9.*ones(1,length(klasa_9)-index_trening9),...
               10.*ones(1,length(klasa_10)-index_trening10)];
           
Ntest = size(input_test,2);

%%

% Pomesati podatke
ind = randperm(Ntrening);
input_trening = input_trening(:,ind);
output_trening = output_trening(:,ind);

ind = randperm(Ntest);
input_test = input_test(:,ind);
output_test = output_test(:,ind);

%% Obrada matrica output_trening i output_test
%hocemo da se vidi koliko pogodaka ima u train i test skupu, mi imamo
%vrednosti od nula do 10 pa se svaki testira
Ytrain = zeros(11,length(output_trening));

for i = 0:10
    for j = 1:length(output_trening)
        if(output_trening(1,j) == i)
            Ytrain(i+1,j) = 1;
        end
    end
end

Ytst = zeros(11,length(output_test));

for i = 0:10
    for j = 1:length(output_test)
        if(output_test(1,j) == i)
            Ytst(i+1,j) = 1;
        end
    end
end


%% Neural network

% Inicijalizacija svih promenljivih koje ce biti potrebne za
% krosvalidaciju 

% najbolji acc
acc = 0;
% najbolji F1
f1 = 0;
% struktura
struktura = {40,100,150};
best_struct = {};
% regularizacija
regularizacija = {0.1,0.3,0.5,0.7,0.9};
best_reg = 0.1;
% transfer function
transfer_fja = {'poslin','tansig','logsig'};
% najbolji broj epoha
best_epoch = 0;
% tezinski faktori
w_t = {2,3,4,5};
best_wt = 0;

%% Krosvalidacija
%     Potrebno je isprobati svaku kombinaciju hiperparametara koji mogu da
%     uticu na uspesnost NM

for structure = struktura
  for reg = regularizacija
   for transfer = transfer_fja
    for wt = w_t
        %Kreiranje NM sa trenutnom kombinacijom hiperparametara
    	net = patternnet(structure{1});
        
        for i=1:length(structure{1})
           net.layers{i}.transferFcn = transfer{1};
        end 

        %Definisanje koeficijenta regularizacije
        net.performParam.regularization = reg{1};
    
        %Aktiviranje zastite od preobucavanja na osnovu validacionog skupa
        net.divideFcn = 'divideind';
    
        %Podatke podeliti na osnovu indeksa, 80% train, 20% val, 0% test
        net.divideParam.trainInd = 1:floor(0.8*Ntrening);
        net.divideParam.testInd = [];
        net.divideParam.valInd = floor(0.8*Ntrening)+1:Ntrening;
    
        %Podesiti na koliko epoha se gleda rast greske na val skupu
        net.trainParam.max_fail = 20;
    
        %Podesiti maksimalnu dozvoljenu gresku
        net.trainParam.goal = 1e-6;
    
        %Podesiti vrednost minimalnog gradijenta
        net.trainParam.min_grad = 1e-3;
    
        %Podesiti maksimalan broj epoha treniranja
        net.trainParam.epochs = 1000;
        
        %Iskljucivanje prozora za obucavanje (zbog brzeg obucavanja)
        net.trainparam.showWindow = false;
    
        %Definisanje vektora sa tezinama sa kojim ce svaki podatak uci u
        %kriterijumsku funkciju
        w = ones(Ntrening,1);    
        w(output_trening == 3) = 10*w_t{1};
        w(output_trening == 8) = 7*w_t{1};
        w(output_trening == 4) = 6*w_t{1};
        w(output_trening == 7) = 5*w_t{1};
        w(output_trening == 6) = w_t{1};
        
        %Treniranje neuralne mreze nad trening skupom 
        [net, tr] = train(net, input_trening, Ytrain, [], [], w);
        
        %Dobijanje validacionih podataka
        Xval = input_trening(:,tr.valInd);
        Yval = Ytrain(:,tr.valInd);

        %Ispitivanje NM nad validacionim podacima
        Yval_pred = net(Xval);

        %Racunanje konfuzione matrice
        [~, cm] = confusion(Yval, Yval_pred);
        cm  = cm';

        %Racunanje pokazatelja performansi za 5. klasu
        R = cm(6,6)/sum(cm(:,6));
        P = cm(6,6)/sum(cm(6,:));
        A = trace(cm)/sum(cm(:));
        
        F1 = 2*R*P/(R+P); %f1 skor
   
        %Proveravanje da li je dobijena struktura najbolja i ukoliko jeste
        %cuvanje novih vrednosti
        %if A>acc
        
        if F1>f1
            f1 = F1;
            acc = A;
            best_reg = reg{1};
            best_struct = structure{1};
            best_epoch = tr.best_epoch;
            best_transfer = transfer{1};
            best_wt = wt{1};
        end
    end
   end
  end
end


%% Treniranje NM sa najboljim hiperparametrima
% Ovde treba podesiti sve hiperparametre koji su dobijeni malopre
%(struktura, aktivacione funkcije, koeficijent regularizacije, duzina
% treniranja (broj epoha), vektor tezina... Treniranje se vrsi na CELOM
% trening skupu (bez val skupa).

net = patternnet(best_struct);
net.trainParam.epochs = best_epoch;
net.divideFcn = 'divideind';
net.trainParam.max_fail = 10;
net.performParam.regularization = best_reg;

net.divideParam.trainInd = 1:floor(0.8*Ntrening);
net.divideParam.testInd = [];
net.divideParam.valInd = floor(0.8*Ntrening)+1:Ntrening;

w = ones(Ntrening,1);    
w(output_trening == 3) = 10*best_wt;
w(output_trening == 8) = 7*best_wt;
w(output_trening == 4) = 6*best_wt;
w(output_trening == 7) = 5*best_wt;
w(output_trening == 6) = best_wt;
w(output_trening == 5) = 1;

for i=1:length(best_struct)
        net.layers{i}.transferFcn = best_transfer;
end

[net,tr] = train(net,input_trening,Ytrain, [],[],w);



%% Testiranje NM nad test podacima

%%%%%% Predikaija NM nad trening skupom i prikaz matrice konfucije
Ytrening_pred = net(input_trening);
figure;
    plotconfusion(Ytrain, Ytrening_pred);
    title('Trening');
%%%%%%

%%%%%% Predikaija NM nad test skupom i prikaz matrice konfucije
Ytest_pred = net(input_test);
figure;
    plotconfusion(Ytst, Ytest_pred);
    title('Test');
%%%%%%

% Racunanje konfuzione matrice
[~, cm] = confusion(Ytst, Ytest_pred);
cm = cm';

% Racunanje pokazatelja performansi za prvu klasu
R = cm(6,6)/sum(cm(:,6));
P = cm(6,6)/sum(cm(6,:));
A = trace(cm)/sum(cm(:));
F1 = 2*R*P/(R+P);


