with Tasks.Sense;

use Tasks;

package body Tasks.Think is



   protected body Think_data is

      function GetSpeedVector return Vector4d is
      begin
         return Shared_Speed_Vector;
      end GetSpeedVector;

   end Think_data;




   task body Think is

   begin
      loop
         -- Get data from sensors
         Think_data.Vx := Sense.Shared_Sensor_Data.Get_Distance3 - Sense.Shared_Sensor_Data.Get_Distance1;
         Think_data.Vy := Sense.Shared_Sensor_Data.Get_Distance2 - Sense.Shared_Sensor_Data.Get_Distance4;


      --  if (Distance1 = 0.0 and Distance3 = 0.0) then
      --     Vx := 0.0;
      --  end if;

      --  if (Distance2 = 0.0 and Distance4 = 0.0) then
      --     Vy := 0.0;
      --  end if;

      -- Here there is gonna be an if statement, if theta is larger than some value, then [0, 0, 1 ] or [0 ,0 , -1]
      -- Theta := Ada.Numerics.Elementary_Functions.ArcTan(Vy/Vx);

      -- Calculation to acheive the unit vector which is U = V / |V|
      Dir_length := Ada.Numerics.Elementary_Functions.Sqrt(Vx**2 + Vy**2); -- |V|

      if Dir_length = 0.0 then
         Direction_Vector (0) := 0.0; -- Ux / |V|; x component of unit vector * the length og unit vector
         Direction_Vector (1) := 0.0; -- Uy / |V|; y component of unit vector * the length og unit vector
         Direction_Vector (2) := 0.0; -- Uy / |V|; z component of unit vector * the length og unit vector
      else
         Direction_Vector (0) := Vx / Dir_length;  -- Ux / |V|; x component of unit vector * the length og unit vector
         Direction_Vector (1) := Vy / Dir_length;  -- Uy / |V|; y component of unit vector * the length og unit vector
         Direction_Vector (2) := 0;                -- Uz / |V|; z component of unit vector * the length og unit vector
      end if;

      Shared_Speed_Vector (0) := (Movement_matrix (0, 0) * Direction_Vector (0) + Movement_matrix (0, 1) * Direction_Vector (1) + Movement_matrix (0, 2) * Direction_Vector (2));
      Shared_Speed_Vector (1) := (Movement_matrix (1, 0) * Direction_Vector (0) + Movement_matrix (1, 1) * Direction_Vector (1) + Movement_matrix (1, 2) * Direction_Vector (2));
      Shared_Speed_Vector (2) := (Movement_matrix (2, 0) * Direction_Vector (0) + Movement_matrix (2, 1) * Direction_Vector (1) + Movement_matrix (2, 2) * Direction_Vector (2));
      Shared_Speed_Vector (3) := (Movement_matrix (3, 0) * Direction_Vector (0) + Movement_matrix (3, 1) * Direction_Vector (1) + Movement_matrix (3, 2) * Direction_Vector (2));

      delay 1.0;
      end loop;
   end Think;

end Tasks.Think;
