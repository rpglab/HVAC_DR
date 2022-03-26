classdef DemandResponseAtSpecifiedTime
    methods(Static)
        function out= simulateTemperatureForWholeDay(house,StatusAtEvery1Min,TempAtEvery1min,baseData,Tout)
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
        
        function out= resimulateTemperatureAtSpecifiedTime(house,TempAtEvery1min,StatusAtEvery1min,baseData,onHouseArray,  Tout)
            test=1;
            for HVAC =1 : numel(house)
                a=baseData.DRStartTime;
                if(ismember(HVAC,onHouseArray))
                    while(1~=0) %baseData.simulationTimeinMin
                        if(a<baseData.simulationTimeinMin)
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
                            while (1~=0)
                                TempAtEvery1min(HVAC,a)=u(T);
                                StatusAtEvery1min(HVAC,a)=house(HVAC).Status;
                                test=test+1;
                                a=a+1; T=T+1;
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
                end
                house(HVAC).test = test;
            end
            out={house,StatusAtEvery1min,TempAtEvery1min};
        end
        
        function u= OnStatusTempSimulationEquation(house,Tout)
            syms ti(t);
            ode1 = diff(ti) == (-2/(house.Req* house.AirHeatCapacity))*ti + (Tout(house.StatusFlipTime ,1 ))/(house.Req* house.AirHeatCapacity) - (house.Qvalue/house.AirHeatCapacity);
            cond= ti(0) == house.TinIC;
            u(t) = dsolve(ode1,cond);
        end
        function u= OffStatusTempSimulationEquation(house,Tout)
            syms ti(t);
            ode1 = diff(ti) == (-2/(house.Req* house.AirHeatCapacity))*ti + (Tout(house.StatusFlipTime ,1 ))/(house.Req* house.AirHeatCapacity) + (house.Qvalue/house.AirHeatCapacity);
            cond= ti(0) == house.TinIC;
            u(t) = dsolve(ode1,cond);
        end
    end
end