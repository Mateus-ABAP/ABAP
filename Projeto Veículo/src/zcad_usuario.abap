REPORT zcad_usuario.

CLASS zcl_usuario DEFINITION.
  PUBLIC SECTION.
    METHODS:
      set_dados IMPORTING nome                 TYPE zusuarios-nome
                          login                TYPE zusuarios-login
                          senha                TYPE zusuarios-senha
                          perfil               TYPE zusuarios-perfil,
      verificar_login RETURNING VALUE(existe)  TYPE abap_bool,
      gerar_id        RETURNING VALUE(novo_id) TYPE zusuarios-id_usuario,
      criar_usuario   RETURNING VALUE(sucesso) TYPE abap_bool.
  PRIVATE SECTION.
    DATA: nome_u   TYPE zusuarios-nome,
          login_u  TYPE zusuarios-login,
          senha_u  TYPE zusuarios-senha,
          perfil_u TYPE zusuarios-perfil,
          id_u     TYPE zusuarios-id_usuario.
ENDCLASS.

CLASS zcl_usuario IMPLEMENTATION.

  METHOD set_dados.
    nome_u   = nome.
    login_u  = login.
    senha_u  = senha.
    perfil_u = perfil.
  ENDMETHOD.

  METHOD verificar_login.
    SELECT SINGLE login
      FROM zusuarios
      INTO @DATA(temp)
      WHERE login = @login_u.

    IF sy-subrc = 0.
      existe = abap_true.
    ELSE.
      existe = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD gerar_id.
    DATA: lv_ultimo_id_num TYPE i.

    SELECT MAX( id_usuario )
      FROM zusuarios
      INTO @DATA(lv_ultimo_id_char).

    IF lv_ultimo_id_char IS INITIAL.
      lv_ultimo_id_num = 1.
    ELSE.
      lv_ultimo_id_num = lv_ultimo_id_char + 1.
    ENDIF.

    novo_id = lv_ultimo_id_num.
  ENDMETHOD.

  METHOD criar_usuario.
    id_u = gerar_id( ).

    DATA(usuario) = VALUE zusuarios(
      id_usuario  = id_u
      nome        = nome_u
      login       = login_u
      senha       = senha_u
      perfil      = perfil_u ).

    INSERT zusuarios FROM usuario.

    IF sy-subrc = 0.
      COMMIT WORK.
      sucesso = abap_true.
    ELSE.
      ROLLBACK WORK.
      sucesso = abap_false.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

DATA: usuario_obj TYPE REF TO zcl_usuario,
      perfil      TYPE zusuarios-perfil,
      id_user     TYPE zusuarios-id_usuario.

SELECTION-SCREEN: PUSHBUTTON /1(20) bt_volt USER-COMMAND voltar.

SELECTION-SCREEN BEGIN OF BLOCK dados WITH FRAME TITLE text-001.
  PARAMETERS: p_nome  TYPE zusuarios-nome,
              p_login TYPE zusuarios-login,
              p_senha TYPE zusuarios-senha,
              rb_user RADIOBUTTON GROUP grp DEFAULT 'X',
              rb_adm  RADIOBUTTON GROUP grp.
SELECTION-SCREEN END OF BLOCK dados.

INITIALIZATION.
  bt_volt = '# Voltar ao Menu'.
  GET PARAMETER ID 'ZID' FIELD id_user.

AT SELECTION-SCREEN.
  IF sy-ucomm = 'VOLTAR'.
    SET PARAMETER ID 'ZID' FIELD id_user.
    SUBMIT zmenus VIA SELECTION-SCREEN AND RETURN.
  ENDIF.

START-OF-SELECTION.

  IF rb_user = 'X'.
    perfil = 'U'.
  ELSEIF rb_adm = 'X'.
    perfil = 'A'.
  ELSE.
    MESSAGE 'Selecione o perfil.' TYPE 'E'.
    RETURN.
  ENDIF.

  CREATE OBJECT usuario_obj.

  usuario_obj->set_dados(
    EXPORTING nome   = p_nome
              login  = p_login
              senha  = p_senha
              perfil = perfil ).

  IF usuario_obj->verificar_login( ) = abap_true.
    MESSAGE 'Login já cadastrado. Por favor, escolha outro.' TYPE 'E'.
    RETURN.
  ENDIF.

  IF usuario_obj->criar_usuario( ) = abap_true.
    MESSAGE 'Usuário cadastrado com sucesso!' TYPE 'S'.
  ELSE.
    MESSAGE 'Erro ao cadastrar o usuário. Tente novamente.' TYPE 'E'.
  ENDIF.
