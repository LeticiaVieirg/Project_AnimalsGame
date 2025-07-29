-- Database creation
DROP DATABASE IF EXISTS animals_game;
CREATE DATABASE IF NOT EXISTS animals_game;
USE animals_game;

-- Table creations
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

-- Indexes
CREATE INDEX idx_cliente_email ON cliente(email);
CREATE INDEX idx_animal_nome ON animal(nome_animal);
CREATE INDEX idx_extracao_data ON extracao(data_extracao);
CREATE INDEX idx_aposta_cliente ON aposta(id_cliente);
CREATE INDEX idx_aposta_extracao ON aposta(id_extracao);
CREATE INDEX idx_aposta_animal ON aposta(id_animal);
CREATE INDEX idx_resultado_extracao ON resultado(id_extracao);
CREATE INDEX idx_resultado_animal ON resultado(id_animal);