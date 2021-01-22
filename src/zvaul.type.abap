TYPE-POOL zvaul.

TYPES: BEGIN OF zvaul_auth,
         client__token   TYPE string,
         accessor        TYPE string,
         policies        TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
         token__policies TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
         metadata        TYPE string,
         renewable       TYPE xfeld,
         lease__duration TYPE int4,
         entity__id      TYPE string,
         token_type      TYPE string,
         orphan          TYPE xfeld,
       END OF zvaul_auth.

TYPES: BEGIN OF zvaul_login,
         request_id      TYPE string,
         lease__id       TYPE string,
         renewable       TYPE xfeld,
         lease__duration TYPE int4,
         data            TYPE string,
         wrap__info      TYPE string,
         warnings        TYPE string,
         auth            TYPE zvaul_auth,
       END OF zvaul_login.

TYPES: BEGIN OF zvaul_login_request,
         password     TYPE string,
         policies     TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
         bound__cidrs TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
       END OF zvaul_login_request.


TYPES: BEGIN OF zvaul_totpt_create,
         generate      TYPE string,
         issuer        TYPE string,
         account__name TYPE string,
         period        TYPE int2,
         digit         TYPE i,
         skew          TYPE i,
       END OF zvaul_totpt_create.

TYPES: BEGIN OF zvaul_totpt_data,
         barcode TYPE xstring,
         url     TYPE string,
       END OF zvaul_totpt_data.

TYPES: BEGIN OF zvaul_totpt_create_resp,
         request_id     TYPE string,
         lease__id      TYPE string,
         renewable      TYPE xfeld,
         lease_duration TYPE int2,
         data           TYPE zvaul_totpt_data,
         wrap__info     TYPE string,
         warnings       TYPE string,
         auth           TYPE string,
       END OF zvaul_totpt_create_resp.

TYPES: BEGIN OF zvaul_totpt_code,
         code TYPE string,
       END OF zvaul_totpt_code.

TYPES: BEGIN OF zvaul_totpt_code_data,
         code TYPE string,
         valid TYPE xfeld,
       END OF zvaul_totpt_code_data.

TYPES: BEGIN OF zvaul_totpt_code_resp,
         request_id     TYPE string,
         lease__id      TYPE string,
         renewable      TYPE xfeld,
         lease_duration TYPE int2,
         data           TYPE zvaul_totpt_code_data,
         wrap__info     TYPE string,
         warnings       TYPE string,
         auth           TYPE string,
       END OF zvaul_totpt_code_resp.

TYPES: BEGIN OF zvaul_error,
         errors TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
       END OF zvaul_error.
