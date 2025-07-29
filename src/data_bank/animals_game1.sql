-- criacao do banco de dados 
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
-- insira na tabela cliente esses dados 
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

-- Consulta: recupera informações sobre apostas vencedoras, detalha e 
-- Mostra as apostas vencedoras e os seus premios 
SELECT 
	a.id_aposta,
	c.nome_cliente,
	e.data_extracao,
	an.nome_animal AS animal_apostado,
	a.valor_apostado,
	a.valor_apostado * 18.00 AS valor_premio
FROM
	aposta a
JOIN cliente c ON a.id_cliente = c.id_cliente -- liga aposta com cliente por meio do id do cliente
JOIN extracao e ON a.id_extracao = e.id_extracao 
JOIN animal an ON a.id_animal = an.id_animal
JOIN resultado r ON a.id_extracao = r.id_extracao
WHERE a.id_animal = r.id_animal; -- filtro para mostrar somente as apostas onde o animal é sorteado

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

-- Listagem simples de todos os clientes
SELECT * FROM cliente; -- selecione todos de cliente

-- Listar apostas com filtro por cliente
-- selecione informacoes especificas sobre um determinado cliente
SELECT a.id_aposta, an.nome_animal, a.valor_apostado 
FROM aposta a                                -- relaciona a tabela apostas com
JOIN animal an ON a.id_animal = an.id_animal -- a tabela de animais 
WHERE a.id_cliente = 1;

-- Consulta para verificar todos os sorteios com os animais sorteados
-- Seleciona informacoes especificas de extracao e animal
SELECT e.id_extracao, e.data_extracao, an.nome_animal AS animal_sorteado
FROM extracao e                                   -- relaciona a tabela extracao com
JOIN resultado r ON e.id_extracao = r.id_extracao -- a tabela resultado 
JOIN animal an ON r.id_animal = an.id_animal;     -- e a tabela animais 

-- Consulta com GROUP BY para somar apostas por animal
-- Seleciona informacoes de animal e aposta, 
-- realiza a soma de todos os valores apostados em cada animal
SELECT a.id_animal, an.nome_animal, SUM(a.valor_apostado) AS total_apostado
FROM aposta a                                -- relaciona a tabela aposta a tabela animal
JOIN animal an ON a.id_animal = an.id_animal -- por meio do id
GROUP BY a.id_animal, an.nome_animal;        -- Agrupa os resultados por id animal e nome animal 

-- Atualizar saldo de um cliente
UPDATE cliente SET saldo = 500.00 WHERE id_cliente = 2;

-- Atualizar valor de uma aposta
UPDATE aposta SET valor_apostado = 100.00 WHERE id_aposta = 3;

-- Atualizar resultado de uma extração
UPDATE resultado SET id_animal = 12 WHERE id_extracao = 3;

-- 4.2
-- View 1: Simplificacao de consultas de apostas vencedoras
CREATE VIEW vw_apostas_vencedoras AS
SELECT                                         -- Seleciona informacoes das apostas
    a.id_aposta,                               
    c.nome_cliente,
    e.data_extracao,
    an_aposta.nome_animal AS animal_apostado,
    an_resultado.nome_animal AS animal_sorteado,
    a.valor_apostado,
    (a.valor_apostado * 18.00) AS valor_premio
    
FROM aposta a                                  -- relaciona a tabela aposta com 
JOIN cliente c ON a.id_cliente = c.id_cliente  -- a tabela cliente 
JOIN extracao e ON a.id_extracao = e.id_extracao
JOIN animal an_aposta ON a.id_animal = an_aposta.id_animal
JOIN resultado r ON a.id_extracao = r.id_extracao
JOIN animal an_resultado ON r.id_animal = an_resultado.id_animal
WHERE a.id_animal = r.id_animal;                 -- garante que so traz apostas vencedoras 


