-------------------------------------------
-- Esta consulta envolverá a tabela de produtos, para buscar os sabores, a tabela de itens de notas fiscais, para obter o faturamento (quantidade X preço), e a tabela de notas fiscais, onde tem a data da venda. Você irá juntar a tabela de produtos e a tabela de itens de notas fiscais pelo código de produto, e em seguida juntará com a tabela de notas fiscais:
SELECT * FROM [TABELA DE PRODUTOS] TP
SELECT * FROM [NOTAS FISCAIS] NF
SELECT * FROM [ITENS NOTAS FISCAIS] INF


-------------------------------------------
-- Junte as três tabelas, selecionando os campos importantes para o relatório
SELECT
    TP.SABOR ,
    NF.DATA ,
    (INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO
FROM [ITENS NOTAS FISCAIS] INF

INNER JOIN [TABELA DE PRODUTOS] TP
ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
INNER JOIN [NOTAS FISCAIS] NF
ON NF.NUMERO = INF.NUMERO


-------------------------------------------
-- Agrupe esta consulta por sabor e ano
SELECT
    TP.SABOR ,
    YEAR(NF.DATA) AS ANO ,
    SUM (INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO
FROM [ITENS NOTAS FISCAIS] INF

INNER JOIN [TABELA DE PRODUTOS] TP
ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
INNER JOIN [NOTAS FISCAIS] NF
ON NF.NUMERO = INF.NUMERO

GROUP BY
    TP.SABOR ,
    YEAR(NF.DATA)


-------------------------------------------
-- Aplique o filtro para ter somente as vendas de 2016:
SELECT
    TP.SABOR ,
    YEAR(NF.DATA) AS ANO ,
    SUM(INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO
FROM [ITENS NOTAS FISCAIS] INF

INNER JOIN [TABELA DE PRODUTOS] TP
ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
INNER JOIN [NOTAS FISCAIS] NF
ON NF.NUMERO = INF.NUMERO

WHERE YEAR(NF.DATA) = 2016
GROUP BY
    TP.SABOR ,
    YEAR(NF.DATA)


-------------------------------------------
-- Guarde esta consulta e faça outra para obter a soma total de vendas no mesmo período. Para isso, aproveite a consulta anterior, mas tire o sabor do grupo:
SELECT
    YEAR(NF.DATA) AS ANO ,
    SUM(INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO ,
FROM [ITENS NOTAS FISCAIS] INF

INNER JOIN [TABELA DE PRODUTOS] TP
ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
INNER JOIN [NOTAS FISCAIS] NF
ON NF.NUMERO = INF.NUMERO

WHERE YEAR(NF.DATA) = 2016
GROUP BY YEAR(NF.DATA)


-------------------------------------------
-- Junte as duas consultas pelo campo que representa o ano:
SELECT
    AUX1.SABOR ,
    AUX1.FATURAMENTO ,
    AUX2.TOTAL
FROM
(
    SELECT
    TP.SABOR ,
    YEAR(NF.DATA) AS ANO ,
    SUM(INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO
    FROM [ITENS NOTAS FISCAIS] INF

    INNER JOIN [TABELA DE PRODUTOS] TP
    ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
    INNER JOIN [NOTAS FISCAIS] NF
    ON NF.NUMERO = INF.NUMERO

    WHERE YEAR(NF.DATA) = 2016
    GROUP BY
        TP.SABOR ,
        YEAR(NF.DATA)
) AUX1
INNER JOIN
(
    SELECT
    YEAR(NF.DATA) AS ANO ,
    SUM(INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO ,
    FROM [ITENS NOTAS FISCAIS] INF

    INNER JOIN [TABELA DE PRODUTOS] TP
    ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
    INNER JOIN [NOTAS FISCAIS] NF
    ON NF.NUMERO = INF.NUMERO

    WHERE YEAR(NF.DATA) = 2016
    GROUP BY YEAR(NF.DATA)
) AUX2
ON AUX1.ANO = AUX2.ANO


-------------------------------------------
-- Calcule a coluna percentual e ordene a saída do maior para o menor faturamento. Aproveite e converta os dados de faturamento e percentual para ser representado com duas casas decimais:
SELECT
    AUX1.SABOR ,
    AUX1.ANO ,
    CONVERT(DECIMAL(15, 2), AUX1.FATURAMENTO) AS FATURAMENTO ,
    CONVERT(VARCHAR, CONVERT(DECIMAL(15, 2), (AUX1.FATURAMENTO / AUX2.TOTAL) * 100))
    + ' %' AS PERCENTUAL
FROM
(
    SELECT
        TP.SABOR ,
        YEAR(NF.DATA) AS ANO ,
        SUM(INF.QUANTIDADE * INF.PREÇO) AS FATURAMENTO
    FROM [ITENS NOTAS FISCAIS] INF

    INNER JOIN [TABELA DE PRODUTOS] TP
    ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
    INNER JOIN [NOTAS FISCAIS] NF
    ON NF.NUMERO = NF.NUMERO

    WHERE YEAR(NF.DATA) = 2016

    GROUP BY
        TP.SABOR ,
        YEAR(NF.DATA)
) AUX1
INNER JOIN
(
    SELECT
        YEAR(NF.DATA) AS ANO ,
        SUM(INF.QUANTIDADE * INF.PREÇO) AS TOTAL
    FROM [ITENS NOTAS FISCAIS] INF

    INNER JOIN [TABELA DE PRODUTOS] TP
    ON TP.[CODIGO DO PRODUTO] = INF.[CODIGO DO PRODUTO]
    INNER JOIN [NOTAS FISCAIS] NF
    ON NF.NUMERO = INF.NUMERO

    WHERE YEAR(NF.DATA) = 2016

    GROUP BY
        YEAR(NF.DATA)
) AUX2
ORDER BY
    AUX1.FATURAMENTO DESC