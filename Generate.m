
% funkcija koja kreira neuralnu mrezu u zavisnosti od broja
% layera i broja neurona

function [p_Tr,r_Tr,p_Ts,r_Ts] = Generate_NMiljana(ulazTest,izlazTest...
                                 ,ulazTrening, izlazTrening,neurons)

    net = patternnet(neurons);
    %ovo je krosvalidacija,potrebno probati sve i svasta za nm
    net.divideFcn = '';        % Iskljucivanje zastite od preobucavanja
    net.trainParam.epochs = 2000;
    net.trainParam.goal = 1e-3;
    net.trainParam.min_grad = 1e-8;
    net.performFcn = 'crossentropy';
   [net,tr] = train(net,ulazTrening,izlazTrening);  % treniranje NM

    % Prikaz matrica konfuzije
    izlazPrediction = sim(net, ulazTest);
    figure;
        plotconfusion(izlazTest, izlazPrediction);
        title('Testing set confusion matrix');

    izlazTreningPrediction = sim(net,ulazTrening);
    figure;
        plotconfusion(izlazTrening,izlazTreningPrediction);
        title('Training set confusion matrix');


    K1 = ulazTest(:,izlazTest==0);
    K2 = ulazTest(:,izlazTest==1);

    % Precision & recall za klasu 1
    [~,cm,~,~] = confusion(izlazTest,izlazPrediction);
    cm = cm';

    p_Tr = cm(2,2)/sum(cm(2,:));   % (true positive)/(predicted positive)
    r_Tr = cm(2,2)/sum(cm(:,2));      % (true positive)/(actual positive)

    [~,cm,~,~] = confusion(izlazTrening,izlazTreningPrediction);
    cm = cm';

    p_Ts = cm(2,2)/sum(cm(2,:));   % (true positive)/(predicted positive)
    r_Ts = cm(2,2)/sum(cm(:,2));      % (true positive)/(actual positive)

    % Definisanje i prikaz granice odlucivanja
    
    Ntest = 100;
    xTest = linspace(-4, 4, Ntest);
    yTest = linspace(-2, 6, Ntest);
    inTest = [];

    for i = xTest
        inTest = [inTest [i*ones(size(yTest)); yTest]];
    end

    outTest = sim(net, inTest);
    K1p = inTest(:,outTest<0.5);
    K2p = inTest(:,outTest>=0.5);

    figure;
    hold all;
        plot(K1(1,:),K1(2,:),'ko');
        axis equal;
        plot(K2(1,:),K2(2,:),'bx');
        scatter(K1p(1,:), K1p(2,:),'y.');
        scatter(K2p(1,:),K2p(2,:),'r.');
        title('Granica odlucivanja');
        legend('Klasa 0','Klasa 1','K0p','K1p');

    figure;
        plotperform(tr)    % Prikaz krive obucavanja


end


