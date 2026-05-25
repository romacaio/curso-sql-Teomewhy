
-- Quantas transações foram feitas no mês de julho e quantos clientes distintos

SELECT 
    count (*),
    count (DISTINCT IdTransacao),
    count(DISTINCT idCliente)
FROM transacoes
WHERE DtCriacao >= '2025-07-01' AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC;





