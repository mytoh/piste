
;; -*- coding: utf-8 -*-

(define-module piste.util
  (export
    colour-string
    path-home-file
    path-src-file
    print-list)
  (require-extension (srfi 13))
  (use piste.env)
  (use file.util))
(select-module piste.util)

;; util
(define (path-home-file file)
  (build-path (home-directory) file))

(define (path-src-file file)
  (build-path *srcdir* file))

(define (print-list num lyst)
  (for-each (^f (print (colour-string num f)))
            lyst))

(define (colour-string colour-number s)
  ;; take number, string -> return string
  (cond
    ((string? s)
     (string-concatenate
       `("[38;5;" ,(number->string colour-number) "m"
         ,s
         "[0m")))
    (else
     (string-concatenate
       `("[38;5;" ,(number->string colour-number) "m"
         ,s
         "[0m")))))

