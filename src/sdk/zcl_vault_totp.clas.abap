CLASS zcl_vault_totp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS: zvaul.

    CONSTANTS: server TYPE string VALUE 'http://10.0.0.192:8201'.

    CONSTANTS: base_url TYPE string VALUE '/v1/totp/'.

    CONSTANTS: BEGIN OF service,
                 create TYPE string VALUE 'keys',
                 check  TYPE string VALUE 'code',
               END OF service.

    CLASS-METHODS: create
      IMPORTING issuer          TYPE string OPTIONAL
                username        TYPE string
                account_name    TYPE string
                token           TYPE string
      RETURNING VALUE(r_result) TYPE zvaul_totpt_create_resp
      RAISING   zcx_vault.

    CLASS-METHODS: delete
      IMPORTING username        TYPE string
                token           TYPE string
      RETURNING VALUE(r_result) TYPE boolean
      RAISING   zcx_vault.

    CLASS-METHODS: list
      IMPORTING token           TYPE string
      RETURNING VALUE(r_result) TYPE zvaul_totpt_code_resp
      RAISING   zcx_vault.

    CLASS-METHODS: check_code
      IMPORTING username        TYPE string
                code            TYPE string
                token           TYPE string
      RETURNING VALUE(r_result) TYPE zvaul_totpt_code_resp
      RAISING   zcx_vault.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_vault_totp IMPLEMENTATION.
  METHOD create.

    DATA(url) = |{ server }{ base_url }{ service-create }/{ username }|.

    cl_http_client=>create_by_url( EXPORTING url                = url
                                   IMPORTING client             = DATA(client)
                                  EXCEPTIONS argument_not_found = 1
                                             plugin_not_active  = 2
                                             internal_error     = 3
                                             OTHERS             = 4 ).

    DATA(request) = VALUE zvaul_totpt_create(
        generate      = abap_true
        issuer        = issuer
        account__name = account_name
        digit         = 6
        skew          = 1
    ).

    DATA(payload_request) = /ui2/cl_json=>serialize(
                              data             = request
                              compress         = abap_true
                              pretty_name      = /ui2/cl_json=>pretty_mode-extended ).

    client->request->set_cdata(        data = payload_request ).
    client->request->set_header_field( name = 'X-Vault-Token'
                                       value = token ).
    client->request->set_content_type( content_type = 'application/json' ).
    client->request->set_method(       method = if_http_request=>co_request_method_post ).
    client->request->set_version(      version = if_http_request=>co_protocol_version_1_1 ).

    client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).

    client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4 ).

    DATA(payload_response) = client->response->get_cdata( ).

    /ui2/cl_json=>deserialize(
      EXPORTING
        json        =  payload_response
        pretty_name = /ui2/cl_json=>pretty_mode-extended
      CHANGING
        data        = r_result
    ).

  ENDMETHOD.

  METHOD check_code.

    DATA(url) = |{ server }{ base_url }{ service-check }/{ username }|.

    cl_http_client=>create_by_url( EXPORTING url                = url
                                   IMPORTING client             = DATA(client)
                                  EXCEPTIONS argument_not_found = 1
                                             plugin_not_active  = 2
                                             internal_error     = 3
                                             OTHERS             = 4 ).

    DATA(request) = VALUE zvaul_totpt_code( code = code ).

    DATA(payload_request) = /ui2/cl_json=>serialize(
                              data             = request
                              compress         = abap_true
                              pretty_name      = /ui2/cl_json=>pretty_mode-extended ).

    client->request->set_cdata(        data = payload_request ).
    client->request->set_header_field( name = 'X-Vault-Token'
                                       value = token ).
    client->request->set_content_type( content_type = 'application/json' ).
    client->request->set_method(       method = if_http_request=>co_request_method_post ).
    client->request->set_version(      version = if_http_request=>co_protocol_version_1_1 ).

    client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).

    client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4 ).

    DATA(payload_response) = client->response->get_cdata( ).
    client->response->get_status( IMPORTING code   = DATA(status_code)
                                            reason = DATA(status_text) ).

    IF status_code NE '200'.
      DATA errors TYPE zvaul_error.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json        =  payload_response
          pretty_name = /ui2/cl_json=>pretty_mode-extended
        CHANGING
          data        = errors ).

      DATA(error) = VALUE string( errors-errors[ 1 ] DEFAULT 'Error' ).

      RAISE EXCEPTION TYPE zcx_vault
        EXPORTING
          textid = zcx_vault=>generic
          attr1  = error
          attr2  = ''
          attr3  = ''
          attr4  = ''.
    ENDIF.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json        =  payload_response
        pretty_name = /ui2/cl_json=>pretty_mode-extended
      CHANGING
        data        = r_result ).

  ENDMETHOD.

  METHOD delete.

    DATA(url) = |{ server }{ base_url }{ service-create }/{ username }|.

    cl_http_client=>create_by_url( EXPORTING url                = url
                                   IMPORTING client             = DATA(client)
                                  EXCEPTIONS argument_not_found = 1
                                             plugin_not_active  = 2
                                             internal_error     = 3
                                             OTHERS             = 4 ).

    client->request->set_header_field( name = 'X-Vault-Token'
                                       value = token ).
    client->request->set_method(       method = 'DELETE' ).
    client->request->set_version(      version = if_http_request=>co_protocol_version_1_1 ).

    client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).

    client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4 ).

    DATA(payload_response) = client->response->get_cdata( ).
    client->response->get_status( IMPORTING code   = DATA(status_code)
                                            reason = DATA(status_text) ).

    IF status_code NE '204'.
      DATA errors TYPE zvaul_error.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json        =  payload_response
          pretty_name = /ui2/cl_json=>pretty_mode-extended
        CHANGING
          data        = errors ).

      DATA(error) = VALUE string( errors-errors[ 1 ] DEFAULT 'Error' ).

      RAISE EXCEPTION TYPE zcx_vault
        EXPORTING
          textid = zcx_vault=>generic
          attr1  = error
          attr2  = ''
          attr3  = ''
          attr4  = ''.

    ELSE.
      r_result = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD list.
    DATA(url) = |{ server }{ base_url }{ service-create }|.

    cl_http_client=>create_by_url( EXPORTING url                = url
                                   IMPORTING client             = DATA(client)
                                  EXCEPTIONS argument_not_found = 1
                                             plugin_not_active  = 2
                                             internal_error     = 3
                                             OTHERS             = 4 ).

    client->request->set_header_field( name = 'X-Vault-Token'
                                        value = token ).
    client->request->set_content_type( content_type = 'application/json' ).
    client->request->set_method(       method = 'LIST' ).
    client->request->set_version(      version = if_http_request=>co_protocol_version_1_1 ).

    client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).

    client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4 ).

    DATA(payload_response) = client->response->get_cdata( ).
    client->response->get_status( IMPORTING code   = DATA(status_code)
                                            reason = DATA(status_text) ).

    IF status_code NE '200'.
      DATA errors TYPE zvaul_error.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json        =  payload_response
          pretty_name = /ui2/cl_json=>pretty_mode-extended
        CHANGING
          data        = errors ).

      DATA(error) = VALUE string( errors-errors[ 1 ] DEFAULT 'Error' ).

      RAISE EXCEPTION TYPE zcx_vault
        EXPORTING
          textid = zcx_vault=>generic
          attr1  = error
          attr2  = ''
          attr3  = ''
          attr4  = ''.
    ENDIF.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json        =  payload_response
        pretty_name = /ui2/cl_json=>pretty_mode-extended
      CHANGING
        data        = r_result ).
  ENDMETHOD.

ENDCLASS.
