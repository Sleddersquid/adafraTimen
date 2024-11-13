with Priorities;
with Tasks.Think; use Tasks;

package Tasks.Act is

   -- Protected type for å lagre og oppdatere speed-verdier fra Think
   protected type Act_Data is
      procedure Set_Speed_Vector(New_Vector : in Think.Vector4d);
      function Get_Speed_Vector return Think.Vector4d;
   private
      Speed_Vector : Think.Vector4d := (0.0, 0.0, 0.0, 0.0);
   end Act_Data;

   -- Deling av Act_Data for trådsikker tilgang
   Shared_Act_Data : Act_Data;

   -- Act task som vil bruke dataene fra Think for å styre handlingene
   task Act with Priority => Priorities.Act is
   end Act;

end Tasks.Act;
