
;; -*- coding: utf-8 -*-

(define-module piste.commands.list
  (export dot-list)
  (use util.list) ; slices
  (use srfi-1)
  (use piste)
  (use file.util))
(select-module piste.commands.list)


;; list

(define file-is-managed?
  (every-pred
    (^f (file-is-symlink? (path-home-file f)))
    (^f (file-eqv? (sys-realpath (path-home-file f))
                   (path-src-file f)))))

(define (list-not-symlinks lyst)
  (filter (^f (if (and (file-exists? (path-home-file f))
                    (not (file-is-symlink? (path-home-file f))))
                #t #f))
          lyst))

(define (list-symlinks lyst)
  (filter (^f (if (file-is-symlink? (path-home-file f))
                #t #f))
          lyst))

(define (list-managed-symlinks lyst)
  (filter file-is-managed?
          lyst))

(define (list-not-managed-symlinks lyst)
  (remove file-is-managed?  lyst))

(define (list-dotfiles)
  (let ((exist-files (list-not-symlinks *dotfiles*))
        (managed-files (list-managed-symlinks *dotfiles*))
        (not-managed-files (list-not-managed-symlinks *dotfiles*)))
    (print "managed files")
    (print-list 190 managed-files)
    (newline)
    (print "not symlink")
    (print-list 38 exist-files)
    (newline)
    (print "not managed files")
    (print-list 103 not-managed-files)))

(define (dot-list)
  (list-dotfiles))
