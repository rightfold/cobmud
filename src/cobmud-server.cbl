       identification division.
       program-id. cobmud-server.

       data division.
       working-storage section.
       01 ZMQ_REP                       binary-int value 4.

       01 bind-address                  pic X(256).

       01 zmq-ctx                       pointer.
       01 zmq-socket                    pointer.

       01 zmq-request                   pic X(256).
       01 zmq-recv-flags                binary-int value 0.
       01 zmq-send-flags                binary-int value 0.

       01 zmq-errno                     binary-int.
       01 zmq-strerror                  pointer.
       01 zmq-ok                        binary-int.

       procedure division.
       main-para.
           accept bind-address from argument-value
           string bind-address delimited by space
                  x'00'        delimited by size
                  into bind-address

           call "zmq_ctx_new" giving zmq-ctx
           if zmq-ctx = null then perform error-para end-if

           call "zmq_socket" using value zmq-ctx
                                   value ZMQ_REP
                             giving zmq-socket
           if zmq-socket = null then perform error-para end-if

           call "zmq_bind" using value zmq-socket
                                 reference bind-address
                           giving zmq-ok
           if zmq-ok = -1 then perform error-para end-if

           perform forever
               call "zmq_recv" using value zmq-socket
                                     reference zmq-request
                                     value function length(zmq-request)
                                     value zmq-recv-flags
                               giving zmq-ok
               if zmq-ok = -1 then perform error-para end-if

               call "zmq_send" using value zmq-socket
                                     reference zmq-request
                                     value function length(zmq-request)
                                     value zmq-send-flags
                               giving zmq-ok
               if zmq-ok = -1 then perform error-para end-if

               display zmq-request
           end-perform

           goback
           .

       error-para.
           call "zmq_errno" giving zmq-errno
           call "zmq_strerror" using value zmq-errno
                               giving zmq-strerror
           call "puts" using value zmq-strerror
           goback giving 1
           .
