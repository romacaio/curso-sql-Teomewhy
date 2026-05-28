-- Dos clientes que começaram SQL no primeiro dia, quantos chegaram ao 5 dia?
-- CTE: Common Table Expression

WITH tb_cliente_primeiro_dia AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
),

tb_cliente_ultimo_dia AS (

    SELECT DISTINCT idCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-29'

),

tb_join AS (
    
    SELECT t1.idCliente AS primCliente,
            t2.idCliente AS ultCliente
    
    FROM tb_cliente_primeiro_dia AS t1

    LEFT JOIN tb_cliente_ultimo_dia AS t2
    ON t1.idCliente = t2.idCliente
)

SELECT count(primCliente),
        count(ultCliente),
        1. * count(primCliente) / count(ultCliente) AS proporcao

FROM tb_join

