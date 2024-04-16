(load "./src/ch4/amb-evaluator/parsing-natural-language.scm")

; "The professor lectures to the student with the cat"

; [참고답안]

;;; Amb-Eval input:
(parse '(the professor lectures to the student in the class with the cat))

;;; Starting a new problem
;;; Amb-Eval output:
(sentence
  (noun-phrase (articles the) (nouns professor))
  (verb-phrase (verb-phrase
                 (verb-phrase (verb lectures)
                              (pre-phrase (prep to) (noun-phrase (articles the) (nouns student))))
                 (pre-phrase (prep in) (noun-phrase (articles the) (nouns class))))
               (pre-phrase (prep with) (noun-phrase (articles the) (nouns cat)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval output:
(sentence (noun-phrase (articles the) (nouns professor))
          (verb-phrase (verb-phrase (verb lectures)
                                    (pre-phrase (prep to)
                                                (noun-phrase (articles the)
                                                             (nouns student))))
                       (pre-phrase (prep in)
                                   (noun-phrase (noun-phrase (articles the) (nouns class))
                                                (pre-phrase (prep with)
                                                            (noun-phrase (articles the) (nouns cat)))))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval output:
(sentence (noun-phrase (articles the) (nouns professor))
          (verb-phrase (verb-phrase (verb lectures)
                                    (pre-phrase (prep to)
                                                (noun-phrase (noun-phrase (articles the) (nouns student))
                                                             (pre-phrase (prep in)
                                                                         (noun-phrase (articles the) (nouns class))))))
                       (pre-phrase (prep with) (noun-phrase (articles the) (nouns cat)))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval output:
(sentence (noun-phrase (articles the) (nouns professor))
          (verb-phrase (verb lectures)
                       (pre-phrase (prep to)
                                   (noun-phrase (noun-phrase (noun-phrase (articles the)
                                                                          (nouns student))
                                                             (pre-phrase (prep in)
                                                                         (noun-phrase (articles the)
                                                                                      (nouns class))))
                                                (pre-phrase (prep with) (noun-phrase (articles the) (nouns cat)))))))

;;; Amb-Eval input:
try-again

;;; Amb-Eval output:
(sentence (noun-phrase (articles the) (nouns professor))
          (verb-phrase (verb lectures)
                       (pre-phrase (prep to)
                                   (noun-phrase (noun-phrase (articles the)
                                                             (nouns student))
                                                (pre-phrase (prep in)
                                                            (noun-phrase (noun-phrase (articles the)
                                                                                      (nouns class))
                                                                         (pre-phrase (prep with)
                                                                                     (noun-phrase (articles the)
                                                                                                  (nouns cat)))))))))
