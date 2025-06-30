# ZCRUD_PRODUTOS – CRUD Simples em ABAP

Este projeto é um exemplo funcional de um programa ABAP que realiza operações de **Create, Read, Update e Delete (CRUD)** sobre uma tabela personalizada chamada `ZPRODUTOS`.

## 📦 Funcionalidades

- 📥 Criar um novo produto com geração automática de ID
- 🔍 Consultar produto por ID
- ✏️ Atualizar informações de um produto existente
- ❌ Excluir um produto do sistema

## 🧾 Estrutura da Tabela `ZPRODUTOS`

| Campo       | Tipo de Dado           | Descrição               	 |
|-------------|------------------------|---------------------------------|
| ID_PROD     | Numérico / CHAR(6~10)  | Identificador do produto (PK)   |
| NOME        | CHAR(50)               | Nome do produto         	 |
| PRECO       | CURR ou DEC(13,2)      | Preço do produto       	 |
| CATEGORIA   | CHAR(30)               | Categoria do produto   	 |
| DT_CRIACAO  | DATS                   | Data de criação       		 |
| STATUS      | CHAR(1)                | Status (A = Ativo, I = Inativo) |

## 📋 Como utilizar

1. Crie a tabela `ZPRODUTOS` com os campos acima.
2. Crie um novo report no SAP com o nome `ZCRUD_PRODUTOS`.
3. Copie e cole o conteúdo do arquivo `zcrud_produtos.abap`.
4. Execute o programa (`F8`).
5. Preencha os campos no bloco de seleção.
6. Escolha a operação desejada (Criar, Ler, Atualizar ou Deletar).

## 📌 Boas práticas utilizadas

- Separação de lógica por `FORM`
- Uso de `SELECT SINGLE` para validação de existência
- Validação de campos obrigatórios antes de persistência
- Mensagens de feedback para o usuário
- Uso de `SY-DATUM` para data de criação
- Tipagem baseada na estrutura da tabela `ZPRODUTOS`

