; (a)

(rule (today ?today)
      (meeting ?division (?today . ?time)))

; (b)

(rule (meeting-time ?person ?day-and-time)
      (and (job ?person (?division . ?rest))
           (or (meeting ?division ?day-and-time)
               (meeting the-whole-company ?day-and-time))))

; (c)

(and (meeting-time (Hacker Alyssa P) (Wednesday . ?time))
     (meeting ?division (Wednesday . ?time)))
