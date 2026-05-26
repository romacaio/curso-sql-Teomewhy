-- Quantos produtos são de rpg?

SELECT count(*)

FROM produtos
WHERE DescCategoriaProduto = 'rpg';

-- forma melhorada
SELECT DescCategoriaProduto,
        count(*)

FROM produtos
GROUP BY DescCategoriaProduto
