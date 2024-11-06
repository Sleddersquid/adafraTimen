-- Dette er med orginal lib.

with MicroBit.Ultrasonic;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Types;
with MicroBit.MotorDriver;
--  with MicroBit.Eriklib; use MicroBit.Eriklib;
with HAL;

-- Needed for the sqrt() function
with Ada.Numerics.Elementary_Functions;

procedure Main is

   ------------------------------- TODO: --------------------------------
   -- 1:    Remove distance from the Init of Variables. DONE!
   -- 2.1:  Add if check for positive and negative speeds. DONE! See microbit-motordriver
   -- 2.2:  Add two Speeds arrays (one pos, one neg). Not needed with current solution DONE!
   -- 2.3:  Insert these Speeds arrays into Motordrive.Drive(); DONE!. See member function WromWrom
   -- 3:    Add documentation for the measurements of Length, Width and Radius
   -- 4:    Add documentation for matrix dot product multiplication
   -- 5:    Add documentation for unit vector and how it acheive what it does
   -- 6:    Remove Sensor_Range. Might not be needed after all because of the new formula for sensor input DONE!
   -- 7:    Add doc for why Sensor needs 50ms for reset.
   -- 8:    Rename Vx and Vy to something more conventional.
   -- 9:    Ultrasonic sensor gives high values, so 45 degress are difficult to acheive.
   -- 10:   Maybe Sensor_Range is needed after all, because it sees too far.
   -- 11:   Add calculation for theta, theta = tan^-1(Vy/Vx)

   ------------------------------ Sensors -------------------------------

   -- This is for the sensor and all its definitions
   package sensor1 is new MicroBit.Ultrasonic(MicroBit.MB_P16, MicroBit.MB_P0); -- Trigger, Echo
   package sensor2 is new MicroBit.Ultrasonic(MicroBit.MB_P15, MicroBit.MB_P1); -- Trigger, Echo
   package sensor3 is new MicroBit.Ultrasonic(MicroBit.MB_P14, MicroBit.MB_P2); -- Trigger, Echo
   package sensor4 is new MicroBit.Ultrasonic(MicroBit.MB_P13, MicroBit.MB_P12); -- Trigger, Echo

   -- NOTE: The Sensor_Range was for the other vector formula [1/s1 - 1/s3, 1/s4 - 1/s2]
   -- New formula is [s3 - s1, s4 - s2] NOTE: This is not the final formula

   -- Might not be needed Sensor_Range because of the new formula
   --  type Sensor_Range is new Float range 0.5 .. 400.0;

   ------------------------ Matrises and Vectors ------------------------

   -- Definitions for Matrix and Vectors
   -- These definitions are for the indexes of the Movement_matrix which is 4x3
   type Rows is new Integer range 0 .. 3; -- It has 4 rows
   type Cols is new Integer range 0 .. 2; -- It has 3 collums

   -- This is for the index of Direction_Vector wich is 3x1 (Vx, Vy, theta)
   type Direction_Index is new Integer range 0 .. 2;

   -- This is for the index of Speed_Vector wich is 4x1 (V1, V2, V3, V4)
   --  type Speed_Index is new Integer range 0 .. 3; -- NOTE:

   -- After all the index definitions; Matrix and Vectors definitions
   type Matrix4x3 is array (Rows, Cols) of Float;

   type Vector3d is array (Direction_Index) of Float;

   --  type Vector4d is array (Speed_Index) of Float; -- NOTE:

   --------------------- Init of Matrix and Vectors ---------------------

   -- Variables for the Movement_matrix. Length, Width and Radius, see doc (TODO: Add document)
   -- These Variables are needed for the Movement_matrix
   length    : Float := 12.0;
   width     : Float := 7.7;
   max_Speed : Float := 4000.0;
   radius    : Float := 3.2;

   Movement_matrix : Matrix4x3 :=
     ((max_Speed, -max_Speed, -(length + width)),  --
      (max_Speed, max_Speed, (length + width)),    --
      (max_Speed, max_Speed, -(length + width)),   --
      (max_Speed, -max_Speed, (length + width)));  --


   Direction_Vector : Vector3d := (0.0, 0.0, 0.0); -- [Vx, Vy, theta]

   -- When under refactor try to use the Speed array type from Motordriver DONE!
   Speed_Vector : MicroBit.MotorDriver.Vector4d := (0.0, 0.0, 0.0, 0.0); -- [V1, V2, V3, V4]

   -------------------- Init of Variables----------------------
   Vx         : Float;
   Vy         : Float;
   Theta      : Float;

   Dir_length : Float;

   Distance1 : Float;
   Distance2 : Float;
   Distance3 : Float;
   Distance4 : Float;
