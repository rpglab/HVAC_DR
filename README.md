## Quantification of Demand Response provided by Heating, Ventilation, and Air Conditioning (HVAC)
This is a set of Matlab codes that simulates the building internal temperature profile and load profile when HVAC is functioning to maintain the set temperature. This program also calculates the demand response potential for each time interval of pre-specified length, e.g. 5, 10 and 15mins. 

The main program is *SimulationStart.m*. Symbolic Math Toolbox is required to run this program.


### Input files:
1. *InitializationStructure.txt* - Contains all basic parameters required by the program with "\n" as delimiter. Parameters are explained below:

		1. Number_of_houses
		2. ThermalResistanceUpperLimit
		3. ThermalResistanceLowerLimit
		4. KW_ratings_of_HVAC
		5. Temp_deadband
		6. InternalTemperatureUpperLimit 
		7. InternalTemperatureLowerLimit
		8. HeatRateUpperLimit
		9. HeatRateLowerLimit 
		10. HeatOutRateUpperLimit
		11. HeatOutRateLowerLimit
		12. AirHeatUpperLimit
		13. AirHeatLowerLimit
		14. TempSetUpperLimit
		15. TempSetLowerLimit
		16. simulationTimeinMin
		17. DRstarttime

		 
2. *TemperatureOfTheDay.txt* (Temperature of the day) - Contains the 'Tout' or the ambient/air temperature (in Fahrenheit or F) outside of the room/house. 
                            The file should contain (Hours_needed_to_simulate * 60) lines of temperature values.
							The temporal resolution of the input temperature data is a MINUTE.
                            For example: if the temperature for the first hour is 80F, then the 1st 60 lines of the file will have "80". Likewise it should be filled for every hour for the program to function properly.

Note: All input files must be in the same folder with the matlab codes.


### Program flow:
 1. Starts From "SimulationStart.m" file
           - Performs basic parameters reading from input files
           - Transfers control to "TemperatureInitializationMode.m"
		   
 2. In "TemperatureInitializationMode.m"
           - Calculates the maximum support times that HVACs are capable of.
           - Calculates Temperature profile and load profile for the whole simulation period/day
           - Calculates normalized load values for every time resolution specified (e.g., 5,10,15mins) 
           - Calculates Demand Response potential for every time resolution specified (e.g., 5,10,15mins) 
           - Returns control to "SimulationStart.m" file
		   
3. In "SimulationStart.m" file
           - Stores the simulated values in variable "msg"
           - Also display the run time for whole simulation in variable "timeE"
           - In a Intel i7, 16GB Ram computer, the program had runtime of 10mins for simulating 100 houses and 1 simulation period (30 minutes).
		   
4. "msg" Profile includes all the simulation results in 10 cells
	   -cell (1,1): House parameter details; HVAC on/off status; House temperature;
	   -cell (1,2): HVAC demand response available time for each HVAC system;
	   -cell (1,3): Load Profile
	   -cell (1,4): Load Profile at a 5 minutes time interval;
	   -cell (1,5): Total HVAC demand response available time and availble status for 5 minutes for each time period;


Note:
Conditionalfunctions.m file
           - It is utility class 
SampleTest.m file
           - This class contains all the chart functions but they are not part of the whole program. They must be run individually with different input variable
           - This also has input utility function for filling Tout data if 24 temperature values are present for whole day .


## Citation:
If you use these codes for your work, please cite the following paper:

<a class="off" href="/papers/Praveen-CunzhiZhao-ISGT-TCL-DR-MG/" target="_blank">Praveen Dhanasekar, Cunzhi Zhao and Xingpeng Li, "Quantitative Analysis of Demand Response Using Thermostatically Controlled Loads", *IEEE PES Innovative Smart Grid Technology*, New Orleans, LA, USA, Apr. 2022.</a>


## Contributions:
This program was initially created by Praveen Dhanasekar, and then modified and cleaned up by Cunzhi Zhao.


## Contact:
If you need any techinical support, please feel free to reach out to <a class="" href="/people/Cunzhi-Zhao/">Cunzhi Zhao</a> at czhao20@uh.edu or <a class="" href="/people/Praveen-Dhanasekar/">Praveen Dhanasekar</a> at praveendhanasekar07@gmail.com.

For collaboration, please contact <a class="" href="/people/Xingpeng-Li/">Dr. Xingpeng Li</a>.

Website: <a class="off" href="/"  target="_blank">https://rpglab.github.io/</a>


## License:
This work is licensed under the terms of the <a class="off" href="https://creativecommons.org/licenses/by/4.0/"  target="_blank">Creative Commons Attribution 4.0 (CC BY 4.0) license.</a>


## Disclaimer:
The author doesn’t make any warranty for the accuracy, completeness, or usefulness of any information disclosed; and the author assumes no liability or responsibility for any errors or omissions for the information (data/code/results etc) disclosed.

