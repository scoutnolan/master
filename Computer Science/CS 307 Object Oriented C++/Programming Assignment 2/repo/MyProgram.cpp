// ****************************************
// Program Title: Project2
// Project File: MyProgram.cpp
// Name: Nolan Anderson
// Course: CS-307
// Due Date: 04/25/2021
// ****************************************
#include "Simulation.h"
#include <iostream>

int main(int argc, char* argv[])
{
	Simulation mySim; 							// Instantiate Simulation object
	mySim.initializeSimulation();				// Call Simulation::initializeSimulation
	mySim.runSimulation(mySim.getClockMult());	// Call Simulation::runSimulation
}
