/*
    listar todas as transações adicionando uma coluna nova sinalizando “alto”, “médio” e “baixo” 
    para o valor dos pontos [<10 ; <500; >=500]
*/

SELECT *,
        CASE 
            WHEN QtdePontos < 10 THEN 'baixo'
            WHEN qtdePontos < 500 THEN 'médio'
            WHEN qtdePontos >= 500 THEN 'alto'
        END AS FlQtdePontos 

FROM transacoes
ORDER BY QtdePontos DESC;
