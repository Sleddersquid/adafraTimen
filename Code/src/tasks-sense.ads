with MicroBit.Ultrasonic;
with Priorities;

package Tasks.Sense is
   -- Create a new instance of the Ultrasonic sensor for each sensor.
   package Sensor1 is new MicroBit.Ultrasonic(MicroBit.MB_P16, MicroBit.MB_P0); -- Echo, Trigger
   package Sensor2 is new MicroBit.Ultrasonic(MicroBit.MB_P15, MicroBit.MB_P1); -- Echo, Trigger
   package Sensor3 is new MicroBit.Ultrasonic(MicroBit.MB_P14, MicroBit.MB_P2); -- Echo, Trigger
   package Sensor4 is new MicroBit.Ultrasonic(MicroBit.MB_P13, MicroBit.MB_P12); -- Echo, Trigger

   protected type Update_Sensor_Data is
      -- Distance 1. Front sensor. Distance is in cm.
      function Get_Distance1 return Float;
      -- Distance 2. Right sensor. Distance is in cm.
      function Get_Distance2 return Float;
      -- Distance 3. Back sensor. Distance is in cm.
      function Get_Distance3 return Float;
      -- Distance 4. Left sensor. Distance is in cm.
      function Get_Distance4 return Float;

      -- Update the sensor data.
      procedure Update(D1, D2, D3, D4 : in Float);
   private
      -- The max distance the sensor is set to read.
      Max_Distance : Float := 40.0; -- In cm
      Distance1 : Float := 0.0;
      Distance2 : Float := 0.0;
      Distance3 : Float := 0.0;
      Distance4 : Float := 0.0;
   end Update_Sensor_Data;

   Shared_Sensor_Data : Update_Sensor_Data;

   task Sense with Priority => Priorities.Sense; -- Priority of the task Sense

end Tasks.Sense;
