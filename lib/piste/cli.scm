
(define-module piste.cli
  (export runner)
  (use gauche.process)
  (use util.match)
  (use file.util)
  (use srfi-1)
  (require-extension (srfi 1 13))    ; iota

  (use piste)
  (use piste.commands))
(select-module piste.cli)




(define (runner args)
  (match (cadr args)
    ((or "link" "ln")
     (dot-link))
    ((or "list" "ls")
     (dot-list))))
