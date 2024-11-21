with MicroBit.MotorDriver;
with Tasks.Think;   use Tasks;
with Ada.Real_Time; use Ada.Real_Time;
with HAL;           use HAL;
with DFR0548;       use DFR0548;

package body Tasks.Act is
   procedure WromWrom_Vector (Speed_Vector : Think.Vector4d) is
      -- Local variables used to set the speeds of each wheel. Wheel is type record, defined at dfr0548.ads(43:3)
      -- 0th position is for positive speeds, and 1st position is for negative speeds.
      left_front  : Wheel := (0, 0);
      right_front : Wheel := (0, 0);
      left_back   : Wheel := (0, 0);
      right_back  : Wheel := (0, 0);

      -- Local variables to store the speeds of each wheel separately.
      -- Stored sperately to adjust the speed of each wheel according to Equation 13.
      speed_left_front  : Float;
      speed_right_front : Float;
      speed_left_back   : Float;
      speed_right_back  : Float;
   begin
      -- Getting the speeds of each wheel from the speed vector.
      speed_left_front := Speed_Vector (0);
      speed_right_front := Speed_Vector (1);
      speed_left_back := Speed_Vector (2);
      speed_right_back := Speed_Vector (3);

      -- Adjusting the speeds of left front wheel according to Equation 13.
      if speed_left_front > 4095.0 then
         speed_left_front := 4095.0;
      elsif speed_left_front < -4095.0 then
         speed_left_front := -4095.0;
      end if;

      -- Adjusting the speeds of right front wheel according to Equation 13.
      if speed_right_front > 4095.0 then
         speed_right_front := 4095.0;
      elsif speed_right_front < -4095.0 then
         speed_right_front := -4095.0;
      end if;

      -- Adjusting the speeds of left back wheel according to Equation 13.
      if speed_left_back > 4095.0 then
         speed_left_back := 4095.0;
      elsif speed_left_back < -4095.0 then
         speed_left_back := -4095.0;
      end if;

      -- Adjusting the speeds of right back wheel according to Equation 13.
      if speed_right_back > 4095.0 then
         speed_right_back := 4095.0;
      elsif speed_right_back < -4095.0 then
         speed_right_back := -4095.0;
      end if;

      -- Setting the speeds of left front wheel. If the speed is positive, the 0th position is set, else the 1st position is set.
      if speed_left_front > 0.0 then
         left_front := (Uint12 (speed_left_front), 0);
      else
         speed_left_front := abs (speed_left_front);
         left_front := (0, Uint12 (speed_left_front));
      end if;

      -- Setting the speeds of right front wheel. If the speed is positive, the 0th position is set, else the 1st position is set.
      if speed_right_front > 0.0 then
         right_front := (UInt12 (speed_right_front), 0);
      else
         speed_right_front := abs (speed_right_front);
         right_front := (0, Uint12 (speed_right_front));
      end if;

      -- Setting the speeds of left back wheel. If the speed is positive, the 0th position is set, else the 1st position is set.
      if speed_left_back > 0.0 then
         left_back := (Uint12 (speed_left_back), 0);
      else
         speed_left_back := abs (speed_left_back);
         left_back := (0, Uint12 (speed_left_back));
      end if;

      -- Setting the speeds of right back wheel. If the speed is positive, the 0th position is set, else the 1st position is set.
      if speed_right_back > 0.0 then
         right_back := (Uint12 (speed_right_back), 0);
      else
         speed_right_back := abs (speed_right_back);
         right_back := (0, Uint12 (speed_right_back));
      end if;

      -- Driving the wheels with the speeds adjusted as above.
      -- Drive_Wheels is a procedure from MicroBit.MotorDriver, defined at microbit-motordriver.ads
      -- This procedure used to be private, but has been modified to be public.
      MicroBit.MotorDriver.Drive_Wheels
        (rf => right_front,
         rb => right_back,
         lf => left_front,
         lb => left_back);
   end WromWrom_Vector;

   task body Act is
      -- Local_Speed_Vector to store the calulated speed vector from Think
      Local_Speed_Vector : Think.Vector4d;

      -- Start_Time to store the current time
      Start_Time : Time;
   begin
      loop
         -- Get the current time
         Start_Time := Clock;

         -- Get the calulated speed vector from Think
         Local_Speed_Vector := Tasks.Think.Get_Speed_Vector;

         -- Acts main procedure to drive the wheels. The speed vector passed as an in arguament
         WromWrom_Vector (Local_Speed_Vector);

         -- Taking use of the delay until, so that the computation time is taken into account.
         delay until Start_Time + Milliseconds (140);
      end loop;
   end Act;
end Tasks.Act;
