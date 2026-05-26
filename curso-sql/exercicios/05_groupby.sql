-- Qual o valor médio de pontos positivos por dia?

SELECT sum(QtdePontos) AS TotalPontos,
        count(DISTINCT substr(DtCriacao,1,10)) AS QtDeDiasUnicos,
        sum(QtdePontos) / count(DISTINCT substr(DtCriacao,1,10)) AS AvgPontosDias

FROM transacoes
WHERE QtdePontos > 0;

SELECT substr(DtCriacao, 1,10) AS DtDia,
        round(avg(QtdePontos), 2) AS AvgPontosDia

FROM transacoes
WHERE QtdePontos > 0
GROUP BY 1 -- primeira do select
ORDER BY 1;