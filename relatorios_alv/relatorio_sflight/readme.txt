# zrelatorio_alv_sflight

Relatório ALV desenvolvido em ABAP para exibir dados da tabela SFLIGHT com filtros por:

- Companhia aérea (`CARRID`)
- Número de conexão (`CONNID`)
- Intervalo de datas (`FLDATE`)

Inclui cálculo de lucro estimado (`PRICE * SEATSOCC`) e exibição com layout otimizado (zebra e ajuste de colunas).

Exibição via `REUSE_ALV_GRID_DISPLAY`.