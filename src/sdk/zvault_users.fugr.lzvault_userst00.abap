*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 02.03.2021 at 10:07:27
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVAULT_USERS....................................*
DATA:  BEGIN OF STATUS_ZVAULT_USERS                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVAULT_USERS                  .
CONTROLS: TCTRL_ZVAULT_USERS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVAULT_USERS                  .
TABLES: ZVAULT_USERS                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
