classdef TemperatureInitializationMode
    methods (Static)
        function msg = startTemperatureSimulation(baseData)
            %Create a house model with internal resistances and initial temperature
            %calculated
            %CheckBase Data
            House= conditionalFunctions.InitialHouseParameters(baseData);
            Tout= conditionalFunctions.Fetchtemperature();
            StatusAtEvery1Min= strings(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            TempAtEvery1min=zeros(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            StatusAtEvery1minFor5min= strings(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            TempAtEvery1minFor5min=zeros(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            
            StatusAtEvery1minFor10min= strings(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            TempAtEvery1minFor10min=zeros(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            
            StatusAtEvery1minFor15min= strings(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            TempAtEvery1minFor15min=zeros(baseData.Number_of_houses,(baseData.simulationTimeinMin));
            
            
            
            %To calculate the DR at the start of the time with their set low temperatures and to find the maximum time that they can support.
            loadProfile=zeros(1,baseData.simulationTimeinMin);
            deltaHouses=DemandResponseAtStart.SetTemperatureLow(House, baseData);
            DRatStartHouses = DemandResponseAtStart.Start(deltaHouses, Tout , baseData ,TempAtEvery1min , StatusAtEvery1Min);
            deltaTimeforDRStart= DemandResponseAtStart.deltaTimeCalc(DRatStartHouses{1,2}, 1);
            %To calculate the DR at any specified instant.
            %={ DemandResponseAtSpecifiedTimeHouses,StatusAtEvery1Min,TempAtEvery1min}=
            
            %Simulates Temperatures for whole simulation period(or for a whole day)
            TempDataForWholeDay=DemandResponseAtSpecifiedTime.simulateTemperatureForWholeDay(House,StatusAtEvery1Min ,TempAtEvery1min,baseData,Tout );
            
            %calculates load for every 1min   
            NormalLoadProfile = DemandResponseAtStart.loadProfileCalc(TempDataForWholeDay{1,1},TempDataForWholeDay{1,2} ,loadProfile,baseData);

            
            %1minApproach - DR calculations for different resolutions.
            %The DRResolution: e,g. 5minutes, 10minutes, 15minutes.
            DRSupportFor5Min1minApproach = DemandResponseAtStart.DRForCalc1stMinApproach(TempDataForWholeDay{1,1},TempDataForWholeDay{1,2},TempDataForWholeDay{1,3},Tout,baseData , 1, 5);
            %DRSupportFor10Min1minApproach = DemandResponseAtStart.DRForCalc1stMinApproach(TempDataForWholeDay{1,1},TempDataForWholeDay{1,2},TempDataForWholeDay{1,3},Tout,baseData , 1, 10);
            %DRSupportFor15Min1minApproach = DemandResponseAtStart.DRForCalc1stMinApproach(TempDataForWholeDay{1,1},TempDataForWholeDay{1,2},TempDataForWholeDay{1,3},Tout,baseData , 1, 15);
            
            %HVAC Load values during normal operations for different resolutions 
            NormalLoadCurveFor5min = DemandResponseAtStart.loadProf5min(NormalLoadProfile{1,2});
            %NormalLoadCurveFor10min = DemandResponseAtStart.loadProfXliChangeOne(NormalLoadProfile{1,2},10);
            %NormalLoadCurveFor15min =DemandResponseAtStart.loadProfXliChangeOne(NormalLoadProfile{1,2},15);
            
            
            %result
            msg= { TempDataForWholeDay,  deltaTimeforDRStart,NormalLoadProfile ,NormalLoadCurveFor5min, ...
                   DRSupportFor5Min1minApproach %, DRSupportFor10Min1minApproach ,DRSupportFor15Min1minApproach
            };

        end
    end
end