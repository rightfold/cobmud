       identification division.
       program-id. cobmud-server.

       data division.
       working-storage section.
       01 ZMQ_REP                       binary-int value 4.

       01 bind-address                  pic X(256).

       01 zmq-ctx                       pointer.
       01 zmq-socket                    pointer.

       01 zmq-recv-flags                binary-int value 0.
       01 zmq-send-flags                binary-int value 0.

       01 zmq-errno                     binary-int.
       01 zmq-strerror                  pointer.
       01 zmq-ok                        binary-int.

       01 request.
           02 player-id                 pic X(15).
           02 command                   pic X(50).

       procedure division.
       main-para.
           perform configure-para
           perform listen-para

           perform forever
               perform recv-para
               perform interpret-para
               perform send-para
           end-perform

           stop run
           .

       configure-para.
           accept bind-address from argument-value
           string bind-address delimited by space
                  x'00'        delimited by size
                  into bind-address
           .

       listen-para.
           call "zmq_ctx_new" giving zmq-ctx
           if zmq-ctx = null then perform zmq-error-para end-if

           call "zmq_socket" using value zmq-ctx
                                   value ZMQ_REP
                             giving zmq-socket
           if zmq-socket = null then perform zmq-error-para end-if

           call "zmq_bind" using value zmq-socket
                                 reference bind-address
                           giving zmq-ok
           if zmq-ok = -1 then perform zmq-error-para end-if
           .

        recv-para.
           move spaces to request
           call "zmq_recv" using value zmq-socket
                                 reference request
                                 value function length(request)
                                 value zmq-recv-flags
                           giving zmq-ok
           if zmq-ok = -1 then perform zmq-error-para end-if
           .

       interpret-para.
           evaluate command
               when "look"
                   call "cobmud-command-look" using reference player-id
           end-evaluate
           .

       send-para.
           call "zmq_send" using value zmq-socket
                                 reference request
                                 value function length(request)
                                 value zmq-send-flags
                           giving zmq-ok
           if zmq-ok = -1 then perform zmq-error-para end-if
           .

       zmq-error-para.
           call "zmq_errno" giving zmq-errno
           call "zmq_strerror" using value zmq-errno
                               giving zmq-strerror
           call "puts" using value zmq-strerror
           goback giving 1
           .
