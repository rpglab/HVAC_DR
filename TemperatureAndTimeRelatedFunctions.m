
classdef TemperatureAndTimeRelatedFunctions
    methods (Static)
        function resultHouse = TimeToStartAgain(house,Tout)
            syms ti(t);
            ode1 = diff(ti) == (-2/(house.Req* house.AirHeatCapacity))*ti + (Tout(house.StatusFlipTime ,1 ))/(house.Req* house.AirHeatCapacity) + (house.Qvalue/house.AirHeatCapacity);
            cond= ti(0) == house.TinIC;
            u(t) = dsolve(ode1,cond);
            syms t;
            eqn=u(t)==house.Tset+(house.deadBand/2);
            sol=solve(eqn,t);
            house.StatusPreviousFlipTime= house.StatusFlipTime;
            house.StatusFlipTime= round(double(sol));
            resultHouse=house;
            house.TinIC= double(u(house.StatusFlipTime));
        end
    end
end
