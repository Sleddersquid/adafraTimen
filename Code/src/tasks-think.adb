with Tasks.Sense;

with Ada.Real_Time; use Ada.Real_Time;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Tasks.Think is
   protected body Think_data is
      procedure Set_Velocity(Vx_val, Vy_val : in Float) is
      begin
         Vx := Vx_val;
         Vy := Vy_val;

         if Vx = 0.0 and Vy = 0.0 then
            Magnitude := 0.0;
         else
            Magnitude := Ada.Numerics.Elementary_Functions.Sqrt((abs (Vx)) ** 2.0 + (abs (Vy)) ** 2.0);
         end if;

         if Vx = 0.0 then
            Theta := 0.0;
         elsif Vy = 0.0 then
            Theta := -Ada.Numerics.Elementary_Functions.Arctan(Vx, 1.0);
         else
            Theta := Ada.Numerics.Elementary_Functions.Arctan(Vy, Vx);
         end if;

         if Magnitude = 0.0 then
            Direction_Vector := (1.0, 0.0, 0.0);
         else
            Direction_Vector(0) := Vx / Magnitude;
            Direction_Vector(1) := Vy / Magnitude;
            Direction_Vector(2) := Theta;
         end if;

         for j in Rows'Range loop
            Shared_Speed_Vector(Speed_Index(j)) :=
               Movement_matrix(j, 0) * Direction_Vector(0) +
               Movement_matrix(j, 1) * Direction_Vector(1) +
               Movement_matrix(j, 2) * Direction_Vector(2);
         end loop;
      end Set_Velocity;

      function GetSpeedVector return Vector4d is
      begin
         return Shared_Speed_Vector;
      end GetSpeedVector;

   end Think_data;

   function Get_Speed_Vector return Vector4d is
   begin
      return Shared_Think_Data.GetSpeedVector;
   end Get_Speed_Vector;

   task body Think is
      Start_Time: Time;
   begin
      loop
         Start_Time := Clock;

         Shared_Think_Data.Set_Velocity(
            Sense.Shared_Sensor_Data.Get_Distance3 - Sense.Shared_Sensor_Data.Get_Distance1,
            Sense.Shared_Sensor_Data.Get_Distance2 - Sense.Shared_Sensor_Data.Get_Distance4
         );

         delay until Start_Time + Milliseconds(140);
      end loop;
   end Think;

end Tasks.Think;
