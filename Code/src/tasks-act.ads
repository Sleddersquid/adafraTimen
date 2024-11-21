with Priorities;
with Tasks.Think;
use Tasks;

package Tasks.Act is
   -- This procedure is used to drive the wheels of the vehicle. A vector in R^4 is passed as an in arguament.
   -- @param Speed_Vector The vector containing the speed of each wheel.
   procedure WromWrom_Vector (Speed_Vector : Think.Vector4d);

   task Act
     with Priority => Priorities.Act is -- Priority of the task Act
   end Act;

end Tasks.Act;
