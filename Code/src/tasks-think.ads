with MicroBit.MotorDriver;
with Priorities;

package Tasks.Think is

   -- Definisjon av indekser for Matrix og Vectors
   type Rows is new Integer range 0 .. 3; -- Har 4 rader
   type Cols is new Integer range 0 .. 2; -- Har 3 kolonner

   -- Dette er indeksen for Direction_Vector som er 3x1 (Vx, Vy, theta)
   type Direction_Index is new Integer range 0 .. 2;

   -- Dette er indeksen for Speed_Vector som er 4x1 (V1, V2, V3, V4)
   type Speed_Index is new Integer range 0 .. 3;

   -- Vektor definisjoner
   type Vector3d is array (Direction_Index) of Float; -- 3D vektor for retning
   type Vector4d is array (Speed_Index) of Float; -- 4D vektor for hastigheter

   -- Variabler for Movement_matrix. (Se dokumentasjon for detaljer)
   length    : Float := 12.0;
   width     : Float := 7.7;
   max_Speed : Float := 4000.0;
   radius    : Float := 3.2;

   -- Matrix definisjon, plassert her da protected types ikke støtter arrays direkte
   type Matrix4x3 is array (Rows, Cols) of Float;
   Movement_matrix : constant Matrix4x3 := (
      (max_Speed, -max_Speed, -max_Speed),
      (max_Speed, max_Speed, max_Speed),
      (max_Speed, max_Speed, -max_Speed),
      (max_Speed, -max_Speed, max_Speed)
   );

   -- Protected type for å beskytte data i flertrådede operasjoner
   protected type Think_data is
      procedure Set_Velocity(Vx_val, Vy_val : in Float); -- Setter hastighetskomponenter
      function GetSpeedVector return Vector4d; -- Henter beregnede hastighetsverdier
   private
      Vx         : Float := 0.0; -- Hastighet i x-retning
      Vy         : Float := 0.0; -- Hastighet i y-retning
      Theta      : Float := 0.0; -- Vinkel for retning
      Dir_length : Float := 0.0; -- Lengden av retningsvektoren

      Direction_Vector : Vector3d := (0.0, 0.0, 0.0); -- Retningsvektor
      Shared_Speed_Vector : Vector4d := (0.0, 0.0, 0.0, 0.0); -- Hastighetsvektor


   end Think_data;

   -- Gjør instansen av Think_data tilgjengelig som en global variabel
   Shared_Think_Data : Think_data;

   -- Offentlig funksjon som henter hastighetsvektoren fra Shared_Think_Data
   function Get_Speed_Vector return Vector4d;

   task Think with Priority => Priorities.Think is
   end Think;

end Tasks.Think;
