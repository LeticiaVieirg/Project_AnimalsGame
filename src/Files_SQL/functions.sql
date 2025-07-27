USE animals_game;

-- Função 1: Retorna o saldo atual de um cliente
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

-- Função 2: Calcula o total apostado por um cliente
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
