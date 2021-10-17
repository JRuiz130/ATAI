
+garbage(r4) : true <- 
					!ensure_burn(s).
					burn(garb).

+!ensure_burn(S) : garbage(r4)
   <- burn(garb);
      !ensure_burn(S).
+!ensure_burn(_).
