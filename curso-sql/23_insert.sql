DELETE FROM relatorio_diario; -- sem ele teremos dados duplicados cada vez que rodado

WITH tb_diario AS (

    SELECT  substr(DtCriacao, 1, 10) AS dtDia,
            count(idTransacao) AS qtDeTransacao
    FROM transacoes
    GROUP BY dtDia
    ORDER BY dtDia
),

tb_acum AS (
    
    SELECT  *,
        sum(qtDeTransacao) OVER (ORDER BY dtDia) AS qtDeTransacao_acum
    FROM tb_diario

)

INSERT INTO relatorio_diario 

SELECT *
FROM tb_acum;

SELECT * FROM relatorio_diario;