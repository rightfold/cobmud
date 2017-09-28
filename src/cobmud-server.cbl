       identification division.
       program-id. cobmud-server.

       data division.
       working-storage section.
       01 ZMQ_REP                       binary-int value 4.

       01 bind-address                  pic X(256).

       01 zmq-ctx                       pointer.
       01 zmq-socket                    pointer.

       01 zmq-errno                     binary-int.
       01 zmq-strerror                  pointer.
       01 zmq-bind-ok                   binary-int.

       procedure division.
       main-para.
           accept bind-address from argument-value
           string bind-address delimited by space
                  x'00'        delimited by size
                  into bind-address

           call "zmq_ctx_new" giving zmq-ctx
           if zmq-ctx = null then perform error-para end-if

           call "zmq_socket" using by value zmq-ctx
                                   by value ZMQ_REP
                             giving zmq-socket
           if zmq-socket = null then perform error-para end-if

           call "zmq_bind" using by value zmq-socket
                                 by reference bind-address
                           giving zmq-bind-ok
           if zmq-bind-ok = -1 then perform error-para end-if

           goback
           .

       error-para.
           call "zmq_errno" giving zmq-errno
           call "zmq_strerror" using by value zmq-errno
                               giving zmq-strerror
           call "puts" using by value zmq-strerror
           goback giving 1
           .
