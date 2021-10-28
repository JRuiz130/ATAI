1.-
The jasonAgent_ALLIED_RADIOMAN, from now on Radioman, it's in essence a copy of
jasonAgent_ALLIED but with an added debug feature in its get agent to aim
behaviour. This new feature shows, first, the current distance between the radioman and
the flag, and then the distance between the agent and the allied base.

/////ALGORITHM EXPLANATION/////
/*
* We store Radiomans position on X, Y, Z.
* We store the position of the base on BX, BY, BZ (previously we created basePos belief on INIT)
* We store objectives distance on OX, OY, OZ.
* We get the distance to the flag by using !distance function on jgomas.asl and comparing
* the radiomans distance and the objectives distance.
* We print Radiomans position
* If the radioman does not have the flag, We print the distance. Else not.
* We calculate and print the distance to the base the same way we did previously
*/

?debug(Mode); if (Mode<=4) { //used debug mode <=4 not to interfere with other messages
  ?my_position(X, Y, Z);
  //base position
  ?basePos(BX, BY, BZ);
  ?objective(OX, OY, OZ);
  !distance( pos(X, Y, Z), pos(OX, OY, OZ) ); //argument casting to "pos" needed
  ?distance(DistanceToFlag);
  .println("Radioman here! My current position: ", X, ", ",  Y, ", ", Z);
  if(not objectivePackTaken(on)){ //check if the flag is taken
    .println("Distance to the flag: ", DistanceToFlag);
  }
  !distance( pos(X, Y, Z), pos(BX, BY, BZ) ); //argument casting to "pos" needed
  ?distance(DistanceToBase);
  .println("Distance to the base: ", DistanceToBase);
}

2.-
We create a new agent, jasonAgent_AXIS_CRAZY. This crazy agent goes on a random direction between UP, DOWN, LEFT, RIGHT for each
look_response iteration.
We create a random number between 1 and 4. We assign each direction a number.
X = math.random(4);

if(agent_state(standing)){
  if(0<= X & X < 1){
    -agent_state(standing);
    +order(down);
    +agent_state(standing);
  }
  if(1<= X & X < 2){
    -agent_state(standing);
    +order(up);
    +agent_state(standing);
  }
  if(2<= X & X < 3){
    -agent_state(standing);
    +order(left);
    +agent_state(standing);
  }
  if(3<= X & X <= 4){
    -agent_state(standing);
    +order(right);
    +agent_state(standing);
  }
}
