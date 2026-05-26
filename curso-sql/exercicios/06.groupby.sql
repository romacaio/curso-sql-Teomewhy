-- Qual dia da semana quem tem mais pedidos em 2025?

SELECT strftime('%w', substr(DtCriacao,1,10)) AS DiaSemana,
        count(IdTransacao) AS QtDeTransacao       
        
FROM transacoes
WHERE DtCriacao >= '2025-01-01' AND DtCriacao < '2026-01-01'
GROUP BY DiaSemana
ORDER BY QtDeTransacao DESC

LIMIT 1;