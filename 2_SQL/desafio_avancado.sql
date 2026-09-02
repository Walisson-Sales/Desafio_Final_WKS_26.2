USE clinica_care;

-- Desafio Avançado:
-- Pergunta de negócio:
-- Quais pacientes possuem maior valor de consultas realizadas
-- dentro de cada plano e qual é o seu perfil financeiro?

WITH ValorPorPaciente AS (
    SELECT 
        pl.id_plano,
        pl.nome_plano,
        pac.id_paciente,
        pac.nome_completo AS paciente,
        COUNT(c.id_consulta) AS total_consultas,
        SUM(c.valor_consulta) AS valor_total_consultas
    FROM Paciente pac
    INNER JOIN Plano pl 
        ON pac.id_plano = pl.id_plano
    INNER JOIN Consulta c 
        ON pac.id_paciente = c.id_paciente
    WHERE c.status = 'Realizada'
    GROUP BY 
        pl.id_plano,
        pl.nome_plano,
        pac.id_paciente,
        pac.nome_completo
)

SELECT 
    nome_plano,
    paciente,
    total_consultas,
    valor_total_consultas,

    -- Ranking dos pacientes dentro de cada plano
    RANK() OVER (
        PARTITION BY id_plano
        ORDER BY valor_total_consultas DESC
    ) AS ranking_no_plano,

    -- Classificação do perfil financeiro
    CASE
        WHEN valor_total_consultas > 500 
            THEN 'Paciente Premium (Alto Valor)'
        WHEN valor_total_consultas BETWEEN 200 AND 500 
            THEN 'Paciente Padrão'
        ELSE 'Paciente Esporádico'
    END AS perfil_financeiro

FROM ValorPorPaciente
ORDER BY 
    nome_plano,
    ranking_no_plano;

-- Sugestão de índice:
-- Índice composto para auxiliar a filtragem por status,
-- o JOIN por paciente e o acesso ao valor da consulta.

CREATE INDEX idx_consulta_cobertura 
ON Consulta (id_paciente, status, valor_consulta);