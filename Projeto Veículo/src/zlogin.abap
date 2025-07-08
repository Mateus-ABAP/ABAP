  REPORT zlogin.

  PARAMETERS:
    p_login TYPE zusuarios-login,
    p_senha TYPE zusuarios-senha.

  DATA: lv_perfil   TYPE zusuarios-perfil,
        lv_id_user  TYPE zusuarios-id_usuario.

  START-OF-SELECTION.

    SELECT SINGLE id_usuario perfil
      INTO (lv_id_user, lv_perfil)
      FROM zusuarios
      WHERE login = p_login AND senha = p_senha.

    IF sy-subrc <> 0.
      MESSAGE 'Login ou senha inválidos.' TYPE 'E'.
    ELSEIF lv_perfil = 'A' OR lv_perfil = 'U'.
      SET PARAMETER ID 'ZID' FIELD lv_id_user.
      SUBMIT zmenus VIA SELECTION-SCREEN.
    ELSE.
      MESSAGE 'Perfil inválido.' TYPE 'E'.
    ENDIF.
