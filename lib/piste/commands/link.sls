
(library (piste commands link)
  (export
    link)
  (import
    (silta base)
    (silta write)
    (silta cxr)
    (loitsu file)
    (loitsu message)
    (loitsu maali)
    )

  (begin

    (define (get-setting file)
      (car (file->sexp-list file)))

    (define (config-file)
      (build-path (home-directory) ".pisterc"))

    (define (link-files lst src dest)
      (for-each
        (lambda (f)
          (let ((dest-file (build-path dest f)))
            (ensure-directory (path-dirname dest-file))
            (cond
              ((and (file-exists? (build-path src f))
                    (not (file-exists? dest-file)))
               (create-symbolic-link (build-path src f)
                                     dest-file)
               (display (paint f 39))
               (display " linked")
               (newline))
              (else
                (display (paint f 128))
                (display " exists!")
                (newline)))))
        lst))


    (define (ensure-directory dir)
      (if (not (file-exists? dir))
        (make-directory* dir)))

    (define (link args)
      (let ((dotdir (caddr args))
            (targetdir (if (null? (cdddr args))
                         (home-directory)
                         (cadddr args))))
        (ensure-directory targetdir)
        (ohei "link your files")
        (cond
          ((file-exists? (config-file))
           (link-files (get-setting (config-file))
                       dotdir
                       targetdir))
          (else
            (display "create .pisterc file in your home directory")
            (newline)))))

    ))
