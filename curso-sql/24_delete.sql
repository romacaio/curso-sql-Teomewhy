-- podemos deletar campos específicos utilizando o DELETE + WHERE

DELETE FROM relatorio_diario
WHERE strftime('%w', Dtdia) = '0';

SELECT * FROM relatorio_diario;