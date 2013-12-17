%leu dados
dados=csvread('dados.csv');

%separou dados entre positivos e negativos
dadosPos= dados( find(dados(:, 42)==1),  :);
dadosNeg= dados( find(dados(:, 42)==0),  :);
saida = [dadosPos(:, 42); dadosNeg(:, 42)];

%separa os dados entre saidas positivas e negativas e ordena eles
dadosPos = dadosPos(:, 1:41);
dadosNeg = dadosNeg(:, 1:41);
dados2 = [dadosPos;dadosNeg];


%normaliza os dados

dados2 = normalizacao(dados2);



%PCA
%[COEFF, SCORE, LATENT, TSQUARED] = princomp(sigmoided);

%divide aleatoriamente o conjunto de dados nos 3 casos proporcional aos
%parametros
[treino, validacao, teste]=dividerand(size(dados, 1), 0.7, 0, 0.3);

[ redes, mse ] = geraClassificadores(dados2(treino, :), saida(treino, :), 100, 200);
save('classificadores.mat');

selecao = selecaoComite(redes, dados2(treino, :), saida(treino,:), mse, 1);
save('saveConstrucao.mat');

[selecaoGen, populacao, adaptacao] = algGen( redes, dados2(treino, :), saida(treino, :), 100, 100);
save('saveAlgGen.mat');

%busca
resultTreino = round( comite( selecao, dados2(treino, :) ) );
resultTeste  = round( comite( selecao, dados2(teste, :) ) );
resultGeral  = round( comite( selecao, dados2 ) );

%genetico
resultTreinoGen = round( comite( selecaoGen, dados2(treino, :) ) );
resultTesteGen  = round( comite( selecaoGen, dados2(teste, :) ) );
resultGeralGen  = round( comite( selecaoGen, dados2 ) );

plotconfusion(resultTreino, saida(treino, :)', 'Treino', resultTeste, saida(teste,:)', 'Teste', resultGeral, saida','Geral', resultTreinoGen, saida(treino, :)', 'Treino Gen', resultTesteGen, saida(teste,:)', 'Teste Gen', resultGeralGen, saida','Geral Gen' );

