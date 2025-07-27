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

-- 4.1 Operações basicas
INSERT INTO cliente(nome_cliente, telefone, email, saldo) 
VALUES ('Carlos Silva', '81987654321', 'carlos.silva@email.com', 300.00);

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (1, 2, 11, 50.00);

INSERT INTO resultado (id_extracao, id_animal)
VALUES (6, 5);

-- Remover cliente por ID
delete from aposta where id_cliente =1;
DELETE FROM cliente WHERE id_cliente = 1;

-- Remover todas as apostas de uma extração
DELETE FROM aposta WHERE id_extracao = 3;

-- Remover animal específico
delete from aposta where id_animal = 25;
DELETE FROM animal WHERE id_animal = 25;

-- Atualizar saldo de um cliente
UPDATE cliente SET saldo = 500.00 WHERE id_cliente = 2;

-- Atualizar valor de uma aposta
UPDATE aposta SET valor_apostado = 100.00 WHERE id_aposta = 3;

-- Atualizar resultado de uma extração
UPDATE resultado SET id_animal = 12 WHERE id_extracao = 3;


--------------------------------------------------------------------------
--------------------------------------------------------------------------


-- 4.3 Gatilho 
-- Trigger 1: Atualizar saldo apos aposta
DELIMITER 
CREATE TRIGGER trg_aposta_antes_inserir_validar_saldo
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

-- Teste trigger 1
-- Caso de teste 1: Cliente com saldo suficiente - Passa
-- Verificar saldo antes
SELECT saldo FROM cliente WHERE id_cliente = 2;

-- Inserir aposta
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (2, 2, 11, 50.00);

-- Verificar saldo depois
SELECT saldo FROM cliente WHERE id_cliente = 2;

-- Caso de teste 2: Cliente com saldo insuficiente - Nao passa
-- Verificar saldo antes
SELECT saldo FROM cliente WHERE id_cliente = 5;

-- Tentar inserir aposta com valor maior que o saldo 
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (5, 2, 11, 200.00);


-- Trigger 2
DELIMITER $$
CREATE PROCEDURE pagar_apostas()
BEGIN 
    -- ATUALIZAR O SALDO DOS CLIENTES QUE GANHARAM APOSTAS
    UPDATE cliente c
    JOIN (
        SELECT a.id_cliente, SUM(a.valor_apostado * 18) AS premio_total
        FROM aposta a
        JOIN resultado r ON a.id_extracao = r.id_extracao
        WHERE a.id_animal = r.id_animal AND a.pago = FALSE 
        GROUP BY a.id_cliente
    ) ganhadores ON c.id_cliente = ganhadores.id_cliente 
    SET c.saldo = c.saldo + ganhadores.premio_total;
    
    -- Marcar apostas como pagas
    UPDATE aposta a 
    JOIN resultado r ON a.id_extracao = r.id_extracao 
    SET a.pago = TRUE
    WHERE a.id_animal = r.id_animal AND a.pago = FALSE;
END $$
DELIMITER ;

-- Teste 2.1: Aposta em extração sem resultado 
START TRANSACTION;
SELECT '=== TESTE 2.1: Extração sem resultado ===' AS mensagem;
SELECT e.id_extracao, e.data_extracao, r.id_animal 
FROM extracao e LEFT JOIN resultado r ON e.id_extracao = r.id_extracao
WHERE r.id_extracao IS NULL;

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 6, 5, 20.00);
ROLLBACK;

-- Teste 2.2: Aposta em extração com resultado 
START TRANSACTION;
SELECT '=== TESTE 2.2: Extração com resultado ===' AS mensagem;
SELECT e.id_extracao, e.data_extracao, r.id_animal 
FROM extracao e JOIN resultado r ON e.id_extracao = r.id_extracao
LIMIT 1;

-- Falha na insercao
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 1, 5, 20.00);
ROLLBACK;


-- Trigger 3
-- Gatilho para validar aposta
DELIMITER //

