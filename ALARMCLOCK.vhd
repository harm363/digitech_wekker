------------------------------------------
------------------------------------------
-- Date        : Thu Sep 03 14:53:20 2020
--
-- Author      : Harm Hongerkamp        
--
-- Company     : 
--
-- Description : architecture off alarmclock project.
--
------------------------------------------
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity  ALARMCLOCK  is
    port( Alarm, Snooze, Minute, Hour, Clock, Dselect: in std_logic;
         Adjust: in std_logic_vector(1 downto 0);
         Buzz, led: out std_logic;
         Display_data:out std_logic_vector(3 downto 0);
         Display_select: out std_logic_vector(3 downto 0));
    
end ALARMCLOCK;
