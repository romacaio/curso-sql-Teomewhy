-- Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 01?

WITH tb_alunos_dia01 AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
),

tb_dia_cliente AS (
    SELECT  t1.idCliente, 
            substr(t2.DtCriacao, 1, 10) AS dtDia,
            count(*) AS qtDeInteracoes
    FROM tb_alunos_dia01 AS t1

    LEFT JOIN transacoes AS t2
    ON t1.idCliente = t2.idCliente
    AND t2.DtCriacao >= '2025-08-25'
    AND t2.DtCriacao < '2025-09-01'

    GROUP BY t1.idCliente, dtDia
    ORDER BY t1.idCliente, dtDia
),

tb_rn AS (
    SELECT *,
            row_number() over (PARTITION BY idCliente ORDER BY qtDeInteracoes DESC, dtDia) AS rn
        
    FROM tb_dia_cliente
)

SELECT *

FROM tb_rn
WHERE rn = 1