CREATE TRIGGER trg_aposta_antes_inserir_validar_saldo_animal
BEFORE INSERT ON aposta
FOR EACH ROW
BEGIN 
    DECLARE saldo_atual DECIMAL(10,2);
    
    -- OBTER SALDO DO CLIENTE 
    SELECT saldo INTO saldo_atual
    FROM cliente
    WHERE id_cliente = NEW.id_cliente;
    
    -- VERIFICA SE O CLIENTE TEM SALDO SUFICIENTE
    IF saldo_atual < NEW.valor_apostado THEN 
        -- CASO NÃO OBTENHA SALDO SUFICIENTE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'SALDO INSUFICIENTE. APOSTA NÃO PODE SER REALIZADA';
    ELSE 
        -- ATUALIZA O SALDO DO CLIENTE
        UPDATE cliente
        SET saldo = saldo - NEW.valor_apostado
        WHERE id_cliente = NEW.id_cliente;
    END IF;
END//
DELIMITER ;

-- Teste 3.1: Animal existente 
START TRANSACTION;
SELECT '=== TESTE 3.1: Animal existente ===' AS mensagem;
SELECT id_animal, nome_animal FROM animal WHERE id_animal = 11;

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 2, 11, 20.00);
ROLLBACK;

-- Teste 3.2: Animal inexistente
START TRANSACTION;
SELECT '=== TESTE 3.2: Animal inexistente ===' AS mensagem;
SELECT id_animal FROM animal WHERE id_animal = 999;

-- Inserção cpm falha
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 2, 999, 20.00);
ROLLBACK;

-- Trigger 4
-- Caso o cliente tenha saldo, confirma aposta e atualizar o saldo 
DELIMITER //

CREATE TRIGGER trg_aposta_antes_inserir_validar_extracao
BEFORE INSERT ON aposta
FOR EACH ROW 
BEGIN 
    DECLARE verifica_resultados INT;
    
    -- Verificar se a extração já tem resultado
    SELECT COUNT(*) INTO verifica_resultados
    FROM resultado
    WHERE id_extracao = NEW.id_extracao;
    
    -- Se já tiver resultado 
    IF verifica_resultados > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'EXTRAÇÃO JÁ FOI REALIZADA. JÁ TEM RESULTADO CADASTRADO';
    END IF;
END//

DELIMITER ;


-- Triggers 5: 
-- Caso o cliente não tenha saldo, não proseguir com a aposta;
DELIMITER $$

CREATE TRIGGER trg_aposta_antes_inserir_validar_animal
BEFORE INSERT ON aposta 
FOR EACH ROW 
BEGIN
    DECLARE animal_cadastrado INT;
    
    -- Verificar se ID informado está cadastrado na tabela animais 
    SELECT COUNT(*) INTO animal_cadastrado 
    FROM animal 
    WHERE id_animal = NEW.id_animal;
    
    -- Caso não haja ID informado
    IF animal_cadastrado = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'NÃO É POSSÍVEL VALIDAR SUA APOSTA, POIS O ANIMAL É INVÁLIDO';
    END IF;
END$$

DELIMITER ;

-- Teste do Trigger 5
INSERT INTO animal (id_animal, nome) VALUES (1, 'Cavalo');
INSERT INTO aposta (id_animal, valor_apostado) VALUES (1, 10.00);
INSERT INTO aposta (id_animal, valor_apostado) VALUES (999, 10.00);

-- Trigger 6 : Registrar alteracoes de saldo
DELIMITER //
CREATE TRIGGER trg_registrar_alteracao_saldo
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    IF OLD.saldo != NEW.saldo THEN
        INSERT INTO historico_saldo (id_cliente, saldo_anterior, saldo_novo, motivo)
        VALUES (NEW.id_cliente, OLD.saldo, NEW.saldo, 'Alteração de saldo');
    END IF;
END//
DELIMITER ;

-- Primeiro, cria a tabela historico_saldo se não existir
CREATE TABLE IF NOT EXISTS historico_saldo (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    saldo_anterior DECIMAL(10,2),
    saldo_novo DECIMAL(10,2),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);
-- Teste 4.1: Alteração de saldo
START TRANSACTION;
SELECT '=== TESTE 4.1: Alteração de saldo ===' AS mensagem;
SELECT 'Histórico antes:' AS mensagem;
SELECT * FROM historico_saldo WHERE id_cliente = 2;

SELECT 'Saldo atual:' AS mensagem;
SELECT saldo FROM cliente WHERE id_cliente = 2;

UPDATE cliente SET saldo = 600.00 WHERE id_cliente = 2;

SELECT 'Histórico depois:' AS mensagem;
SELECT * FROM historico_saldo WHERE id_cliente = 2 ORDER BY data_alteracao DESC;
ROLLBACK;
