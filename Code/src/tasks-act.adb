with MicroBit.MotorDriver;
with Tasks.Think;   use Tasks;
with Ada.Real_Time; use Ada.Real_Time;
with HAL;           use HAL;
with DFR0548;       use DFR0548;

package body Tasks.Act is
   procedure WromWrom_Vector (Speed_Vector : Think.Vector4d) is
      left_front  : Wheel := (0, 0);
      right_front : Wheel := (0, 0);
      left_back   : Wheel := (0, 0);
      right_back  : Wheel := (0, 0);

      speed_left_front  : Float;
      speed_right_front : Float;
      speed_left_back   : Float;
      speed_right_back  : Float;
   begin
      speed_left_front := Speed_Vector (0);
      speed_right_front := Speed_Vector (1);
      speed_left_back := Speed_Vector (2);
      speed_right_back := Speed_Vector (3);

      if speed_left_front > 4095.0 then
         speed_left_front := 4095.0;
      elsif speed_left_front < -4095.0 then
         speed_left_front := -4095.0;
      end if;

      if speed_right_front > 4095.0 then
         speed_right_front := 4095.0;
      elsif speed_right_front < -4095.0 then
         speed_right_front := -4095.0;
      end if;

      if speed_left_back > 4095.0 then
         speed_left_back := 4095.0;
      elsif speed_left_back < -4095.0 then
         speed_left_back := -4095.0;
      end if;

      if speed_right_back > 4095.0 then
         speed_right_back := 4095.0;
      elsif speed_right_back < -4095.0 then
         speed_right_back := -4095.0;
      end if;

      if speed_left_front > 0.0 then
         left_front := (Uint12 (speed_left_front), 0);
      else
         speed_left_front := abs (speed_left_front);
         left_front := (0, Uint12 (speed_left_front));
      end if;

      if speed_right_front > 0.0 then
         right_front := (UInt12 (speed_right_front), 0);
      else
         speed_right_front := abs (speed_right_front);
         right_front := (0, Uint12 (speed_right_front));
      end if;

      if speed_left_back > 0.0 then
         left_back := (Uint12 (speed_left_back), 0);
      else
         speed_left_back := abs (speed_left_back);
         left_back := (0, Uint12 (speed_left_back));
      end if;

      if speed_right_back > 0.0 then
         right_back := (Uint12 (speed_right_back), 0);
      else
         speed_right_back := abs (speed_right_back);
         right_back := (0, Uint12 (speed_right_back));
      end if;

      MicroBit.MotorDriver.Drive_Wheels
        (rf => right_front,
         rb => right_back,
         lf => left_front,
         lb => left_back);
   end WromWrom_Vector;

   task body Act is
      Local_Speed_Vector : Think.Vector4d;

      Start_Time : Time;
   begin
      loop
         Start_Time := Clock;

         Local_Speed_Vector := Tasks.Think.Get_Speed_Vector;

         WromWrom_Vector (Local_Speed_Vector);

         delay until Start_Time + Milliseconds (140);
      end loop;
   end Act;
end Tasks.Act;
