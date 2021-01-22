*&---------------------------------------------------------------------*
*& Report zvault_totp_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvault_totp_test.


PARAMETERS: pa_cr TYPE xfeld RADIOBUTTON GROUP gr1,
            pa_li TYPE xfeld RADIOBUTTON GROUP gr1,
            pa_de TYPE xfeld RADIOBUTTON GROUP gr1,
            pa_ts TYPE xfeld RADIOBUTTON GROUP gr1.

PARAMETERS: p_user   TYPE string LOWER CASE,
            p_token  TYPE string LOWER CASE,
            p_server TYPE string LOWER CASE.


DATA code TYPE string.

TRY.
    CASE abap_true.
      WHEN pa_cr.
        DATA(totp) = zcl_vault_totp=>create(
          EXPORTING
            issuer       = |{ sy-sysid }{ sy-mandt }|
            username     = p_user
            account_name = |{ p_user }@{ sy-sysid }{ sy-mandt }.test|
            token        = p_token ).

        DATA(png) = `<div><img src="data:image/jpeg;base64,` &&
                    totp-data-barcode &&
                    `" alt="Red dot" /></div>`.

        cl_demo_input=>new( )->add_text( text = png
                            )->add_field( CHANGING field = code
                            )->request( ).

        cl_demo_output=>display_data(
            name = 'Result'
            value = zcl_vault_totp=>check_code( username = p_user
                                                code     = code
                                                token    = p_token )-data-valid ).

      WHEN pa_li.
        DATA(list) = zcl_vault_totp=>list( token = p_token ).

        cl_demo_output=>display_data( value = list-data-keys ).

      WHEN pa_de.
        zcl_vault_totp=>delete( username = p_user
                                token    = p_token ).

      WHEN pa_ts.

        cl_demo_input=>new(
          )->add_field( CHANGING field = code
          )->request( ).

        cl_demo_output=>display_data(
            name = 'Result'
            value = zcl_vault_totp=>check_code(
                             username = p_user
                             code     = code
                             token    = p_token
                           )-data-valid ).

    ENDCASE.

  CATCH zcx_vault INTO DATA(ex).
    MESSAGE ex->get_text( ) TYPE 'I'.
ENDTRY.
