SELECT idCliente,
        qtdePontos,
        qtdePontos + 10 AS qtdePontosPlus10,
        qtdePontos * 2 AS qtdePontoDouble,
        DtCriacao,
        
        substr(DtCriacao, 1,19) AS dtSubString,
        datetime(substr(DtCriacao, 1, 19)) AS dtCriacaoNova,
        strftime('%w', datetime(substr(DtCriacao, 1, 19))) AS diaSemana
        
FROM clientes;