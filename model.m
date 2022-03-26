
classdef model
    properties
        index;
        TinIC ;
        AirHeatCapacity;
        Qvalue;
        QOutValue;
        Req;
        Tset;
        HVACType;
        PowerH;
        PowerL;
        Status;
        StatusFlipTime;
        StatusPreviousFlipTime;
        deadBand;
        test;
        TinICInitial;
    end
    methods
        function obj = model()
            if ~nargin
                % the default constructor. Needed for array creation
                obj.TinICInitial=2;
                obj.test=1;
                obj.index=1;
                obj.deadBand=0;
                obj.StatusFlipTime=1;
                obj.StatusPreviousFlipTime=1;
                obj.TinIC=0 ;
                obj.AirHeatCapacity=0;
                obj.Qvalue=0;
                obj.QOutValue=0;
                obj.Req=0;
                obj.Tset=0;
                obj.HVACType=1;
                obj.PowerH=0;
                obj.PowerL=0;
                obj.Status="on";
            end
            
        end
        
    end
end
