with MicroBit.MotorDriver; -- For å kontrollere motorene basert på Speed_Vector
with Tasks.Think;

with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;

package body Tasks.Act is

   protected body Act_Data is

      -- Setter verdiene til Speed_Vector fra Think
      procedure Set_Speed_Vector(New_Vector : in Think.Vector4d) is
      begin
         Speed_Vector := New_Vector;
      end Set_Speed_Vector;

      -- Henter verdiene fra Speed_Vector for handling
      function Get_Speed_Vector return Think.Vector4d is
      begin
         return Speed_Vector;
      end Get_Speed_Vector;

   end Act_Data;

   -- Implementering av task body for Act
   task body Act is
      Local_Speed_Vector : Think.Vector4d; -- Lokal kopi av hastighetsvektor

      Start_Time, Stop_Time : Time;
      Elapsed_Time          : Time_Span;
   begin
      loop
         Start_Time := Clock;

         -- Hent oppdatert speed data fra Think
         Local_Speed_Vector := Tasks.Think.Get_Speed_Vector;

         -- Kjør motorene basert på Local_Speed_Vector ved hjelp av WromWrom_Vector
         MicroBit.MotorDriver.WromWrom_Vector(MicroBit.MotorDriver.Vector4d(Local_Speed_Vector));

         -- Delay for å tillate jevn oppdatering av data
            Stop_Time    := Clock;
            Elapsed_Time := Stop_Time - Start_Time;
         Put_Line("(Act) Time taken: " & Duration'Image(To_Duration(Elapsed_Time)));
         delay 0.2; -- 200ms
      end loop;
   end Act;

end Tasks.Act;
