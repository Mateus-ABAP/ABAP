REPORT zmenus.

DATA: p_user         TYPE zusuarios-id_usuario,
      v_tipo_usuario TYPE zusuarios-perfil.

SELECTION-SCREEN BEGIN OF BLOCK b_usuario WITH FRAME TITLE text-001.
  PARAMETERS: rb_res RADIOBUTTON GROUP rb_u DEFAULT 'X' MODIF ID USR,
              rb_con RADIOBUTTON GROUP rb_u MODIF ID USR.
SELECTION-SCREEN END OF BLOCK b_usuario.

SELECTION-SCREEN BEGIN OF BLOCK b_admin WITH FRAME TITLE text-002.
  PARAMETERS: rb_cad  RADIOBUTTON GROUP rb_a DEFAULT 'X' MODIF ID ADM,
              rb_conA RADIOBUTTON GROUP rb_a MODIF ID ADM,
              rb_rel  RADIOBUTTON GROUP rb_a MODIF ID ADM,
              rb_cadU RADIOBUTTON GROUP rb_a MODIF ID ADM.
SELECTION-SCREEN END OF BLOCK b_admin.

INITIALIZATION.
  GET PARAMETER ID 'ZID' FIELD p_user.

  SELECT SINGLE perfil INTO v_tipo_usuario
    FROM zusuarios
    WHERE id_usuario = p_user.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF v_tipo_usuario = 'A'.
      IF screen-group1 = 'USR'.
        screen-active = 0.
      ENDIF.
    ELSEIF v_tipo_usuario = 'U'.
      IF screen-group1 = 'ADM'.
        screen-active = 0.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.
  CASE v_tipo_usuario.
    WHEN 'U'.
      IF rb_res = 'X'.
        SUBMIT zreservar_veiculo  VIA SELECTION-SCREEN.
      ELSEIF rb_con = 'X'.
        SUBMIT zconsult_reserva VIA SELECTION-SCREEN.
      ELSE.
        MESSAGE 'Selecione uma opção válida (usuário).' TYPE 'E'.
      ENDIF.
    WHEN 'A'.
      IF rb_cad = 'X'.
        SUBMIT zcad_veiculo     VIA SELECTION-SCREEN.
      ELSEIF rb_conA = 'X'.
        SUBMIT zconsult_reserva VIA SELECTION-SCREEN.
      ELSEIF rb_rel = 'X'.
        SUBMIT zrel_lucro       VIA SELECTION-SCREEN.
      ELSEIF rb_cadU = 'X'.
        SUBMIT zcad_usuario     VIA SELECTION-SCREEN.
      ELSE.
        MESSAGE 'Selecione uma opção válida (admin).' TYPE 'E'.
      ENDIF.
    WHEN OTHERS.
      MESSAGE 'Tipo de usuário não reconhecido.' TYPE 'E'.
  ENDCASE.