-- View 2: Visualizacao do saldo dos clientes com classificacao
-- Classificacao dos clientes com base no seu saldo 
CREATE VIEW vw_saldo_clientes AS
SELECT 
    id_cliente,
    nome_cliente,
    telefone,
    email,
    saldo,
    CASE         -- Calculo da classificacao
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
-- JOIN aposta ap ON a.id_animal = ap.id_animal 
JOIN animal an ON a.id_animal = an.id_animal -- relaciona animais 
GROUP BY a.id_animal, an.nome_animal
ORDER BY total_apostas DESC;

-- Consulta simples para apostas vencedoras não pagas
SELECT * FROM vw_apostas_vencedoras WHERE valor_premio > 0;

-- View 4: Mostrar o historico completo das extracoes, com estatisticas de aposta de cada sorteio
CREATE VIEW vw_historico_resultados AS -- ok
SELECT 
    e.id_extracao,
    e.data_extracao,
    a.nome_animal AS animal_sorteado,
    (SELECT COUNT(*) FROM aposta ap WHERE ap.id_extracao = e.id_extracao) AS total_apostas,
    (SELECT SUM(ap.valor_apostado) FROM aposta ap WHERE ap.id_extracao = e.id_extracao) AS valor_total_apostado
FROM extracao e
JOIN resultado r ON e.id_extracao = r.id_extracao
JOIN animal a ON r.id_animal = a.id_animal;

-- View 5 
CREATE OR REPLACE VIEW vw_total_apostado_por_cliente AS
SELECT 
    c.id_cliente,
    c.nome_cliente,
    COUNT(a.id_aposta) AS total_apostas,
    SUM(a.valor_apostado) AS total_valor_apostado
FROM cliente c
LEFT JOIN aposta a ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome_cliente;

-- View 6 
CREATE OR REPLACE VIEW vw_animais_mais_apostados AS
SELECT 
    an.id_animal,
    an.nome_animal,
    COUNT(a.id_aposta) AS total_apostas
FROM animal an
LEFT JOIN aposta a ON an.id_animal = a.id_animal
GROUP BY an.id_animal, an.nome_animal
ORDER BY total_apostas DESC;

-- View 7 
CREATE OR REPLACE VIEW vw_extracoes_com_resultado AS
SELECT 
    e.id_extracao,
    e.data_extracao,
    an.id_animal,
    an.nome_animal AS animal_sorteado
FROM resultado r
JOIN extracao e ON e.id_extracao = r.id_extracao
JOIN animal an ON an.id_animal = r.id_animal;


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

-- Inserir aposta (valor menor que o saldo)
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (2, 2, 11, 50.00);

-- Verificar saldo depois (deve ter diminuído)
SELECT saldo FROM cliente WHERE id_cliente = 2;

-- Caso de teste 2: Cliente com saldo insuficiente - Nao passa
-- Verificar saldo antes
SELECT saldo FROM cliente WHERE id_cliente = 5;

-- Tentar inserir aposta com valor maior que o saldo (deve gerar erro)
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (5, 2, 11, 200.00);

-- ----------------------

-- --------------------------

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

-- Teste 2.1: Aposta em extração sem resultado (deve passar)
START TRANSACTION;
SELECT '=== TESTE 2.1: Extração sem resultado ===' AS mensagem;
SELECT e.id_extracao, e.data_extracao, r.id_animal 
FROM extracao e LEFT JOIN resultado r ON e.id_extracao = r.id_extracao
WHERE r.id_extracao IS NULL;

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 6, 5, 20.00);
ROLLBACK;

-- Teste 2.2: Aposta em extração com resultado (deve falhar)
START TRANSACTION;
SELECT '=== TESTE 2.2: Extração com resultado ===' AS mensagem;
SELECT e.id_extracao, e.data_extracao, r.id_animal 
FROM extracao e JOIN resultado r ON e.id_extracao = r.id_extracao
LIMIT 1;

-- Esta inserção deve falhar
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

-- Teste 3.1: Animal existente (deve passar)
START TRANSACTION;
SELECT '=== TESTE 3.1: Animal existente ===' AS mensagem;
SELECT id_animal, nome_animal FROM animal WHERE id_animal = 11;

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 2, 11, 20.00);
ROLLBACK;

