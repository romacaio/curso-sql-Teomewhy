WITH tb_transacoes AS (
    SELECT IdTransacao,
            IdCliente,
            qtdePontos,
            datetime(substr(DtCriacao, 1, 19)) AS dtCriacao,
            julianday('now') - julianday(substr(DtCriacao, 1, 10)) AS diffDate
    FROM transacoes
),

tb_cliente AS (
    SELECT idCliente,
            datetime(substr(DtCriacao, 1 , 19)) AS dtCriacao,
            julianday('now') - julianday(substr(DtCriacao, 1, 10)) AS idadeBase 
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

tb_join AS (

        SELECT t1.*,
                t2.idadeBase,
                t3.DescNomeProduto AS produtoVida,
                T4.DescNomeProduto AS produto56,
                T5.DescNomeProduto AS produto28,
                T6.DescNomeProduto AS produto14,
                T7.DescNomeProduto AS produto7
                
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
        AND t6.rn7 = 1
        
        ORDER BY idCliente
)

SELECT *
FROM tb_join
