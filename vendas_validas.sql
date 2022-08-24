SELECT * FROM [TABELA DE CLIENTES]
SELECT * FROM [ITENS NOTAS FISCAIS]
SELECT * FROM [NOTAS FISCAIS]

-------------------------------------------
-- Primeiramente, junte a tabela de notas fiscais com a tabela de itens
SELECT * FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF
ON NF.NUMERO = INF.NUMERO


-------------------------------------------
-- A seguir, segregue os campos importantes deste JOIN, aplicando algumas funções. Você irá obter apenas o CPF, a data convertida para mês e ano (para ver somente os dados dentro do mês) e a quantidade vendida:
SELECT
    NF.CPF ,
    SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7) AS ANO_MES ,
    INF.QUANTIDADE
FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF
ON NF.NUMERO = INF.NUMERO


-------------------------------------------
-- Agrupe esta consulta para obter o valor tota, por cliente e por mês/ano
SELECT
    NF.CPF ,
    SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7) AS ANO_MES ,
    SUM(INF.QUANTIDADE) AS QUANTIDADE_MES
FROM [NOTAS FISCAIS] NF
INNER JOIN [ITENS NOTAS FISCAIS] INF
ON NF.NUMERO = INF.NUMERO
GROUP BY
    NF.CPF ,
    SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7)


-------------------------------------------
-- Guarde esta consulta e verifique, agora, os dados do limite de vendas em quantidades contidas na tabela de clientes. Selecione apenas os campos necessários a serem usados no relatório.
SELECT TC.NOME, TC.[VOLUME DE COMPRA] FROM [TABELA DE CLIENTES] TC


-------------------------------------------
-- Junte as duas consultas acima. A que obtém dados de vendas e a que obtém dados do limite máximo
SELECT
    TC.NOME ,
    CQ.ANO_MES ,
    CQ.QUANTIDADE_MES ,
    TC.[VOLUME DE COMPRA]
FROM
(
    SELECT
        NF.CPF ,
        SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7) AS ANO_MES,
        SUM(INF.QUANTIDADE) AS QUANTIDADE_MES
    FROM [NOTAS FISCAIS] NF
    INNER JOIN [ITENS NOTAS FISCAIS] INF
    ON NF.NUMERO = INF.NUMERO

    GROUP BY
        NF.CPF ,
        SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7)
) CQ
INNER JOIN [TABELA DE CLIENTES] TC
ON TC.CPF = CQ.CPF


-------------------------------------------
-- Com duas colunas comparando as vendas com os limites, crie um "case" que irá testar se a venda do mês superou ou não a venda limite e escrever um label para isso. Apresente esta consulta ordenada e você terá o relatório final:
SELECT
    AUX1.NOME ,
    AUX1.QUANTIDADE_MES ,
    CASE
        WHEN AUX1.QUANTIDADE_MES <= AUX1.[VOLUME DE COMPRA / 10] THEN 'VENDA VÁLIDA'
        WHEN AUX1.QUANTIDADE_MES > AUX1.[VOLUME DE COMPRA / 10] THEN 'VENDA INVÁLIDA'
    END AS STATUS_VENDA
FROM
(
    SELECT
        TC.NOME ,
        CQ.ANO_MES ,
        CQ.QUANTIDADE_MES ,
        TC.[VOLUME DE COMPRA]
    FROM
    (
        SELECT
            NF.CPF ,
            SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7) AS ANO_MES ,
            SUM(INF.QUANTIDADE) AS QUANTIDADE_MES
        FROM [NOTAS FISCAIS] NF
        INNER JOIN [ITENS NOTAS FISCAIS] INF
        ON NF.NUMERO = INF.NUMERO
        GROUP BY
            NF.CPF ,
            SUBSTRING(CONVERT(VARCHAR, NF.[DATA], 120), 1, 7)
    ) CQ
    INNER JOIN [TABELA DE CLIENTES] TC
    ON TC.CPF = CQ.CPF
) AUX1
ORDER BY
    AUX1.NOME ,
    AUX1.ANO_MES


-------------------------------------------
--