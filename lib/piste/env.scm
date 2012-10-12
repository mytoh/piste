
;; -*- coding: utf-8 -*-

(define-module piste.env
  (export
    piste-file
    *srcdir*
    *dotfiles*)
  (use kirjasto.config)
  (use file.util))
(select-module piste.env)

(define piste-file (read-config (build-path (home-directory) ".pisterc")))
(define *srcdir* (expand-path (car piste-file)))
(define *dotfiles* (cadr piste-file))

