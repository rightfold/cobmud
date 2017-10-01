       identification division.
       program-id. cobmud-command-look.

       data division.
       linkage section.
       01 player-id                     pic X(15).

       procedure division using reference player-id.
           display player-id
           exit program
           .
