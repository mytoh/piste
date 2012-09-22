
;; -*- coding: utf-8 -*-

(define-module piste.util
  (export
    path-home-file
    path-src-file
    print-list)
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
