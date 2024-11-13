with MicroBit.Console; use MicroBit.Console;
with MicroBit.Ultrasonic;
with Tasks.Think;

use Tasks;

package body Tasks.Sense is

-- Implementerer protected type for trygg sensor data tilgang
protected body Sensor_Data is

   function Get_Distance1 return Float is
   begin
      if Distance1 < 0.0 or Distance1 > 40.0 then
         return 0.0;
      else
         return Distance1;
      end if;
   end Get_Distance1;

   function Get_Distance2 return Float is
   begin
      if Distance2 < 0.0 or Distance2 > 40.0 then
         return 0.0;
      else
         return Distance2;
      end if;
   end Get_Distance2;

   function Get_Distance3 return Float is
   begin
      if Distance3 < 0.0 or Distance3 > 40.0 then
         return 0.0;
      else
         return Distance3;
      end if;
   end Get_Distance3;

   function Get_Distance4 return Float is
   begin
      if Distance4 < 0.0 or Distance4 > 40.0 then
         return 0.0;
      else
         return Distance4;
      end if;
   end Get_Distance4;

   -- prcedure (does not return a value) for å oppdatere sensordata i protected type
   procedure Update(D1, D2, D3, D4 : in Float) is
   begin
      Distance1 := D1;
      Distance2 := D2;
      Distance3 := D3;
      Distance4 := D4;
   end Update;
end Sensor_Data;

 -- Implementerer task body for Sense_Task
   task body Sense is
   begin
      loop
         -- Leser sensordata fra hver sensor og oppdaterer shared data
         Shared_Sensor_Data.Update(Float(Sensor1.Read), Float(Sensor2.Read), Float(Sensor3.Read), Float(Sensor4.Read));
         --  Think.Start(Distance1, Distance2, Distance3, Distance4); -- Entries not allowed :(
         delay 0.06;  -- Burde være 60ms. Kan være 50ms (max)
      end loop;
   end Sense;

end Tasks.Sense;



------------- Kan inkluderes i main.adb----------------
-- Implementerer task for å lese sensordata periodisk
--task body Sense_Task is
--   begin
--      loop
         -- Leser sensordata
    --     Shared_Sensor_Data.Update(Sensor1.Read, Sensor2.Read, Sensor3.Read, Sensor4.Read);
    --     delay 1000;
    --  end loop;
--  end
--end Tasks.Sense;

