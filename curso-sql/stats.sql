SELECT 
        avg(QtdePontos), -- média
        1. * sum (QtdePontos) / count (idCliente) AS MediaCarteiraRoots, -- bascicamente é isso que o avg faz
        round(avg (QtdePontos), 2) AS MediaCarteira, -- arredondando
        
        min (qtdePontos) AS MinCarteira,
        max (qtdePontos) AS MaxCarteira,

        sum (flTwitch),
        sum (flEmail)

FROM clientes