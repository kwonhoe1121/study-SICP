(rule (bigshot ?bshot ?division)
      (and (job ?bshot (?division . ?bshot-rest))
           (not (and (supervisor ?bshot ?boss)
                     (job ?boss (?division . ?boss-rest))))))
