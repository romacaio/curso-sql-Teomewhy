-- Qual o produto mais transacionado?

SELECT IdProduto,
        sum(QtdeProduto) AS QtProdutosSum

FROM transacao_produto
GROUP BY 1
ORDER BY 2 DESC

LIMIT 1;

SELECT *
FROM produtos
WHERE IdProduto LIKE '5%'
