----------------------------------0--------
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

  signal counter_secs, counter_mins, wake_mins, snooze_mins: integer range 0 to 5;--integer(5 downto 0); --only 6 bits are needed to be able to count to 60
  signal saved_hours, saved_mins: integer range 0 to 5; 
signal counter_hours, wake_hours: integer range 0 to 4; --only 5 bits needed for hour counter
signal display_1, display_2, display_3, display_4: integer range 3 to 0; --only 4 bits per display are needed.
    begin        
-- counter process, this process calculates the new time on every clocksignal    
    process(clock, counter_secs, counter_mins, counter_hours, Adjust ) 
        begin
        if rising_edge(clock) then
            counter_secs <= counter_secs +1;
            if (counter_secs > 59) then
                counter_secs <=0;
                counter_mins <= counter_mins +1;
                if (counter_mins > 59) then
                    counter_mins <= 0;
                    counter_hours <= counter_hours +1;
                    if(counter_hours >23) then 
                        counter_hours <=0;
                    end if;               
                end if;
            end if;
            if(Adjust /= "00") then
              LED <= LED xor '1';
            else
              LED <= '0';
            end if;
        end if;
    end process;
    --counter

--display process, this process handles all the display action on the display kloksignal.
    process(Dselect, Adjust, Display_select, Display_data,display_1, display_2, display_3, display_4)
    --this process switches displays
    begin
        --TODO give Display select an initial value to be able to rotate here
      if rising_edge(Dselect) then
            --first turn dispplays off
            --then switch display and show data
            Display_select := Display_select ror 1;
            --add logic for displaydata
           case Display_select is
            when "0111" =>
                Display_data <= display_1;
            when "1011"=>
              Display_data <= display_2;
            when "1101" =>
              Display_data <= display_3;
            when "1110" =>
              Display_data <= display_4;
           end case;
        end if;
    end process;

--this is the main process
process (Adjust, counter_secs, counter_mins, counter_hours, Alarm, Buzz, clock )
begin
  --start with display setup
  --if adjust is 01 the wake time is to be showed, else the current time
  --maybe move next but of code to the display process because of the halting
  --propertie of the time adjuster.
  if (Adjust = "01" ) then
    wake_hours <= saved_hours;
    wake_mins <= saved_mins;
    display_2 <= wake_mins/10;
    display_1 <= wake_mins-display_2;
    display_4 <= wake_hours/10;
    display_3 <= wake_hours-display_4;
    if(hour = '1' and Minute ='1') then
      wake_hours <= 0;
      wake_mins <= 0;
    end if;
    --  Adjust is set to time changer
    if (Hour = '1') then
      wake_hours <= wake_hours +1;
      wait until Hour = '0';
    end if;     
  if (Minute = '1') then
    wake_mins <= wake_mins +1;
    wait until Minute = '0';
  end if;
  saved_hours <= wake_hours;
  saved_mins <= wake_mins;
  
  else
    display_2 <= counter_mins/
    display_1 <= counter_mins-display_2;
    display_4 <= counter_hours/10;
    display_3 <= counter_hours-display_4;
  end if;
  
  if (Adjust = "10" ) then
    if(hour = '1' and Minute ='1') then
      --this is not goint to work in real life, must be rewritten..
         counter_hours <= 0;
         counter_mins<= 0;
         wait until (hour = '0' and Minute = '0');
    end if;
    --Adjust is set to time changer
    if (Hour = '1') then
      counter_hours <= counter_hours +1;
      wait until Hour = '0';
    end if;
    if (Minute = '1') then
      counter_mins <= counter_mins +1;
      wait until Minute = '0';
    end if;
  end if; 
       
--ALARMCLOCKclock code:
  if(ALARMCLOCKclock = '1') then
    if (counter_hours = wake_hours and counter_mins = wake_mins) then
      Buzz <= '1';    
    end if;
    if (Buzz = '1' and Snooze = '1') then 
      Buzz <= '0';
      --set an alternative alarm time 10 min after the snooze button is hit.
      wake_mins <= wake_mins+10;
      if (wake_mins > 59) then
        wake_mins <= wake_mins-60;
      end if;
      if(wake_hours > 23) then
        wake_hours <= 0;
      end if;     
    end if;
  else
  wake_hours <= saved_hours;
  wake_mins <= saved_mins;
end if;

  
end process;

end architecture;

