-- Lista de clientes com 0 (zero) pontos;

SELECT idCliente,
        qtdePontos

From clientes
WHERE qtdePontos = 0;
