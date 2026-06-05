CREATE TABLE tb_feature_store_cliente AS

WITH tb_transacoes AS (
    SELECT IdTransacao,
            IdCliente,
            qtdePontos,
            datetime(substr(DtCriacao, 1, 19)) AS dtCriacao,
            julianday('2025-06-01') - julianday(substr(DtCriacao, 1, 10)) AS diffDate,
            CAST(strftime('%H', substr(DtCriacao, 1, 19)) AS INTEGER) AS dtTime
    FROM transacoes
    WHERE DtCriacao < '2025-06-01'
),

tb_cliente AS (
    SELECT idCliente,
            datetime(substr(DtCriacao, 1 , 19)) AS dtCriacao,
            julianday('2025-06-01') - julianday(substr(DtCriacao, 1, 10)) AS idadeBase 
    FROM clientes
),

tb_sumario_transacoes AS (

SELECT idCliente,
        count(IdTransacao) AS qtdeTransacoesVida,
        
        count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtdeTransacoesD56,
        count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtdeTransacoesD28,
        count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtdeTransacoesD14,
        count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtdeTransacoesD7,

        min(diffDAte) AS diasUltimaInteracao,
        sum(qtdePontos) AS totalPontos,
        
        sum(CASE WHEN qtdePontos > 0 THEN qtdePontos else 0 END) AS qtDePontosPosVida,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS qtdePontosPos56,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosPos28, 
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosPos14,
        sum(CASE WHEN qtdePontos > 0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS qtdePontosPos7,

        sum(CASE WHEN qtdePontos < 0 THEN qtdePontos else 0 END) AS qtDePontosNegVida,
        sum(CASE WHEN qtdePontos < 0 THEN qtdePontos else 0 END) AS qtDePontosPosVida,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg56,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg28, 
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg14,
        sum(CASE WHEN qtdePontos < 0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg7

FROM tb_transacoes
GROUP BY idCliente
),

tb_transacao_produto AS (

        SELECT t1.*,
                t3.DescNomeProduto,
                t3.DescCategoriaProduto

        FROM tb_transacoes AS t1

        LEFT JOIN transacao_produto AS t2
        ON t1.IdTransacao = t2.IdTransacao

        LEFT JOIN produtos AS t3
        ON t2.IdProduto = t3.IdProduto
),

tb_cliente_produto AS (

        SELECT idCliente,
                DescNomeProduto,
                count(DescNomeProduto) AS qtDeVida,
                count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtDe56,
                count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtDe28,
                count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtDe14,
                count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtDe7

        FROM tb_transacao_produto
        GROUP BY idCliente, DescNomeProduto
),

tb_cliente_produto_rn AS (

        SELECT *,
                row_number() OVER (PARTITION BY idCliente ORDER BY qtDeVida DESC) AS rnVida,
                row_number() OVER (PARTITION BY idCliente ORDER BY qtDe56 DESC) AS rn56,
                row_number() OVER (PARTITION BY idCliente ORDER BY qtDe28 DESC) AS rn28,
                row_number() OVER (PARTITION BY idCliente ORDER BY qtDe14 DESC) AS rn14,
                row_number() OVER (PARTITION BY idCliente ORDER BY qtDe7 DESC) AS rn7
        
        FROM tb_cliente_produto
),

tb_cliente_dia AS (

        SELECT  idCliente,
                strftime('%w',DtCriacao) AS dtDia,
                count(*) AS qtDeTransacao
        FROM tb_transacoes
        WHERE diffDate <= 28

        GROUP BY idCliente, dtDia
),

tb_cliente_dia_rn AS (

SELECT *,
        row_number() OVER (PARTITION BY idCliente ORDER BY qtdeTransacao DESC) AS rnDia

FROM tb_cliente_dia

),

tb_join AS (

        SELECT t1.*,
                t2.idadeBase,
                t3.DescNomeProduto AS produtoVida,
                T4.DescNomeProduto AS produto56,
                T5.DescNomeProduto AS produto28,
                T6.DescNomeProduto AS produto14,
                T7.DescNomeProduto AS produto7,
                coalesce(t8.dtDia, -1) AS dtDia,
                coalesce(t9.periodo, 'SEM INFORMACAO') AS periodoMaisTransacao28
                
        FROM tb_sumario_transacoes AS t1

        LEFT JOIN tb_cliente AS t2
        ON t1.idCliente = t2.idCliente

        LEFT JOIN tb_cliente_produto_rn AS t3
        ON t1.idCliente = t3.idCliente
        AND t3.rnVida = 1

        LEFT JOIN tb_cliente_produto_rn AS t4
        ON t1.idCliente = t4.idCliente
        AND t4.rn56 = 1 

        LEFT JOIN tb_cliente_produto_rn AS t5
        ON t1.idCliente = t5.idCliente
        AND t5.rn28 = 1 

        LEFT JOIN tb_cliente_produto_rn AS t6
        ON t1.idCliente = t6.idCliente
        AND t6.rn14 = 1

        LEFT JOIN tb_cliente_produto_rn AS t7
        ON t1.idCliente = t7.idCliente
        AND t7.rn7 = 1

        LEFT JOIN tb_cliente_dia_rn AS t8
        ON t1.idCliente = t8.idCliente
        AND t8.rnDia = 1

        LEFT JOIN tb_cliente_periodo_rn AS T9
        ON t1.idCliente = t9.idCliente
        AND t9.rnPeriodo = 1
        
        ORDER BY idCliente
),

tb_cliente_periodo AS (

        SELECT idCliente,
                CASE 
                        WHEN dtTime BETWEEN 7 AND 12 THEN 'MANHÃ'
                        WHEN dtTime BETWEEN 13 AND 18 THEN 'TARDE'
                        WHEN dtTime BETWEEN 19 AND 23 THEN 'NOITE'
                        ELSE 'MADRUGADA'
                END AS periodo,
                count(*) AS qtDeTransacao

        FROM tb_transacoes
        WHERE diffDate <= 28
        GROUP BY 1,2
),

tb_cliente_periodo_rn AS (

        SELECT *,
                row_number() OVER (PARTITION BY idCliente ORDER BY qtDeTransacao DESC) AS rnPeriodo
        FROM tb_cliente_periodo
)

INSERT INTO tb_feature_store_cliente

SELECT '2025-06-01' AS dtRef,  
        *,
        1. * qtdeTransacoesD28 / qtdeTransacoesVida AS engajamento28Vida
FROM tb_join   


SELECT *
FROM tb_feature_store_cliente
ORDER BY idCliente, dtRef       