begin
   Put_Line ("Hello, world!");
   loop
      -- Calculate Vx and Vy based on the input from the sensors
      -- Needs to be converted into Float because sensorX.Read gives Distance_cm

      Distance1 := Float(sensor1.Read); -- Sensor1
      Distance2 := Float(sensor2.Read); -- Sensor2
      Distance3 := Float(sensor3.Read); -- Sensor3
      Distance4 := Float(sensor4.Read); -- Sensor4

      Put_Line ("Front: " & Float'Image(Distance1));
      Put_Line ("Right: " & Float'Image(Distance2));
      Put_Line ("Back: " & Float'Image(Distance3));
      Put_Line ("Left: " & Float'Image(Distance4));

      Vx := Distance4 - Distance2;
      Vy := Distance3 - Distance1;

      if (Distance1 = 0.0 and Distance3 = 0.0) then
         Vx := 0.0;
      end if;

      if (Distance2 = 0.0 and Distance4 = 0.0) then
         Vy := 0.0;
      end if;

      Theta := Ada.Numerics.Elementary_Functions.ArcTan(Vy/Vx);

      Put_Line ("Vx: " & Float'Image(Vx));
      Put_Line ("Vy: " & Float'Image(Vy));

      -- Calculation to acheive the unit vector which is U = V / |V|
      Dir_length := Ada.Numerics.Elementary_Functions.Sqrt(Vx**2 + Vy**2); -- |V|

      Put_Line ("Dir_length: " & Float'Image(Dir_length));

      if Dir_length = 0.0 then
         Direction_Vector (0) := 0.0; -- Ux / |V|; x component of unit vector * the length og unit vector
         Direction_Vector (1) := 0.0; -- Uy / |V|; y component of unit vector * the length og unit vector
         Direction_Vector (2) := 0.0; -- Uy / |V|; z component of unit vector * the length og unit vector
      else
         Direction_Vector (0) := Vx / Dir_length; -- Ux / |V|; x component of unit vector * the length og unit vector
         Direction_Vector (1) := Vy / Dir_length; -- Uy / |V|; y component of unit vector * the length og unit vector
         Direction_Vector (2) := Theta; -- Uy / |V|; z component of unit vector * the length og unit vector
      end if;

      Put_Line ("Direction_Vector (0): " & Float'Image(Direction_Vector (0)));
      Put_Line ("Direction_Vector (1): " & Float'Image(Direction_Vector (1)));

      --  Direction_Vector (0) := 0.0; -- Ux / |V|; x component of unit vector * the length og unit vector
      --  Direction_Vector (1) := 0.0; -- Uy / |V|; y component of unit vector * the length og unit vector

      Speed_Vector (0) := 1.0/4.0 * (Movement_matrix (0, 0) * Direction_Vector (0) + Movement_matrix (0, 1) * Direction_Vector (1) + Movement_matrix (0, 2) * Direction_Vector (2));
      Speed_Vector (1) := 1.0/4.0 * (Movement_matrix (1, 0) * Direction_Vector (0) + Movement_matrix (1, 1) * Direction_Vector (1) + Movement_matrix (1, 2) * Direction_Vector (2));
      Speed_Vector (2) := 1.0/4.0 * (Movement_matrix (2, 0) * Direction_Vector (0) + Movement_matrix (2, 1) * Direction_Vector (1) + Movement_matrix (2, 2) * Direction_Vector (2));
      Speed_Vector (3) := 1.0/4.0 * (Movement_matrix (3, 0) * Direction_Vector (0) + Movement_matrix (3, 1) * Direction_Vector (1) + Movement_matrix (3, 2) * Direction_Vector (2));

      Put_Line ("Speed_Vector (0): " & Float'Image(Speed_Vector (0)));
      Put_Line ("Speed_Vector (1): " & Float'Image(Speed_Vector (1)));
      Put_Line ("Speed_Vector (2): " & Float'Image(Speed_Vector (2)));
      Put_Line ("Speed_Vector (3): " & Float'Image(Speed_Vector (3)));

      -- Burde vrike. Idk, den compiler i det minste. Viktigste nå er å sette opp ultrasonic sensors sånn at det henger på bilen ordentlig.
      MicroBit.MotorDriver.WromWrom_Vector(Speed_Vector);
      -- Stop and full flank if statements.

      delay 0.05; --50ms
   end loop;
end Main;
