-- Dos clientes que começaram SQL no primeiro dia, quantos chegaram ao 5 dia?

SELECT count(DISTINCT IdCliente) AS QtDeClientes

FROM transacoes AS t1

WHERE substr(t1.DtCriacao, 1, 10) = '2025-08-29'
AND t1.idCliente IN (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
)
