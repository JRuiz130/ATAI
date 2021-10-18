Homework 2: Jason
Lea Wölfl, Xabier Arriaga & Jon Ander Ruiz

In this readme file our changes in the code are described.
Task 1)
a) randomly scattering garbage: for this we made changes in the constructor of the MarsModel class. Instead on placing
the garbage on fixed positions we produce 3 garbage instances with randomly generated coordinates.
            int x, y;
			for(int i = 0; i <= 3; i++){
				x = rand.nextInt(6);
				y = rand.nextInt(6);
				add(GARB, x, y);
			}

b) randomly placing incinerator with r2: this change is also done in the MarsModel constructor by generating random
numbers for the coordinates.
                x = rand.nextInt(6);
				y = rand.nextInt(6);
				Location r2Loc = new Location(x, y);
				setAgPos(1, r2Loc);

c) randomly placing r1 on the grid: again this is done in the constructor
                x = rand.nextInt(6);
				y = rand.nextInt(6);
				Location r1Loc = new Location(x, y);
				setAgPos(0, r1Loc);

Task 2)
modify agent r2 so sometimes it fails while trying to burn the garbage: for this we made some changes in the method burnGarb().
we generate a random boolean and then let agent r2 fail sometimes, but a maximum of 2 times in a row (just like r1).
We also print a message to know when they are failing.
                if (random.nextBoolean() || nerr == MErr) {
					System.out.println("Succesfully burnt the garbage");
                    remove(GARB, getAgPos(1));
                    nerr = 0;
                } else {
					System.out.println("I failed burning the garbage!");
                    nerr++;
                }
In order to let the agent r2 try again after trying to burn the garbage ones and failing we also added new behaviour
to the r2.asl file. By this we ensure that at one point the garbage really is burnt.
    +!ensure_burn(S) : garbage(r2)
       <- burn(garb);
          !ensure_burn(S).
    +!ensure_burn(_).


Task 3)
Modifying agent r1s path:
a) scan top-down instead of left-right: for this we changed the method nextSlot(). The changes are just in the adjustment
of the x and y coordinates so the robot moves one place down on each step (or to the next column on top of the grid).

b) scanning continuously:
in order to scan continuously we send the agent r1 to the top left corner of the grid and start there again.
            Location r1 = getAgPos(0);

			r1.y++;
            if (r1.y == getHeight()) {
                r1.y = 0;
                r1.x++;
            }
            // finished searching the whole grid
            if (r1.x == getWidth()) {
                //for continuosly searching
				setAgPos(0, 0, 0);
				return;
            }

            setAgPos(0, r1);


Task 4)
Include a new agent r3 that moves and produces garbage randomly:
We created a new agent r3 by adding it in the jedit environment. In the super() method of the MarsModel constructor
we then changed the number of agents to 3 instead of 2.
Also in the constructor we set the first position of r3 randomly on the grid. In the method nextSlot() we added code
such that r3 is teleporting randomly around the grid. In the same method we also added logic so r3 places garbage.
Therefore we generate random numbers and for one number we let r3 produce a piece of garbage on its current position.
            //R3 putting garbage
			int prob = rand.nextInt(4);
			if(prob == 0){
				System.out.println("R3: Putting garbage");
				add(GARB, x, y);
			}

Task 5)
For our task we added a new agent r4 that is moving around and sometimes picks up garbage, moves it somewhere else and
drops it again.
R4 is scanning the surface horizontally. When r4 finds garbage, if it has not already picked up garbage, it picks it up.
Then it keeps moving in the same direction and for each square of the grid it has a 20% probability to drop it.
When the agent drops the garbage, this drops one square behind r4, so we had to be careful with the agents position.
In case the agent is not on the left wall of the grid, it drops normally, but when the agent is on the wall, the garbage drops
one square up. In case the agent is in the (0, 0) position, it drops the garbage on the other corner of the grid.
As we can see on the following code, r4 has the objective to pick the garbage up and to carry it.
+garbage(r4) : not .desire(take(garb,R))
   <- !take(garb,R).

+!take(S,L) : true
   <- pickalt(garb).

We also created a new function pickGarbAlt which is very similar to pickGarb, but only affects r4 and it does not have any
probability to not pick the garbage.

void pickGarbAlt() {
    // r4 location has garbage
    if (model.hasObject(GARB, getAgPos(3)) && (r4HasGarb == false)) {
          remove(GARB, getAgPos(3));
          r4HasGarb = true;
          System.out.println("I, R4, succesfully picked up the garbage!");
    }
}
