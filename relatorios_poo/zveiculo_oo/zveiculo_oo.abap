REPORT ZVEICULO_OO.

CLASS zcl_veiculo DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING modelo TYPE string
                                   ano    TYPE i,
             exibir_informacoes ABSTRACT.
  PROTECTED SECTION.
    DATA: mv_modelo TYPE string,
          mv_ano    TYPE i.
ENDCLASS.

CLASS zcl_veiculo IMPLEMENTATION.

  METHOD constructor.
    mv_modelo = modelo.
    mv_ano    = ano.
  ENDMETHOD.

ENDCLASS.

CLASS zcl_carro DEFINITION INHERITING FROM zcl_veiculo.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING modelo     TYPE string
                                   ano        TYPE i
                                   num_portas TYPE i,
             exibir_informacoes REDEFINITION.
    PRIVATE SECTION.
      DATA: mv_num_portas TYPE i.
ENDCLASS.

CLASS zcl_carro IMPLEMENTATION.
   METHOD constructor.
     super->constructor( modelo = modelo ano = ano ).
     mv_num_portas = num_portas.
   ENDMETHOD.

   METHOD exibir_informacoes.
     WRITE: / 'Carro:',    mv_modelo,
              ', Ano:',    mv_ano,
              ', Portas:', mv_num_portas.
   ENDMETHOD.
ENDCLASS.

CLASS zcl_moto DEFINITION INHERITING FROM zcl_veiculo.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING modelo     TYPE string
                                   ano        TYPE i
                                   cilindrada TYPE i,
             exibir_informacoes REDEFINITION.
    PRIVATE SECTION.
      DATA: mv_cilindrada TYPE i.
ENDCLASS.

CLASS zcl_moto IMPLEMENTATION.
  METHOD constructor.
    super->constructor( modelo = modelo ano = ano ).
    mv_cilindrada = cilindrada.
  ENDMETHOD.

  METHOD exibir_informacoes.
    WRITE: / 'Moto:',       mv_modelo,
             ', Ano:',        mv_ano,
             ', Cilindrada:', mv_cilindrada.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_veiculo TYPE REF TO zcl_veiculo.

  lo_veiculo = NEW zcl_carro( modelo = 'Civic' ano = 2025 num_portas = 5 ).
  lo_veiculo->exibir_informacoes( ).

  lo_veiculo = NEW zcl_moto( modelo = 'hornet' ano = 2024 cilindrada = 600 ).
  lo_veiculo->exibir_informacoes( ).
