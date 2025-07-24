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

-- Coluna pagamento 
ALTER TABLE aposta ADD pago BOOLEAN DEFAULT FALSE;

-- Mostrar os bilhetes acertaram o resultado e os que perderam

CREATE OR REPLACE VIEW vw_bilhetes_resultados AS 
SELECT 
	a.id_aposta,
    a.id_cliente,
    c.nome_cliente,
    a.id_extracao,
    e.data_extracao,
    a.id_animal AS animal_apostado,
    r.id_animal AS animal_sorteado,
    a.valor_apostado,
    
    CASE 
		WHEN a.id_animal = r.id_animal THEN 'Ganhou'
        ELSE 'Perdeu'
        END AS status_aposta,
        CASE 
        WHEN a.id_animal = r.id_animal THEN a.valor_apostado * 18 
        ELSE 0 
        END AS valor_premio, 
        a.pago
        FROM aposta a
        JOIN cliente c ON c.id_cliente = a.id_cliente
        JOIN extracao e ON e.id_extracao = a.id_extracao
        JOIN resultado r ON r.id_extracao = a.id_extracao;
        
-- Visualizar todos os bilhetes, status (ganhou ou perdeu).
SELECT * FROM vw_bilhetes_resultados;

DELIMITER $$

CREATE PROCEDURE pagar_apostas ()
	BEGIN 
	
    -- ATUALIZAR O SALDO DOS CLIENTES QUE GANHOU APSOTA 
    
    UPDATE cliente.c 
    JOIN (SELECT a.id_cliente, SUM(a.valor_apostado * 18) AS premio_total
    FROM aposta a
    JOIN resultado r ON a.id_extracao = r.id_extracao
    WHERE a.id_animal = r.id_animal AND a.pago = FALSE 
    GROUP BY a.id_cliente) ganhadores ON c.id_cliente = ganhadores.id_cliente SET c.saldo = c.saldo + ganhadores.premio_total;
    
    -- Informa que a aposta foi paga 
    UPDATE aposta a 
    JOIN resultado r ON a.id_extracao = r.id_extracao 
    SET a.pago = TRUE
    WHERE a.id_animal = r.id_animal AND a.pago = FALSE;
END $$
DELIMITER ;

-- Gatilhos
-- Gatilho para validar aposta
-- caso o cliente tenha saldo, confirma aposta e atualizar o saldo 
-- caso o cliente não tenha saldo, não proseguir com a aposta;

DELIMITER $$

CREATE TRIGGER tg_realizaraposta
	BEFORE INSERT ON aposta
    FOR EACH ROW
    BEGIN 
		DECLARE saldo_atual DECIMAL (10,2);
        
        -- OBTER SALDO DO CLIENTE 
        SELECT saldo INTO saldo_atual
        FROM cliente
        WHERE id_cliente = NEW.id_cliente;
        
		-- VERIFICA SE O CLIENTE TEM SALDO SUFICIENTE PARA REALIZAR APOSTA
    IF saldo_atual <NEW.valor_apostado THEN 
		-- CASO NÃO OBTENHA SALDO SUFICIENTE
		SET MESSAGE_TEXT = 'SALDO INSUFICIENTE. APOSTA NÃO PODE SER REALIZDA';
	ELSE 
		UPDATE cliente
        SET saldo = saldo - NEW.valor_apostado
        WHERE id_cliente = NEW.id_cliente;
	END IF;
END $$

-- bloquear extração após ser informado resultado.

DELIMITER ;

DELIMITER $$
	
CREATE TRIGGER tg_bloquearextracao
	BEFORE INSERT ON aposta
    FOR EACH ROW 
    BEGIN 
		DECLARE verifica_resultados INT;
        
        -- Verificar se a extração já tem resultado
        
        SELECT COUNT(*) INTO verifica_resultados
        FROM resultado
        WHERE id_extracao = NEW.id_extracao;
        
        -- Se já tive resultado 
        IF verificar_resultado > 0 THEN
        SET MESSAGE_TEXT = 'EXTRAÇÃO JÁ FOI REALIZADA. JÁ TEM RESULTADO CADASTRO';
	END IF;
END $$
DELIMITER ;
-- NÃO DEIXAR REALIZAR APOSTA CASO TENTE APOSTAR EM UM ANIMAL QUE NÃO TENHA NO BANCO DE DADOS

DELIMITER $$

CREATE TRIGGER tg_verificar_animal
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
			SET MESSAGE_TEXT = 'NÃO É POSSÍVEL VALIDAR SUA APOSTA, POIS O ANIMAL É INVALIDO';
		END IF;
	END $$
DELIMITER ; 

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

-- Testes de Gatilhos
	-- Descreva as operações que disparam cada gatilho.
    -- Forneça os comandos SQL para simular essas operações e verifique os resultados esperados do gatilho.

-- Aposta com Saldo Suficiente 

SELECT saldo FROM cliente WHERE id_cliente = 1;

-- Validar aposta 

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (1, 1, 15, 30.00);

-- Verificar saldo após apostar 
SELECT saldo FROM cliente WHERE id_cliente = 1;

-- verificar aposta 

SELECT * FROM aposta WHERE id_cliente = 1; 

-- Aposta sem saldo suficiente 

SELECT saldo FROM cliente WHERE id_cliente = 5;

-- validar aposta 

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (5, 1, 25, 150.00);


-- Extracao bloqueada / já tem resultado
SELECT * FROM resultado;
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (2, 1, 15, 100.00);

-- Extracao sem resultado 
-- Verificar se a extracao 6, ainda está sem resultado
SELECT * FROM resultado WHERE id_extracao = 6;

-- Apostar na extracão 6
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (3, 6, 12, 20.00);


-- animal válido 

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (3, 6, 12, 20.00);


-- animal inválido
-- Aposta não pode ser realizada.

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (4, 6, 99, 20.00);

-- Exemplos de testes simples para as funções

-- Testar saldo do cliente 1
SELECT fn_saldo_cliente(1) AS saldo_cliente;

-- Testar total apostado pelo cliente 3
SELECT fn_total_apostado_por_cliente(3) AS total_apostado;
