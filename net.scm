(use-modules (rnrs bytevectors))

(define (get-buf) (make-bytevector 80))

(define (host port)
	(let ((sock (socket PF_INET SOCK_STREAM 0)))
		(bind sock AF_INET INADDR_ANY port)
		(listen sock 1)
		(let ((ret (accept sock)))
			(close-port sock)
			(car ret))))

(define (client dst port)
	(let ((sock (socket PF_INET SOCK_STREAM 0)))
		(connect sock AF_INET dst port)
		sock))

;(define (netread sock buf)
;	(let ((n (recv! sock buf)))
;		(string-take (utf8->string buf) n)))

(define (NRhost sock)
	(write (primitive-eval (read sock)) sock))

(define (NRclient sock str)
	(write str sock)
	(read sock))
