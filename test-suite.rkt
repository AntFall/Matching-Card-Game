#lang htdp/isl+
(require 2htdp/abstraction)
(require 2htdp/image)
(require 2htdp/universe)
(require racket/list)

(define MYNAME "Brysen")


;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;                                                                                           ;;;;;;      ;                       ;                       ;                                          
;    ;;;;;;;                   ;                                 ;;;;;;;                   ;            ;                       ;          ;            ;                                          
;     ;     ;                  ;                                  ;     ;                  ;                                               ;                                                       
;     ;     ;                  ;                                  ;     ;                  ;                                               ;                                                       
;     ;      ;     ;;;;;     ;;;;;;;;      ;;;;;                  ;      ;     ;;;;      ;;;;;;;     ;;;;        ;; ;;;      ;;;;        ;;;;;;;;    ;;;;          ;;;;;     ;; ;;;       ;;;;; ;  
;     ;      ;    ;     ;      ;          ;     ;                 ;      ;    ;    ;       ;            ;         ;;   ;        ;          ;            ;         ;     ;     ;;   ;     ;     ;;  
;     ;      ;          ;      ;                ;                 ;      ;   ;      ;      ;            ;         ;     ;       ;          ;            ;        ;       ;    ;     ;    ;      ;  
;     ;      ;          ;      ;                ;                 ;      ;   ;      ;      ;            ;         ;     ;       ;          ;            ;        ;       ;    ;     ;     ;;;;;    
;     ;      ;     ;;;;;;      ;           ;;;;;;                 ;      ;   ;;;;;;;;      ;            ;         ;     ;       ;          ;            ;        ;       ;    ;     ;          ;   
;     ;      ;    ;     ;      ;          ;     ;                 ;      ;   ;             ;            ;         ;     ;       ;          ;            ;        ;       ;    ;     ;           ;  
;     ;     ;    ;      ;      ;         ;      ;                 ;     ;    ;             ;            ;         ;     ;       ;          ;            ;        ;       ;    ;     ;    ;      ;  
;     ;     ;    ;     ;;      ;    ;;   ;     ;;                 ;     ;     ;     ;      ;            ;         ;     ;       ;          ;    ;;      ;         ;     ;     ;     ;    ;;    ;   
;    ;;;;;;;      ;;;;; ;;      ;;;;      ;;;;; ;;               ;;;;;;;       ;;;;;     ;;;;;;;    ;;;;;;;;;    ;;;   ;;;  ;;;;;;;;;       ;;;;    ;;;;;;;;;      ;;;;;     ;;;   ;;;   ; ;;;;    
;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;                                                                                                                                                                                                  
;;; Colors
;; A color is one of the following:
(define DARKRED "dark red")
(define RED "red")
(define DEEPPINK "deep pink")
(define CHOCOLATE "chocolate")
(define BROWN "brown")
(define ORANGE "orange")
(define GOLD "gold")
(define YELLOW "yellow")
(define GREEN "green")
(define DARKOLIVEGREEN "dark olive green")
(define DARKGREEN "dark green")
(define CYAN "cyan")
(define ROYALBLUE "royal blue")
(define BLUE "blue")
(define PURPLE "purple")
(define DARKMAGENTA "dark magenta")
(define POWDERBLUE "powder blue")
(define DARKKHAKI "dark khaki")
(define WHITE "white")
(define GREY "grey")
(define BLACK "black")
(define NONE "none")

;; A list of colors, loc, is a (cons color loc)
; Sample loc
(define MT-LOC (list NONE NONE NONE NONE NONE NONE
                     NONE NONE NONE NONE NONE NONE
                     NONE NONE NONE NONE NONE NONE
                     NONE NONE NONE NONE NONE NONE
                     NONE NONE NONE NONE NONE NONE
                     NONE NONE NONE NONE NONE NONE))
(define LOC1 (list DARKRED DARKRED RED RED DEEPPINK DEEPPINK
                   CHOCOLATE CHOCOLATE BROWN BROWN ORANGE ORANGE
                   GOLD GOLD YELLOW YELLOW GREEN GREEN
                   DARKOLIVEGREEN DARKOLIVEGREEN DARKGREEN DARKGREEN CYAN CYAN
                   ROYALBLUE ROYALBLUE BLUE BLUE PURPLE PURPLE
                   DARKMAGENTA DARKMAGENTA POWDERBLUE POWDERBLUE DARKKHAKI DARKKHAKI))
