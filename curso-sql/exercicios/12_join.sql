-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?

-- primeira forma de resolução

WITH tb_clientes_jan AS (
    SELECT DISTINCT idcliente

    FROM transacoes
    WHERE DtCriacao >= '2025-01-01'
    AND DtCriacao < '2025-02-01'

)

SELECT  count(DISTINCT t1.idCliente) AS cliente_jan,
        count(DISTINCT t2.idCliente) AS cliente_curso

FROM tb_clientes_jan AS t1

LEFT JOIN transacoes AS t2
ON t1.idCliente = t2.idCliente 
AND DtCriacao >= '2025-08-25'
AND DtCriacao < '2025-08-30';



