

;; -*- coding: utf-8 -*-

(define-module piste.commands.link
  (export dot-link)
  (use util.list) ; slices
  (use srfi-1)
  (use piste)
  (use file.util))
(select-module piste.commands.link)

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

