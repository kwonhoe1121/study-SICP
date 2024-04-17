(load "./src/ch4/amb-evaluator/parsing-natural-language.scm")

; [참고답안]

(define adjectives '(adjective ugly stupid lazy dirty shitty))
(define (parse-simple-noun-phrase)
  (amb (list 'simple-noun-phrase
             (parse-word articles)
             (parse-word nouns))
       (list 'simple-noun-phrase
             (parse-word articles)
             (parse-word adjectives)
             (parse-word nouns))))
