with Priorities;

package Tasks.Think is

   -- Definitions of indexe's for Matrix and Vectors
   -- These definitions are for the indexes of the Movement_matrix which is 4x3
   type Rows is new Integer range 0 .. 3; -- It has 4 rows
   type Cols is new Integer range 0 .. 2; -- It has 3 collums

   -- This is for the index of Direction_Vector wich is 3x1 (Vx, Vy, theta)
   type Direction_Index is new Integer range 0 .. 2;

   -- This is for the index of Speed_Vector wich is 4x1 (V1, V2, V3, V4)
   type Speed_Index is new Integer range 0 .. 3; -- NOTE:

   -- After all the index definitions; Matrix and Vectors definitions
   type Matrix4x3 is array (Rows, Cols) of Float;

   type Vector3d is array (Direction_Index) of Float;

   type Vector4d is array (Speed_Index) of Float;

   protected type Think_data is
      function GetSpeedVector return Vector4d;

   private
      Vx         : Float;
      Vy         : Float;
      Theta      : Float;
      Dir_length : Float;

      -- Variables for the Movement_matrix. Length, Width and Radius, see doc (TODO: Add document)
      -- These Variables are needed for the Movement_matrix
      length    : Float := 12.0;
      width     : Float := 7.7;
      max_Speed : Float := 4000.0;
      radius    : Float := 3.2;

      Movement_matrix : Matrix4x3 := (
         (max_Speed, -max_Speed, -(length + width)),  --
         (max_Speed, max_Speed, (length + width)),    --
         (max_Speed, max_Speed, -(length + width)),   --
         (max_Speed, -max_Speed, (length + width))
      );

      Direction_Vector : Vector3d := (0.0, 0.0, 0.0); -- [Vx, Vy, theta]

      Shared_Speed_Vector : Vector4d := (0.0, 0.0, 0.0, 0.0); -- [V1, V2, V3, V4]


   end Think_data;


   task Think with Priority => Priorities.Think is

   end Think;


end Tasks.Think;
