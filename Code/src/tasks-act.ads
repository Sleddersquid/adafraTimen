with Priorities;
with Tasks.Think;
use Tasks;

package Tasks.Act is
   procedure WromWrom_Vector (Speed_Vector : Think.Vector4d);

   task Act
     with Priority => Priorities.Act is
   end Act;

end Tasks.Act;
