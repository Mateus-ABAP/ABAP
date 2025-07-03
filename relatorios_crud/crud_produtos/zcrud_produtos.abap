REPORT zcrud_produtos.

TYPES: BEGIN OF ty_produto,
         id_prod   TYPE zprodutos-id_prod,
         nome      TYPE zprodutos-nome,
         preco     TYPE zprodutos-preco,
         categoria TYPE zprodutos-categoria,
         data      TYPE zprodutos-dt_criacao,
         status    TYPE zprodutos-status,
       END OF ty_produto.

DATA: wa_produto  TYPE ty_produto.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_id  TYPE zprodutos-id_prod,
              p_nom TYPE zprodutos-nome,
              p_prc TYPE zprodutos-preco,
              p_ctg TYPE zprodutos-categoria,
              p_sts TYPE zprodutos-status.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
  PARAMETERS: rb_crt RADIOBUTTON GROUP rb DEFAULT 'X',
              rb_rd  RADIOBUTTON GROUP rb,
              rb_upd RADIOBUTTON GROUP rb,
              rb_del RADIOBUTTON GROUP rb.
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  p_sts = 'A'.

START-OF-SELECTION.

  PERFORM preencher_estrutura.

  CASE 'X'.
    WHEN rb_crt.
      PERFORM criar_produto.
    WHEN rb_rd.
      PERFORM exibir_produto.
    WHEN rb_upd.
      PERFORM atualizar_produto.
    WHEN rb_del.
      PERFORM deletar_produto.
  ENDCASE.

FORM preencher_estrutura.
  CLEAR wa_produto.
  wa_produto-id_prod    = p_id.
  wa_produto-nome       = p_nom.
  wa_produto-preco      = p_prc.
  wa_produto-categoria  = p_ctg.
  wa_produto-data       = sy-datum.
  wa_produto-status     = p_sts.
ENDFORM.

FORM criar_produto.
  DATA: lv_ultimo_id TYPE zprodutos-id_prod.

  SELECT MAX( id_prod ) INTO lv_ultimo_id FROM zprodutos.

  IF sy-subrc <> 0 OR lv_ultimo_id IS INITIAL.
    lv_ultimo_id = 1.
  ELSE.
    lv_ultimo_id = lv_ultimo_id + 1.
  ENDIF.

  IF wa_produto-status <> 'A' AND wa_produto-status <> 'I'.
    MESSAGE: 'O status do produto só pode ser A ou I' TYPE 'E'.
  ENDIF.

  IF wa_produto-nome      IS INITIAL OR
     wa_produto-preco     IS INITIAL OR
     wa_produto-categoria IS INITIAL.

     MESSAGE: 'Preencha todos os campos corretamente' TYPE 'E'.
  ENDIF.

  wa_produto-id_prod = lv_ultimo_id.

  INSERT zprodutos FROM wa_produto.

  IF sy-subrc = 0.
    WRITE: / 'Produto', wa_produto-nome, 'criado com sucesso. ID:', wa_produto-id_prod.
  ELSE.
    WRITE: / 'Erro ao criar produto.'.
  ENDIF.
ENDFORM.

FORM exibir_produto.
  SELECT SINGLE * INTO wa_produto FROM zprodutos WHERE id_prod = p_id.

  IF sy-subrc <> 0.
    MESSAGE 'Produto não encontrado' TYPE 'I'.
  ELSE.
    WRITE: / 'ID:',        wa_produto-id_prod,
             'Nome:',      wa_produto-nome,
             'Categoria:', wa_produto-categoria,
             'Preço:',     wa_produto-preco,
             'Status:',    wa_produto-status.
  ENDIF.
ENDFORM.

FORM atualizar_produto.

  IF wa_produto-id_prod IS INITIAL.
    MESSAGE 'Informe o ID do produto para atualizar' TYPE 'E'.
  ENDIF.

  SELECT SINGLE id_prod INTO @DATA(lv_exist) FROM zprodutos WHERE id_prod = @wa_produto-id_prod.
  IF sy-subrc <> 0.
    MESSAGE 'Produto não encontrado' TYPE 'E'.
  ENDIF.

  IF wa_produto-nome      IS INITIAL OR
    wa_produto-preco     IS INITIAL OR
    wa_produto-categoria IS INITIAL OR
    ( wa_produto-status <> 'A' AND wa_produto-status <> 'I' ).
    MESSAGE 'Preencha todos os campos corretamente' TYPE 'E'.
  ENDIF.

  UPDATE zprodutos SET
    nome        = @wa_produto-nome,
    preco       = @wa_produto-preco,
    categoria   = @wa_produto-categoria,
    status      = @wa_produto-status
  WHERE id_prod = @wa_produto-id_prod.

  IF sy-subrc = 0.
    MESSAGE 'Produto atualizado com sucesso' TYPE 'S'.
  ENDIF.
ENDFORM.

FORM deletar_produto.
  IF wa_produto-id_prod IS INITIAL.
    MESSAGE 'Informe o ID do produto para apagá-lo' TYPE 'E'.
  ENDIF.

  SELECT SINGLE id_prod INTO @DATA(lv_exist) FROM zprodutos WHERE id_prod = @wa_produto-id_prod.
  IF sy-subrc <> 0.
    MESSAGE 'Produto não encontrado' TYPE 'E'.
  ENDIF.

  DELETE FROM zprodutos WHERE id_prod = wa_produto-id_prod.

  IF sy-subrc = 0.
    MESSAGE 'Produto excluído com sucesso' TYPE 'S'.
  ENDIF.
ENDFORM.
