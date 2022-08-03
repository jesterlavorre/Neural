clc; clear all; close all;

%% Definisanje parametara i funkcija

A = 4; B = 3; f1 = 20; f2 = 9;

x = 0:0.001:1.799;
N = length(x);

% Sinosidalna funkcija
h = A*sin(2*pi*f1*x)+B*sin(2*pi*f2*x);

% Slucajan sum odredjene standardne devijacije
s = (0.2*min(A,B)).*randn(1,N);

% Konacna funkcija

y = h + s;

%% Podela skupa na trening i test

% Slucajan odabir trening i test skupa
%ind = randperm(N);
%index = 1;

ind = randperm(N);

ulazTrening = x(ind(1:0.8*N));
ulazTest = x(ind(0.8*N +1:N));

izlazTrening = y(ind(1:0.8*N));
izlazTest = y(ind(0.8*N +1:N));

%ulazTrening = x(ind(1:index));
%ulazTest = x(ind(index+1:end));

%izlazTrening = y(ind(1:index));
%izlazTest = y(ind(index+1:end));


%% Prikaz funkcija

figure;
    plot(x,h);
    hold on;
    plot(x,y);
    hold off;
    title('Prikaz funkcija h(x) i y(x)');
    xlabel('Vrednost promenljive x [a.u.]');
    ylabel('Amplituda [a.u.]');
    legend('h(x)','y(x)');
    
%% Neuralna mreza

net = fitnet(200,'trainscg');

% Podesiti parametre neuralne mreze
net.performFcn = 'mse';%kriterijumska fja ovo kreira gresku u izlaznom sloju
net.divideFcn = '';
net.trainParam.epochs = 2000;
net.trainParam.goal = 0.000001;


% Obuciti NM nad trening skupom
net = train(net, ulazTrening, izlazTrening);

% Izvrsiti klasifikaciju nad test podacima
izlazPred = sim(net,ulazTest);

%% Prikaz rezultata
figure;
    plot(ulazTest, izlazPred, 'ro');
    hold on;
    plot(ulazTest, izlazTest, 'bx');
    legend('Estimirani podaci','Originalni podaci');
    title('Uspesnost predikcije neuralne mreze');
    

