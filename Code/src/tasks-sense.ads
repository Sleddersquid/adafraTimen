
with MicroBit.Ultrasonic;
with MicroBit.Types;
with Priorities;

package Tasks.Sense is

   -- Sensorpakker for ultralydsensorene:          Trigger          Echo
   package Sensor1 is new MicroBit.Ultrasonic(MicroBit.MB_P16, MicroBit.MB_P0);
   package Sensor2 is new MicroBit.Ultrasonic(MicroBit.MB_P15, MicroBit.MB_P1);
   package Sensor3 is new MicroBit.Ultrasonic(MicroBit.MB_P14, MicroBit.MB_P2);
   package Sensor4 is new MicroBit.Ultrasonic(MicroBit.MB_P13, MicroBit.MB_P12);

   -- setter protected type for å beskyttet sensor data
   protected type Update_Sensor_Data is
      function Get_Distance1 return Float;
      function Get_Distance2 return Float;
      function Get_Distance3 return Float;
      function Get_Distance4 return Float;


      procedure Update(D1, D2, D3, D4 : in Float);
   private
      Max_Distance : Float := 40.0; -- In cm
      Distance1 : Float := 0.0;
      Distance2 : Float := 0.0;
      Distance3 : Float := 0.0;
      Distance4 : Float := 0.0;
   end Update_Sensor_Data;

   -- lagringsplass for sensordata som deles
   Shared_Sensor_Data : Update_Sensor_Data;

   task Sense with Priority => Priorities.Sense;

end Tasks.Sense;
