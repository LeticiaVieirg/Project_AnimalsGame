<h1 align="center">Animals Game</h1>

## Descrição

Animals Game é um projeto desenvolvido em MySQL que tem como objetivo simular um sistema de apostas do jogo do bicho.

Ele permite que os clientes realizem suas apostas escolhendo o(s) animal(is), o horário da extração e o valor desejado. O banco de dados gerencia todo o sistema, controlando:

- Extrações abertas e encerradas  
- Apostas realizadas  
- Clientes cadastrados  
- Saldo individual de cada cliente  

---

## Modelagem e Entidades

O sistema é composto pelas seguintes entidades principais:

- **Clientes**
- **Animais**
- **Extrações**
- **Apostas**
- **Resultados**

---

## Funcionalidades Implementadas

### Validação de Apostas

Foram criados gatilhos (triggers) que garantem a integridade das apostas no momento da inserção:

- Verificação de saldo: Impede que um cliente aposte mais do que possui.
- Bloqueio de apostas em extrações encerradas: Impede que o cliente aposte em uma extração que já teve resultado divulgado.
- Validação de animal: Impede apostas em animais inexistentes na base de dados.

---

### Visualização de Bilhetes

Foi criada uma **view chamada `vw_bilhetes_resultados`** que lista todas as apostas realizadas, informando:

- Nome do cliente  
- Animal apostado  
- Animal sorteado  
- Status da aposta (Ganhou ou Perdeu)  
- Valor apostado  
- Valor ganho (caso tenha vencido)  

Essa view facilita o acompanhamento e análise de todas as apostas feitas no sistema
