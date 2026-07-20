CLASS zcx_flight_error_07 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check   " excepción "checked": obliga a TRY/CATCH o a propagarla
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    " Atributo con el mensaje de error (lo pide el enunciado)
    DATA error_text TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        error_text TYPE string   OPTIONAL
        previous   LIKE previous OPTIONAL.   " para encadenar excepciones (buena práctica)

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcx_flight_error_07 IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    " Siempre primero: inicializa la parte heredada de CX_STATIC_CHECK
    super->constructor( previous = previous ).
    me->error_text = error_text.
  ENDMETHOD.

ENDCLASS.
