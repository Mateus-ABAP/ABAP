REPORT ZTESTANDO_ALV.

TYPES: BEGIN OF ty_voo,
         carrid     TYPE sflight-carrid,
         connid     TYPE sflight-connid,
         fldate     TYPE sflight-fldate,
         price      TYPE sflight-price,
         seatsmax   TYPE sflight-seatsmax,
         seatsocc   TYPE sflight-seatsocc,
         lucro      TYPE sflight-paymentsum,
       END OF ty_voo.

DATA: lt_voos     TYPE TABLE OF ty_voo,
      wa_voo      TYPE ty_voo,
      lt_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv,
      layout      TYPE slis_layout_alv.

PARAMETERS: p_carrid TYPE sflight-carrid OBLIGATORY,
            p_connid TYPE sflight-connid OBLIGATORY.

DATA: v_fldate TYPE sflight-fldate.

SELECT-OPTIONS: s_fldate FOR v_fldate.

START-OF-SELECTION.
  PERFORM buscar_dados.
  PERFORM preparar_alv.
  PERFORM exibir_alv.

*----------------------------------------------------------------*
*       FORM buscar_dados                                             
*----------------------------------------------------------------*
FORM buscar_dados.

  SELECT carrid, connid, fldate, price, seatsmax, seatsocc
    INTO TABLE @DATA(lt_sflight)
    FROM sflight
    WHERE carrid = @p_carrid
      AND connid = @p_connid
      AND fldate IN @s_fldate.

  IF sy-subrc <> 0.
    MESSAGE 'Nenhum dado encontrado para os filtros!' TYPE 'E'.
  ENDIF.

  LOOP AT lt_sflight INTO DATA(wk).
    wa_voo-carrid   = wk-carrid.
    wa_voo-connid   = wk-connid.
    wa_voo-fldate   = wk-fldate.
    wa_voo-price    = wk-price.
    wa_voo-seatsmax = wk-seatsmax.
    wa_voo-seatsocc = wk-seatsocc.
    wa_voo-lucro    = wk-price * wk-seatsocc.
    APPEND wa_voo TO lt_voos.
  ENDLOOP.

ENDFORM.

*----------------------------------------------------------------*
*       FORM preparar_alv                                             
*----------------------------------------------------------------*
FORM preparar_alv.

  layout-zebra             = 'X'.
  layout-colwidth_optimize = 'X'.

  PERFORM adicionar_campo USING 'CARRID' 'Companhia' '10'.
  PERFORM adicionar_campo USING 'CONNID' 'Conexão'  '10'.
  PERFORM adicionar_campo USING 'FLDATE' 'Data do Voo' '15'.
  PERFORM adicionar_campo USING 'PRICE'  'Preço Unitário' '15'.
  PERFORM adicionar_campo USING 'SEATSMAX' 'Assentos Totais' '15'.
  PERFORM adicionar_campo USING 'SEATSOCC' 'Assentos Ocupados' '15'.
  PERFORM adicionar_campo USING 'LUCRO' 'Lucro Estimado' '15'.

ENDFORM.

*----------------------------------------------------------------*
*       FORM adicionar_campo                                          
*----------------------------------------------------------------*
FORM adicionar_campo USING p_campo p_texto p_largura.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = p_campo.
  wa_fieldcat-seltext_m = p_texto.
  wa_fieldcat-outputlen = p_largura.
  APPEND wa_fieldcat TO lt_fieldcat.

ENDFORM.

*----------------------------------------------------------------*
*       FORM exibir_alv                                               
*----------------------------------------------------------------*
FORM exibir_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = layout
      it_fieldcat        = lt_fieldcat
    TABLES
      t_outtab           = lt_voos
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Erro ao exibir relatório ALV!' TYPE 'E'.
  ENDIF.

ENDFORM.
