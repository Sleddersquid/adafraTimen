with Tasks.Sense;

with Ada.Real_Time; use Ada.Real_Time;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Tasks.Think is
   protected body Think_data is
      procedure Set_Velocity(Vx_val, Vy_val : in Float) is
      begin
         -- Vx = s_3 - s_1. Equation 6
         Vx := Vx_val;
         -- Vy = s_2 - s_4. Equation 7
         Vy := Vy_val;

         -- Equation 9.
         if Vx = 0.0 and Vy = 0.0 then
            -- If both Vx and Vy are zero, then magnitude is not needed to be calculated.
            Magnitude := 0.0;
         else
            -- Magnitude(norm) for direction vector, sqrt(Vx^2 + Vy^2)
            Magnitude := Ada.Numerics.Elementary_Functions.Sqrt((abs (Vx)) ** 2.0 + (abs (Vy)) ** 2.0);
         end if;

         -- Equation 10.
         if Vx = 0.0 then
            -- Case 1. Numerics.Argument_Error is handled.
            Theta := 0.0;
         elsif Vy = 0.0 then
            -- Case 2. Car rotates if object detected in front or back.
            Theta := -Ada.Numerics.Elementary_Functions.Arctan(Vx, 1.0);
         else
            -- Case 3. Theta calulated as arctan(Vy/Vx)
            Theta := Ada.Numerics.Elementary_Functions.Arctan(Vy, Vx);
         end if;

         -- Equation 11.
         if Magnitude = 0.0 then
            -- If no object in proximity, move forwards, and so Vx = 1
            Direction_Vector := (1.0, 0.0, 0.0);
         else
            -- unit vector û = u / |u|, where u = (Vx, Vy, Theta)
            Direction_Vector(0) := Vx / Magnitude;
            Direction_Vector(1) := Vy / Magnitude;
            Direction_Vector(2) := Theta;
         end if;

         -- Equation 5.
         for i in Rows'Range loop
            Shared_Speed_Vector(Speed_Index(i)) :=
               -- Equation 12.
               -- Typo in report: In Equation 12, j starts at zero, but should start at 1.
               Movement_matrix(i, 0) * Direction_Vector(0) +
               Movement_matrix(i, 1) * Direction_Vector(1) +
               Movement_matrix(i, 2) * Direction_Vector(2);
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
      -- Start_Time to store the current time
      Start_Time: Time;
   begin
      loop
         -- Get the current time
         Start_Time := Clock;

         -- Thinks main procedure. Get each sensor distance and calculate the speeds of each wheel.
         Shared_Think_Data.Set_Velocity(
            Sense.Shared_Sensor_Data.Get_Distance3 - Sense.Shared_Sensor_Data.Get_Distance1,
            Sense.Shared_Sensor_Data.Get_Distance2 - Sense.Shared_Sensor_Data.Get_Distance4
         );

         -- Taking use of the delay until, so that the computation time is taken into account.
         delay until Start_Time + Milliseconds(140);
      end loop;
   end Think;

end Tasks.Think;
