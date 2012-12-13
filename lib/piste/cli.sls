
(library (piste cli)
  (export
    runner)
  (import
    (rnrs)
    (loitsu cli)
    (piste commands)
    )

  (begin

    (define (runner args)
      (match-short-command (cadr args)
        ("list"
         (list-files args))
        ("link"
         (link args))))

    ))
