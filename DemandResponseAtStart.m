classdef DemandResponseAtStart
    methods(Static)
        function out= Start(house,Tout , baseData , TempAtEvery1min ,StatusAtEvery1Min)
            for i=1:numel(house)
                if(strcmp(house(i).Status,"on")==1)
                    house(i).Status = "off";
                end
            end
            test=1;
            for HVAC =1 : numel(house)
                a=1;
                while(1~=0) %baseData.simulationTimeinMin
                    if(a<=baseData.simulationTimeinMin)
                        T=1;
                        if(strcmp(house(HVAC).Status,"on")==1)
                            syms ti(t);
                            ode1 = diff(ti) == (-2/(house(HVAC).Req * house(HVAC).AirHeatCapacity))*ti + (Tout(house(HVAC).StatusFlipTime ,1 ))/(house(HVAC).Req* house(HVAC).AirHeatCapacity) - (house(HVAC).Qvalue/house(HVAC).AirHeatCapacity);
                            cond= ti(0) == house(HVAC).TinIC;
                            u(t) = dsolve(ode1,cond);
                        else
                            syms ti(t);
                            %ode1 = diff(ti) == (-2/(house(HVAC).Req * house(HVAC).AirHeatCapacity))*ti + (Tout(house(HVAC).StatusFlipTime ,1 ))/(house(HVAC).Req* house(HVAC).AirHeatCapacity) + (house(HVAC).Qvalue/house(HVAC).AirHeatCapacity);
                            ode1 = diff(ti) == (-2/(house(HVAC).Req * house(HVAC).AirHeatCapacity))*ti + (Tout(house(HVAC).StatusFlipTime ,1 ))/(house(HVAC).Req* house(HVAC).AirHeatCapacity) + (house(HVAC).QOutValue/house(HVAC).AirHeatCapacity);
                            cond= ti(0) == house(HVAC).TinIC;
                            u(t) = dsolve(ode1,cond);
                        end
                        while (1~=0)
                            TempAtEvery1min(HVAC,a)=u(T);
                            StatusAtEvery1Min(HVAC,a)=house(HVAC).Status;
                            test=test+1;
                            a=a+1;
                            if(a==baseData.simulationTimeinMin)
                                break;
                            end
                            T=T+1;
                            if (a > baseData.simulationTimeinMin)
                                break;
                            end
                            if( (TempAtEvery1min(HVAC,a-1) > (house(HVAC).Tset + (house(HVAC).deadBand/2))))
                                house(HVAC).TinIC = TempAtEvery1min(HVAC,a-1);
                                house(HVAC).Status = "on";
                                house(HVAC).StatusPreviousFlipTime =house(HVAC).StatusFlipTime;
                                house(HVAC).StatusFlipTime=a;
                                break;
                            end
                            if((TempAtEvery1min(HVAC,a-1) < (house(HVAC).Tset - (house(HVAC).deadBand/2))))
                                house(HVAC).TinIC = TempAtEvery1min(HVAC,a-1);
                                house(HVAC).Status = "off";
                                house(HVAC).StatusPreviousFlipTime =house(HVAC).StatusFlipTime;
                                house(HVAC).StatusFlipTime=a;
                                break;
                            end
                            if((Tout(a,1) ~= Tout(a-1,1) ))
                                house(HVAC).TinIC = TempAtEvery1min(HVAC,a-1);
                                break;
                                
                            end
                        end
                    else
                        break;
                    end
                    
                end
                house(HVAC).test = test;
            end
            out={house,StatusAtEvery1Min,TempAtEvery1min};
            
        end
        function loadProfiles= loadProfileCalc(House,StatusAtEvery1Min,loadProfile,baseData)
            totalOnLoad =0;
            for i= 1: numel(House)
                totalOnLoad= totalOnLoad+ House(i).PowerH;
            end
            for TIME=1:(baseData.simulationTimeinMin)
                for HVAC=1:baseData.Number_of_houses
                    if(strcmp(StatusAtEvery1Min(HVAC,TIME),'on')==1)
                        loadProfile(1,TIME)=loadProfile(1,TIME)+House(HVAC).PowerH;
                        
                    else
                        loadProfile(1,TIME)=loadProfile(1,TIME)+House(HVAC).PowerL;
                    end
                end
            end
            
            loadProfile1=loadProfile/(totalOnLoad); %Converting them to multplier values for demand response.
            % writematrix(loadProfile1,'loadProfile.csv');
            loadProfiles = {loadProfile1 , loadProfile};
            
        end
        
        function result= loadProf5min(loadProf)
            i=0; j=1;
            loadProf5min = zeros(1,(numel(loadProf)/5));
            while(i < numel(loadProf))
                loadProf5min(1,j) = ( loadProf ((i+1) ));
                i=i+5;j=j+1;
            end
            result= loadProf5min;
        end
        
        function result= MeanloadProf5min(loadProf)
            i=0; j=1;
            loadProf5min = zeros(1,(numel(loadProf)/5));
            while(i < numel(loadProf))
                loadProf5min(1,j) = mean( loadProf ((i+1) : (i+5) ));
                i=i+5;j=j+1;
            end
            result= loadProf5min;
        end
        
        
        function result= loadProfXliChangeOne(loadProf, resolution)
            i=0; j=1;
            loadProfChange = zeros(1,(numel(loadProf)/resolution));
            while(i < numel(loadProf))
                loadProfChange(1,j) = ( loadProf ((i+1)));
                i=i+resolution;j=j+1;
            end
            result= loadProfChange;
        end
        
        function result= loadProfXliChangeMean(loadProf, resolution)
            i=0; j=1;
            loadProfChange = zeros(1,(numel(loadProf)/resolution));
            while(i < numel(loadProf))
                loadProfChange(1,j) = mean( loadProf ((i+1) : (i+resolution) ));
                i=i+resolution;j=j+1;
            end
            result= loadProfChange;
        end
        
        function result = loadlistfor5minSupport(house,StatusAtEvery1min,TimeToStart)
            total1= size(StatusAtEvery1min);
            total= total1(1,1);
            tempHVAC =zeros(1,total);
            for HVAC = 1 :total
                a=0; % for 5min calculation
                for time= TimeToStart: (TimeToStart+5)
                    if(StatusAtEvery1min(HVAC,time) == "off" )
                        a=a+1;
                    end
                end
                if(a==5)
                    
                    tempHVAC(1,HVAC) = HVAC;
                end
            end
            HVACList= tempHVAC(tempHVAC~=0);
            load=0;
            
            for i = 1: numel(HVACList)
                load = load + house(HVACList(1,i)).PowerH;
            end
            
            result= {load , HVACList};
        end
        
        function result= deltaTimeCalc(StatusForEvery1min , StartTime)
            HVAC = size(StatusForEvery1min);
            time=  size(StatusForEvery1min); deltaTime = zeros(1,HVAC(1,1));
            for i= 1: HVAC(1,1)
                T=1;
                for j = StartTime: time(1,2)
                    if(j==time(1,2))
                        break;
                    end
                    if ((strcmp(StatusForEvery1min(i,j),StatusForEvery1min(i,j+1)))==0)
                        break;
                    end
                    T=T+1;
                end
                deltaTime(1,i)= T;
            end
            result= deltaTime;
        end
        
        function result = SetTemperatureLow(House , baseData)
            for i = 1: numel(House)
                House(i).TinIC = House(i).Tset-(baseData.Temp_deadband/2);
            end
            result=House;
        end
        
        function result= DRFor5MinCalc(house, StatusAtEvery1minFor5min, TempAtEvery1minFor5min , StatusAtEvery1Min, TempAtEvery1min, Tout ,baseData , StartTime, DRResolution)
            for i=1:numel(house)
                if(strcmp(house(i).Status,"on")==1)
                    house(i).Status = "off";
                end
            end
            test=1;
            for HVAC =1 : numel(house)
                loopJumpTime=StartTime;
                while(1~=0) %baseData.simulationTimeinMin
                    a= loopJumpTime ;
                    if(a<=baseData.simulationTimeinMin)
                        house(HVAC).Status = "off";
                        house(HVAC).TinIC = TempAtEvery1min(HVAC,a);
                        T=1;
                        if(strcmp(house(HVAC).Status,"on")==1)
                            syms ti(t);
                            ode1 = diff(ti) == (-2/(house(HVAC).Req * house(HVAC).AirHeatCapacity))*ti + (Tout(house(HVAC).StatusFlipTime ,1 ))/(house(HVAC).Req* house(HVAC).AirHeatCapacity) - (house(HVAC).Qvalue/house(HVAC).AirHeatCapacity);
                            cond= ti(0) == house(HVAC).TinIC;
                            u(t) = dsolve(ode1,cond);
                        else
                            syms ti(t);
                            ode1 = diff(ti) == (-2/(house(HVAC).Req * house(HVAC).AirHeatCapacity))*ti + (Tout(house(HVAC).StatusFlipTime ,1 ))/(house(HVAC).Req* house(HVAC).AirHeatCapacity) + (house(HVAC).Qvalue/house(HVAC).AirHeatCapacity);
                            cond= ti(0) == house(HVAC).TinIC;
                            u(t) = dsolve(ode1,cond);
                        end
                        loopIn=1;
                        while ((loopIn<= DRResolution) )
                            
                            TempAtEvery1minFor5min(HVAC,a)=u(T);
                            StatusAtEvery1minFor5min(HVAC,a)=house(HVAC).Status;
                            test=test+1;
                            T=T+1;
                            a=a+1;
                            loopIn= loopIn+1;
                            %                             if(a==baseData.simulationTimeinMin)
                            %                             break;
                            %                             end
                            %                             T=T+1;
                            %                             if (a > baseData.simulationTimeinMin)
                            %                                 break;
                            %                             end
                            if( (TempAtEvery1minFor5min(HVAC,a-1) > (house(HVAC).Tset + (house(HVAC).deadBand/2))))
                                house(HVAC).TinIC = TempAtEvery1minFor5min(HVAC,a-1);
                                house(HVAC).Status = "on";
                                house(HVAC).StatusPreviousFlipTime =house(HVAC).StatusFlipTime;
                                house(HVAC).StatusFlipTime=a;
                                loopJumpTime = loopJumpTime+DRResolution;
                                break;
                            end
                            if((TempAtEvery1minFor5min(HVAC,a-1) < (house(HVAC).Tset - (house(HVAC).deadBand/2))))
                                house(HVAC).TinIC = TempAtEvery1minFor5min(HVAC,a-1);
                                house(HVAC).Status = "off";
                                house(HVAC).StatusPreviousFlipTime =house(HVAC).StatusFlipTime;
                                house(HVAC).StatusFlipTime=a;
                                loopJumpTime = loopJumpTime+DRResolution;
                                break;
                            end
                            if(loopIn > DRResolution ||(a > baseData.simulationTimeinMin))
                                house(HVAC).TinIC = TempAtEvery1minFor5min(HVAC,a-1);
                                loopJumpTime = loopJumpTime+5;
                                break;
                                
                            end
                            
                        end
                    else
                        break;
                    end
                    
                end
                house(HVAC).test = test;
            end
            result={house,StatusAtEvery1minFor5min,TempAtEvery1minFor5min};
            
        end
        
        function result= DRForCalc1stMinApproach(house,StatusAtEvery1Min,TempAtEvery1min,Tout,baseData , StartTime, DRResolution)
            
            DRPotential= zeros(1, (baseData.simulationTimeinMin/DRResolution));
            DRHouseListAtIntervals= zeros(baseData.Number_of_houses,(baseData.simulationTimeinMin/DRResolution));
            for HVAC= 1: baseData.Number_of_houses
                i=StartTime; j=StartTime;
                while(j <= (baseData.simulationTimeinMin/DRResolution))
                    if(strcmp(StatusAtEvery1Min(HVAC,i) , "on" ) ==1 )% if(1==1)%
                        Time= DemandResponseAtStart.TempFuncEquation(house(HVAC), Tout(i,1) ,...
                            TempAtEvery1min(HVAC,i), (house(HVAC).Tset+ (baseData.Temp_deadband/2)) );
                        if(Time >= DRResolution)
                            DRPotential(1,j) = DRPotential(1,j) + house(HVAC).PowerH;
                            DRHouseListAtIntervals(HVAC,j)=1;
                        end
                        
                    end
                    i= i + DRResolution;j=j+1;
                end
            end
            result={DRPotential ,DRHouseListAtIntervals };
        end
        
        function result= TempFuncEquation(house, Tout , TempAtEvery1min , TempUpperLimit)
            syms ti(t);
            %ode1 = diff(ti) == (-2/(house.Req * house.AirHeatCapacity))*ti + (Tout)/(house.Req* house.AirHeatCapacity) + (house.Qvalue/house.AirHeatCapacity);
            ode1 = diff(ti) == (-2/(house.Req * house.AirHeatCapacity))*ti + (Tout)/(house.Req* house.AirHeatCapacity) + (house.QOutValue/house.AirHeatCapacity);
            cond= ti(0) == TempAtEvery1min;
            u(t) = dsolve(ode1,cond);
            
            eqn= u == TempUpperLimit;
            sol= solve(eqn);
            result= double(sol);
        end
        
        function result = supportTimeCalculator(house,StatusForEvery1min , DRResolution ,...
                StartTime , TimeSupportForHousesInIntervals)
            totalTime= size(TimeSupportForHousesInIntervals) ;
            for HVAC = 1: numel(house)
                i=StartTime;
                if(StartTime==1)
                    Time =   StartTime;
                else
                    Time =   StartTime* DRResolution;
                end
                while(i<=totalTime(1,2))
                    tempsubset =StatusForEvery1min(HVAC, : );
                    if((StartTime ~=1) && (i < totalTime(1,2)))
                        subset= tempsubset(( Time+1  : (Time+DRResolution) ));
                    end
                    if((StartTime ==1))
                        subset= tempsubset(( Time  : ((Time+DRResolution)-1) ));
                    end
                    [value, count] = groupcounts(subset.');
                    val = (find((ismember(count,"off"))));
                    if(StartTime ~=1  && (i<totalTime(1,2)) && ~isempty(val) )
                        TimeSupportForHousesInIntervals(HVAC,i+1) = value(val) ;
                    end
                    if ((StartTime ==1) && ~isempty(val))
                        TimeSupportForHousesInIntervals(HVAC,i) = value(val) ;
                    end
                    if((StartTime ~=1)  && (i<totalTime(1,2)) && isempty(val) )
                        TimeSupportForHousesInIntervals(HVAC,i+1) = 0 ;
                    end
                    if ((StartTime ==1) && isempty(val))
                        TimeSupportForHousesInIntervals(HVAC,i) = 0 ;
                    end
                    Time =Time+DRResolution;i=i+1;
                end
                
            end
            
            result=TimeSupportForHousesInIntervals;
        end
        
        function result = LoadCurveForInterval(House,HouseListOfTimeSupport, DRResolution , StartTime , baseData )
            loadProfile = zeros(1, baseData.simulationTimeinMin/DRResolution) ;
            for Time = (StartTime): (baseData.simulationTimeinMin/DRResolution)
                for HVAC = 1: numel(House)
                    if(HouseListOfTimeSupport(HVAC,Time) < DRResolution )
                        loadProfile(1, Time ) = loadProfile(1, Time )+  House(HVAC).PowerH;
                    end
                end
            end
            
            result= loadProfile;
        end
        
        function result = LoadCurveForSpecifiedInterval(House,HouseListOfTimeSupport, DRResolution , StartTime , baseData )
            loadProfile = zeros(1, baseData.simulationTimeinMin/DRResolution) ;
            Tstart=(StartTime/DRResolution);
            for Time =Tstart : (baseData.simulationTimeinMin/DRResolution)
                for HVAC = 1: numel(House)
                    if(HouseListOfTimeSupport(HVAC,Time) < DRResolution )
                        loadProfile(1, Time ) = loadProfile(1, Time )+  House(HVAC).PowerH;
                    end
                end
            end
            
            result= loadProfile;
        end
        
        function result = FillDataForSpecified(Data1,Data2  , baseData)
            for HVAC= 1: baseData.Number_of_houses
                for Time = 1: baseData.DRStartTime
                    Data1(HVAC, Time) = Data2(HVAC,Time);
                end
                
            end
            result = Data1;
        end
        
        function result= FillDRValues(DRSupportFor5minIntervalAtSpecifiedInterval ,LoadCurveFor5minNormalTime , DRResolution, baseData)
            if (DRResolution == 5)
                i=1;
                while(i <= ((baseData.DRStartTime/DRResolution)))
                    DRSupportFor5minIntervalAtSpecifiedInterval(1, i) = LoadCurveFor5minNormalTime(1,(i));
                    i=i+1;
                end
            end
            if (DRResolution == 10)
                i=1;j=1;
                while(j <= ((baseData.DRStartTime/DRResolution)))
                    DRSupportFor5minIntervalAtSpecifiedInterval(1, j) = LoadCurveFor5minNormalTime(1,(i));
                    i=i+2; j=j+1;
                end
            end
            if (DRResolution == 15)
                i=1;j=1;
                while(j <=  ((baseData.DRStartTime/DRResolution)))
                    DRSupportFor5minIntervalAtSpecifiedInterval(1, j) = LoadCurveFor5minNormalTime(1,(i));
                    i=i+3; j=j+1;
                end
            end
            result=DRSupportFor5minIntervalAtSpecifiedInterval;
        end
    end
end