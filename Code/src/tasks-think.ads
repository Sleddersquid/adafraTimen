with Priorities;

package Tasks.Think is

   -- Indexes for creating the main Matrix.
   type Rows is new Integer range 0 .. 3; -- n = 4 rows
   type Cols is new Integer range 0 .. 2; -- m = 3 columns

   -- The indexes for the direction vector.
   type Direction_Index is new Integer range 0 .. 2;

   -- The indexes for the speed vector.
   type Speed_Index is new Integer range 0 .. 3;

   -- For vector in R^3. Defined in Equation 3.
   type Vector3d is array (Direction_Index) of Float;

   -- For vector in R^4. Defined in Equation 3.
   type Vector4d is array (Speed_Index) of Float;

   -- Koeficient, to give for the max speed of the vehicle.
   max_Speed : Float := 4000.0;

   -- The main matrix. M in R^4x3. See Equation 4.
   -- It is constant, because it is never modified.
   type Matrix4x3 is array (Rows, Cols) of Float;
   Movement_matrix : constant Matrix4x3 := (
      (max_Speed, -max_Speed, -max_Speed),
      (max_Speed, max_Speed, max_Speed),
      (max_Speed, max_Speed, -max_Speed),
      (max_Speed, -max_Speed, max_Speed)
   );

   protected type Think_data is
      -- Procedure to calulate the speeds for each wheel.
      procedure Set_Velocity(Vx_val, Vy_val : in Float);
      -- Returns the calulated speed vector.
      function GetSpeedVector return Vector4d;
   private
      -- Local variables used in calulations in Set_Velocity.
      Vx         : Float := 0.0;
      Vy         : Float := 0.0;
      Theta      : Float := 0.0;
      Magnitude : Float := 0.0;

      -- Initzializing the direction vector and the speed vector.
      Direction_Vector : Vector3d := (0.0, 0.0, 0.0);
      Shared_Speed_Vector : Vector4d := (0.0, 0.0, 0.0, 0.0);
   end Think_data;

   Shared_Think_Data : Think_data;

   -- Function to get the speed vector from protected type.
   function Get_Speed_Vector return Vector4d;

   task Think with Priority => Priorities.Think is -- Priority of the task Think
   end Think;

end Tasks.Think;
