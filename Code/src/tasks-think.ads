with Priorities;

package Tasks.Think is

   type Rows is new Integer range 0 .. 3;
   type Cols is new Integer range 0 .. 2;

   type Direction_Index is new Integer range 0 .. 2;

   type Speed_Index is new Integer range 0 .. 3;

   type Vector3d is array (Direction_Index) of Float;
   type Vector4d is array (Speed_Index) of Float;

   max_Speed : Float := 4000.0;

   type Matrix4x3 is array (Rows, Cols) of Float;
   Movement_matrix : constant Matrix4x3 := (
      (max_Speed, -max_Speed, -max_Speed),
      (max_Speed, max_Speed, max_Speed),
      (max_Speed, max_Speed, -max_Speed),
      (max_Speed, -max_Speed, max_Speed)
   );

   protected type Think_data is
      procedure Set_Velocity(Vx_val, Vy_val : in Float);
      function GetSpeedVector return Vector4d;
   private
      Vx         : Float := 0.0;
      Vy         : Float := 0.0;
      Theta      : Float := 0.0;
      Magnitude : Float := 0.0;

      Direction_Vector : Vector3d := (0.0, 0.0, 0.0);
      Shared_Speed_Vector : Vector4d := (0.0, 0.0, 0.0, 0.0);
   end Think_data;

   Shared_Think_Data : Think_data;

   function Get_Speed_Vector return Vector4d;

   task Think with Priority => Priorities.Think is
   end Think;

end Tasks.Think;
