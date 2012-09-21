
(define-module piste.bin-runner
  (export bin-runner)
  (use gauche.process)
  (use util.list) ; slices
  (use util.match)
  (use file.util)
  (use srfi-1)
  (require-extension (srfi 1 13))    ; iota
  (use kirjasto.tiedosto)
  (use kirjasto.väri))
(select-module piste.bin-runner)

(define piste-file (file->sexp-list (build-path (home-directory) ".pisterc")))
(define *srcdir* (caar piste-file))
(define *dotfiles* (cadar piste-file))


;; util
(define (path-home-file file)
  (build-path (home-directory) file))

(define (path-src-file file)
  (build-path *srcdir* file))

(define (print-list num lyst)
  (for-each (^f (print (colour-string num f)))
            lyst))

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

;; commands

(define (dot-link)
  (link-make-symlink *dotfiles*))

(define (dot-list)
  (list-dotfiles))


(define (bin-runner args)
  (match (cadr args)
    ((or "link" "ln")
     (dot-link))
    ((or "list" "ls")
     (dot-list))))
