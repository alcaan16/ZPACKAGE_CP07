CLASS zcl_flight_manager_07 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_flight_manager_07.   " ZIF_ = interfaz global (el contrato)

    " ALIASES: mismo truco que usabas en el molde (ALIASES get_output FOR lif_output~get_output).
    " Nos deja escribir 'add_flight' en vez de 'zif_flight_manager_07~add_flight'.
    ALIASES add_flight             FOR zif_flight_manager_07~add_flight.
    ALIASES get_flights_by_airline FOR zif_flight_manager_07~get_flights_by_airline.
    ALIASES get_cheapest_flight    FOR zif_flight_manager_07~get_cheapest_flight.
    ALIASES get_total_revenue      FOR zif_flight_manager_07~get_total_revenue.
    ALIASES ty_flight              FOR zif_flight_manager_07~ty_flight.
    ALIASES tt_flights             FOR zif_flight_manager_07~tt_flights.

    " Constructor con precarga OPCIONAL (it_ = importing table)
    METHODS constructor
      IMPORTING it_flights TYPE tt_flights OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
    " La colección interna: atributo privado (encapsulación)
    DATA flights TYPE tt_flights.



ENDCLASS.


CLASS zcl_flight_manager_07 IMPLEMENTATION.


  METHOD constructor.
    " Si no se pasa it_flights, OPTIONAL lo deja vacío y flights queda vacía. Perfecto.
    flights = it_flights.
  ENDMETHOD.


  METHOD get_total_revenue.
    " rv_ = returning value
    rv_revenue = REDUCE /dmo/flight_price(
                   INIT revenue = 0
                   FOR ls_flight IN flights          " ls_ = local structure (work area)
                   NEXT revenue = revenue + ls_flight-price ).
  ENDMETHOD.

  METHOD get_cheapest_flight.
    IF flights IS INITIAL.
      RETURN.                    " rs_ = returning structure; se queda vacío si no hay vuelos
    ENDIF.

    " Arrancamos con el primer vuelo y nos quedamos con el más barato en cada paso
    rs_flight = REDUCE ty_flight(
                  INIT cheapest = flights[ 1 ]
                  FOR ls_flight IN flights
                  NEXT cheapest = COND #( WHEN ls_flight-price < cheapest-price
                                          THEN ls_flight
                                          ELSE cheapest ) ).
  ENDMETHOD.

  METHOD get_flights_by_airline.
    " rt_ = returning table
    rt_flights = VALUE #( FOR ls_flight IN flights
                          WHERE ( carrier_id = iv_carrier_id )   " iv_ = importing value
                          ( ls_flight ) ).
  ENDMETHOD.

  METHOD add_flight.
    " is_ = importing structure. is_flight LLEGA ya relleno: se usa, no se asigna.

    " PASO 1 — Precio positivo
    IF is_flight-price <= 0.
      RAISE EXCEPTION TYPE zcx_flight_error_07 " ZCX_ = clase de excepción global
        EXPORTING
          error_text = |Precio inválido para { is_flight-carrier_id } { is_flight-connection_id }: { is_flight-price }|.
    ENDIF.

    " PASO 2 — Sin duplicados (mismo carrier_id + connection_id)
    IF line_exists( flights[ carrier_id    = is_flight-carrier_id
                             connection_id = is_flight-connection_id ] ).
      RAISE EXCEPTION TYPE zcx_flight_error_07
        EXPORTING
          error_text = |Ya existe un vuelo { is_flight-carrier_id } { is_flight-connection_id }|.
    ENDIF.

    " PASO 3 — Alta
    APPEND is_flight TO flights.

  ENDMETHOD.


ENDCLASS.





