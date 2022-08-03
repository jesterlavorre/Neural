clc; clear all; close all;

%% Ucitavanje podataka

data = load('dataset3.mat');
data = data.data;

%% Vizuelizacija podataka po klasama
ulaz = data(:,1:2)';
class_0 = data(1:1500,1:2)';
class_1 = data(1501:3000,1:2)';
aff = data(:,3)';

figure;
    plot(class_0(1,:),class_0(2,:),'rx');
    hold on;
    plot(class_1(1,:),class_1(2,:),'bo');
    axis equal;
    title('Prikaz podataka po klasama');
    xlabel('Vrednost po apscisi [a.u.]');
    ylabel('Vrednost po ordinati [a.u.]');
    legend('Klasa 0','Klasa 1');
%ovde je kraj prve tacke
%% Podela skupa podataka

N = length(ulaz(1,:));
niz = randperm(N); % Nasumicna permutacija niza od 1 do N

procenat_obucavanja = 80; % definisanje koliko procenata podataka 
                          % ulazi u obucavajuci skup
                          
last_ind = (procenat_obucavanja/100)*N;
                          
% Definisanje trening skupa
ulazTrening = ulaz(:,niz(1:last_ind));
izlazTrening = aff(:,niz(1:last_ind));  

% Definisanje skupa za testiranje
ulazTest = ulaz(:,niz((last_ind+1):N));
izlazTest = aff(niz((last_ind+1):N));   % Ocekivani izlaz

%% OPtimalna neuralna mreza

[p_Tr1,r_Tr1,p_Ts1,r_Ts1] = Generate_NMiljana(ulazTest,izlazTest,...
                                ulazTrening,izlazTrening,[5 5]);
%ovo je kad je ok mreza
%% Overfitting efekat

[p_Tr2,r_Tr2,p_Ts2,r_Ts2] = Generate_NMiljana(ulazTest,izlazTest,...
                                ulazTrening,izlazTrening,[30 30 30]);
%ovo je kad se preobuci
%% Underfitting efekat

[p_Tr3,r_Tr3,p_Ts3,r_Ts3] = Generate_NMiljana(ulazTest,izlazTest,...
                                ulazTrening,izlazTrening,2);
%ovo je kad nije dobro obucena