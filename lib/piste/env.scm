
;; -*- coding: utf-8 -*-

(define-module piste.env
  (export
    piste-file
    *srcdir*
    *dotfiles*)
  (use file.util))
(select-module piste.env)

(define piste-file (file->sexp-list (build-path (home-directory) ".pisterc")))
(define *srcdir* (expand-path (caar piste-file)))
(define *dotfiles* (cadar piste-file))

