use animals_game;

CREATE VIEW vw_apostas_vencedoras AS
SELECT 
    a.id_aposta,
    c.nome_cliente,
    e.data_extracao,
    an_aposta.nome_animal AS animal_apostado,
    an_resultado.nome_animal AS animal_sorteado,
    a.valor_apostado,
    (a.valor_apostado * 18.00) AS valor_premio
FROM aposta a
JOIN cliente c ON a.id_cliente = c.id_cliente
JOIN extracao e ON a.id_extracao = e.id_extracao
JOIN animal an_aposta ON a.id_animal = an_aposta.id_animal
JOIN resultado r ON a.id_extracao = r.id_extracao
JOIN animal an_resultado ON r.id_animal = an_resultado.id_animal
WHERE a.id_animal = r.id_animal;

CREATE VIEW vw_saldo_clientes AS
SELECT 
    id_cliente,
    nome_cliente,
    telefone,
    email,
    saldo,
    CASE 
        WHEN saldo > 200 THEN 'Alto'
        WHEN saldo BETWEEN 100 AND 200 THEN 'Médio'
        ELSE 'Baixo'
    END AS nivel_saldo
FROM cliente;

CREATE VIEW vw_animais_mais_apostados AS
SELECT 
    a.id_animal,
    an.nome_animal,
    COUNT(*) AS total_apostas,
    SUM(ap.valor_apostado) AS valor_total_apostado
FROM animal a
JOIN aposta ap ON a.id_animal = ap.id_animal
JOIN animal an ON a.id_animal = an.id_animal
GROUP BY a.id_animal, an.nome_animal
ORDER BY total_apostas DESC;

CREATE VIEW vw_historico_resultados AS
SELECT 
    e.id_extracao,
    e.data_extracao,
    a.nome_animal AS animal_sorteado,
    (SELECT COUNT(*) FROM aposta ap WHERE ap.id_extracao = e.id_extracao) AS total_apostas,
    (SELECT SUM(ap.valor_apostado) FROM aposta ap WHERE ap.id_extracao = e.id_extracao) AS valor_total_apostado
FROM extracao e
JOIN resultado r ON e.id_extracao = r.id_extracao
JOIN animal a ON r.id_animal = a.id_animal;

CREATE OR REPLACE VIEW vw_total_apostado_por_cliente AS
SELECT 
    c.id_cliente,
    c.nome_cliente,
    COUNT(a.id_aposta) AS total_apostas,
    SUM(a.valor_apostado) AS total_valor_apostado
FROM cliente c
LEFT JOIN aposta a ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome_cliente;

CREATE OR REPLACE VIEW vw_animais_mais_apostados AS
SELECT 
    an.id_animal,
    an.nome_animal,
    COUNT(a.id_aposta) AS total_apostas
FROM animal an
LEFT JOIN aposta a ON an.id_animal = a.id_animal
GROUP BY an.id_animal, an.nome_animal
ORDER BY total_apostas DESC;

CREATE OR REPLACE VIEW vw_extracoes_com_resultado AS
SELECT 
    e.id_extracao,
    e.data_extracao,
    an.id_animal,
    an.nome_animal AS animal_sorteado
FROM resultado r
JOIN extracao e ON e.id_extracao = r.id_extracao
JOIN animal an ON an.id_animal = r.id_animal;
