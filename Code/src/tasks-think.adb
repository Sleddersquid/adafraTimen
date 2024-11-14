with Tasks.Sense;
with Ada.Numerics.Elementary_Functions;

with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions; -- Take the power of a float

package body Tasks.Think is

   protected body Think_data is

      -- Setter hastighetskomponentene og beregner nødvendige verdier
      procedure Set_Velocity(Vx_val, Vy_val : in Float) is
      begin
         Vx := Vx_val;
         Vy := Vy_val;
         --  Put_Line("Vx: " & Float'Image(Vx) & " Vy: " & Float'Image(Vy) & " Theta: " & Float'Image(Theta));

         --  Beregn Theta og Dir_length
         if Vx = 0.0 and Vy = 0.0 then
            Magnitude := 0.0;
         else
            Magnitude := Ada.Numerics.Elementary_Functions.Sqrt((abs (Vx)) ** 2.0 + (abs (Vy)) ** 2.0);
         end if;

         --  Put_Line("Vx: " & Float'Image(Vx) & " Vy: " & Float'Image(Vy));
         if Vy = 0.0 then
            Theta := -Ada.Numerics.Elementary_Functions.Arctan(Vx, 1.0); -- Turn when either sensor 1 or 3 detects something, but not sensor 2 or 4
         elsif Vx = 0.0 or Vy = 0.0 then
            Theta := 0.0;
         else
            Theta := Ada.Numerics.Elementary_Functions.Arctan(Vy, Vx);
            --  Put_Line("Calculate theta");
         end if;


         --  if Vx = 0.0 and Vy = 0.0 then
         --     Theta := 0.0;
         --  elsif Vx = 0.0 then
         --     Theta := Ada.Numerics.Elementary_Functions.Arctan(Vy, 1.0); -- Turn when either sensor 1 or 3 detects something, but not sensor 2 or 4
         --  else
         --     Theta := -Ada.Numerics.Elementary_Functions.Arctan(Vy, Vx);
         --     --  Put_Line("Calculate theta");
         --  end if;


         Put_Line(" Theta: " & Float'Image(Theta));

         if Magnitude = 0.0 then
            Direction_Vector := (1.0, 0.0, 0.0);
         else
            Direction_Vector(0) := Vx / Magnitude;
            Direction_Vector(1) := Vy / Magnitude;
            Direction_Vector(2) := Theta;
         end if;

         --  Put_Line("Direction_Vector: " & Float'Image(Direction_Vector(0)) & " " & Float'Image(Direction_Vector(1)) & " " & Float'Image(Direction_Vector(2)));

         -- Oppdater Shared_Speed_Vector basert på Movement_matrix
         for j in Rows'Range loop
            Shared_Speed_Vector(Speed_Index(j)) :=
               Movement_matrix(j, 0) * Direction_Vector(0) +
               Movement_matrix(j, 1) * Direction_Vector(1) +
               Movement_matrix(j, 2) * Direction_Vector(2);
         end loop;
      end Set_Velocity;

      -- Henter den beregnede hastighetsvektoren for å brukes i andre tasker
      function GetSpeedVector return Vector4d is
      begin
         return Shared_Speed_Vector;
      end GetSpeedVector;

   end Think_data;

   -- Offentlig funksjon som henter hastighetsvektoren fra Shared_Think_Data
   function Get_Speed_Vector return Vector4d is
   begin
      return Shared_Think_Data.GetSpeedVector;
   end Get_Speed_Vector;

   -- Implementering av task body for Think
   task body Think is

   Start_Time, Stop_Time : Time;
   Elapsed_Time          : Time_Span;

   begin
      loop
         Start_Time := Clock;


         Shared_Think_Data.Set_Velocity(
            Sense.Shared_Sensor_Data.Get_Distance3 - Sense.Shared_Sensor_Data.Get_Distance1,
            Sense.Shared_Sensor_Data.Get_Distance2 - Sense.Shared_Sensor_Data.Get_Distance4
         );

            Stop_Time    := Clock;
            Elapsed_Time := Stop_Time - Start_Time;
         Put_Line("(Think) Time taken: " & Duration'Image(To_Duration(Elapsed_Time)));
         delay until Start_Time + Milliseconds(10); -- 200ms
      end loop;
   end Think;

end Tasks.Think;
