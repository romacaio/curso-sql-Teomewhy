-- Lista de transações com o produto “Resgatar Ponei”;

-- descobrindo o ID do prod “Resgatar Ponei”
SELECT DescNomeProduto,
        IdProduto

FROM produtos
WHERE DescNomeProduto = 'Resgatar Ponei';

-- buscando as transações com esse ID desse prod
SELECT *
FROM transacao_produto
WHERE IdProduto = 15;