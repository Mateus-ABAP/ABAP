🚗 Sistema de Gestão de Reservas de Veículos (ABAP)
Este projeto é um sistema simples de gestão de reservas de veículos, desenvolvido em ABAP com foco em Orientação a Objetos. Criado como um projeto de portfólio, demonstra funcionalidades essenciais de um sistema transacional SAP.
🎯 Funcionalidades Principais
O sistema gerencia usuários, veículos e reservas, cobrindo:
Autenticação: Login de usuários (administrador/comum).
Cadastros: Gestão de usuários e veículos.
Reservas: Criação e consulta de reservas.
Análise: Relatórios de lucro e estatísticas de reservas.
⚙️ Como Funciona?
A aplicação é modular, com programas ABAP e classes locais que encapsulam a lógica de negócio e operações de banco de dados.
Componentes Essenciais:
1. Tabelas Customizadas (Z-tables)
Criadas via SE11, armazenam os dados do sistema. É fundamental que os campos sejam criados com os nomes, tipos e comprimentos exatos para que os programas funcionem corretamente.
ZUSUARIOS: Armazena informações dos usuários do sistema.
Estrutura da Tabela:
ID_USUARIO (Tipo: NUMC, Comprimento: 5, Chave Primária)
NOME (Tipo: CHAR, Comprimento: 50)
LOGIN (Tipo: CHAR, Comprimento: 20)
SENHA (Tipo: CHAR, Comprimento: 20)
PERFIL (Tipo: CHAR, Comprimento: 1) - Valores esperados: 'A' (Administrador), 'U' (Usuário Comum)
ZVEICULOS: Armazena informações dos veículos disponíveis para aluguel.
Estrutura da Tabela:
ID_VEICULO (Tipo: NUMC, Comprimento: 5, Chave Primária)
MODELO (Tipo: CHAR, Comprimento: 50)
PLACA (Tipo: CHAR, Comprimento: 7, Chave Única)
STATUS (Tipo: CHAR, Comprimento: 1) - Valores esperados: 'D' (Disponível), 'I' (Indisponível)
VALOR_DIA (Tipo: CURR, Comprimento: 11, Casas Decimais: 2)
ZRESERVAS: Armazena os detalhes das reservas de veículos.
Estrutura da Tabela:
ID_RESERVA (Tipo: NUMC, Comprimento: 10, Chave Primária)
ID_USUARIO (Tipo: NUMC, Comprimento: 5, Chave Estrangeira para ZUSUARIOS)
ID_VEICULO (Tipo: NUMC, Comprimento: 5, Chave Estrangeira para ZVEICULOS)
DATA_INICIO (Tipo: DATS)
DATA_FIM (Tipo: DATS)
VALOR_TOTAL (Tipo: CURR, Comprimento: 15, Casas Decimais: 2)
STATUS (Tipo: CHAR, Comprimento: 1) - Valores esperados: 'A' (Ativa), 'F' (Finalizada), 'C' (Cancelada)
Importante: O nome deste campo é STATUS, não STATUS_RESERVA.
2. Programas ABAP
Criados via SE38, cada um com uma função específica:
ZLOGIN: Ponto de entrada para autenticação.
ZMENUS: Menu principal, acesso por perfil.
ZCAD_USUARIO: Cadastro de usuários.
ZCAD_VEICULO: Cadastro de veículos.
ZRESERVAR_VEICULO: Criação de reservas.
ZCONSULT_RESERVA: Consulta de reservas (com filtro e opção "todas").
ZREL_LUCRO: Relatório de lucro/dashboard.
ZPOPULAR: Programa utilitário essencial para popular dados de teste.
✨ Aspectos Relevantes para Avaliadores
Este projeto, embora simples, demonstra uma série de boas práticas e habilidades essenciais no desenvolvimento ABAP:
Orientação a Objetos (POO): Utilização de classes locais (zcl_consult_reserva, zcl_usuario, zcl_relatorio_lucro) com métodos bem definidos para encapsular a lógica de negócio, promover a modularidade e a reutilização de código (set_parametros, carregar_dados, gerar_id, criar_usuario, etc.).
Manipulação de Dados (DML): Operações básicas e avançadas de banco de dados (INSERT, DELETE, SELECT) com tabelas customizadas (ZUSUARIOS, ZVEICULOS, ZRESERVAS).
Consultas SQL Dinâmicas: Exemplo de SELECT com WHERE (lt_condicoes_where) em ZCONSULT_RESERVA_OO para flexibilidade na filtragem.
Relatórios ALV: Implementação de relatórios ALV (REUSE_ALV_GRID_DISPLAY) para exibição de dados tabulares, incluindo a construção dinâmica do catálogo de campos.
Validações e Tratamento de Erros:
Validação de datas (p_dt_ini > p_dt_fim).
Verificação de logins duplicados (verificar_login).
Tratamento de divisão por zero em cálculos (ticket_medio, taxa_cancelamento_pct).
Uso de mensagens (MESSAGE TYPE 'E', 'I', 'S') para feedback claro ao usuário.
Tratamento de Dados de Entrada: Uso da instrução CONDENSE em ZPOPULAR_COMPLETO para limpar espaços em branco de campos de texto (login/senha), garantindo a integridade dos dados e evitando problemas de autenticação.
Geração de IDs Sequenciais: Lógica para gerar IDs numéricos sequenciais com preenchimento de zeros à esquerda (NUMC), demonstrando controle sobre chaves primárias customizadas.
Modularização e Reutilização: Organização do código em rotinas (FORM) e métodos, como inserir_reserva_detalhada em ZPOPULAR_COMPLETO, para melhorar a legibilidade e a manutenção.
Interação com Tela de Seleção: Utilização de PARAMETERS e RADIOBUTTON GROUP para criar interfaces de seleção de dados intuitivas para o usuário.
🚀 Como Usar o Projeto? (Guia Rápido)
Configuração Inicial:
Crie as tabelas Z (SE11) com os campos exatos.
Crie os programas ABAP (SE38) e ative-os.
Crie os Text Elements (SE38 -> GOTO -> Text Elements -> Text Symbols).
Preparar Dados:
Execute o programa ZPOPULAR (SE38, F8) para limpar e popular as tabelas com dados de teste.
Iniciar o Sistema:
Execute o programa ZLOGIN (SE38, F8).
Use as credenciais de teste:
Administrador: Login ADM, Senha 1111
Usuário Comum: Login USR, Senha 2222
Navegar:
Após o login, explore as funcionalidades através do menu principal (ZMENUS).
