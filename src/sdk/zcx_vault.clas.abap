CLASS zcx_vault DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_t100_message .
    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous LIKE previous OPTIONAL
        attr1    TYPE string OPTIONAL
        attr2    TYPE string OPTIONAL
        attr3    TYPE string OPTIONAL
        attr4    TYPE string OPTIONAL.

    CONSTANTS: BEGIN OF generic,
                 msgid TYPE symsgid      VALUE 'ZAULT',
                 msgno TYPE symsgno      VALUE '000',
                 attr1 TYPE scx_attrname VALUE 'ATTR1',
                 attr2 TYPE scx_attrname VALUE 'ATTR2',
                 attr3 TYPE scx_attrname VALUE 'ATTR3',
                 attr4 TYPE scx_attrname VALUE 'ATTR4',
               END OF generic.

    DATA: attr1 TYPE string READ-ONLY,
          attr2 TYPE string READ-ONLY,
          attr3 TYPE string READ-ONLY,
          attr4 TYPE string READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcx_vault IMPLEMENTATION.


  METHOD constructor  ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->attr1 = attr1.
    me->attr2 = attr2.
    me->attr3 = attr3.
    me->attr4 = attr4.

  ENDMETHOD.
ENDCLASS.
