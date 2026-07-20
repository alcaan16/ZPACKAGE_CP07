INTERFACE zif_flight_manager_07
  PUBLIC.

  " --- Row type del vuelo (released data elements /dmo/) ---
  TYPES: BEGIN OF ty_flight,        " ty_ = tipo/estructura
           carrier_id    TYPE /dmo/carrier_id,
           connection_id TYPE /dmo/connection_id,
           price         TYPE /dmo/flight_price,
           currency_code TYPE /dmo/currency_code,
         END OF ty_flight.

  TYPES tt_flights TYPE STANDARD TABLE OF ty_flight   " tt_ = tipo tabla
                        WITH EMPTY KEY.

  " --- Contrato ---
  METHODS add_flight
    IMPORTING is_flight TYPE ty_flight            " is_ = importing structure
    RAISING   zcx_flight_error_07.

  METHODS get_flights_by_airline
    IMPORTING iv_carrier_id     TYPE /dmo/carrier_id
    RETURNING VALUE(rt_flights) TYPE tt_flights.

  METHODS get_cheapest_flight
    RETURNING VALUE(rs_flight)  TYPE ty_flight.

  METHODS get_total_revenue
    RETURNING VALUE(rv_revenue) TYPE /dmo/flight_price.

ENDINTERFACE.

