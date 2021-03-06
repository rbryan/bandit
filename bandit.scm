(use-modules (rnrs io ports) (srfi srfi-1))

(define (get-listener-ports n port)
  (let ((sock-port (socket PF_INET SOCK_STREAM 0)))
    (bind sock-port AF_INET INADDR_ANY port)
    (listen sock-port n)
    (let loop ((res '()) (n n))
    	(if (= 0 n) (begin (close-port sock-port) res)
		(loop (cons (car (accept sock-port)) res) (- n 1))
	)
    )
  )
)

(define (all l) (fold (lambda (x y) (and x y)) #t l))

(define (repl port)
  (let loop ((listener-ports (get-listener-ports 2 port)))
	  (let ((ports (select listener-ports '() '() #f)))
	    ;(format #t "Debug: ~a\n" ports)
	    (if (all (map (lambda (port)
		    (catch #t 
			   ;(lambda () (format (cdr port) "~a\n" (eval (read (car port)) (interaction-environment))) #t)
			   (lambda () (let ((expr (read port))) (read-char port) (format port "~a\n" (primitive-eval expr))) #t)
			   (lambda (key . args) 
			     (if (eq? key 'quit)
			       #f
			       (begin
				 (format port "~a\n" args) #t))))
		   )
		 (car ports)))
	    (loop listener-ports)
	    (for-each close-port listener-ports)))))
