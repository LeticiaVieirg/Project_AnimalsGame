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
(5, '2025-07-17 17:30:00');

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) VALUES
(1, 1, 15, 30.00 ),
(3, 1, 15, 20.00 ),
(2, 1, 15, 80.00 ),
(5, 1, 15, 10.00 ),
(4, 1, 15, 25.00 );

INSERT INTO resultado (id_extracao, id_animal) VALUES
(1, 7),
(2, 9),
(3, 11),
(4, 18),
(5, 1);


SELECT 
	a.id_aposta,
	c.nome_cliente,
	e.data_extracao,
	an.nome_animal AS animal_apostado,
	a.valor_apostado,
	a.valor_apostado * 18.00 AS valor_premio
FROM
	aposta a
JOIN cliente c ON a.id_cliente = c.id_cliente
JOIN extracao e ON a.id_extracao = e.id_extracao 
JOIN animal an ON a.id_animal = an.id_animal
JOIN resultado r ON a.id_extracao = r.id_extracao
WHERE a.id_animal = r.id_animal;


-- 4.1 Operações basicas
INSERT INTO cliente(nome_cliente, telefone, email, saldo) 
VALUES ('Carlos Silva', '81987654321', 'carlos.silva@email.com', 300.00);

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (1, 2, 11, 50.00);

INSERT INTO resultado (id_extracao, id_animal)
VALUES (6, '2025-07-18 09:30:00', 5);

-- Remover cliente por ID
DELETE FROM cliente WHERE id_cliente = 5;

-- Remover todas as apostas de uma extração
DELETE FROM aposta WHERE id_extracao = 3;

-- Remover animal específico
DELETE FROM animal WHERE id_animal = 25;

-- Listagem simples de todos os clientes
SELECT * FROM cliente;

-- Listar apostas com filtro por cliente
SELECT a.id_aposta, an.nome_animal, a.valor_apostado 
FROM aposta a
JOIN animal an ON a.id_animal = an.id_animal
WHERE a.id_cliente = 1;

-- Consulta com JOIN para ver resultados e animais sorteados
SELECT e.id_extracao, e.data_extracao, an.nome_animal AS animal_sorteado
FROM extracao e
JOIN resultado r ON e.id_extracao = r.id_extracao
JOIN animal an ON r.id_animal = an.id_animal;

-- Consulta com GROUP BY para somar apostas por animal
SELECT a.id_animal, an.nome_animal, SUM(a.valor_apostado) AS total_apostado
FROM aposta a
JOIN animal an ON a.id_animal = an.id_animal
GROUP BY a.id_animal, an.nome_animal;

-- Atualizar saldo de um cliente
UPDATE cliente SET saldo = 500.00 WHERE id_cliente = 2;

-- Atualizar valor de uma aposta
UPDATE aposta SET valor_apostado = 100.00 WHERE id_aposta = 3;

-- Atualizar resultado de uma extração
UPDATE resultado SET id_animal = 12 WHERE id_extracao = 3;

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

-- View 4: Apresenta historico completo das extracoes, com estatisticas de aposta de cada sorteio
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

-- 4.3 Gatilho 
-- Trigger 1: Atualizar saldo apos aposta
DELIMITER 
CREATE TRIGGER tg_atualizar_saldo_apos_aposta
BEFORE INSERT ON aposta
FOR EACH ROW
BEGIN
    DECLARE saldo_atual DECIMAL(10,2);
    
    SELECT saldo INTO saldo_atual FROM cliente WHERE id_cliente = NEW.id_cliente;
    
    IF saldo_atual < NEW.valor_apostado THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Saldo insuficiente para realizar a aposta';
    ELSE
        UPDATE cliente SET saldo = saldo - NEW.valor_apostado 
        WHERE id_cliente = NEW.id_cliente;
    END IF;
END //
DELIMITER ;

-- Ponto 5.4: teste de ateração

-- Alterar dados de um cliente 
UPDATE cliente
SET nome_cliente = 'João Batista', telefone = '84977773456', email = 'joaob@gmail.com', saldo = 100
WHERE id_cliente = 1;

-- Alterar os dados de uma aposta
UPDATE aposta
SET id_cliente = 2, id_extracao = 3, id_animal = 17, valor_apostado = 40
WHERE id_aposta = 3; 

-- Alterar os dados de um resultado
UPDATE resultado
SET id_extracao = 1, id_animal = 14
WHERE id_resultado = 3;

-- Indices

CREATE INDEX idx_cliente_email ON cliente(email);
-- Consultas que buscam cliente por e-mail serão instantâneas.

CREATE INDEX idx_animal_nome ON animal(nome_animal);
-- Permite buscas por nome sem varredura completa.

CREATE INDEX idx_extracao_data ON extracao(data_extracao);
-- Consultas ordenadas por data serão mais rápidas.

CREATE INDEX idx_aposta_cliente ON aposta(id_cliente);
CREATE INDEX idx_aposta_extracao ON aposta(id_extracao);
CREATE INDEX idx_aposta_animal ON aposta(id_animal);
-- Aceleram as consultas em JOINs

CREATE INDEX idx_resultado_extracao ON resultado(id_extracao);
CREATE INDEX idx_resultado_animal ON resultado(id_animal);
-- Aceleram consultas que verificam qual animal foi sorteado.