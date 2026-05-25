
SELECT sum(qtdePontos),

       sum(CASE
            WHEN qtdePontos > 0 THEN qtdePontos
        END) AS QtdePontosPositivos,

        sum(CASE
            WHEN QtdePontos < 0 THEN qtdePontos
        END) AS QtPontosNegativos,

        count (CASE
            WHEN QtdePontos < 0 THEN qtdePontos
        END) AS QtdeTransacaoNegativas

FROM transacoes
WHERE DtCriacao >= '2025-07-01' AND DtCriacao < '2025-08-01';
