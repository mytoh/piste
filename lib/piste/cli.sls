
(library (piste cli)
  (export
    runner)
  (import
    (rnrs)
    (match)
    (piste commands)
    )

  (begin

    (define (runner args)
      (match (cadr args)
        ("list"
         (list-files args))
        ("link"
         (link args))))

    ))
