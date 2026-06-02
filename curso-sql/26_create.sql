
--DROP TABLE IF EXISTS clientes_d28;

CREATE TABLE IF NOT EXISTS clientes_d28 (
    idCliente varchar(250) PRIMARY KEY,
    qtDeTransacao integer
);

DELETE FROM clientes_d28;
INSERT INTO clientes_d28

SELECT idCliente,
        count(IdTransacao) AS qtDeTransacao

FROM transacoes
WHERE julianday('now') - julianday(substr(DtCriacao, 1, 10)) <= 28 
GROUP BY idCliente;

SELECT *
FROM clientes_d28;