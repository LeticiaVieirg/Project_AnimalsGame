## Dictonary 
### Tabela Cliente
| Coluna | Tipo | Tamanho |Restrições | Chave | Descrição |
| ---    | ---  | ---     | ---       | ---   | --------      |
| id_cliente | INT | - | NOT NULL/UNIQUE | PK| Campo de auto incremento | 
| nome_cliente | VAR_CHAR | 50| NOT NULL | - | Nome do Cliente |
| telefone | VAR_CHAR | 50| NOT NULL | - | Telefone do cliente |
| email | VAR_CHAR |  50 | NOT NULL | - | E-mail do cliente |
| saldo | DECIMAL | 10,2 | NOT NULL |- | Saldo na conta |
### Tabela Aposta_Cliente
| Coluna | Tipo | Tamanho |Restrições | Chave | Descrição |
| ---    | ---  | ---     | ---       | ---   | ---       |
| id_aposta_cliente | Int | - | NOT NULL/UNIQUE | PK | Campo de auto incremento |
| id_aposta | INT | - | NOT NULL | FK | Campo de auto incremento |
| id_cliente| INT | - | NOT NULL | FK | Campo de auto incremento |
| valor | DECIMAL | 10,2 | NOT NULL |- | Valor da aposta feita pelo cliente |
### Tabela Aposta
| Coluna | Tipo | Tamanho |Restrições | Chave | Descrição |
| ---    | ---  | ---     | ---       | ---   | ---       |
| id_aposta| INT| - | NOT NULL/UNIQUE | PK | Campo de auto incremento |
| valor_aposta | DECIMAL | 10,2 | NOT NULL |- | Valor da aposta |
| id_extracao| INT | - | NOT NULL | FK | Campo de auto incremento |
### Tabela Extração
| Coluna | Tipo | Tamanho |Restrições | Chave | Descrição |
| ---    | ---  | ---     | ---       | ---   | ---       |
| id_extracao| INT | - | NOT NULL/UNIQUE | PK | Campo de auto incremento |
| data| DATETIME | - | NOT NULL | - | Data da aposta |
| horario| DATETIME | - | NOT NULL | - | Horário da aposta|
| id_aposta| INT | - | NOT NULL/UNIQUE | FK | Campo de auto incremento |
### Tabela Animal
| Coluna | Tipo | Tamanho |Restrições | Chave | Descrição |
| ---    | ---  | ---     | ---       | ---   | ---       |
| id_animal| INT| - | NOT NULL/UNIQUE | PK | Campo de auto incremento |
| nome_animal | VAR_CHAR |25| NOT NULL | - | Nome do Animal |
| id_Grupo| INT | - | NOT NULL | FK | Campo de auto incremento |
### Tabela Grupo
| Coluna | Tipo | Tamanho |Restrições | Chave | Descrição |
| ---    | ---  | ---     | ---       | ---   | ---       |
| id_grupo| INT | - | NOT NULL/UNIQUE | PK | Campo de auto incremento |
| dezenas | DECIMAL | 10,2 | NOT NULL | -- | Valores de cada animlal |
