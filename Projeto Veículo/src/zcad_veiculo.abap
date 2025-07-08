REPORT ZCAD_VEICULO.

CLASS ZCL_veiculo DEFINITION.
  PUBLIC SECTION.
    METHODS:
      set_dados IMPORTING modelo                 TYPE zveiculos-modelo
                          placa                  TYPE zveiculos-placa
                          status                 TYPE zveiculos-status
                          vl_dia                 TYPE zveiculos-valor_dia,
      verifica_veiculo  RETURNING VALUE(existe)  TYPE abap_bool,
      gerar_id          RETURNING VALUE(ult_id)  TYPE zveiculos-id_veiculo,
      cadastrar_veiculo RETURNING VALUE(sucesso) TYPE abap_bool.
  PRIVATE SECTION.
    DATA: id_v         TYPE zveiculos-id_veiculo,
          modelo_v     TYPE zveiculos-modelo,
          placa_v      TYPE zveiculos-placa,
          status_v     TYPE zveiculos-status,
          vl_dia_v     TYPE zveiculos-valor_dia.
ENDCLASS.

CLASS ZCL_veiculo IMPLEMENTATION.

  METHOD set_dados.
    modelo_v = modelo.
    placa_v  = placa.
    status_v = status.
    vl_dia_v = vl_dia.
  ENDMETHOD.

  METHOD verifica_veiculo.
    SELECT SINGLE placa
      INTO @DATA(temp)
      FROM zveiculos
      WHERE placa = @placa_v.

    IF sy-subrc = 0.
      existe = abap_true.
    ELSE.
      existe = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD gerar_id.
    DATA: lv_ultimo_id_num  TYPE zveiculos-id_veiculo.
    DATA: lv_ultimo_id_char TYPE zveiculos-id_veiculo.

    SELECT MAX( id_veiculo )
      FROM zveiculos
      INTO @lv_ultimo_id_char.

    IF lv_ultimo_id_char IS INITIAL.
      lv_ultimo_id_num = 1.
    ELSE.
      lv_ultimo_id_num = lv_ultimo_id_char + 1.
    ENDIF.

    ult_id = lv_ultimo_id_num.
  ENDMETHOD.

  METHOD cadastrar_veiculo.
    id_v = gerar_id( ).

    DATA(veiculo) = VALUE zveiculos(
      id_veiculo  = id_v
      modelo      = modelo_v
      placa       = placa_v
      status      = status_v
      valor_dia   = vl_dia_v ).

    INSERT zveiculos FROM veiculo.

    IF sy-subrc = 0.
      COMMIT WORK.
      sucesso = abap_true.
    ELSE.
      ROLLBACK WORK.
      sucesso = abap_false.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

DATA: veiculo_obj TYPE REF TO zcl_veiculo,
      status      TYPE zveiculos-status,
      id_v        TYPE zveiculos-id_veiculo.

SELECTION-SCREEN: PUSHBUTTON /1(15) bt_volt USER-COMMAND voltar.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_model  TYPE zveiculos-modelo    OBLIGATORY,
              p_placa  TYPE zveiculos-placa     OBLIGATORY,
              p_vl_d   TYPE zveiculos-valor_dia OBLIGATORY,
              rb_dis   RADIOBUTTON GROUP sts DEFAULT 'X',
              rb_ind   RADIOBUTTON GROUP sts.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  bt_volt = '# Voltar ao Menu'.
  GET PARAMETER ID 'ZID' FIELD id_v.

AT SELECTION-SCREEN.
  IF sy-ucomm = 'VOLTAR'.
    SET PARAMETER ID 'ZID' FIELD id_v.
    SUBMIT zmenus VIA SELECTION-SCREEN AND RETURN.
  ENDIF.

START-OF-SELECTION.

  IF rb_dis = 'X'.
    status = 'D'.
  ELSE.
    status = 'I'.
  ENDIF.

  CREATE OBJECT veiculo_obj.

  veiculo_obj->set_dados(
    EXPORTING modelo = p_model
              placa  = p_placa
              status = status
              vl_dia = p_vl_d ).

  IF veiculo_obj->verifica_veiculo( ) = abap_true.
    MESSAGE 'Veículo com esta placa já cadastrado. Por favor, verifique.' TYPE 'E'.
    RETURN.
  ENDIF.

  IF veiculo_obj->cadastrar_veiculo( ) = abap_true.
    MESSAGE 'Veículo cadastrado com sucesso!' TYPE 'S'.
  ELSE.
    MESSAGE 'Erro ao cadastrar o veículo. Tente novamente.' TYPE 'E'.
  ENDIF.
