
WITH tb_cliente_dia AS (
    SELECT  DISTINCT idCliente,
            substr(DtCriacao, 1, 10) AS dtDia,
            count(IdTransacao) AS qtDeTransacao

    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'

    GROUP BY idCliente, dtDia
),

tb_lag AS (

    SELECT  *,
            sum(qtDeTransacao) OVER (PARTITION BY idCliente ORDER BY dtDia) AS acum,
            lag(qtDeTransacao) OVER (PARTITION BY idCliente ORDER BY dtDia) AS lagTransacao

    FROM tb_cliente_dia
)

SELECT  *,
        1.* qtDeTransacao / lagTransacao
FROM tb_lag
