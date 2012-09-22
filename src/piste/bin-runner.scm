
(define-module piste.bin-runner
  (export bin-runner)
  (use gauche.process)
  (use util.list) ; slices
  (use util.match)
  (use file.util)
  (use srfi-1)
  (require-extension (srfi 1 13))    ; iota
  (use kirjasto.tiedosto)
  (use kirjasto.väri)

  (use piste.util)
  (use piste.commands))
(select-module piste.bin-runner)

(define piste-file (file->sexp-list (build-path (home-directory) ".pisterc")))
(define *srcdir* (expand-path (caar piste-file)))
(define *dotfiles* (cadar piste-file))


;; link
(define (link-make-symlink files)
  (if (null? files)
    '()
    (let ((file (car files)))
      (cond
        ((file-exists? (path-home-file file))
         (print (string-append (colour-string 1 file) " exists, skip")))
        ((file-is-directory? (sys-dirname (path-home-file file)))
         (link-file-home file))
        (else
          (print (string-append "making ,(sys-dirname (path-home-file file))"))
          (make-directory* (sys-dirname (path-home-file file)))
          (link-file-home file)))
      (link-make-symlink (cdr files)))))

(define (link-file-home file)
  (print (string-append (colour-string 38 file)
                        " linked"))
  (sys-symlink (path-src-file file)
               (path-home-file file)))


;; commands

(define (dot-link)
  (link-make-symlink *dotfiles*))



(define (bin-runner args)
  (match (cadr args)
    ((or "link" "ln")
     (dot-link))
    ((or "list" "ls")
     (dot-list))))
