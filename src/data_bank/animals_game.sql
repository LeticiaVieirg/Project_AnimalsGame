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
