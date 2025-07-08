REPORT zpopular_completo.

TABLES: zusuarios, zveiculos, zreservas.

START-OF-SELECTION.
  PERFORM limpar_todas_tabelas.
  PERFORM popular_usuarios_iniciais.
  PERFORM popular_veiculos_teste.
  PERFORM popular_reservas_teste.

  MESSAGE 'Todas as tabelas foram populadas com dados de teste com sucesso!' TYPE 'S'.

FORM limpar_todas_tabelas.
  DELETE FROM zreservas.
  DELETE FROM zveiculos.
  DELETE FROM zusuarios.
  COMMIT WORK AND WAIT.
  WRITE: / '--> Todas as tabelas (ZUSUARIOS, ZVEICULOS, ZRESERVAS) foram limpas.' COLOR 3.
ENDFORM.

FORM popular_usuarios_iniciais.
  DATA: ls_usuario TYPE zusuarios.

  CLEAR ls_usuario.
  ls_usuario-id_usuario = '00001'.
  ls_usuario-nome       = 'Administrador'.
  ls_usuario-login      = 'ADM'.
  CONDENSE ls_usuario-login.
  ls_usuario-senha      = '1111'.
  CONDENSE ls_usuario-senha.
  ls_usuario-perfil     = 'A'.
  INSERT zusuarios FROM ls_usuario.

  CLEAR ls_usuario.
  ls_usuario-id_usuario = '00002'.
  ls_usuario-nome       = 'Usuario'.
  ls_usuario-login      = 'USR'.
  CONDENSE ls_usuario-login.
  ls_usuario-senha      = '2222'.
  CONDENSE ls_usuario-senha.
  ls_usuario-perfil     = 'U'.
  INSERT zusuarios FROM ls_usuario.

  COMMIT WORK AND WAIT.
  WRITE: / '--> Usuários iniciais (ADM e USR) populados.' COLOR 3.
ENDFORM.

FORM popular_veiculos_teste.
  DATA: ls_veiculo TYPE zveiculos.

  CLEAR ls_veiculo.
  ls_veiculo-id_veiculo  = '10001'.
  ls_veiculo-modelo      = 'Fiat Mobi'.
  ls_veiculo-placa       = 'ABC1A23'.
  ls_veiculo-status      = 'D'.
  ls_veiculo-valor_dia   = '75.00'.
  INSERT zveiculos FROM ls_veiculo.

  CLEAR ls_veiculo.
  ls_veiculo-id_veiculo  = '10002'.
  ls_veiculo-modelo      = 'VW Virtus'.
  ls_veiculo-placa       = 'DEF4B56'.
  ls_veiculo-status      = 'D'.
  ls_veiculo-valor_dia   = '120.00'.
  INSERT zveiculos FROM ls_veiculo.

  CLEAR ls_veiculo.
  ls_veiculo-id_veiculo  = '10003'.
  ls_veiculo-modelo      = 'Jeep Compass'.
  ls_veiculo-placa       = 'GHI7C89'.
  ls_veiculo-status      = 'D'.
  ls_veiculo-valor_dia   = '180.00'.
  INSERT zveiculos FROM ls_veiculo.

  CLEAR ls_veiculo.
  ls_veiculo-id_veiculo  = '10004'.
  ls_veiculo-modelo      = 'Hyundai HB20'.
  ls_veiculo-placa       = 'JKL0D12'.
  ls_veiculo-status      = 'D'.
  ls_veiculo-valor_dia   = '90.00'.
  INSERT zveiculos FROM ls_veiculo.

  CLEAR ls_veiculo.
  ls_veiculo-id_veiculo  = '10005'.
  ls_veiculo-modelo      = 'Renault Kwid'.
  ls_veiculo-placa       = 'MNO3E45'.
  ls_veiculo-status      = 'D'.
  ls_veiculo-valor_dia   = '60.00'.
  INSERT zveiculos FROM ls_veiculo.

  COMMIT WORK AND WAIT.
  WRITE: / '--> Veículos de teste populados.' COLOR 3.
