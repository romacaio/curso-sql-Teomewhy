-- Qual o produto com mais pontos transacionados?

SELECT  IdProduto,
        sum(vlProduto * QtdeProduto) AS TotalPontos

FROM transacao_produto
GROUP BY 1
ORDER BY 2 DESC

LIMIT 1;

