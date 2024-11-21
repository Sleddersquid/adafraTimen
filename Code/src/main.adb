with Tasks.Sense;
with Tasks.Think;
with Tasks.Act;
use Tasks;
--------------------------------------------------------------
-- The code was commented on the 21.11.2024.
-- The hand in date for the code and report was: 14.11.2024.
-- No changes were made to the code after the hand in date.

-- Real Time Revolutionaries
-- The group members were, in no particular order:
-- Eirik Kongsparten, Hamsa Hashi and Erik Sebastian Nyborg-Vazquez.
-- The code was written in Ada 2024.

-- Some comments will refer to the report, especially for the equations.
-- All comments are in English, so is the report. Comments will not be perfect, and I might be wrong about some things. How to be human.

-- Motors are connected such as: M1 = Left Back, M2 = Left Front, M3 = Right Back, M4 = Right Front

-- When speaking of vectors, it is in mathematical terms, and not in programming terms. All conatainers are arrays.
--------------------------------------------------------------

-- main prosess is not a part of the real time system, but is used to start Sense, Think and Act
procedure Main is
begin
   loop
      delay 100.0;
   end loop;
end Main;
