
USE animals_game;

-- Data population
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
(1, 1, 15, 30.00),
(3, 1, 10, 20.00),
(2, 1, 17, 80.00),
(5, 1, 12, 10.00),
(4, 1, 25, 25.00);

INSERT INTO resultado (id_extracao, id_animal) VALUES
(1, 15),
(2, 9),
(3, 11),
(4, 18),
(5, 1);

-- Basic operations
INSERT INTO cliente(nome_cliente, telefone, email, saldo) 
VALUES ('Carlos Silva', '81987654321', 'carlos.silva@email.com', 300.00);

INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (1, 2, 11, 50.00);

-- Remove operations
DELETE FROM cliente WHERE id_cliente = 5;
DELETE FROM aposta WHERE id_extracao = 3;
DELETE FROM animal WHERE id_animal = 25;

-- Update operations
UPDATE cliente SET saldo = 500.00 WHERE id_cliente = 2;
UPDATE aposta SET valor_apostado = 100.00 WHERE id_aposta = 3;
UPDATE resultado SET id_animal = 12 WHERE id_extracao = 3;
