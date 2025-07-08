REPORT zrel_lucro.

TABLES: zreservas.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_dt_i TYPE zreservas-data_inicio OBLIGATORY DEFAULT sy-datum,
              p_dt_f TYPE zreservas-data_fim    OBLIGATORY DEFAULT '99991231'.
SELECTION-SCREEN END OF BLOCK b1.

CLASS zcl_relatorio_lucro DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_dados_relatorio,
             receita_total           TYPE zreservas-valor_total,
             total_reservas          TYPE i,
             qtd_ativas              TYPE i,
             qtd_finalizadas         TYPE i,
             qtd_canceladas          TYPE i,
             ticket_medio            TYPE zreservas-valor_total,
             taxa_cancelamento_pct   TYPE p LENGTH 5 DECIMALS 2,
             moeda                   TYPE waers,
           END OF ty_dados_relatorio.

    METHODS:
      gerar_relatorio IMPORTING iv_data_inicio TYPE zreservas-data_inicio
                                 iv_data_fim    TYPE zreservas-data_fim.
  PRIVATE SECTION.
    DATA: ms_dados_relatorio TYPE ty_dados_relatorio,
          mt_dados_relatorio TYPE STANDARD TABLE OF ty_dados_relatorio.
ENDCLASS.

CLASS zcl_relatorio_lucro IMPLEMENTATION.

  METHOD gerar_relatorio.
    DATA(lv_data_inicio) = iv_data_inicio.
    DATA(lv_data_fim)    = iv_data_fim.

    CLEAR: ms_dados_relatorio, mt_dados_relatorio.

    SELECT SUM( valor_total )
      FROM zreservas
      INTO @ms_dados_relatorio-receita_total
      WHERE data_inicio BETWEEN @lv_data_inicio AND @lv_data_fim
        AND status = 'F'.

    SELECT COUNT(*)
      FROM zreservas
      INTO @ms_dados_relatorio-total_reservas
      WHERE data_inicio BETWEEN @lv_data_inicio AND @lv_data_fim.

    TYPES: BEGIN OF ty_contagem_status,
             status TYPE zreservas-status,
             qtd    TYPE i,
           END OF ty_contagem_status.
    DATA: lt_contagens_por_status TYPE STANDARD TABLE OF ty_contagem_status,
          ls_contagem             TYPE ty_contagem_status.

    SELECT status, COUNT(*) AS qtd
      FROM zreservas
      INTO TABLE @lt_contagens_por_status
      WHERE data_inicio BETWEEN @lv_data_inicio AND @lv_data_fim
      GROUP BY status.

    LOOP AT lt_contagens_por_status INTO ls_contagem.
      CASE ls_contagem-status.
        WHEN 'A'.
          ms_dados_relatorio-qtd_ativas = ls_contagem-qtd.
        WHEN 'F'.
          ms_dados_relatorio-qtd_finalizadas = ls_contagem-qtd.
        WHEN 'C'.
          ms_dados_relatorio-qtd_canceladas = ls_contagem-qtd.
      ENDCASE.
    ENDLOOP.

    IF ms_dados_relatorio-qtd_finalizadas > 0.
      ms_dados_relatorio-ticket_medio = ms_dados_relatorio-receita_total / ms_dados_relatorio-qtd_finalizadas.
    ELSE.
      ms_dados_relatorio-ticket_medio = 0.
    ENDIF.

    IF ms_dados_relatorio-total_reservas > 0.
      ms_dados_relatorio-taxa_cancelamento_pct = ( ms_dados_relatorio-qtd_canceladas * 100 ) / ms_dados_relatorio-total_reservas.
    ELSE.
      ms_dados_relatorio-taxa_cancelamento_pct = 0.
    ENDIF.

    ms_dados_relatorio-moeda = 'BRL'.

    APPEND ms_dados_relatorio TO mt_dados_relatorio.

    DATA: lt_catalogo_campos TYPE slis_t_fieldcat_alv,
          layout_alv         TYPE slis_layout_alv.

    layout_alv-zebra           = 'X'.
    layout_alv-colwidth_optimize = 'X'.

    APPEND VALUE #( fieldname = 'RECEITA_TOTAL'         seltext_l = 'Receita Total'         currency = 'MOEDA' ) TO lt_catalogo_campos.
    APPEND VALUE #( fieldname = 'TOTAL_RESERVAS'        seltext_l = 'Total de Reservas' )                        TO lt_catalogo_campos.
    APPEND VALUE #( fieldname = 'QTD_ATIVAS'            seltext_l = 'Qtd. Ativas' )                              TO lt_catalogo_campos.
    APPEND VALUE #( fieldname = 'QTD_FINALIZADAS'       seltext_l = 'Qtd. Finalizadas' )                         TO lt_catalogo_campos.
    APPEND VALUE #( fieldname = 'QTD_CANCELADAS'        seltext_l = 'Qtd. Canceladas' )                          TO lt_catalogo_campos.
    APPEND VALUE #( fieldname = 'TICKET_MEDIO'          seltext_l = 'Ticket Médio'          currency = 'MOEDA' ) TO lt_catalogo_campos.
    APPEND VALUE #( fieldname = 'TAXA_CANCELAMENTO_PCT' seltext_l = 'Taxa Cancelamento (%)' )                    TO lt_catalogo_campos.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        it_fieldcat        = lt_catalogo_campos
        is_layout          = layout_alv
      TABLES
        t_outtab           = mt_dados_relatorio
      EXCEPTIONS
        others             = 1.

    IF sy-subrc <> 0.
      MESSAGE 'Erro ao exibir o relatório' TYPE 'E'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

AT SELECTION-SCREEN.
  IF p_dt_i > p_dt_f.
    MESSAGE 'Data inicial não pode ser maior que a final' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  DATA(lo_relatorio) = NEW zcl_relatorio_lucro( ).
  lo_relatorio->gerar_relatorio( iv_data_inicio = p_dt_i iv_data_fim = p_dt_f ).
