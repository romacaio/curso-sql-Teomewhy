-- Qual o dia da semana mais ativo de cada usuário?

WITH tb_cliente_semana AS (
    
    SELECT idCliente,
            strftime('%w', substr(DtCriacao,1, 10)) AS diaSemana,
            count(IdTransacao) AS qtDetransacao
    FROM transacoes
    GROUP BY IdCliente, diaSemana
),

tb_rn AS (

    SELECT *,
         Case 
            WHEN diaSemana = '0' THEN 'Domingo'
            WHEN diaSemana = '1' THEN 'Segunda'
            WHEN diaSemana = '2' THEN 'Terça'
            WHEN diaSemana = '3' THEN 'Quarta'
            WHEN diaSemana = '4' THEN 'Quinta'
            WHEN diaSemana = '5' THEN 'Sexta'
            WHEN diaSemana = '6' THEN 'Sábado' 
        END AS descDiaSema,      
        row_number() OVER (PARTITION BY idCliente ORDER BY qtDetransacao DESC) AS rn
   
    FROM tb_cliente_semana
)

SELECT *
     
FROM tb_rn
WHERE rn = 1
