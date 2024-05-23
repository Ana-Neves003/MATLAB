clear all;
close all;
clc

% Exemplo de matriz
matriz_exemplo = [1, 2, 3; 4, 5, 6; 7, 8, 9];

% Calcular a média ao longo das colunas (dimensão 2)
media_colunas = mean(matriz_exemplo, 1);

% Calcular a média ao longo das linhas (dimensão 1)
media_linhas = mean(matriz_exemplo, 2);

disp('Matriz Original:');
disp(matriz_exemplo);

disp('Média ao Longo das Colunas:');
disp(media_colunas);

disp('Média ao Longo das Linhas:');
disp(media_linhas);
