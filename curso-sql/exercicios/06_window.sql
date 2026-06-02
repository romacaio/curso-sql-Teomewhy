-- Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo?

WITH tb_dia_cliente AS (
    SELECT substr(DtCriacao, 1, 10) AS dtDia,
            count(DISTINCT idCliente) AS qtDeCliente

    FROM clientes

    GROUP BY dtDia
    ORDER BY dtDia
),

tb_acum AS (

    SELECT  *,
            sum(qtDeCliente) OVER (ORDER BY dtDia) AS qtDeClientes_acum
    FROM tb_dia_cliente
)

SELECT *
FROM tb_acum