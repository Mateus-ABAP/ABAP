# Repositório de Relatórios ALV em ABAP

Este repositório contém diversos exemplos de **relatórios ALV (ABAP List Viewer)** desenvolvidos em ABAP, com foco em layout, organização de código, boas práticas e uso da função padrão `REUSE_ALV_GRID_DISPLAY`.

## 📌 Objetivo

Centralizar relatórios desenvolvidos com ALV, de forma modular e comentada, para estudo, reuso ou apresentação em entrevistas/técnicos.

## 📂 Estrutura

Cada relatório está em sua própria subpasta, dentro da pasta `relatorios/`, com:

- Arquivo `.abap` com o código-fonte completo
- `README.md` explicando aquele relatório específico

## 📜 Lista de Relatórios

| Nome                                     | Descrição                                             |
|------------------------------------------|-------------------------------------------------------|
| `zrelatorio_alv_sflight.abap`            | Exibe dados de voos da tabela SFLIGHT, com cálculo de lucro |

## 📚 Recursos Utilizados

- `REUSE_ALV_GRID_DISPLAY` (função padrão para ALV)
- `SLIS_FIELDCAT_ALV` e `SLIS_LAYOUT_ALV`
- `@DATA(...)` e `DATA(...)` (sintaxe moderna)
- `SELECT-OPTIONS` e `PARAMETERS`
- Modularização com `FORM`

## ✅ Requisitos

- Acesso ao sistema SAP com permissões para criação de reports Z
- ABAP 7.40 ou superior
- Tabela SFLIGHT disponível para relatórios baseados nela

---

## 🧑‍💻 Autor

**Mateus Oliveira**  
[GitHub Profile](https://github.com/Mateus_ABAP)

---

## 🪪 Licença

Este repositório está sob a licença MIT.