(define LOC2 (list GREEN DARKKHAKI PURPLE RED CYAN DEEPPINK
                   RED GOLD BLUE DARKRED CHOCOLATE DARKKHAKI
                   DARKGREEN DEEPPINK BLUE YELLOW DARKOLIVEGREEN BROWN
                   CHOCOLATE ORANGE PURPLE GREEN POWDERBLUE DARKMAGENTA
                   DARKOLIVEGREEN BROWN POWDERBLUE DARKRED ORANGE DARKGREEN
                   ROYALBLUE CYAN GOLD DARKMAGENTA ROYALBLUE YELLOW))
(define LOC3 (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                   NONE NONE RED NONE POWDERBLUE DARKGREEN
                   POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                   CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                   NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                   PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE))

;; A player is a structure (make-player name loc is-turn?)
(define-struct player (name loc is-turn?))

; Sample Players
(define PLAYER1 (make-player "Brysen" (list RED GREEN BLUE) #f))
(define PLAYER2 (make-player "Richie" (list BLUE) #t))
(define PLAYER3 (make-player "Timmy" (list BROWN YELLOW) #f))

;; A list of players, lop, is one of:
; 1. '()
; 2. (cons player lop)

; Sample lop
(define LOP1 (list PLAYER1 PLAYER2))
(define LOP2 (list PLAYER2 PLAYER3))
(define LOP3 (list PLAYER1 PLAYER3))

;;; World
;; A world is a structure (make-world loc lop lon)
;; where lon is contains the indeces of the cards that are revealed to all players
;; in the current WorldState
(define-struct world (loc lop revealed-cards))

;; Sample worlds
(define INIT-WORLD (make-world (shuffle LOC1) '() '()))
(define WORLD1 (make-world LOC1 LOP1 '(4 22)))
(define WORLD2 (make-world LOC2 LOP2 '(3)))
(define WORLD3 (make-world LOC3 LOP3 '()))

(define (draw-world a-world)
  (local [(define ROW1 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (world-loc a-world) 6)))
                          (define ROW2 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc a-world) 6) 6))) 
                          (define ROW3 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc a-world) 12) 6)))
                          (define ROW4 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc a-world) 18) 6)))
                          (define ROW5 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc a-world) 24) 6)))
                          (define ROW6 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc a-world) 30) 6)))]
                    (above (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW1)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW2)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW3)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW4)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW5)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW6))))

;; Sample expressions for draw-world
(define DW-WORLD1 (local [(define ROW1 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (world-loc WORLD1) 6)))
                          (define ROW2 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD1) 6) 6))) 
                          (define ROW3 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD1) 12) 6)))
                          (define ROW4 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD1) 18) 6)))
                          (define ROW5 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD1) 24) 6)))
                          (define ROW6 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD1) 30) 6)))]
                    (above (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW1)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW2)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW3)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW4)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW5)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW6))))

(define DW-WORLD2 (local [(define ROW1 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (world-loc WORLD2) 6)))
                          (define ROW2 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD2) 6) 6))) 
                          (define ROW3 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD2) 12) 6)))
                          (define ROW4 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD2) 18) 6)))
                          (define ROW5 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD2) 24) 6)))
                          (define ROW6 (map (lambda (a-color) (rectangle 50 50 'solid a-color)) (take (drop (world-loc WORLD2) 30) 6)))]
                    (above (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW1)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW2)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW3)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW4)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW5)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW6))))

(define DW-WORLD3 (local [(define ROW1 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (world-loc WORLD3) 6)))
                          (define ROW2 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc WORLD3) 6) 6))) 
                          (define ROW3 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc WORLD3) 12) 6)))
                          (define ROW4 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc WORLD3) 18) 6)))
                          (define ROW5 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc WORLD3) 24) 6)))
                          (define ROW6 (map (lambda (a-color) (rectangle 50 50 'solid (if (equal? a-color NONE) BLACK a-color))) (take (drop (world-loc WORLD3) 30) 6)))]
                    (above (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW1)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW2)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW3)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW4)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW5)
                           (foldr (lambda (img1 img2) (beside img1 img2)) empty-image ROW6))))

(draw-world WORLD1)
(draw-world WORLD2)
(draw-world WORLD3)
                          
