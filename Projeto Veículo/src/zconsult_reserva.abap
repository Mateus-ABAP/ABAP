REPORT zconsult_reserva.

CLASS zcl_consult_reserva DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_reserva,
             id_reserva    TYPE zreservas-id_reserva,
             id_usuario    TYPE zreservas-id_usuario,
             id_veiculo    TYPE zveiculos-id_veiculo,
             modelo_v      TYPE zveiculos-modelo,
             placa_v       TYPE zveiculos-placa,
             dt_inicio     TYPE zreservas-data_inicio,
             dt_fim        TYPE zreservas-data_fim,
             vl_dia        TYPE zveiculos-valor_dia,
             vl_total      TYPE zreservas-valor_total,
             sts_reserva   TYPE zreservas-status,
           END OF ty_reserva.

    METHODS:
      set_parametros IMPORTING i_pas TYPE c i_atu TYPE c i_fut TYPE c i_todas TYPE c,
      carregar_dados,
      filtrar_dados,
      exibir_alv,
      montar_fieldcat,
      add_field      IMPORTING p_field TYPE slis_fieldname p_text  TYPE string.

  PRIVATE SECTION.
    DATA: lt_reservas     TYPE STANDARD TABLE OF ty_reserva,
          lt_filtrado     TYPE STANDARD TABLE OF ty_reserva,
          lt_fieldcat     TYPE slis_t_fieldcat_alv,
          wa_fieldcat     TYPE slis_fieldcat_alv,
          layout          TYPE slis_layout_alv,
          rb_pas          TYPE c,
          rb_atu          TYPE c,
          rb_fut          TYPE c,
          rb_todas        TYPE c,
          p_user          TYPE zusuarios-id_usuario,
          tipo_usuario    TYPE zusuarios-perfil.
ENDCLASS.

CLASS zcl_consult_reserva IMPLEMENTATION.
  METHOD set_parametros.
    rb_pas   = i_pas.
    rb_atu   = i_atu.
    rb_fut   = i_fut.
    rb_todas = i_todas.
  ENDMETHOD.

  METHOD carregar_dados.
    GET PARAMETER ID 'ZID' FIELD p_user.
    IF p_user IS INITIAL.
      MESSAGE 'ID do usu rio n o encontrado. Por favor, fa a login.' TYPE 'E'.
      RETURN.
    ENDIF.

    SELECT SINGLE perfil
      INTO @tipo_usuario
      FROM zusuarios
      WHERE id_usuario = @p_user.

    IF sy-subrc <> 0.
      MESSAGE 'Perfil do usu rio n o encontrado ou inv lido.' TYPE 'E'.
      RETURN.
    ENDIF.

    CLEAR lt_reservas.
    DATA: lt_condicoes_where TYPE STANDARD TABLE OF string.

    IF tipo_usuario = 'U'.
      APPEND |r~id_usuario = '{ p_user }'| TO lt_condicoes_where.
    ELSEIF tipo_usuario = 'A'.
    ELSE.
      MESSAGE 'Tipo de usu rio n o reconhecido. N o   poss vel carregar dados.' TYPE 'E'.
      RETURN.
    ENDIF.

    SELECT r~id_reserva,
           r~id_usuario,
           r~id_veiculo,
           v~modelo       AS modelo_v,
           v~placa        AS placa_v,
           r~data_inicio  AS dt_inicio,
           r~data_fim     AS dt_fim,
           v~valor_dia    AS vl_dia,
           r~valor_total  AS vl_total,
           r~status       AS sts_reserva
      INTO CORRESPONDING FIELDS OF TABLE @lt_reservas
      FROM zreservas AS r
      INNER JOIN zveiculos AS v
        ON r~id_veiculo = v~id_veiculo
      WHERE (lt_condicoes_where).

    IF lt_reservas IS INITIAL.
      MESSAGE 'Nenhuma reserva encontrada para o seu perfil.' TYPE 'I'.
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD filtrar_dados.
    DATA: wa_reserva TYPE ty_reserva.
    CLEAR lt_filtrado.

    IF rb_todas = 'X'.
      lt_filtrado[] = lt_reservas[].
    ELSE.
      LOOP AT lt_reservas INTO wa_reserva.
        CASE 'X'.
          WHEN rb_pas.
            IF wa_reserva-dt_fim < sy-datum.
              APPEND wa_reserva TO lt_filtrado.
            ENDIF.
          WHEN rb_atu.
            IF sy-datum BETWEEN wa_reserva-dt_inicio AND wa_reserva-dt_fim.
              APPEND wa_reserva TO lt_filtrado.
            ENDIF.
          WHEN rb_fut.
            IF wa_reserva-dt_inicio > sy-datum.
              APPEND wa_reserva TO lt_filtrado.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDIF.

    IF lt_filtrado IS INITIAL.
      MESSAGE 'Nenhuma reserva encontrada com os crit rios de filtro selecionados.' TYPE 'I'.
    ENDIF.
  ENDMETHOD.

  METHOD montar_fieldcat.
    layout-zebra           = 'X'.
    layout-colwidth_optimize = 'X'.

    me->add_field( p_field = 'ID_RESERVA'    p_text = 'C digo' ).
    me->add_field( p_field = 'ID_USUARIO'    p_text = 'ID Usu rio' ).
    me->add_field( p_field = 'ID_VEICULO'    p_text = 'ID Ve culo' ).
    me->add_field( p_field = 'MODELO_V'      p_text = 'Modelo' ).
    me->add_field( p_field = 'PLACA_V'       p_text = 'Placa' ).
    me->add_field( p_field = 'DT_INICIO'     p_text = 'Data In cio' ).
    me->add_field( p_field = 'DT_FIM'        p_text = 'Data Fim' ).
    me->add_field( p_field = 'VL_DIA'        p_text = 'Valor Dia' ).
    me->add_field( p_field = 'VL_TOTAL'      p_text = 'Valor Total' ).
    me->add_field( p_field = 'STS_RESERVA'   p_text = 'Status' ).
  ENDMETHOD.

  METHOD exibir_alv.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        it_fieldcat = lt_fieldcat
        is_layout   = layout
      TABLES
        t_outtab    = lt_filtrado.
  ENDMETHOD.

  METHOD add_field.
    DATA wa_fieldcat_local TYPE slis_fieldcat_alv.
    CLEAR wa_fieldcat_local.
    wa_fieldcat_local-fieldname = p_field.
    wa_fieldcat_local-seltext_s = p_text.
    wa_fieldcat_local-seltext_m = p_text.
    wa_fieldcat_local-seltext_l = p_text.
    APPEND wa_fieldcat_local TO lt_fieldcat.
  ENDMETHOD.
ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK reservas WITH FRAME TITLE text-001.
  PARAMETERS: rb_todas RADIOBUTTON GROUP res DEFAULT 'X',
              rb_pas   RADIOBUTTON GROUP res,
              rb_atual RADIOBUTTON GROUP res,
              rb_fut   RADIOBUTTON GROUP res.
SELECTION-SCREEN END OF BLOCK reservas.

START-OF-SELECTION.
  DATA(lo_consulta) = NEW zcl_consult_reserva( ).
  lo_consulta->set_parametros( i_pas = rb_pas i_atu = rb_atual i_fut = rb_fut i_todas = rb_todas ).
  lo_consulta->carregar_dados( ).
  lo_consulta->filtrar_dados( ).
  lo_consulta->montar_fieldcat( ).
  lo_consulta->exibir_alv( ).
