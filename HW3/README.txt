By Lea Wölfl, Xabier Arriaga & Jon Ander Ruiz
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

3.-
The new agent: jasonAgent_AXIS_CRAZY_SUPPORT follows the crazy agent of the previous exercises. To make this possible,
the crazy agent sends its location with a goto command.
The new agent receives this message and goes to the position:

//code on jasonAgent_AXIS_CRAZY.
//The crazy agent tells its position to the others so they can follow him
.my_team("AXIS", E); //Get all the Axis members
//.println("Crazy team: ", E);
?my_position(AX, AY, AZ); //Store the position here so it updates with each iteration
.concat("goto(", AX, ", ", AY, ", ", AZ, ")", Content1); //store the message content. Message is a goto to the crazy agent position
.send_msg_with_conversation_id(E, tell, Content1, "INT"); //Send the message
.println("Crazy agent: message sent: ", Content1);

//code on jasonAgent_AXIS_CRAZY_SUPPORT:
//When the Crazy supporter receives his teamates coordinates, it goes there
+goto(X,Y,Z)[source(T)]
  <-
  .println("Received the goto message from my Crazy Teammate. On my way", T);
  !add_task(task("TASK_GOTO_POSITION", T, pos(X, Y, Z), ""));
  -+state(standing);
  -goto(_,_,_).

4.-
Implement an ALLIED agent that locates the “crazy” agent and kills him. The “crazy” agent can defend himself.
For this, the crazy Axis soldier sends his position to the Allied team. The Allied Crazy Assassin listens this communication
and then goes to find and kill him. As soon as he kills the crazy soldier, he changes its focus and goes to take the flag and return it
to the base.

//code on jasonAgent_AXIS_CRAZY
//The crazy agent tells its position to the other team so they can end him
.my_team("ALLIED", A); //Get all the Allied members
.send_msg_with_conversation_id(A, tell, Content1, "INT"); //Send the message
.println("Crazy agent: message sent to allies ", Content1);

//code on jasonAgent_ALLIED_CRAZY_ASSASSIN
//When the Crazy assasin receives crazy's coordinates, it goes there
+goto(X,Y,Z)[source(T)]
  <-
  .println("Received the goto message from my Crazy objetive. On my way", T);
  !add_task(task("TASK_GOTO_POSITION", T, pos(X, Y, Z), ""));
  -+state(standing);
  -goto(_,_,_).

5.-
New task of our choice.
We decided to make a tower-like defender for the axis team. Its function is to stay in its place and wait for the enemies.
As he finds his enemies, he focuses his aim on them and kills them.
