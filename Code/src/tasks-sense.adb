with MicroBit.Console; use MicroBit.Console;
with MicroBit.Ultrasonic;

with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;

package body Tasks.Sense is

-- Implementerer protected type for trygg sensor data tilgang
protected body Update_Sensor_Data is

   function Get_Distance1 return Float is
   begin
      if Distance1 < 0.0 or Distance1 > Max_Distance then
         return 0.0;
      end if;
      return Distance1;
   end Get_Distance1;

   function Get_Distance2 return Float is
   begin
      if Distance2 < 0.0 or Distance2 > Max_Distance then
         return 0.0;
      end if;
      return Distance2;
   end Get_Distance2;

   function Get_Distance3 return Float is
   begin
      if Distance3 < 0.0 or Distance3 > Max_Distance then
         return 0.0;
      end if;
      return Distance3;
   end Get_Distance3;

   function Get_Distance4 return Float is
   begin
      if Distance4 < 0.0 or Distance4 > Max_Distance then
         return 0.0;
      end if;
      return Distance4;
   end Get_Distance4;

   -- prcedure(fortsette) for å oppdatere sensordata i protected type
   procedure Update(D1, D2, D3, D4 : in Float) is
   begin
      Distance1 := D1;
      Distance2 := D2;
      Distance3 := D3;
      Distance4 := D4;
   end Update;
end Update_Sensor_Data;

 -- Implementerer task body for Sense_Task
   task body Sense is
      Start_Time, Stop_Time : Time;
      Elapsed_Time          : Time_Span;
   begin
      loop
         Start_Time := Clock;
         -- Leser sensordata fra hver sensor og oppdaterer shared data
         Shared_Sensor_Data.Update(Float(Sensor1.Read), Float(Sensor2.Read), Float(Sensor3.Read), Float(Sensor4.Read));

         Stop_Time    := Clock;
         Elapsed_Time := Stop_Time - Start_Time;
         Put_Line("(Sense) Time taken: " & Duration'Image(To_Duration(Elapsed_Time)));

         delay 0.2; -- 200ms
      end loop;
   end Sense;

end Tasks.Sense;
