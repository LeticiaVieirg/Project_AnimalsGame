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