ENDFORM.

FORM popular_reservas_teste.
  DATA: lv_res_id    TYPE zreservas-id_reserva,
        lv_data_base TYPE sy-datum.
  DATA: lv_data_inicio_calc TYPE zreservas-data_inicio.

  SELECT MAX( id_reserva ) FROM zreservas INTO @DATA(max_current_res_id).
  IF max_current_res_id IS INITIAL.
    lv_res_id = 1.
  ELSE.
    lv_res_id = max_current_res_id + 1.
  ENDIF.

  lv_data_base = sy-datum.

  lv_data_inicio_calc = lv_data_base - 30.
  PERFORM inserir_reserva_detalhada USING
    '00001'
    '10001'
    'F'
    lv_data_inicio_calc
    5
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base - 60.
  PERFORM inserir_reserva_detalhada USING
    '00001'
    '10002'
    'F'
    lv_data_inicio_calc
    10
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base + 5.
  PERFORM inserir_reserva_detalhada USING
    '00001'
    '10003'
    'A'
    lv_data_inicio_calc
    3
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base - 10.
  PERFORM inserir_reserva_detalhada USING
    '00001'
    '10004'
    'C'
    lv_data_inicio_calc
    2
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base - 15.
  PERFORM inserir_reserva_detalhada USING
    '00002'
    '10005'
    'F'
    lv_data_inicio_calc
    7
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base - 20.
  PERFORM inserir_reserva_detalhada USING
    '00002'
    '10001'
    'F'
    lv_data_inicio_calc
    4
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base.
  PERFORM inserir_reserva_detalhada USING
    '00002'
    '10002'
    'A'
    lv_data_inicio_calc
    6
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base - 25.
  PERFORM inserir_reserva_detalhada USING
    '00002'
    '10003'
    'C'
    lv_data_inicio_calc
    1
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base + 15.
  PERFORM inserir_reserva_detalhada USING
    '00004'
    '10004'
    'A'
    lv_data_inicio_calc
    4
    CHANGING lv_res_id.

  lv_data_inicio_calc = lv_data_base - 50.
  PERFORM inserir_reserva_detalhada USING
    '00004'
    '10005'
    'F'
    lv_data_inicio_calc
    8
    CHANGING lv_res_id.

  COMMIT WORK AND WAIT.
  WRITE: / '--> Reservas de teste populadas.' COLOR 3.
ENDFORM.

FORM inserir_reserva_detalhada USING
  iv_id_usuario  TYPE zusuarios-id_usuario
  iv_id_veiculo  TYPE zveiculos-id_veiculo
  iv_status      TYPE zreservas-status
  iv_data_inicio TYPE zreservas-data_inicio
  iv_duracao_dias TYPE i
  CHANGING cv_id_reserva TYPE zreservas-id_reserva.

  DATA: ls_reserva     TYPE zreservas,
        lv_valor_dia   TYPE zveiculos-valor_dia,
        lv_data_fim    TYPE zreservas-data_fim.

  lv_data_fim = iv_data_inicio + iv_duracao_dias.

  SELECT SINGLE valor_dia INTO lv_valor_dia
    FROM zveiculos
    WHERE id_veiculo = iv_id_veiculo.

  CLEAR ls_reserva.
  ls_reserva-id_reserva    = cv_id_reserva.
  ls_reserva-id_usuario    = iv_id_usuario.
  ls_reserva-id_veiculo    = iv_id_veiculo.
  ls_reserva-data_inicio   = iv_data_inicio.
  ls_reserva-data_fim      = lv_data_fim.
  ls_reserva-status        = iv_status.

  IF sy-subrc = 0.
    ls_reserva-valor_total = lv_valor_dia * iv_duracao_dias.
  ELSE.
    ls_reserva-valor_total = 0.
  ENDIF.

  INSERT zreservas FROM ls_reserva.

  ADD 1 TO cv_id_reserva.
ENDFORM.
