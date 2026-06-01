
WITH cliente_dia AS (
    SELECT  DISTINCT IdCliente,
            substr(DtCriacao, 1, 10) AS dtDia

    FROM transacoes
    WHERE substr(DtCriacao, 1, 4) = '2025'

    ORDER BY IdCliente, DtCriacao
),

tb_lag AS (
    SELECT  *,
            lag(dtDia) OVER(PARTITION BY idCliente ORDER BY dtDia) AS lagDia

    FROM cliente_dia
),

tb_diff_dt AS (
    SELECT  *,
            julianday(dtDia) - julianday(lagDia) AS diffDt

    FROM tb_lag
),

tb_avg_cliente AS (
    SELECT  idCliente,
            avg(diffDt) AS avg_dia

    FROM tb_diff_dt
    GROUP BY idCliente
)

SELECT avg(avg_dia)
FROM tb_avg_cliente