classdef conditionalFunctions
    methods (Static)
        function answer=chartfiller(Tset,Tcalculated,baseData)
            db = baseData.Temp_deadband; %= deadband
            if(((Tcalculated < (Tset-(db/2))) || (Tcalculated > (Tset+(db/2)))))
                answer = 'on';
            else
                answer = 'off';
            end
        end
        function chartModified= ColumnYes(chart,baseData)
            for i=1:baseData.Number_of_houses %total number of houses
                chart(i,1) = 'on';
            end
            chartModified= chart;
        end
        
        %Tout from file is fetched through this function
        function Tout= Fetchtemperature()
            fid = fopen('TemperatureOfTheDay.txt');
            C = textscan(fid, '%d');
            Tout= (cell2mat(C)-32)*5/9;
            fclose(fid);
        end
        
        %Builds the house object with the help of base parameters
        function S = InitialHouseParameters(baseData)
            % ------------------------------- R,C,Tout,Q
            AirHeatCapacity= ((baseData.AirHeatUpperLimit - baseData.AirHeatLowerLimit)*rand(baseData.Number_of_houses,1)+ baseData.AirHeatLowerLimit);
            thermalResistances =((baseData.ThermalResistanceUpperLimit - baseData.ThermalResistanceLowerLimit)*rand(baseData.Number_of_houses,1)+ baseData.ThermalResistanceLowerLimit);
           % InternalTemp= (baseData.InternalTemperatureUpperLimit-baseData.InternalTemperatureLowerLimit)*rand(baseData.Number_of_houses,1)+baseData.InternalTemperatureLowerLimit;
            types=(str2double((split(baseData.KW_ratings_of_HVAC,","))));
            numbers=size(types);
            HVACTypes=round((numbers(1,1)-1)*rand(baseData.Number_of_houses,1)+1);
            Qvalue=(baseData.HeatRateUpperLimit-baseData.HeatRateLowerLimit)*rand(baseData.Number_of_houses,1)+baseData.HeatRateLowerLimit;
            QOutValue=(baseData.HeatOutRateUpperLimit-baseData.HeatOutRateLowerLimit)*rand(baseData.Number_of_houses,1)+baseData.HeatOutRateLowerLimit;
            Tset=(baseData.TempSetUpperLimit-baseData.TempSetLowerLimit)*rand(baseData.Number_of_houses,1)+baseData.TempSetLowerLimit;
            S= model.empty(baseData.Number_of_houses,0);
            
            
            for i = 1: baseData.Number_of_houses
                S(i).index= i;
                S(i).Req = thermalResistances(i,1);
                S(i).HVACType=HVACTypes(i,1);
                S(i).PowerH=types(S(i).HVACType,1);
                S(i).PowerL=0;
                S(i).Qvalue=Qvalue(i,1);
                S(i).QOutValue=QOutValue(i,1);
                S(i).deadBand=baseData.Temp_deadband;
                S(i).Tset= Tset(i,1);
                internal = (randi([round(S(i).Tset-(S(i).deadBand/2)) round(S(i).Tset+(S(i).deadBand/2))], 1,1));
                S(i).TinICInitial= internal(1,1); 
                S(i).TinIC= internal(1,1);
                S(i).AirHeatCapacity= AirHeatCapacity(i,1);
                if( S(i).TinIC < S(i).Tset )
                    S(i).Status="off";
                else
                    S(i).Status="on";
                end
            end
            
        end
        
        function OnHouses= returnHouseOnStatus(house)
            
            j=1;
            OnHouses= model.empty(numel(house),0);
            for i =1: numel(house)
                if(strcmp(house(i).Status,"on")==1)
                    OnHouses(j)= house(i);
                    j=j+1;
                end
            end
            
        end
        
        function result= correctHouseParametersAtSpecifiedTime(house, TempAtEvery1min, StatusAtEvery1min ,onHouseArray , TimeToStart)
               for HVAC = 1: numel(house)
                   if(ismember(HVAC,onHouseArray))
                       house(HVAC).TinIC = TempAtEvery1min(HVAC,TimeToStart);
                       house(HVAC).TinICInitial=TempAtEvery1min(HVAC,TimeToStart);
                       house(HVAC).Status= "off";
                       StatusAtEvery1min(HVAC,TimeToStart)="off";
                       house(HVAC).StatusFlipTime = TimeToStart;
                       house(HVAC).StatusPreviousFlipTime=TimeToStart;
                   end
               end
               result={ house,StatusAtEvery1min };
        end
        
        function result= errorRemoval(listA , listB)
            total = numel(listB);
            for i = 1: total
                if(listA(1,i) < listB(1,i))
                    listB(1,i) = listA(1,i);
                end
            end
            
            result= listB;
        end
        
        function result = countOnHouses(StatusAtEvery1min,DRStartTime,tempAtEvery1min, house)
            total= (size(StatusAtEvery1min));count1=0;tempHVAC = zeros(1, total(1));
            for HVAC =1: total(1)
                if(((strcmp(StatusAtEvery1min(HVAC,DRStartTime),"on"))==1) && (tempAtEvery1min(HVAC,DRStartTime) < (house(HVAC).Tset + (house(HVAC).deadBand/2))))
                    count1 = count1+1;
                    tempHVAC(1,count1)= HVAC; 
                end
            end
            HVACs = zeros(1,count1);
            for HVAC= 1:count1
                HVACs(1,HVAC) = tempHVAC(1,HVAC);
            end
            result={count1, HVACs };
        end

        
        function OffHouses= returnHouseOffStatus(house)
            
            j=1;
            OffHouses= model.empty(numel(house),0);
            for i =1: numel(house)
                if(strcmp(house(i).Status,"off")==1)
                    OffHouses(j)= house(i);
                    j=j+1;
                end
            end
            
        end
        function totalLoad = returnTotalONLoad(house)
            totalLoad=0;
            for i = 1: numel(house)
                if(strcmp(house(i).Status,"on")==1)
                totalLoad= totalLoad+house(i).PowerH;
                end
            end
        end
    end
end