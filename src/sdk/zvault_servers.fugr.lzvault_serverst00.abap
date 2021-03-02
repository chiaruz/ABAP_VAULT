*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 02.03.2021 at 10:08:27
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZVAULT_SERVERS..................................*
DATA:  BEGIN OF STATUS_ZVAULT_SERVERS                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVAULT_SERVERS                .
CONTROLS: TCTRL_ZVAULT_SERVERS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVAULT_SERVERS                .
TABLES: ZVAULT_SERVERS                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