-- Teste 3.2: Animal inexistente (deve falhar)
START TRANSACTION;
SELECT '=== TESTE 3.2: Animal inexistente ===' AS mensagem;
SELECT id_animal FROM animal WHERE id_animal = 999;

-- Esta inserção deve falhar
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado) 
VALUES (3, 2, 999, 20.00);
ROLLBACK;

-- Trigger 4
-- caso o cliente tenha saldo, confirma aposta e atualizar o saldo 
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

-- Primeiro, vamos criar a tabela historico_saldo se não existir
CREATE TABLE IF NOT EXISTS historico_saldo (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    saldo_anterior DECIMAL(10,2),
    saldo_novo DECIMAL(10,2),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Teste 4.1: Alteração de saldo (deve registrar)
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


-- Teste trigger 6 
-- Ver histórico de saldo antes
SELECT * FROM historico_saldo WHERE id_cliente = 2;

-- Atualizar saldo
UPDATE cliente SET saldo = 600.00 WHERE id_cliente = 2;

-- Ver histórico de saldo depois (deve ter novo registro)
SELECT * FROM historico_saldo WHERE id_cliente = 2;

-- Testar atualização que não altera saldo (não deve registrar)
UPDATE cliente SET email = 'novo.email@teste.com' WHERE id_cliente = 2;

-- Verificar que não foi criado novo registro
SELECT * FROM historico_saldo WHERE id_cliente = 2 ORDER BY data_alteracao DESC LIMIT 1;

-- 4.4 Functions
-- Function 1
-- Função para retornar o saldo atual de um cliente pelo ID
DELIMITER $$
CREATE FUNCTION fn_saldo_cliente(p_id_cliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE saldo_cliente DECIMAL(10,2);
    SELECT saldo INTO saldo_cliente
    FROM cliente
    WHERE id_cliente = p_id_cliente;
    RETURN saldo_cliente;
END $$
DELIMITER ;

-- Function 2
-- Função para calcular o total apostado por um cliente
DELIMITER $$
CREATE FUNCTION fn_total_apostado_por_cliente(p_id_cliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_apostado DECIMAL(10,2);
    SELECT COALESCE(SUM(valor_apostado), 0) INTO total_apostado
    FROM aposta
    WHERE id_cliente = p_id_cliente;
    RETURN total_apostado;
END $$
DELIMITER ;

-- ------------------------------------------------------------------------------------------------
 -- 4.5 Otimização e Indices 
-- Consultas que buscam cliente por e-mail serão instantâneas.
CREATE INDEX idx_cliente_email ON cliente(email);

-- Permite buscas por nome sem varredura completa.
CREATE INDEX idx_animal_nome ON animal(nome_animal);

-- Consultas ordenadas por data serão mais rápidas.
CREATE INDEX idx_extracao_data ON extracao(data_extracao);

-- Aceleram as consultas em JOINs
CREATE INDEX idx_aposta_cliente ON aposta(id_cliente);
CREATE INDEX idx_aposta_extracao ON aposta(id_extracao);
CREATE INDEX idx_aposta_animal ON aposta(id_animal);

-- Aceleram consultas que verificam qual animal foi sorteado.
CREATE INDEX idx_resultado_extracao ON resultado(id_extracao);
CREATE INDEX idx_resultado_animal ON resultado(id_animal);
-- --------------------------------------------------------------------------------------------------

-- 5.1 Teste de Inserção
-- Teste de Inserção 1
-- Saldo Suficiente 
SELECT nome_cliente, saldo FROM cliente WHERE id_cliente = 3;
-- 'Nome do Usuário' , Valor do Saldo
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (3, 6, 11, 50.00);
-- Verificar o novo saldo
SELECT nome_cliente, saldo FROM cliente WHERE id_cliente = 3;
-- 'Nome do Usuário, Valor do Saldo - 50 ex: (300 - 50)
-- Verificar se a aposta existe
SELECT * FROM aposta WHERE id_cliente = 3 AND id_extracao = 6;
-- Dados da Aposta

-- Teste de Inserção 2
-- Saldo Insulficiente
SELECT nome_cliente, saldo FROM cliente WHERE id_cliente = 5;
--  'Nome do Usuário', Valor do Saldo
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (5, 6, 25, 150.00);
-- "SALDO INSUFICIENTE. APOSTA NÃO PODE SER REALIZDA"

-- -- Teste de Inserção 3
-- Validar Extração
SELECT * FROM resultado WHERE id_extracao = 1;
-- (id_extracao: 1, id_animal: 15).
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (2, 1, 10, 15.00);
-- "EXTRAÇÃO JÁ FOI REALIZADA. JÁ TEM RESULTADO CADASTRO"
-- Apostando em Extração Aberta
SELECT * FROM resultado WHERE id_extracao = 6;
-- Nenhum retorno esperado
-- Usando o cliente 4 
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (4, 6, 7, 20.00);
-- Resultado esperado: Comando executado com sucesso.
SELECT * FROM aposta WHERE id_cliente = 4 AND id_extracao = 6;
-- Resultado esperado: Linha com os dados da Aposta

-- Teste de Inserção 4
-- Teste do Gatilho de verificar animal
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (4, 6, 99, 10.00);
-- "NÃO É POSSÍVEL VALIDAR SUA APOSTA, POIS O ANIMAL É INVALIDO"
-- --------------------------------------------------------------------------------------------------

-- 5.2 Teste de remoção
-- Teste 1
-- Verificar cliente antes da remoção
SELECT * FROM cliente WHERE id_cliente = 4;
-- Comando de remoção
DELETE FROM cliente WHERE id_cliente = 4;
-- Verificar se foi removido
SELECT * FROM cliente WHERE id_cliente = 4;

-- Teste 2
-- Verificar extração antes da remoção
SELECT * FROM extracao WHERE id_extracao = 6;
-- Comando de remoção
DELETE FROM extracao WHERE id_extracao = 6;
-- Verificar se foi removido
SELECT * FROM extracao WHERE id_extracao = 6;
-- -------------------------------------------------------------------------------------------------

-- 5.3: Teste de listagem
-- Teste 1.1: Listar todos os clientes ordenados por saldo decrescente
SELECT id_cliente, nome_cliente, telefone, email, saldo
FROM cliente
ORDER BY saldo DESC;

-- Teste 1: Listar clientes com saldo acima de 200
SELECT id_cliente, nome_cliente, saldo
FROM cliente
WHERE saldo > 200
ORDER BY nome_cliente;

-- Teste 2: Listar valor total apostado por cliente
SELECT 
    c.id_cliente,
    c.nome_cliente,
    COUNT(a.id_aposta) AS quantidade_apostas,
    SUM(a.valor_apostado) AS total_apostado,
    MAX(a.valor_apostado) AS maior_aposta,
    MIN(a.valor_apostado) AS menor_aposta
FROM cliente c
LEFT JOIN aposta a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente, c.nome_cliente
ORDER BY total_apostado DESC;

-- Teste 3: Listar clientes que nunca apostaram
SELECT 
    c.id_cliente,
    c.nome_cliente,
    c.saldo
FROM cliente c
LEFT JOIN aposta a ON c.id_cliente = a.id_cliente
WHERE a.id_aposta IS NULL;
-- ------------------------------------------------------------------------------------------------

-- 5.4: Teste de alteração
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
-- -------------------------------------------------------------------------------------------------

-- 5.5 Testes de views
select * from  vw_apostas_vencedoras;

select * from vw_saldo_clientes;

select * from vw_animais_mais_apostados; 

-- --------------------------------------------------------------------------------------------------
-- 5.7 Testes de funcoes
-- Testar saldo do cliente 1
SELECT fn_saldo_cliente(1) as saldo_cliente;

-- Testar total apostado pelo cliente 3
SELECT fn_total_apostado(3) as total_apostado;

CREATE INDEX idx_aposta_cliente ON aposta(id_cliente);
CREATE INDEX idx_aposta_extracao ON aposta(id_extracao);
CREATE INDEX idx_aposta_animal ON aposta(id_animal);

CREATE INDEX idx_resultado_extracao ON resultado(id_extracao);
CREATE INDEX idx_resultado_animal ON resultado(id_animal);
