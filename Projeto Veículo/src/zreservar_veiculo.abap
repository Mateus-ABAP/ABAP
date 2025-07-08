REPORT ZRESERVAR_VEICULO.

CLASS ZCL_RESERVA DEFINITION.
  PUBLIC SECTION.
    METHODS:
      set_dados_reserva IMPORTING i_id_usuario  TYPE zusuarios-id_usuario
                                  i_id_veiculo  TYPE zveiculos-id_veiculo
                                  i_data_inicio TYPE zreservas-data_inicio
                                  i_data_fim    TYPE zreservas-data_fim,
      verificar_disponibilidade RETURNING VALUE(rv_disponivel) TYPE abap_bool,
      criar_reserva             RETURNING VALUE(rv_sucesso)    TYPE abap_bool.
  PRIVATE SECTION.
    DATA: md_id_reserva     TYPE zreservas-id_reserva,
          md_id_usuario     TYPE zusuarios-id_usuario,
          md_id_veiculo     TYPE zveiculos-id_veiculo,
          md_data_inicio    TYPE zreservas-data_inicio,
          md_data_fim       TYPE zreservas-data_fim,
          md_valor_total    TYPE zreservas-valor_total,
          md_status_reserva TYPE zreservas-status.
    METHODS:
      _gerar_id_reserva     RETURNING VALUE(rv_novo_id) TYPE zreservas-id_reserva,
      _calcular_valor_total RETURNING VALUE(rv_valor)   TYPE zreservas-valor_total.
ENDCLASS.

CLASS ZCL_RESERVA IMPLEMENTATION.

  METHOD set_dados_reserva.
    md_id_usuario     = i_id_usuario.
    md_id_veiculo     = i_id_veiculo.
    md_data_inicio    = i_data_inicio.
    md_data_fim       = i_data_fim.
    md_status_reserva = 'A'.
  ENDMETHOD.

  METHOD _gerar_id_reserva.
    SELECT MAX( id_reserva )
      FROM zreservas
      INTO @DATA(lv_ultimo_id).

    IF sy-subrc = 0.
      rv_novo_id = lv_ultimo_id + 1.
    ELSE.
      rv_novo_id = 1.
    ENDIF.
  ENDMETHOD.

  METHOD _calcular_valor_total.
    DATA: lv_dias_aluguel TYPE i,
          lv_valor_dia    TYPE zveiculos-valor_dia.

    lv_dias_aluguel = md_data_fim - md_data_inicio.

    SELECT SINGLE valor_dia INTO lv_valor_dia
      FROM zveiculos
      WHERE id_veiculo = md_id_veiculo.

    IF sy-subrc <> 0.
      MESSAGE 'Veículo não encontrado!' TYPE 'E'.
    ENDIF.

    rv_valor = lv_dias_aluguel * lv_valor_dia.
  ENDMETHOD.

  METHOD verificar_disponibilidade.
    DATA: lv_veiculo_status TYPE zveiculos-status.

    SELECT SINGLE status INTO lv_veiculo_status
      FROM zveiculos
      WHERE id_veiculo = md_id_veiculo.

    IF sy-subrc <> 0.
      MESSAGE 'Veículo não encontrado.' TYPE 'E'.
      rv_disponivel = abap_false.
      RETURN.
    ENDIF.

    IF lv_veiculo_status <> 'D'.
      MESSAGE 'Veículo não está disponível para aluguel no momento.' TYPE 'E'.
      rv_disponivel = abap_false.
      RETURN.
    ENDIF.

    SELECT COUNT(*) INTO @DATA(lv_count_reservas)
      FROM zreservas
      WHERE id_veiculo     = @md_id_veiculo
        AND status = 'A'
        AND ( data_inicio <= @md_data_fim AND data_fim >= @md_data_inicio ).

    IF lv_count_reservas > 0.
      MESSAGE 'Veículo já reservado para o período selecionado.' TYPE 'E'.
      rv_disponivel = abap_false.
      RETURN.
    ENDIF.

    rv_disponivel = abap_true.
  ENDMETHOD.

  METHOD criar_reserva.
    IF me->verificar_disponibilidade( ) = abap_false.
      rv_sucesso = abap_false.
      RETURN.
    ENDIF.

    md_id_reserva = me->_gerar_id_reserva( ).

    md_valor_total = me->_calcular_valor_total( ).

    DATA(ls_reserva) = VALUE zreservas(
      id_reserva  = md_id_reserva
      id_usuario  = md_id_usuario
      id_veiculo  = md_id_veiculo
      data_inicio = md_data_inicio
      data_fim    = md_data_fim
      valor_total = md_valor_total
      status      = md_status_reserva
    ).

    INSERT zreservas FROM ls_reserva.
    IF sy-subrc = 0.
      UPDATE zveiculos SET status = 'I' WHERE id_veiculo = md_id_veiculo.
      IF sy-subrc = 0.
        COMMIT WORK.
        rv_sucesso = abap_true.
      ELSE.
        ROLLBACK WORK.
        MESSAGE 'Erro ao atualizar status do veículo. Reserva não criada.' TYPE 'E'.
        rv_sucesso = abap_false.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE 'Erro ao criar a reserva (ID duplicado ou outro problema).' TYPE 'E'.
      rv_sucesso = abap_false.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

DATA: go_reserva_obj TYPE REF TO ZCL_RESERVA,
      gv_id_usuario  TYPE zusuarios-id_usuario.

SELECTION-SCREEN BEGIN OF BLOCK dados_reserva WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_id_vei TYPE zveiculos-id_veiculo OBLIGATORY,
              p_dt_ini  TYPE zreservas-data_inicio OBLIGATORY,
              p_dt_fim  TYPE zreservas-data_fim OBLIGATORY.
SELECTION-SCREEN END OF BLOCK dados_reserva.

SELECTION-SCREEN PUSHBUTTON /1(20) bt_volt USER-COMMAND voltar.

INITIALIZATION.
  bt_volt   = '# Voltar ao Menu'.
  GET PARAMETER ID 'ZID' FIELD gv_id_usuario.

AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'VOLTAR'.
      SET PARAMETER ID 'ZID' FIELD gv_id_usuario.
      SUBMIT zmenus VIA SELECTION-SCREEN AND RETURN.
  ENDCASE.

START-OF-SELECTION.

  CREATE OBJECT go_reserva_obj.

  go_reserva_obj->set_dados_reserva(
    i_id_usuario  = gv_id_usuario
    i_id_veiculo  = p_id_vei
    i_data_inicio = p_dt_ini
    i_data_fim    = p_dt_fim
  ).

  IF go_reserva_obj->criar_reserva( ) = abap_true.
    MESSAGE 'Reserva criada com sucesso!' TYPE 'S'.
  ENDIF.
