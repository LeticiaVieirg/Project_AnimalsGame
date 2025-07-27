-- 1. SQL com os creates, alter tables e visões (views)

-- 4.1
drop database animals_game;
create database if not exists animals_game;
use animals_game;

CREATE TABLE cliente(
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(50),
    telefone VARCHAR(50),
    email VARCHAR(50),
    saldo DECIMAL (10,2)
);

CREATE TABLE animal(
    id_animal INT PRIMARY KEY,
    nome_animal VARCHAR (25)
);

CREATE TABLE extracao(
    id_extracao INT PRIMARY KEY,
    data_extracao DATETIME
);

CREATE TABLE aposta(
    id_aposta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_extracao INT,
    id_animal INT,
    valor_apostado DECIMAL (10,2),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_extracao) REFERENCES extracao (id_extracao),
    FOREIGN KEY (id_animal) REFERENCES animal (id_animal)
);

CREATE TABLE resultado(
    id_resultado INT AUTO_INCREMENT PRIMARY KEY,
    id_extracao INT,
    id_animal INT,
    FOREIGN KEY (id_extracao) REFERENCES extracao (id_extracao),
    FOREIGN KEY (id_animal) REFERENCES animal (id_animal)
);

-- Povoamento do Banco de Dados
INSERT INTO cliente(nome_cliente, telefone, email, saldo) VALUES
('João Pedro', '84988998899', 'joao.pedro@email.com', 230.00),
('Ana Clara', '83997989798', 'ana.clara@email.com', 200.00),
('Maria Eduarda', '82996969798', 'maria.eduarda@email.com', 250.00),
('Diego Rafael', '84967879678', 'diego.rafael@email.com', 180.00),
('Mateus Henrique', '81983458769', 'mateus.henrique@email.com', 140.00);

INSERT INTO animal (id_animal, nome_animal) VALUES
(1, 'Avestruz'), (2, 'Aguia'), (3, 'Burro'), (4, 'Borboleta'),
(5, 'Cachorro'),(6, 'Cabra'),(7, 'Carneiro'),(8, 'Camelo'),
(9, 'Cobra'),(10, 'Coelho'),(11, 'Cavalo'),(12, 'Elefante'),
(13, 'Galo'),(14, 'Gato'),(15, 'Jacaré'),(16, 'Leão'),
(17, 'Macaco'),(18, 'Porco'),(19, 'Pavão'), (20, 'Peru'),
(21, 'Touro'), (22, 'Tigre'),(23, 'Urso'),(24, 'Veado'),
(25, 'Vaca');

INSERT INTO extracao(id_extracao, data_extracao) VALUES
(1, '2025-07-17 09:30:00'),
(2, '2025-07-17 11:30:00'),
(3, '2025-07-17 13:30:00'),
(4, '2025-07-17 15:30:00'),
(5, '2025-07-17 17:30:00'),
(6, '2025-07-18 09:30:00');

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) VALUES
(1, 1, 15, 30.00 ),
(3, 1, 10, 20.00 ),
(2, 1, 17, 80.00 ),
(5, 1, 12, 10.00 ),
(4, 1, 25, 25.00 );

INSERT INTO resultado (id_extracao, id_animal) VALUES
(1, 15),
(2, 9),
(3, 11),
(4, 18),
(5, 1);

-- 4.2
-- View 1: Simplificacao de consultas de apostas vencedoras
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


-- View 2: Visualizacao do saldo dos clientes com classificacao
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

-- Clientes com saldo alto para ofertas especiais
SELECT * FROM vw_saldo_clientes WHERE nivel_saldo = 'Alto';

-- View 3: Animais mais populares entre os apostadores, incluindo contagem de 
-- aposta e valor total apostado
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

-- Consulta simples para apostas vencedoras não pagas
SELECT * FROM vw_apostas_vencedoras WHERE valor_premio > 0;

-- View 4: Apresenta historico completo das extracoes
-- Com estatisticas de aposta de cada sorteio
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

-- View 5 : Resumo total apostado por cada cliente
-- Lista todos os clientes, com apostas e sem apostas
CREATE OR REPLACE VIEW vw_total_apostado_por_cliente AS
SELECT 
    c.id_cliente,
    c.nome_cliente,
    COUNT(a.id_aposta) AS total_apostas,
    SUM(a.valor_apostado) AS total_valor_apostado
FROM cliente c
LEFT JOIN aposta a ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome_cliente;

-- View 6 : Mostra quais animais sao mais populares entre os apostadores
CREATE OR REPLACE VIEW vw_animais_mais_apostados AS
SELECT 
    an.id_animal,
    an.nome_animal,
    COUNT(a.id_aposta) AS total_apostas
FROM animal an
LEFT JOIN aposta a ON an.id_animal = a.id_animal
GROUP BY an.id_animal, an.nome_animal
ORDER BY total_apostas DESC;

-- View 7: Mostra uma lista completa de todas as extracoes realizadas e os seus resultados
-- Extracoes com resultados definidos
CREATE OR REPLACE VIEW vw_extracoes_com_resultado AS
SELECT 
    e.id_extracao,
    e.data_extracao,
    an.id_animal,
    an.nome_animal AS animal_sorteado
FROM resultado r
JOIN extracao e ON e.id_extracao = r.id_extracao
JOIN animal an ON an.id_animal = r.id_animal;
