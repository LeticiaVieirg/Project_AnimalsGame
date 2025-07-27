USE animals_game;

-- Test 1: Sufficient balance
SELECT nome_cliente, saldo FROM cliente WHERE id_cliente = 3;
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (3, 6, 11, 50.00);
SELECT nome_cliente, saldo FROM cliente WHERE id_cliente = 3;
SELECT * FROM aposta WHERE id_cliente = 3 AND id_extracao = 6;

-- Test 2: Insufficient balance
SELECT nome_cliente, saldo FROM cliente WHERE id_cliente = 5;
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (5, 6, 25, 150.00);

-- Test 3: Validate extraction
SELECT * FROM resultado WHERE id_extracao = 1;
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (2, 1, 10, 15.00);

-- Test 4: Betting on open extraction
SELECT * FROM resultado WHERE id_extracao = 6;
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (4, 6, 7, 20.00);
SELECT * FROM aposta WHERE id_cliente = 4 AND id_extracao = 6;

-- Test 5: Animal validation trigger
INSERT INTO aposta (id_cliente, id_extracao, id_animal, valor_apostado)
VALUES (4, 6, 99, 10.00);

-- Test 6: Update tests
UPDATE cliente
SET nome_cliente = 'João Batista', telefone = '84977773456', email = 'joaob@gmail.com', saldo = 100
WHERE id_cliente = 1;

UPDATE aposta
SET id_cliente = 2, id_extracao = 3, id_animal = 17, valor_apostado = 40
WHERE id_aposta = 3;

UPDATE resultado
SET id_extracao = 1, id_animal = 14
WHERE id_resultado = 3;
