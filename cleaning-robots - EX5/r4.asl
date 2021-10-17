// mars robot 4

/* Initial beliefs */

at(P) :- pos(P,X,Y) & pos(r4,X,Y).

/* Initial goal */

!check(slots).

/* Plans */

+!check(slots) : not garbage(r4)
   <- 
      !check(slots).
+!check(slots).


@lg[atomic]
+garbage(r4) : not .desire(take(garb,R))
   <- !take(garb,R).

+!take(S,L) : true
   <- pickalt(garb).



