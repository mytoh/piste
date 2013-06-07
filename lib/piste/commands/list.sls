

(library (piste commands list)
    (export
      list-files)
  (import
    (silta base)
    (silta cxr)
    (silta write)
    (loitsu file)
    (loitsu message)
    (maali))

  (begin

    (define (get-setting file)
      (car (file->sexp-list file)))

    (define (config-file)
      (build-path (home-directory) ".pisterc"))

    (define (display-files lst src dest)
      (for-each
          (lambda (f)
            (let ((dest-file (build-path dest f)))
              (ensure-directory (path-dirname dest-file))
              (cond
                ((and (file-exists? (build-path src f))
                   (not (file-exists? dest-file)))
                 (display (paint f 39))
                 (display " will be linked")
                 (newline))
                (else
                    (display (paint f 128))
                  (display " exists!")
                  (newline)))))
        lst))


    (define (ensure-directory dir)
      (if (not (file-exists? dir))
        (make-directory* dir)))

    (define (list-files args)
      (let ((dotdir (caddr args))
            (targetdir (if (null? (cdddr args))
                         (home-directory)
                         (cadddr args))))
        (ensure-directory targetdir)
        (ohei "listing files")
        (cond
          ((file-exists? (config-file))
           (display-files (get-setting (config-file))
                          dotdir
                          targetdir))
          (else
              (display "create .pisterc file in your home directory")
            (newline)))))

    ))
