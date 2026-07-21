CLASS zcl_cp03_07 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_cp03_07 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Instancia del gestor. lo_ = local object reference.
    " NEW #( ) infiere el tipo del lado izquierdo (zcl_flight_manager_07).
    DATA(lo_manager) = NEW zcl_flight_manager_07( ).

    " Envolvemos las altas en TRY porque add_flight puede lanzar ZCX_FLIGHT_ERROR_07.
    " ls_ = local structure (el vuelo que preparamos para enviar).
    TRY.
        lo_manager->add_flight( VALUE #( carrier_id = 'LH' connection_id = '0400' price = '600.00'  currency_code = 'EUR' ) ).
        lo_manager->add_flight( VALUE #( carrier_id = 'LH' connection_id = '0401' price = '250.00'  currency_code = 'EUR' ) ).
        lo_manager->add_flight( VALUE #( carrier_id = 'AA' connection_id = '0017' price = '1200.00' currency_code = 'USD' ) ).
        lo_manager->add_flight( VALUE #( carrier_id = 'QF' connection_id = '0006' price = '1600.00' currency_code = 'AUD' ) ).
        lo_manager->add_flight( VALUE #( carrier_id = 'UA' connection_id = '0900' price = '90.00'   currency_code = 'USD' ) ).

        out->write( '5 vuelos añadidos correctamente.' ).

      CATCH zcx_flight_error_07 INTO DATA(lx_error).
        out->write( |ERROR inesperado en la precarga: { lx_error->error_text }| ).
    ENDTRY.


    " Bloque B — Precio negativo (debe saltar la excepción del PASO 1)
    TRY.
        lo_manager->add_flight( VALUE #( carrier_id = 'LH' connection_id = '0999' price = '-50.00' currency_code = 'EUR' ) ).
        " Si llega aquí, algo va mal (no debería añadirse)
      CATCH zcx_flight_error_07 INTO DATA(lx_neg).
        out->write( |Capturado (precio negativo): { lx_neg->error_text }| ).
    ENDTRY.

    " Bloque C — Duplicado (debe saltar la excepción del PASO 2)
    "   TÚ: replica el patrón de arriba, pero añadiendo un vuelo que YA existe
    "   (mismo carrier_id + connection_id que uno de los 5 iniciales, p.ej. LH 0400).

    TRY.
        lo_manager->add_flight( VALUE #( carrier_id = 'LH' connection_id = '0400' price = '600.00'  currency_code = 'EUR' ) ).
        " Si llega aquí, algo va mal (no debería añadirse)
      CATCH zcx_flight_error_07 INTO DATA(lx_dup).
        out->write( |Capturado (duplicado): { lx_dup->error_text }| ).
    ENDTRY.

    " Punto 5 — Vuelos de una aerolínea concreta
    out->write( `--- Vuelos de LH ---` ).
    out->write( lo_manager->get_flights_by_airline( iv_carrier_id = 'LH' ) ).

    " Punto 6 — Vuelo más barato
    out->write( `--- Vuelo más barato ---` ).
    out->write( lo_manager->get_cheapest_flight( ) ).

    " Punto 7 — Facturación total
    out->write( |Facturación total: { lo_manager->get_total_revenue( ) }| ).

  ENDMETHOD.
ENDCLASS.




