; and 복합 질의를 병렬로 구현하기
; N²/k => N²/k²
; 이 연산은 동일화와 비슷하다.

; [참고답안]

(define (conjoin conjuncts frame-stream)
  (define (compatible-frames? f1 f2)
    (every (lambda (b1)
                   (let ((b2 (binding-in-frame (binding-variable b1) f2)))
                        (if b2
                            (equal? (binding-value b1) (binding-value b2))
                            #t)))
           f1))
  (define (merge-compatible-frames f1 f2)
    (let go ((bindings f1)
             (merged-frame f2))
         (if (null? bindings)
             merged-frame
             (let* ((b (car bindings))
                    (variable (binding-variable b))
                    (value (binding-value b)))
                   (go (cdr bindings)
                       (if (binding-in-frame variable merged-frame)
                           merged-frame
                           (extend-frame variable value merged-frame)))))))
  (define (merge-compatible-frame-streams fs1 fs2)
    (stream-map
      (lambda (fp)
              (merge-compatible-frames (car fp) (cdr fp)))
      (stream-filter
        (lambda (fp)
                (compatible-frames? (car fp) (cdr fp)))
        (stream-flatmap
          (lambda (f1)
                  (stream-map
                    (lambda (f2)
                            (cons f1 f2))
                    fs2))
          fs1))))
  (cond ((empty-conjunction? conjuncts)
         frame-stream)
        ((empty-conjunction? (rest-conjuncts conjuncts))
         (qeval (first-conjunct conjuncts) frame-stream))
        (else
          (let* ((c1 (first-conjunct conjuncts))
                 (c2 (first-conjunct (rest-conjuncts conjuncts)))
                 (crest (rest-conjuncts (rest-conjuncts conjuncts)))
                 (fs1 (qeval c1 frame-stream))
                 (fs2 (qeval c2 frame-stream)))
                (conjoin crest (merge-compatible-frame-streams fs1 fs2))))))

(put 'and 'qeval conjoin)
