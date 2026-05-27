-- Em 2024, quantas transações de Lovers tivemos?

SELECT count(*) AS numLovers
        --t1.IdTransacao,
        --t1.idCliente,
        --t2.IdProduto,
        --t3.DescCategoriaProduto

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto =  t3.IdProduto

WHERE substr(DtCriacao, 1, 4) = '2024'
AND t3.DescCategoriaProduto = 'lovers';

