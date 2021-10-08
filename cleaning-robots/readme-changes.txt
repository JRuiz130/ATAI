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


Task 3)
Modifying agent r1s path:
a) scan top-down instead of left-right:

b) scanning continously:

Task 4)
Include a new agent r3 that moves and produces garbage randomly:


Task 5)
For our task we change the behaviour of r2. It should now also move around, pick up garbage and burn it right away.
R1 has to continue to bring the garbage to r2 in order for the garbage to get burnt.