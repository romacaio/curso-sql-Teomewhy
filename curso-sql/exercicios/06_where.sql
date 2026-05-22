-- Lista de produtos com nome que termina com “Lover”

SELECT IdProduto,
        DescNomeProduto

FROM produtos
WHERE DescNomeProduto LIKE '%Lover';