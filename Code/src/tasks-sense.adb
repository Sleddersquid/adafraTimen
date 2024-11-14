with MicroBit.Ultrasonic;
with Ada.Real_Time; use Ada.Real_Time;

package body Tasks.Sense is
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

   procedure Update(D1, D2, D3, D4 : in Float) is
   begin
      Distance1 := D1;
      Distance2 := D2;
      Distance3 := D3;
      Distance4 := D4;
   end Update;
end Update_Sensor_Data;

   task body Sense is
      Start_Time: Time;
   begin
      loop
         Start_Time := Clock;

         Shared_Sensor_Data.Update(Float(Sensor1.Read), Float(Sensor2.Read), Float(Sensor3.Read), Float(Sensor4.Read));

         delay until Start_Time + Milliseconds(140);
      end loop;
   end Sense;

end Tasks.Sense;
