USE animals_game;

-- Gatilho 1: Verifica saldo do cliente antes de realizar uma aposta
DELIMITER $$
CREATE TRIGGER tg_realizaraposta
BEFORE INSERT ON aposta
FOR EACH ROW
BEGIN 
    DECLARE saldo_atual DECIMAL(10,2);

    SELECT saldo INTO saldo_atual
    FROM cliente
    WHERE id_cliente = NEW.id_cliente;

    IF saldo_atual < NEW.valor_apostado THEN 
        SET MESSAGE_TEXT = 'SALDO INSUFICIENTE. APOSTA NÃO PODE SER REALIZADA';
    ELSE 
        UPDATE cliente
        SET saldo = saldo - NEW.valor_apostado
        WHERE id_cliente = NEW.id_cliente;
    END IF;
END $$
DELIMITER ;

-- Gatilho 2: Impede apostas em extrações que já possuem resultado
DELIMITER $$
CREATE TRIGGER tg_bloquearextracao
BEFORE INSERT ON aposta
FOR EACH ROW 
BEGIN 
    DECLARE verifica_resultados INT;

    SELECT COUNT(*) INTO verifica_resultados
    FROM resultado
    WHERE id_extracao = NEW.id_extracao;

    IF verifica_resultados > 0 THEN
        SET MESSAGE_TEXT = 'EXTRAÇÃO JÁ FOI REALIZADA. JÁ TEM RESULTADO CADASTRADO';
    END IF;
END $$
DELIMITER ;

-- Gatilho 3: Verifica se o animal apostado existe
DELIMITER $$
CREATE TRIGGER tg_verificar_animal
BEFORE INSERT ON aposta 
FOR EACH ROW 
BEGIN
    DECLARE animal_cadastrado INT;

    SELECT COUNT(*) INTO animal_cadastrado 
    FROM animal 
    WHERE id_animal = NEW.id_animal;

    IF animal_cadastrado = 0 THEN
        SET MESSAGE_TEXT = 'NÃO É POSSÍVEL VALIDAR SUA APOSTA, POIS O ANIMAL É INVÁLIDO';
    END IF;
END $$
DELIMITER ;
