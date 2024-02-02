#lang htdp/asl
(require 2htdp/abstraction)
(require 2htdp/image)
(require 2htdp/universe)
(require racket/list)

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

(define CARD-LENGTH 100)

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
(define WORLD4 (make-world MT-LOC '() '()))

;;; Universe
;; A univ is a structure: (make-univ (ListOf iworld) world)
(define-struct univ (iws game))
;; Sample univs
(define INIT-UNIV (make-univ '() (make-world LOC1
                                             (list (make-player "Computer" '() #f))
                                             '())))
(define UNIV1 (make-univ (list iworld1 iworld2) (make-world LOC1
                                                            (list (make-player "Computer" '() #f)
                                                                  (make-player "iworld1" (list RED BLUE) #t)
                                                                  (make-player "iworld2" (list GREEN YELLOW) #f))
                                                            (list 12))))
(define UNIV2 (make-univ (list iworld2 iworld3) (make-world LOC2
                                                            (list (make-player "Computer" '() #f)
                                                                  (make-player "iworld2" (list RED ORANGE) #t)
                                                                  (make-player "iworld3" (list GREEN YELLOW) #f))
                                                            (list 31 4))))
(define UNIV3 (make-univ (list iworld3 iworld1) (make-world LOC3
                                                            (list (make-player "Computer" '() #f)
                                                                  (make-player "iworld1" (list RED BLUE) #t)
                                                                  (make-player "iworld3" (list CYAN YELLOW) #f))
                                                            '())))
                                                            

;;; Marshalling
;; A marshalled player (mp) is a (list string loc boolean)
;; A marshalled player (mw) is a (list loc lop lon)
#| ;; Sample instances of mp
(define MP1 . . .) . . .
;; Sample expressions for f-on-mp
(define MP1-VAL . . .) . . .
;; mp . . . → . . .
;; Purpose:
(define (f-on-mp an-mp . . .)
  (local [(define name (first an-mp))
          (define LOC (second an-mp))
          (define is-turn? (third an-mp))]
    . . .))
;; Tests using sample computations for f-on-mp
(check-expect (f-on-mp MP1 . . .) MP1-VAL) . . .
;; Tests using sample values for f-on-mp
(check-expect (f-on-mp . . . . . .) . . .)  |#

#| ;; Sample instances of mw
(define MW1 . . .) . . .
;; Sample expressions for f-on-mw
(define MW1-VAL . . .) . . .
;; mw . . . → . . .
;; Purpose:
(define (f-on-mw an-mw . . .)
  (local [(define loc (first an-mw))
          (define lop (second an-mw))
          (define revealed-cards (third an-mw))]
    . . .))
;; Tests using sample computations for f-on-mw
(check-expect (f-on-mw MW1 . . .) MW1-VAL) . . .
;; Tests using sample values for f-on-mw
(check-expect (f-on-mw . . . . . .) . . .)  |#

;;; TSM
;; A to-player message (tpm) is: (cons 'world mw)
#| tpm . . . → . . .
   Purpose:
(define (f-on-tpm a-tpm . . .)
  (. . .(f-on-mw (rest a-tpm) . . .). . .))
Sample instances of tpm
(define A-TPM (cons 'world . . .))
Sample expressions for f-on-tpm
(define A-TPM-VAL (f-on-mw (rest A-TPM) . . .))
Tests using sample for computations for f-on-mw
(check-expect (f-on-tpm A-TPM . . .) A-TPM-VAL) . . .
Tests using sample for values for f-on-mw
(check-expect (f-on-tpm . . . . . .) . . .) . . . |#
;; Sample instances of tpm


;;; TSM
;; A to-server message (tsm) is (list 'click number)
#| tsm . . . → . . .
   Purpose:
(define (f-on-tsm a-tsm . . .)
  (. . .(f-on-mw (rest a-tsm) . . .). . .))
Sample instances of tsm
(define A-tsm (cons 'world . . .))
Sample expressions for f-on-tsm
(define A-tsm-VAL (f-on-mw (rest A-tsm) . . .))
Tests using sample for computations for f-on-mw
(check-expect (f-on-tsm A-tsm . . .) A-tsm-VAL) . . .
Tests using sample for values for f-on-mw
(check-expect (f-on-tsm . . . . . .) . . .) . . . |#
;; Sample instances of tsm
;                                                                                                                                      
;                                                                                                                                      
;                                                                                                                                      
;                                                                                                                                      
;                                                    ;;                       ;;;;        ;;;;          ;                              
;  ;;;     ;;;                                        ;                          ;           ;          ;                              
;   ;;     ;;                                         ;                          ;           ;                                         
;   ; ;   ; ;                                         ;                          ;           ;                                         
;   ; ;   ; ;      ;;;;;      ;;  ;;;     ;;;;; ;     ; ;;;        ;;;;;         ;           ;       ;;;;        ;; ;;;        ;;; ;;  
;   ; ;   ; ;     ;     ;      ; ;   ;   ;     ;;     ;;   ;      ;     ;        ;           ;          ;         ;;   ;      ;   ;;   
;   ;  ; ;  ;           ;      ;;        ;      ;     ;     ;           ;        ;           ;          ;         ;     ;    ;     ;   
;   ;  ; ;  ;           ;      ;          ;;;;;       ;     ;           ;        ;           ;          ;         ;     ;    ;     ;   
;   ;   ;   ;      ;;;;;;      ;               ;      ;     ;      ;;;;;;        ;           ;          ;         ;     ;    ;     ;   
;   ;       ;     ;     ;      ;                ;     ;     ;     ;     ;        ;           ;          ;         ;     ;    ;     ;   
;   ;       ;    ;      ;      ;         ;      ;     ;     ;    ;      ;        ;           ;          ;         ;     ;    ;     ;   
;   ;       ;    ;     ;;      ;         ;;    ;      ;     ;    ;     ;;        ;           ;          ;         ;     ;     ;   ;;   
;  ;;;     ;;;    ;;;;; ;;    ;;;;;;     ; ;;;;      ;;;   ;;;    ;;;;; ;;   ;;;;;;;;;   ;;;;;;;;;  ;;;;;;;;;    ;;;   ;;;     ;;; ;   
;                                                                                                                                  ;   
;                                                                                                                                  ;   
;                                                                                                                                 ;    
;                                                                                                                             ;;;;     
;                                                                                                                                      
;;; Player
;; player -> mp
;; Purpose: To marshall the given world
(define (marshall-player a-player)
  (list (player-name a-player)
        (player-loc a-player)
        (player-is-turn? a-player)))

;; Sample expressions
(define M-PLAYER1 (list (player-name PLAYER1)
                        (player-loc PLAYER1)
                        (player-is-turn? PLAYER1)))
(define M-PLAYER2 (list (player-name PLAYER2)
                        (player-loc PLAYER2)
                        (player-is-turn? PLAYER2)))
(define M-PLAYER3 (list (player-name PLAYER3)
                        (player-loc PLAYER3)
                        (player-is-turn? PLAYER3)))

;; Tests using sample computations for marshall-player
(check-expect (marshall-player PLAYER1) M-PLAYER1)
(check-expect (marshall-player PLAYER2) M-PLAYER2)
(check-expect (marshall-player PLAYER3) M-PLAYER3)
;; Tests using sample values for marshall-player
(check-expect (marshall-player (make-player "Matt" (list RED BLUE YELLOW) #t)) (list "Matt" (list RED BLUE YELLOW) #t))
(check-expect (marshall-player (make-player "Chris" (list ORANGE) #f)) (list "Chris" (list ORANGE) #f))

;;; World
;; world -> mw
;; Purpose: To marshall the given world
(define (marshall-world a-world)
  (list (world-loc a-world)
        (map marshall-player (world-lop a-world))
        (world-revealed-cards a-world)))

;; Sample expressions for marshall world
(define M-WORLD1 (list (world-loc WORLD1)
                       (map marshall-player (world-lop WORLD1))
                       (world-revealed-cards WORLD1)))
(define M-WORLD2 (list (world-loc WORLD2)
                       (map marshall-player (world-lop WORLD2))
                       (world-revealed-cards WORLD2)))
(define M-WORLD3 (list (world-loc WORLD3)
                       (map marshall-player (world-lop WORLD3))
                       (world-revealed-cards WORLD3)))

;; Tests using sample computation for marshall-world
(check-expect (marshall-world WORLD1) M-WORLD1)
(check-expect (marshall-world WORLD2) M-WORLD2)
(check-expect (marshall-world WORLD3) M-WORLD3)
;; Tests using sample values for marshall-world
(check-expect (marshall-world (make-world (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                                                "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                                                "red" "chocolate" "yellow" "purple" "dark green" "orange"
                                                "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                                                "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                                                "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                                          (list (make-player "Computer" (list RED) #t)
                                                (make-player "Teo" (list BLUE YELLOW GREEN) #f))
                                          '(12 34 0)))
              (list (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                          "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                          "red" "chocolate" "yellow" "purple" "dark green" "orange"
                          "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                          "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                          "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                    (list (list "Computer" (list RED) #t)
                          (list "Teo" (list BLUE YELLOW GREEN) #f))
                    (list 12 34 0)))
(check-expect (marshall-world (make-world (list "green" "chocolate" "green" "none" "none" "dark magenta"
                                                "dark green" "royal blue" "brown" "powder blue" "red" "none"
                                                "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                                                "none" "none" "none" "dark green" "powder blue" "deep pink"
                                                "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                                                "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                                          (list (make-player "Alex" (list GREEN ORANGE) #t)
                                                (make-player "Computer" '() #f)
                                                (make-player "Joe" (list RED) #f))
                                          '()))
              (list (list "green" "chocolate" "green" "none" "none" "dark magenta"
                          "dark green" "royal blue" "brown" "powder blue" "red" "none"
                          "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                          "none" "none" "none" "dark green" "powder blue" "deep pink"
                          "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                          "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                    (list (list "Alex" (list GREEN ORANGE) #t)
                          (list "Computer" '() #f)
                          (list "Joe" (list RED) #f))
                    '()))

;                                                                                                                                                              
;                                                                                                                                                              
;                                                                                                                                                              
;                                                                                                                                                              
;                                                                            ;;                       ;;;;        ;;;;          ;                              
;   ;;;    ;;;                                                                ;                          ;           ;          ;                              
;    ;      ;                                                                 ;                          ;           ;                                         
;    ;      ;                                                                 ;                          ;           ;                                         
;    ;      ;    ;; ;;;     ;; ;;  ;;      ;;;;;      ;;  ;;;     ;;;;; ;     ; ;;;        ;;;;;         ;           ;       ;;;;        ;; ;;;        ;;; ;;  
;    ;      ;     ;;   ;     ;;  ;;  ;    ;     ;      ; ;   ;   ;     ;;     ;;   ;      ;     ;        ;           ;          ;         ;;   ;      ;   ;;   
;    ;      ;     ;     ;    ;   ;   ;          ;      ;;        ;      ;     ;     ;           ;        ;           ;          ;         ;     ;    ;     ;   
;    ;      ;     ;     ;    ;   ;   ;          ;      ;          ;;;;;       ;     ;           ;        ;           ;          ;         ;     ;    ;     ;   
;    ;      ;     ;     ;    ;   ;   ;     ;;;;;;      ;               ;      ;     ;      ;;;;;;        ;           ;          ;         ;     ;    ;     ;   
;    ;      ;     ;     ;    ;   ;   ;    ;     ;      ;                ;     ;     ;     ;     ;        ;           ;          ;         ;     ;    ;     ;   
;    ;      ;     ;     ;    ;   ;   ;   ;      ;      ;         ;      ;     ;     ;    ;      ;        ;           ;          ;         ;     ;    ;     ;   
;     ;    ;      ;     ;    ;   ;   ;   ;     ;;      ;         ;;    ;      ;     ;    ;     ;;        ;           ;          ;         ;     ;     ;   ;;   
;      ;;;;      ;;;   ;;;  ;;;  ;;  ;;   ;;;;; ;;    ;;;;;;     ; ;;;;      ;;;   ;;;    ;;;;; ;;   ;;;;;;;;;   ;;;;;;;;;  ;;;;;;;;;    ;;;   ;;;     ;;; ;   
;                                                                                                                                                          ;   
;                                                                                                                                                          ;   
;                                                                                                                                                         ;    
;                                                                                                                                                     ;;;;     
;                                                                                                                                                              
;;; Player
;; mp -> player
;; Purpose: To unmarshall the given mp
(define (unmarshall-player a-mp)
  (make-player (first a-mp)
               (second a-mp)
               (third a-mp)))

;; Sample expressions for unmarshall-player
(define UM-M-PLAYER1 (make-player (first M-PLAYER1)
                                  (second M-PLAYER1)
                                  (third M-PLAYER1)))
(define UM-M-PLAYER2 (make-player (first M-PLAYER2)
                                  (second M-PLAYER2)
                                  (third M-PLAYER2)))
(define UM-M-PLAYER3 (make-player (first M-PLAYER3)
                                  (second M-PLAYER3)
                                  (third M-PLAYER3)))

;; Tests using sample computations for unmarshall-player
(check-expect (unmarshall-player M-PLAYER1) UM-M-PLAYER1)
(check-expect (unmarshall-player M-PLAYER2) UM-M-PLAYER2)
(check-expect (unmarshall-player M-PLAYER3) UM-M-PLAYER3)
;; Tests using sample values for unmarshall-player
(check-expect (unmarshall-player (list "Matt" (list RED BLUE YELLOW) #t))
              (make-player "Matt" (list RED BLUE YELLOW) #t))
(check-expect (unmarshall-player (list "Chris" (list ORANGE) #f))
              (make-player "Chris" (list ORANGE) #f))

;;; World
;; mw -> world
;; Purpose: To unmarshall the given mw
(define (unmarshall-world a-mw)
  (make-world (first a-mw)
              (map unmarshall-player (second a-mw))
              (third a-mw)))

;; Sample expressions for unmarshall-world
(define UM-M-WORLD1 (make-world (first M-WORLD1)
                                (map unmarshall-player (second M-WORLD1))
                                (third M-WORLD1)))
(define UM-M-WORLD2 (make-world (first M-WORLD2)
                                (map unmarshall-player (second M-WORLD2))
                                (third M-WORLD2)))
(define UM-M-WORLD3 (make-world (first M-WORLD3)
                                (map unmarshall-player (second M-WORLD3))
                                (third M-WORLD3)))

;; Tests using sample computations for unmarshall-world
(check-expect (unmarshall-world M-WORLD1) UM-M-WORLD1)
(check-expect (unmarshall-world M-WORLD2) UM-M-WORLD2)
(check-expect (unmarshall-world M-WORLD3) UM-M-WORLD3)
;; Tests using sample values for marshall-world
(check-expect (unmarshall-world (list (list "green" "chocolate" "green" "none" "none" "dark magenta"
                                            "dark green" "royal blue" "brown" "powder blue" "red" "none"
                                            "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                                            "none" "none" "none" "dark green" "powder blue" "deep pink"
                                            "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                                            "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                                      (list (list "Alex" (list GREEN ORANGE) #t)
                                            (list "Computer" '() #f)
                                            (list "Joe" (list RED) #f))
                                      '()))
              (make-world (list "green" "chocolate" "green" "none" "none" "dark magenta"
                                "dark green" "royal blue" "brown" "powder blue" "red" "none"
                                "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                                "none" "none" "none" "dark green" "powder blue" "deep pink"
                                "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                                "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                          (list (make-player "Alex" (list GREEN ORANGE) #t)
                                (make-player "Computer" '() #f)
                                (make-player "Joe" (list RED) #f))
                          '()))
(check-expect (unmarshall-world (list (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                                            "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                                            "red" "chocolate" "yellow" "purple" "dark green" "orange"
                                            "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                                            "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                                            "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                                      (list (list "Computer" (list RED) #t)
                                            (list "Teo" (list BLUE YELLOW GREEN) #f))
                                      (list 12 34 0)))
              (make-world (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                                "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                                "red" "chocolate" "yellow" "purple" "dark green" "orange"
                                "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                                "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                                "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                          (list (make-player "Computer" (list RED) #t)
                                (make-player "Teo" (list BLUE YELLOW GREEN) #f))
                          '(12 34 0)))


;                                                                                                                
;                                                                                                                
;                                                                                                                
;                                                                                                                
;                    ;;         ;;                          ;;;;                                                 
;                     ;          ;                             ;                                                 
;                     ;          ;                             ;                                                 
;     ;;;;       ;;;; ;     ;;;; ;              ;; ;;;;        ;        ;;;;    ;;;;   ;;;;   ;;;;      ;;  ;;;  
;    ;    ;     ;    ;;    ;    ;;               ;;    ;       ;       ;    ;     ;     ;    ;    ;      ; ;   ; 
;          ;   ;      ;   ;      ;               ;      ;      ;             ;    ;     ;   ;      ;     ;;      
;          ;   ;      ;   ;      ;   ;;;;;;;;    ;      ;      ;             ;    ;    ;    ;      ;     ;       
;    ;;;;;;;   ;      ;   ;      ;               ;      ;      ;       ;;;;;;;     ;   ;    ;;;;;;;;     ;       
;   ;      ;   ;      ;   ;      ;               ;      ;      ;      ;      ;     ;  ;     ;            ;       
;   ;      ;   ;      ;   ;      ;               ;      ;      ;      ;      ;      ; ;     ;            ;       
;   ;     ;;    ;    ;;    ;    ;;               ;;    ;       ;      ;     ;;      ;;       ;     ;     ;       
;    ;;;;; ;;    ;;;; ;;    ;;;; ;;              ; ;;;;    ;;;;;;;;;   ;;;;; ;;      ;        ;;;;;     ;;;;;;   
;                                                ;                                   ;                           
;                                                ;                                  ;                            
;                                                ;                                  ;                            
;                                               ;;;                              ;;;;;                           
;                                                                                                                
;; universe iworld -> bundle
;; Purpose: To add new players to the game. If a player with a name already used
;; attempts to join, they are denied
(define (add-player a-univ an-iw)
  (if (member? (iworld-name an-iw) (map iworld-name (univ-iws a-univ)))
      (make-bundle a-univ '() (list an-iw))
      (local [(define new-iws (cons an-iw (univ-iws a-univ)))
              (define game (univ-game a-univ))
              (define new-game (make-world (world-loc game)
                                           (append (world-lop game) (list (make-player (iworld-name an-iw)
                                                                                       '()
                                                                                       (if (equal? (length (world-lop game)) 1)
                                                                                           #t
                                                                                           #f))))
                                           (world-revealed-cards game)))]
        (make-bundle (make-univ new-iws new-game)
                     (map (lambda (iw) (make-mail iw (list 'world
                                                           (marshall-world new-game))))
                          new-iws)
                     '()))))

;; Sample expressions for add-player
(define NEW-ADD (local [(define new-iws (cons iworld3 (univ-iws UNIV1)))
                        (define game (univ-game UNIV1))
                        (define new-game (make-world (world-loc game)
                                                     (append (world-lop game) (list (make-player (iworld-name iworld3)
                                                                                                 '()
                                                                                                 #f)))
                                                     (world-revealed-cards game)))]
                  (make-bundle (make-univ new-iws new-game)
                               (map (lambda (iw) (make-mail iw (list 'world
                                                                     (marshall-world new-game))))
                                    new-iws)
                               '())))
(define RPT-ADD (make-bundle UNIV2 '() (list iworld2)))

;; Tests using sample computations for add-player
(check-expect (add-player UNIV1 iworld3) NEW-ADD)
(check-expect (add-player UNIV2 iworld2) RPT-ADD)
;; Tests using sample values for add-player
(check-expect (add-player (make-univ (list iworld1) (make-world LOC1 (list (make-player (iworld-name iworld1)
                                                                                        (list RED BLUE)
                                                                                        #t)) '()))
                          iworld2)
              (make-bundle (make-univ (list iworld2 iworld1) (make-world LOC1 (list (make-player (iworld-name iworld1)
                                                                                                 (list RED BLUE)
                                                                                                 #t)
                                                                                    (make-player (iworld-name iworld2)
                                                                                                 '()
                                                                                                 #t))
                                                                         '()))
                           (list (make-mail iworld2 (list 'world (marshall-world (make-world LOC1 (list (make-player (iworld-name iworld1)
                                                                                                                     (list RED BLUE)
                                                                                                                     #t)
                                                                                                        (make-player (iworld-name iworld2)
                                                                                                                     '()
                                                                                                                     #t))
                                                                                             '()))))
                                 (make-mail iworld1 (list 'world (marshall-world (make-world LOC1 (list (make-player (iworld-name iworld1)
                                                                                                                     (list RED BLUE)
                                                                                                                     #t)
                                                                                                        (make-player (iworld-name iworld2)
                                                                                                                     '()
                                                                                                                     #t))
                                                                                             '())))))
                           '()))
(check-expect (add-player (make-univ (list iworld1 iworld2) (make-world (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                                                                              NONE NONE RED NONE POWDERBLUE DARKGREEN
                                                                              POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                                                                              CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                                                                              NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                                                                              PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE)
                                                                        (list (make-player "iworld1" '() #t)
                                                                              (make-player "Computer" '() #f)
                                                                              (make-player "iworld2" '() #f))
                                                                        '())) iworld1)
              (make-bundle (make-univ (list iworld1 iworld2) (make-world (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                                                                               NONE NONE RED NONE POWDERBLUE DARKGREEN
                                                                               POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                                                                               CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                                                                               NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                                                                               PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE)
                                                                         (list (make-player "iworld1" '() #t)
                                                                               (make-player "Computer" '() #f)
                                                                               (make-player "iworld2" '() #f))
                                                                         '()))
                           '() (list iworld1)))

;                                                                                                                                                 
;                                                                                                                                                 
;                                                                                                                                                 
;                                                                                                                                                 
;                                                                                            ;;;;                                                 
;                                                                                               ;                                                 
;                                                                                               ;                                                 
;    ;;  ;;;     ;;;;    ;; ;;  ;;     ;;;;;   ;;;;   ;;;;   ;;;;                ;; ;;;;        ;        ;;;;    ;;;;   ;;;;   ;;;;      ;;  ;;;  
;     ; ;   ;   ;    ;    ;;  ;;  ;   ;     ;    ;     ;    ;    ;                ;;    ;       ;       ;    ;     ;     ;    ;    ;      ; ;   ; 
;     ;;       ;      ;   ;   ;   ;  ;       ;   ;     ;   ;      ;               ;      ;      ;             ;    ;     ;   ;      ;     ;;      
;     ;        ;      ;   ;   ;   ;  ;       ;    ;   ;    ;      ;   ;;;;;;;;    ;      ;      ;             ;    ;    ;    ;      ;     ;       
;     ;        ;;;;;;;;   ;   ;   ;  ;       ;    ;   ;    ;;;;;;;;               ;      ;      ;       ;;;;;;;     ;   ;    ;;;;;;;;     ;       
;     ;        ;          ;   ;   ;  ;       ;     ; ;     ;                      ;      ;      ;      ;      ;     ;  ;     ;            ;       
;     ;        ;          ;   ;   ;  ;       ;     ; ;     ;                      ;      ;      ;      ;      ;      ; ;     ;            ;       
;     ;         ;     ;   ;   ;   ;   ;     ;       ;       ;     ;               ;;    ;       ;      ;     ;;      ;;       ;     ;     ;       
;    ;;;;;;      ;;;;;   ;;;  ;;  ;;   ;;;;;        ;        ;;;;;                ; ;;;;    ;;;;;;;;;   ;;;;; ;;      ;        ;;;;;     ;;;;;;   
;                                                                                 ;                                   ;                           
;                                                                                 ;                                  ;                            
;                                                                                 ;                                  ;                            
;                                                                                ;;;                              ;;;;;                           
;                                                                                                                                                 
;; universe iworld -> bundle
;; Purpose: To remove the given iworld from the list of players
(define (remove-player a-univ an-iw)
  (local [(define game (univ-game a-univ))
          (define new-univ (make-univ
                            (filter (lambda (iw) (not (string=? (iworld-name iw)
                                                                (iworld-name an-iw))))
                                    (univ-iws a-univ))
                            (make-world (world-loc game)
                                        (filter (lambda (a-player) (not (eq? (iworld-name an-iw)
                                                                             (player-name a-player))))
                                                (world-lop game))
                                        (world-revealed-cards game))))]
    (make-bundle new-univ
                 (map (lambda (iw) (make-mail iw
                                              (list 'world (marshall-world game))))
                      (univ-iws a-univ))
                 (list an-iw))))

;; Sample expressions for remove-player
(define IW1-RMV (local [(define game (univ-game UNIV1))
                        (define new-univ (make-univ
                                          (filter (lambda (iw) (not (string=? (iworld-name iw)
                                                                              (iworld-name iworld1))))
                                                  (univ-iws UNIV1))
                                          (make-world (world-loc game)
                                                      (filter (lambda (a-player) (not (eq? (iworld-name iworld1)
                                                                                           (player-name a-player))))
                                                              (world-lop game))
                                                      (world-revealed-cards game))))]
                  (make-bundle new-univ
                               (map (lambda (iw) (make-mail iw
                                                            (list 'world (marshall-world game))))
                                    (univ-iws UNIV1))
                               (list iworld1))))

;; Tests using sample computations for remove-player
(check-expect (remove-player UNIV1 iworld1) IW1-RMV)
;; Tests using sample values for remove-player
(check-expect (remove-player (make-univ (list iworld2 iworld3)
                                        (make-world LOC2 (list (make-player "iworld3" (list ORANGE YELLOW PURPLE) #f))
                                                    '()))
                             iworld2)
              (make-bundle (make-univ (list iworld3) (make-world LOC2
                                                                 (list (make-player "iworld3" (list ORANGE YELLOW PURPLE) #f))
                                                                 '()))
                           (list (make-mail iworld2 (list 'world (marshall-world (make-world LOC2 (list (make-player "iworld3" (list ORANGE YELLOW PURPLE) #f))
                                                                                             '()))))
                                 (make-mail iworld3 (list 'world (marshall-world (make-world LOC2 (list (make-player "iworld3" (list ORANGE YELLOW PURPLE) #f))
                                                                                             '())))))
                           (list iworld2)))

;                                                                                                                                                                       
;                                                                                                                                                                       
;                                                                                                                                                                       
;                                                                                                                                                                       
;                                                                                                                                                                       
;                                                                                                                                                                       
;                                                                                                                                                                       
;   ;; ;;;;     ;;  ;;;     ;;;;;       ;;;; ;    ;;;;       ;;;; ;     ;;;; ;             ;; ;;  ;;     ;;;;       ;;;; ;     ;;;; ;     ;;;;       ;;;; ;;    ;;;;    
;    ;;    ;     ; ;   ;   ;     ;     ;    ;;   ;    ;     ;    ;;    ;    ;;              ;;  ;;  ;   ;    ;     ;    ;;    ;    ;;    ;    ;     ;    ;;    ;    ;   
;    ;      ;    ;;       ;       ;   ;      ;  ;      ;    ;          ;                    ;   ;   ;  ;      ;    ;          ;                ;   ;      ;   ;      ;  
;    ;      ;    ;        ;       ;   ;         ;      ;     ;;;;       ;;;;     ;;;;;;;;   ;   ;   ;  ;      ;     ;;;;       ;;;;            ;   ;      ;   ;      ;  
;    ;      ;    ;        ;       ;   ;         ;;;;;;;;         ;          ;               ;   ;   ;  ;;;;;;;;         ;          ;     ;;;;;;;   ;      ;   ;;;;;;;;  
;    ;      ;    ;        ;       ;   ;         ;                 ;          ;              ;   ;   ;  ;                 ;          ;   ;      ;   ;      ;   ;         
;    ;      ;    ;        ;       ;   ;         ;           ;     ;    ;     ;              ;   ;   ;  ;           ;     ;    ;     ;   ;      ;   ;      ;   ;         
;    ;;    ;     ;         ;     ;     ;     ;   ;     ;    ;;   ;     ;;   ;               ;   ;   ;   ;     ;    ;;   ;     ;;   ;    ;     ;;    ;    ;;    ;     ;  
;    ; ;;;;     ;;;;;;      ;;;;;       ;;;;;     ;;;;;     ; ;;;      ; ;;;               ;;;  ;;  ;;   ;;;;;     ; ;;;      ; ;;;      ;;;;; ;;    ;;;; ;     ;;;;;   
;    ;                                                                                                                                                    ;             
;    ;                                                                                                                                                    ;             
;    ;                                                                                                                                                   ;              
;   ;;;                                                                                                                                              ;;;;               
;                                                                                                                                                                       
;; universe iworld tsm -> bundle
;; Purpose: To process the given tsm message
(define (process-message a-univ an-iw a-tsm)
  (local [(define index (second a-tsm))
          (define game (univ-game a-univ))
          (define loc (world-loc game))
          (define lop (world-lop game))
          (define revealed-cards (world-revealed-cards game))
          (define new-revealed-cards (if (and (not (equal? (list-ref loc index) NONE))
                                              (< (length revealed-cards) 2)
                                              (if (> (length revealed-cards) 0)
                                                  (not (equal? index (first revealed-cards)))
                                                  #t))
                                         (cons index revealed-cards)
                                         revealed-cards))
          (define new-loc (if (and (equal? (length new-revealed-cards) 2)
                                   (equal? (list-ref loc (first new-revealed-cards))
                                           (list-ref loc (second new-revealed-cards))))
                              (map (lambda (a-color) (if (equal? (list-ref loc index)
                                                                 a-color)
                                                         NONE
                                                         a-color)) loc)
                              loc))

          (define new-lop (if (not (equal? loc new-loc))
                              (map (lambda (a-player) (if (player-is-turn? a-player)
                                                          (make-player (player-name a-player)
                                                                       (append (player-loc a-player) (list (list-ref loc index)))
                                                                       (player-is-turn? a-player))
                                                          a-player)) lop)
                              lop))

          (define new-new-lop (if (equal? (length new-revealed-cards) 2)
                                  (local [(define BINARY-LOT (map (lambda (a-player) (if (player-is-turn? a-player) 
                                                                                         1
                                                                                         0)) new-lop))
                                          (define NEW-BINARY-LOT (if (or (<= (length BINARY-LOT) 1) (equal? (list-ref loc (first new-revealed-cards))
                                                                                                            (list-ref loc (second new-revealed-cards))))
                                                                     BINARY-LOT
                                                                     (append (list (last BINARY-LOT)) (drop-right BINARY-LOT 1))))]
                                    (for/list ([bin-val NEW-BINARY-LOT][a-player new-lop])
                                      (if (equal? bin-val 1)
                                          (make-player (player-name a-player)
                                                       (player-loc a-player)
                                                       #t)
                                          (make-player (player-name a-player)
                                                       (player-loc a-player)
                                                       #f))))
                                  new-lop))
          (define new-game (make-world new-loc new-new-lop new-revealed-cards))]
    (if (or (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) (iworld-name an-iw))) (world-lop game))))
            (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) "Computer")) (world-lop game)))))
        (make-bundle (make-univ (univ-iws a-univ) new-game)
                     (map (lambda (iw) (make-mail iw (list 'world (marshall-world new-game)))) (univ-iws a-univ))
                     '())
        (make-bundle a-univ '() '()))))

;; Sample expressions for process-message
(define MT-REVCARD (local [(define index (second (list 'click 12)))
                           (define game (univ-game UNIV3))
                           (define loc (world-loc game))
                           (define lop (world-lop game))
                           (define revealed-cards (world-revealed-cards game))
                           (define new-revealed-cards (if (and (not (equal? (list-ref loc index) NONE))
                                                               (< (length revealed-cards) 2)
                                                               (if (> (length revealed-cards) 0)
                                                                   (not (equal? index (first revealed-cards)))
                                                                   #t))
                                                          (cons index revealed-cards)
                                                          revealed-cards))
                           (define new-loc (if (and (equal? (length new-revealed-cards) 2)
                                                    (equal? (list-ref loc (first new-revealed-cards))
                                                            (list-ref loc (second new-revealed-cards))))
                                               (map (lambda (a-color) (if (equal? (list-ref loc index)
                                                                                  a-color)
                                                                          NONE
                                                                          a-color)) loc)
                                               loc))

                           (define new-lop (if (not (equal? loc new-loc))
                                               (map (lambda (a-player) (if (player-is-turn? a-player)
                                                                           (make-player (player-name a-player)
                                                                                        (append (player-loc a-player) (list (list-ref loc index)))
                                                                                        (player-is-turn? a-player))
                                                                           a-player)) lop)
                                               lop))

                           (define new-new-lop (if (equal? (length new-revealed-cards) 2)
                                                   (local [(define BINARY-LOT (map (lambda (a-player) (if (player-is-turn? a-player) 
                                                                                                          1
                                                                                                          0)) new-lop))
                                                           (define NEW-BINARY-LOT (if (or (<= (length BINARY-LOT) 1) (equal? (list-ref loc (first new-revealed-cards))
                                                                                                                             (list-ref loc (second new-revealed-cards))))
                                                                                      BINARY-LOT
                                                                                      (append (list (last BINARY-LOT)) (drop-right BINARY-LOT 1))))]
                                                     (for/list ([bin-val NEW-BINARY-LOT][a-player new-lop])
                                                       (if (equal? bin-val 1)
                                                           (make-player (player-name a-player)
                                                                        (player-loc a-player)
                                                                        #t)
                                                           (make-player (player-name a-player)
                                                                        (player-loc a-player)
                                                                        #f))))
                                                   new-lop))
                           (define new-game (make-world new-loc new-new-lop new-revealed-cards))]
                     (if (or (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) (iworld-name iworld3))) (world-lop game))))
                             (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) "Computer")) (world-lop game)))))
                         (make-bundle (make-univ (univ-iws UNIV3) new-game)
                                      (map (lambda (iw) (make-mail iw (list 'world (marshall-world new-game)))) (univ-iws UNIV3))
                                      '())
                         (make-bundle UNIV3 '() '()))))
(define 1REVCARD (local [(define index (second (list 'click 34)))
                         (define game (univ-game UNIV1))
                         (define loc (world-loc game))
                         (define lop (world-lop game))
                         (define revealed-cards (world-revealed-cards game))
                         (define new-revealed-cards (if (and (not (equal? (list-ref loc index) NONE))
                                                             (< (length revealed-cards) 2)
                                                             (if (> (length revealed-cards) 0)
                                                                 (not (equal? index (first revealed-cards)))
                                                                 #t))
                                                        (cons index revealed-cards)
                                                        revealed-cards))
                         (define new-loc (if (and (equal? (length new-revealed-cards) 2)
                                                  (equal? (list-ref loc (first new-revealed-cards))
                                                          (list-ref loc (second new-revealed-cards))))
                                             (map (lambda (a-color) (if (equal? (list-ref loc index)
                                                                                a-color)
                                                                        NONE
                                                                        a-color)) loc)
                                             loc))

                         (define new-lop (if (not (equal? loc new-loc))
                                             (map (lambda (a-player) (if (player-is-turn? a-player)
                                                                         (make-player (player-name a-player)
                                                                                      (append (player-loc a-player) (list (list-ref loc index)))
                                                                                      (player-is-turn? a-player))
                                                                         a-player)) lop)
                                             lop))

                         (define new-new-lop (if (equal? (length new-revealed-cards) 2)
                                                 (local [(define BINARY-LOT (map (lambda (a-player) (if (player-is-turn? a-player) 
                                                                                                        1
                                                                                                        0)) new-lop))
                                                         (define NEW-BINARY-LOT (if (or (<= (length BINARY-LOT) 1) (equal? (list-ref loc (first new-revealed-cards))
                                                                                                                           (list-ref loc (second new-revealed-cards))))
                                                                                    BINARY-LOT
                                                                                    (append (list (last BINARY-LOT)) (drop-right BINARY-LOT 1))))]
                                                   (for/list ([bin-val NEW-BINARY-LOT][a-player new-lop])
                                                     (if (equal? bin-val 1)
                                                         (make-player (player-name a-player)
                                                                      (player-loc a-player)
                                                                      #t)
                                                         (make-player (player-name a-player)
                                                                      (player-loc a-player)
                                                                      #f))))
                                                 new-lop))
                         (define new-game (make-world new-loc new-new-lop new-revealed-cards))]
                   (if (or (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) (iworld-name iworld1))) (world-lop game))))
                           (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) "Computer")) (world-lop game)))))
                       (make-bundle (make-univ (univ-iws UNIV1) new-game)
                                    (map (lambda (iw) (make-mail iw (list 'world (marshall-world new-game)))) (univ-iws UNIV1))
                                    '())
                       (make-bundle UNIV1 '() '()))))
(define 2REVCARD (local [(define index (second (list 'click 27)))
                         (define game (univ-game UNIV2))
                         (define loc (world-loc game))
                         (define lop (world-lop game))
                         (define revealed-cards (world-revealed-cards game))
                         (define new-revealed-cards (if (and (not (equal? (list-ref loc index) NONE))
                                                             (< (length revealed-cards) 2)
                                                             (if (> (length revealed-cards) 0)
                                                                 (not (equal? index (first revealed-cards)))
                                                                 #t))
                                                        (cons index revealed-cards)
                                                        revealed-cards))
                         (define new-loc (if (and (equal? (length new-revealed-cards) 2)
                                                  (equal? (list-ref loc (first new-revealed-cards))
                                                          (list-ref loc (second new-revealed-cards))))
                                             (map (lambda (a-color) (if (equal? (list-ref loc index)
                                                                                a-color)
                                                                        NONE
                                                                        a-color)) loc)
                                             loc))

                         (define new-lop (if (not (equal? loc new-loc))
                                             (map (lambda (a-player) (if (player-is-turn? a-player)
                                                                         (make-player (player-name a-player)
                                                                                      (append (player-loc a-player) (list (list-ref loc index)))
                                                                                      (player-is-turn? a-player))
                                                                         a-player)) lop)
                                             lop))

                         (define new-new-lop (if (equal? (length new-revealed-cards) 2)
                                                 (local [(define BINARY-LOT (map (lambda (a-player) (if (player-is-turn? a-player) 
                                                                                                        1
                                                                                                        0)) new-lop))
                                                         (define NEW-BINARY-LOT (if (or (<= (length BINARY-LOT) 1) (equal? (list-ref loc (first new-revealed-cards))
                                                                                                                           (list-ref loc (second new-revealed-cards))))
                                                                                    BINARY-LOT
                                                                                    (append (list (last BINARY-LOT)) (drop-right BINARY-LOT 1))))]
                                                   (for/list ([bin-val NEW-BINARY-LOT][a-player new-lop])
                                                     (if (equal? bin-val 1)
                                                         (make-player (player-name a-player)
                                                                      (player-loc a-player)
                                                                      #t)
                                                         (make-player (player-name a-player)
                                                                      (player-loc a-player)
                                                                      #f))))
                                                 new-lop))
                         (define new-game (make-world new-loc new-new-lop new-revealed-cards))]
                   (if (or (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) (iworld-name iworld2))) (world-lop game))))
                           (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) "Computer")) (world-lop game)))))
                       (make-bundle (make-univ (univ-iws UNIV2) new-game)
                                    (map (lambda (iw) (make-mail iw (list 'world (marshall-world new-game)))) (univ-iws UNIV2))
                                    '())
                       (make-bundle UNIV2 '() '()))))
;; Tests using sample computations for process-message
(check-expect (process-message UNIV3 iworld3 (list 'click 12)) MT-REVCARD)
(check-expect (process-message UNIV1 iworld1 (list 'click 34)) 1REVCARD)
(check-expect (process-message UNIV2 iworld2 (list 'click 27)) 2REVCARD)
;; Tests using sample values for process-message
(check-expect (process-message (make-univ (list iworld1) (make-world (list "green" "chocolate" "green" "none" "none" "dark magenta"
                                                                           "dark green" "royal blue" "brown" "powder blue" "red" "none"
                                                                           "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                                                                           "none" "none" "none" "dark green" "powder blue" "deep pink"
                                                                           "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                                                                           "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                                                                     (list (make-player "Computer" '() #f)
                                                                           (make-player "iworld1" (list RED) #t))
                                                                     '()))
                               iworld1
                               (list 'click 2))
              (make-bundle (make-univ (list iworld1) (make-world (list "green" "chocolate" "green" "none" "none" "dark magenta"
                                                                       "dark green" "royal blue" "brown" "powder blue" "red" "none"
                                                                       "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                                                                       "none" "none" "none" "dark green" "powder blue" "deep pink"
                                                                       "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                                                                       "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                                                                 (list (make-player "Computer" '() #f)
                                                                       (make-player "iworld1" (list RED) #t))
                                                                 '(2)))
                           (list (make-mail iworld1 (list 'world (marshall-world (make-world (list "green" "chocolate" "green" "none" "none" "dark magenta"
                                                                                                   "dark green" "royal blue" "brown" "powder blue" "red" "none"
                                                                                                   "blue" "none" "purple" "chocolate" "dark magenta" "blue"
                                                                                                   "none" "none" "none" "dark green" "powder blue" "deep pink"
                                                                                                   "dark khaki" "cyan" "purple" "cyan" "none" "brown"
                                                                                                   "none" "red" "royal blue" "none" "dark khaki" "deep pink")
                                                                                             (list (make-player "Computer" '() #f)
                                                                                                   (make-player "iworld1" (list RED) #t))
                                                                                             '(2))))))
                           '()))
(check-expect (process-message (make-univ (list iworld2) (make-world (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                                                                           "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                                                                           "red" "chocolate" "yellow" "purple" "dark green" "orange"
                                                                           "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                                                                           "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                                                                           "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                                                                     (list (make-player "Computer" (list RED) #f)
                                                                           (make-player "iworld2" (list BLUE YELLOW GREEN) #t))
                                                                     '(12 14)))
                               iworld2
                               (list 'click 34))
              (make-bundle (make-univ (list iworld2) (make-world (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                                                                       "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                                                                       "red" "chocolate" "yellow" "purple" "dark green" "orange"
                                                                       "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                                                                       "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                                                                       "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                                                                 (list (make-player "Computer" (list RED) #t)
                                                                       (make-player "iworld2" (list BLUE YELLOW GREEN) #f))
                                                                 '(12 14)))
                           (list (make-mail iworld2 (list 'world (marshall-world (make-world (list "dark olive green" "red" "gold" "deep pink" "blue" "green"
                                                                                                   "cyan" "dark red" "royal blue" "dark green" "gold" "cyan"
                                                                                                   "red" "chocolate" "yellow" "purple" "dark green" "orange"
                                                                                                   "purple" "blue" "yellow" "brown" "dark khaki" "orange"
                                                                                                   "powder blue" "dark khaki" "dark magenta" "powder blue" "deep pink" "dark olive green"
                                                                                                   "chocolate" "green" "dark red" "dark magenta" "brown" "royal blue")
                                                                                             (list (make-player "Computer" (list RED) #t)
                                                                                                   (make-player "iworld2" (list BLUE YELLOW GREEN) #f))
                                                                                             '(12 14))))))
                           '()))

;                                                                                                                                                  
;                                                                                                                                                  
;                                                                                                                                                  
;                                                                                                                                                  
;                                                                                                                   ;                    ;;        
;                                                                                                      ;            ;                     ;        
;                                                                                                      ;                                  ;        
;                                                                                                      ;                                  ;        
;   ;;  ;;;;      ;;  ;;;      ;;;;;       ;;;;; ;     ;;;;       ;;;;; ;     ;;;;; ;                ;;;;;;;;    ;;;;          ;;;;; ;    ;   ;;;; 
;    ; ;    ;      ; ;   ;    ;     ;     ;     ;;    ;    ;     ;     ;;    ;     ;;                  ;            ;         ;     ;;    ;    ;   
;    ;;      ;     ;;        ;       ;   ;       ;   ;      ;    ;      ;    ;      ;                  ;            ;        ;       ;    ;  ;;    
;    ;       ;     ;         ;       ;   ;           ;      ;     ;;;;;       ;;;;;      ;;;;;;;;      ;            ;        ;            ; ;      
;    ;       ;     ;         ;       ;   ;           ;;;;;;;;          ;           ;                   ;            ;        ;            ;;;      
;    ;       ;     ;         ;       ;   ;           ;                  ;           ;                  ;            ;        ;            ;  ;     
;    ;;      ;     ;         ;       ;   ;       ;   ;           ;      ;    ;      ;                  ;            ;        ;       ;    ;   ;    
;    ; ;    ;      ;          ;     ;     ;     ;     ;     ;    ;;    ;     ;;    ;                   ;    ;;      ;         ;     ;     ;    ;   
;    ;  ;;;;      ;;;;;;       ;;;;;       ;;;;;       ;;;;;     ; ;;;;      ; ;;;;                     ;;;;    ;;;;;;;;;      ;;;;;     ;;   ;;;; 
;    ;                                                                                                                                             
;    ;                                                                                                                                             
;    ;                                                                                                                                             
;   ;;;                                                                                                                                            
;                                                                                                                                                  
;; universe -> bundle
;; Purpose: To check if two cards are revealed. If so sleep for 3 seconds then send a bundle with these removed.
;; Also responsible for making the moves for the computer player.
(define (process-tick a-univ)
  (local [(define game (univ-game a-univ))
          (define new-game (if (equal? (length (world-revealed-cards game)) 2)
                               (make-world (world-loc game)
                                           (world-lop game)
                                           '())
                               game))]
    (if (and (player-is-turn? (first (filter (lambda (a-player) (equal? (player-name a-player) "Computer")) (world-lop game))))
             (< (length (world-revealed-cards game)) 2))
        (process-message a-univ (first (univ-iws a-univ)) (list 'click (random 36)))
        (if (and (equal? (length (world-revealed-cards game)) 2)
                 (not (equal? (list-ref (world-loc game) (first (world-revealed-cards game)))
                              (list-ref (world-loc game) (second (world-revealed-cards game))))))
            (if (equal? (sleep 3) (void))
                (make-bundle (make-univ (univ-iws a-univ) new-game)
                             (map (lambda (iw) (make-mail iw (list 'world (marshall-world new-game)))) (univ-iws a-univ))
                             '())
                (+ 1 1)) ;; Dummy Expression. (sleep x) always equals void.
            (make-bundle (make-univ (univ-iws a-univ) new-game)
                         (map (lambda (iw) (make-mail iw (list 'world (marshall-world new-game)))) (univ-iws a-univ))
                         '())))))
;; Sample expressions for process-tick
(define COMPUTER-MOVE (process-message (make-univ (list iworld1 iworld2) (make-world LOC2 (list (make-player "Computer" '() #t)
                                                                                                (make-player "iworld1" '() #f))
                                                                                     '(1)))
                                       iworld1 (list 'click (random 36))))

(define RESET-REVEALED-CARDS (make-bundle (make-univ (univ-iws UNIV2) (make-world (world-loc (univ-game UNIV2))
                                                                                  (world-lop (univ-game UNIV2))
                                                                                  '()))
                                          (map (lambda (iw) (make-mail iw (list 'world (marshall-world (make-world (world-loc (univ-game UNIV2))
                                                                                                                   (world-lop (univ-game UNIV2))
                                                                                                                   '())))))
                                               (univ-iws UNIV2))
                                          '()))
(define NO-CHANGE (make-bundle UNIV1
                               (list (make-mail iworld1 (list 'world (marshall-world (univ-game UNIV1))))
                                     (make-mail iworld2 (list 'world (marshall-world (univ-game UNIV1)))))
                               '()))
;; Tests using sample computations for process-tick
(check-random (process-tick (make-univ (list iworld1 iworld2) (make-world LOC2 (list (make-player "Computer" '() #t)
                                                                                     (make-player "iworld1" '() #f))
                                                                          '(1))))
              (process-message (make-univ (list iworld1 iworld2) (make-world LOC2 (list (make-player "Computer" '() #t)
                                                                                        (make-player "iworld1" '() #f))
                                                                             '(1)))
                               iworld1 (list 'click (random 36)))) ;; Same as COMPUTER-MOVE. Need full expression to properly use check-random.
                                                                   ;; Note too that process-message will return a bundle
(check-expect (process-tick UNIV2) RESET-REVEALED-CARDS)
(check-expect (process-tick UNIV1) NO-CHANGE)
;; Tests using sample values for process-tick
(check-random (process-tick (make-univ (list iworld1) (make-world (list GREEN DARKKHAKI PURPLE RED CYAN DEEPPINK
                                                                        RED GOLD BLUE DARKRED CHOCOLATE DARKKHAKI
                                                                        DARKGREEN DEEPPINK BLUE YELLOW DARKOLIVEGREEN BROWN
                                                                        CHOCOLATE ORANGE PURPLE GREEN POWDERBLUE DARKMAGENTA
                                                                        DARKOLIVEGREEN BROWN POWDERBLUE DARKRED ORANGE DARKGREEN
                                                                        ROYALBLUE CYAN GOLD DARKMAGENTA ROYALBLUE YELLOW)
                                                                  (list (make-player "Computer" '() #t)
                                                                        (make-player "iworld1" '() #f))
                                                                  '(2))))
              (process-message (make-univ (list iworld1) (make-world (list GREEN DARKKHAKI PURPLE RED CYAN DEEPPINK
                                                                           RED GOLD BLUE DARKRED CHOCOLATE DARKKHAKI
                                                                           DARKGREEN DEEPPINK BLUE YELLOW DARKOLIVEGREEN BROWN
                                                                           CHOCOLATE ORANGE PURPLE GREEN POWDERBLUE DARKMAGENTA
                                                                           DARKOLIVEGREEN BROWN POWDERBLUE DARKRED ORANGE DARKGREEN
                                                                           ROYALBLUE CYAN GOLD DARKMAGENTA ROYALBLUE YELLOW)
                                                                     (list (make-player "Computer" '() #t)
                                                                           (make-player "iworld1" '() #f))
                                                                     '(2)))
                               iworld1
                               (list 'click (random 36))))
(check-expect (process-tick (make-univ (list iworld2 iworld3) (make-world (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                                                                                NONE NONE RED NONE POWDERBLUE DARKGREEN
                                                                                POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                                                                                CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                                                                                NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                                                                                PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE)
                                                                          (list (make-player "Computer" (list ORANGE) #f)
                                                                                (make-player "iworld2" (list PURPLE) #t)
                                                                                (make-player "iworld3" '() #f))
                                                                          '(2 30))))
              (make-bundle (make-univ (list iworld2 iworld3) (make-world (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                                                                               NONE NONE RED NONE POWDERBLUE DARKGREEN
                                                                               POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                                                                               CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                                                                               NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                                                                               PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE)
                                                                         (list (make-player "Computer" (list ORANGE) #f)
                                                                               (make-player "iworld2" (list PURPLE) #t)
                                                                               (make-player "iworld3" '() #f))
                                                                         '()))
                           (list (make-mail iworld2 (list 'world (marshall-world (make-world (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                                                                                                   NONE NONE RED NONE POWDERBLUE DARKGREEN
                                                                                                   POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                                                                                                   CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                                                                                                   NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                                                                                                   PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE)
                                                                                             (list (make-player "Computer" (list ORANGE) #f)
                                                                                                   (make-player "iworld2" (list PURPLE) #t)
                                                                                                   (make-player "iworld3" '() #f))
                                                                                             '()))))
                                 (make-mail iworld3 (list 'world (marshall-world (make-world (list DEEPPINK GREEN NONE PURPLE NONE ROYALBLUE
                                                                                                   NONE NONE RED NONE POWDERBLUE DARKGREEN
                                                                                                   POWDERBLUE DARKKHAKI NONE BROWN CHOCOLATE DARKKHAKI
                                                                                                   CYAN ROYALBLUE CYAN NONE DARKMAGENTA NONE
                                                                                                   NONE DARKMAGENTA BLUE NONE DARKGREEN RED
                                                                                                   PURPLE BROWN DEEPPINK GREEN CHOCOLATE BLUE)
                                                                                             (list (make-player "Computer" (list ORANGE) #f)
                                                                                                   (make-player "iworld2" (list PURPLE) #t)
                                                                                                   (make-player "iworld3" '() #f))
                                                                                             '())))))
                           '()))
                                                                        
;                                   
;                                   
;                                   
;                                   
;                                   
;                                   
;                                   
;    ;;  ;;;   ;;    ;;   ;; ;;;    
;     ; ;   ;   ;     ;    ;;   ;   
;     ;;        ;     ;    ;     ;  
;     ;         ;     ;    ;     ;  
;     ;         ;     ;    ;     ;  
;     ;         ;     ;    ;     ;  
;     ;         ;     ;    ;     ;  
;     ;         ;    ;;    ;     ;  
;    ;;;;;;      ;;;; ;;  ;;;   ;;; 
;                                   
;                                   
;                                   
;                                   
;                                   
;; string or symbol -> universe
;; Purpose: To run the server with the given name
(define (run a-name)
  (universe INIT-UNIV
            (on-new add-player)
            (on-disconnect remove-player)
            (on-msg process-message)
            (on-tick process-tick)))

(run "Concentration")