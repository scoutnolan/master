// ****************************************
// Program Title: Project2
// Project File: Simulation.cpp
// Name: Nolan Anderson
// Course: CS-307
// Due Date: 04/25/2021
// ****************************************
#pragma warning(disable : 4996)

#include "Simulation.h"

Simulation::Simulation()
{
}

Simulation::~Simulation()
{
}

void Simulation::initializeSimulation()
{
	printf("==============================================================\n");
	printf("|          AIRLINE FLIGHT SIMULATION DEMONSTRATION           |\n");
	printf("|            CS 307 -- Programming Assignment 1              |\n");
	printf("==============================================================\n");
	printf("\nPlease enter the name of the simulation data file\n");
	getline(cin, inputFile);
	char* inFileCharArray = &inputFile[0];
	ifstream userInFile(inFileCharArray);
	string cityFile, flightFile;
	char myCityFile[32];
	char myFlightFile[32];

	if (!userInFile)
	{
		cout << "Error opening file: " << inputFile << endl;
		cout << "Terminating program" << endl;
		exit(1);
	}
	else
	{
		cout << "Successfully opened file " << inputFile << endl;
		getline(userInFile, cityFile);
		getline(userInFile, flightFile);
		cout << "Opened City file " << cityFile << "..." << endl;
		cout << "Opened Airline/Flight file " << flightFile << "..." << endl;

		string temp1 = "../" + cityFile;
		string temp2 = "../" + flightFile;
		strcpy(myCityFile, temp1.c_str());
		strcpy(myFlightFile, temp2.c_str());

		cout << "Starting the simulation." << endl;
	}
	printf("\nWhat speed do you want to run the simulation? (1, 2, or 3)\n");
	cin >> clockMult;
	if (clockMult > 3 || clockMult < 1)
	{
		cout << "Error!! Invalid simulation speed" << endl;
		cout << "Exiting program now..." << endl;
		exit(2);
	}

	// Start with default values
	testCity = new City();
	testFlight = new Flight();
	testAircraft = new Aircraft();

	// Then read in the data
	testCity->readData(myCityFile);
	testFlight->readData(myFlightFile);
	testAircraft->readData(myFlightFile);

	// Get start time
	CurrentHr = testFlight->getStartHr();
	CurrentMin = testFlight->getStartMin();
	PrintStartTime();
}

void Simulation::runSimulation(double clocktime)
{
	_ftime_s(&tStruct);
	thisTime = tStruct.time + (((double)(tStruct.millitm)) / 1000.0); 
	outputTime = thisTime + 1.0 / clocktime; 
	vector<Flight> InAir;
	bool finished = false;
	int pos = 0;
	while (!finished) 
	{
		_ftime_s(&tStruct); 
		thisTime = tStruct.time + (((double)(tStruct.millitm)) / 1000.0); 
		if (thisTime >= outputTime)
		{
			CurrentMin += 1;
			Counter += 1;

			vector<Flight> Flights = testFlight->ReturnFlightVector();
			vector<Aircraft> Airplanes = testAircraft->ReturnAircraftList();
			vector<City> Cities = testCity->ReturnCityVector();
			// Increment time.
			if (CurrentMin >= 60)		// Check for minute overflow
			{
				CurrentHr += 1;
				if (CurrentHr == 13)	// Check for hour overflow
				{
					CurrentHr = 1;
				}
				CurrentMin = 0;
			}
			outputTime += 1.0 / clocktime; // Set time for next 1 second interval

			// Output a new flight.
			for (auto& it : Flights)
			{
				int tempHr = it.getDepartHour();
				int tempMin = it.getDepartMin();
				if (CurrentHr == tempHr && CurrentMin == tempMin)	// Find the time
				{
					pos += 1;
					printf("\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
					testFlight->PrintDeparture(*testAircraft, *testCity, it, CurrentHr, CurrentMin);
					PrintCurrentTime();
					printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
					Flight NewInAir(it.getAirline(), it.getAircraftType(), it.getFlightNumber(), it.getDepartCity(), it.getDepartHour(), it.getDepartMin(), it.getArriveCity(), it.getArrMin(), it.getArrHr(), it.getIndex());
					NewInAir.setArrHr(NewInAir.CalcETAHr(it, *testAircraft, *testCity, CurrentHr, CurrentMin));
					NewInAir.setArrMin(NewInAir.CalcETAMin(it, *testAircraft, *testCity, CurrentHr, CurrentMin));
					NewInAir.SetIndex(pos);
					InAir.push_back(NewInAir);
				}
			}

			// Output all current flights.
			if ((Counter % 5) == 0)
			{
				printf("\n\n================================================================\n");
				printf("|  Flight Simulation - Status reports on all flights enroute.  |\n");
				printf("================================================================\n");
				for (auto& all : InAir)
				{
					testFlight->PrintAllData(*testAircraft, *testCity, all, CurrentHr, CurrentMin);
				}
				PrintCurrentTime();
				printf("================================================================\n");
			}

			for (auto &it : InAir)
			{
				if (CurrentHr == it.getArrHr() && CurrentMin == it.getArrMin())
				{
					printf("\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
					testFlight->PrintArrival(*testCity, it, CurrentMin, CurrentHr);
					PrintCurrentTime();
					printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
					InAir.erase(InAir.begin());
					if (InAir.empty())
					{
						cout << endl << endl << "===============================================" << endl;
						cout <<  "Terminating program, all flights have arrived. " << endl;
						cout << "===============================================" << endl;
						finished = true;
					}
				}
			}
			if (CurrentHr == 12)
			{
				cout << endl << endl << "Terminating program, all flights have arrived but not removed from the list. " << endl;
				cout << "Current location and altitude not calculated. " << endl;
				finished = true;
			}
		}
	}
}

void Simulation::PrintCurrentTime()
{
	if (CurrentHr <= 9 && CurrentMin <= 9) { printf("Current clock time: %0d:0%d\n", CurrentHr, CurrentMin); }
	else if (CurrentHr <= 9 && CurrentMin >= 10) { printf("Current clock time: %0d:%d\n", CurrentHr, CurrentMin); }
	else if (CurrentHr >= 10 && CurrentMin <= 9) { printf("Current clock time: %d:0%d\n", CurrentHr, CurrentMin); }
	else if (CurrentHr >= 10 && CurrentMin >= 10) { printf("Current clock time: %d:%d\n", CurrentHr, CurrentMin); }
}

void Simulation::PrintStartTime()
{
	if (CurrentHr <= 9 && CurrentMin <= 9) { printf("*** Starting simulation at 0%d:0%d ***\n", CurrentHr, CurrentMin); }
	else if (CurrentHr <= 9 && CurrentMin >= 10) { printf("*** Starting simulation at 0%d:%d ***\n", CurrentHr, CurrentMin); }
	else if (CurrentHr >= 10 && CurrentMin <= 9) { printf("*** Starting simulation at %d:0%d ***\n", CurrentHr, CurrentMin); }
	else if (CurrentHr >= 10 && CurrentMin >= 10) { printf("*** Starting simulation at %d:%d ***\n", CurrentHr, CurrentMin); }
}


void Simulation::setClockMult(int param)
{
	this->clockMult = param;
}

int Simulation::getClockMult()
{
	return this->clockMult;
}
