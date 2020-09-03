------------------------------------------
------------------------------------------
-- Date        : Thu Sep 03 14:53:26 2020
--
-- Author      : 
--
-- Company     : 
--
-- Description : 
--------------------------------------------
------------------------------------------
library ieee;
use ieee.STD_LOGIC_1164.all;

architecture  wekker_arch  of ALARMCLOCK   is

signal counter_secs, counter_mins, wake_mins: integer range 0 to 5;--integer(5 downto 0); --only 6 bits are needed to be able to count to 60
signal counter_hours, wake_hours: integer range 0 to 4; --only 5 bits needed for hour counter
signal display_1, display_2, display_3, display_4: integer range 3 to 0; --only 4 bits per display are needed.
    begin        
    
    process(clock, counter_secs, counter_mins, counter_hours, Adjust ) 
        begin
        if rising_edge(clock) then
            counter_secs <= counter_secs +1;
            if (counter_secs > 60) then
                counter_secs <=0;
                counter_mins <= counter_mins +1;
                if (counter_mins > 60) then
                    counter_mins <= 0;
                    counter_hours <= counter_hours +1;
                    if(counter_hours >24) then 
                        counter_hours <=0;
                    end if;               
                end if;
            end if;
        end if;
    end process;
    --counter
        
    process(Dselect, Display_select, Display_data,Adjust,display_1, display_2, display_3, display_4)
    --this process switches displays
    begin
        --TODO give Display select an initial value to be able to rotate here
        if rising_edge(Dselect) then
            --first turn dispplays off
            --then switch display and show data
            Display_data <= '0000';
            Display_select ror 1;
            --add logic for displaydata
           case Display_data is
            when "0111" =>
                --display 1
            when "1011"=>
            --display 2
            when "1101" =>
            --display 3
            
            when "1110" =>
            --display 4
        end case;
    end process;
    
    
end wekker_arch;
