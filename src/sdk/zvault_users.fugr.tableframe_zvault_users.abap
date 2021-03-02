*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZVAULT_USERS
*   generation date: 02.03.2021 at 10:07:24
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZVAULT_USERS       .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
