CLASS zcl_vault_userpass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS: zvaul.

    CONSTANTS: server TYPE string VALUE 'http://10.0.0.192:8201'.

    CONSTANTS: base_url TYPE string VALUE '/v1/auth/userpass/'.

    CONSTANTS: BEGIN OF service,
                 users TYPE string VALUE '/users',
                 login TYPE string VALUE 'login',
               END OF service.

    CLASS-METHODS login
      IMPORTING username        TYPE string
                password        TYPE string
      RETURNING VALUE(r_result) TYPE zvaul_login.


  PROTECTED SECTION.
  PRIVATE SECTION.



ENDCLASS.

CLASS zcl_vault_userpass IMPLEMENTATION.

  METHOD login.

    DATA(url) = |{ server }{ base_url }{ service-login }/{ username }|.

    cl_http_client=>create_by_url( EXPORTING url                = url
                                   IMPORTING client             = DATA(client)
                                  EXCEPTIONS argument_not_found = 1
                                             plugin_not_active  = 2
                                             internal_error     = 3
                                             OTHERS             = 4 ).

    DATA(request) = VALUE zvaul_login_request( password = password ).

    DATA(payload_request) = /ui2/cl_json=>serialize(
                              data             = request
                              compress         = abap_true
                              pretty_name      = /ui2/cl_json=>pretty_mode-extended ).

    client->request->set_cdata(        data = payload_request ).
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

ENDCLASS.
