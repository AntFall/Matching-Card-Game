#lang htdp/isl+
(require racket/list)

(define LIST (list 0 0 0 1))
(append (list (last LIST)) (drop-right LIST 1))
(take-right LIST (sub1 (length LIST)))