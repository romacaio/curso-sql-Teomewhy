-- Quantidade de transações Acumuladas ao longo do tempo (diário)?
DROP TABLE IF EXISTS relatorio_diario;

CREATE TABLE IF NOT EXISTS relatorio_diario AS 

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

SELECT *
FROM tb_acum;

SELECT *
FROM relatorio_diario;