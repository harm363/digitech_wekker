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
use ieee.numeric_std.all;



architecture  wekker_arch  of ALARMCLOCK   is
  signal counter_secs, counter_mins,counter_hours, wake_mins, snooze_mins, tmp_sec: std_logic_vector(7 downto 0) := "00000000";
--with 8 bits a bcd counter from 0 to 100 is possible. 
  --signal counter_hours: integer;-- range 0 to 24; --(4 downto 0);
  signal display_1, display_2, display_3, display_4: std_logic_vector(3 downto 0); --only 4 bits per display are needed.
  signal sel_display : std_logic_vector (3 downto 0):= "0111" ;
  signal tmp_led: std_logic := '0';
--  signal test :integer range 0 to 3;
  

--function to count from 0 to 59
function counter (A: std_logic_vector (7 downto 0))
  return  std_logic_vector is
  
  variable tmp1, tmp2, tmp3: std_logic;
  variable B : std_logic_vector(7 downto 0) := "00000000";
  --variable C : std_logic_vector(7 downto 0);
begin
  B := A(7 downto 0);
  B(0) := A(0) xor '1';
  tmp1 := A(0) and '1';
  
  tmp2 := tmp1 and A(1) ;
  B(1) := tmp1  xor A(1);
  
  tmp3 := tmp2 and A(2);
  B(2) := tmp2 xor A(2);
  
 --tmp4 := tmp3 and A(3);
  B(3) := A(3) xor tmp3;
--now for the BCD count 
  if( B(3 downto 0) = "1010") then
    B := B and "11110000"; -- set first for digits 0  
    tmp1 := A(4) and '1';
    B(4) := A(4) xor '1';
    tmp2 := tmp1 and A(5) ;
    B(5) := tmp1  xor A(5);
    tmp3 := tmp2 and A(6);
    B(6) := tmp2 xor A(6);
    --tmp4 := tmp3 and A(3);
    B(7) := A(7) xor tmp3;
  end if;
  if (B(7 downto 4) = "0110") then
    B := B and "00001111";
  end if;
   
  return B;
end counter;

begin
-- counter process, this process calculates the new time on every clocksignal    
    process(clock, Adjust, counter_secs, counter_mins, counter_hours) 
        begin
        if rising_edge(clock) and clock = '1' then
          --     create an adder for counter secs
          counter_secs <= counter(counter_secs);
            if (counter_secs = "01011001") then
              counter_mins <= counter(counter_mins);
              if(counter_mins = "01011001") then
                counter_hours <= counter(counter_hours);
              end if; 
            end if;
            if(Adjust /= "00") then
              tmp_led <= tmp_led xor '1';
              led <= tmp_led;
            else
              led <= '0';
            end if;
        end if;
    end process;
    --counter

--display process, this process handles all the display action on the display kloksignal.
    process(Dselect, sel_display, display_1, display_2, display_3, display_4)
    --this process switches displays
    begin
        
      if rising_edge(Dselect) and Dselect = '1' then
            --first turn dispplays off
            --then switch display and show data
        --add logic     for displaydata
        --Display_select <= "1111";
           case sel_display is
             when "0111" =>
               sel_display <= "1110";
               Display_select <= sel_display;
               Display_data <= display_1;
             when "1011"=>
               sel_display <= "0111";
               Display_select <= sel_display;
              Display_data <=display_4;
             when "1101" =>
               sel_display <= "1011";
               Display_select <= sel_display;
               Display_data <= display_3;
             when "1110" =>
               sel_display <= "1101";
               Display_select <= sel_display;
               Display_data <= display_2;
             when others=>
               sel_display <= "1110";
           end case;
        end if;
    end process;

--this is the main process
process (Adjust, Alarm, clock, display_1, display_2, display_3, display_4, counter_mins, counter_hours )-- counter_mins, counter_hours
begin
  --start with display setup
  --if adjust is 01 the wake time is to be showed, else the current time
  --maybe move next but of code to the display process because of the halting
  --propertie of the time adjuster.
  if (Adjust = "01" ) then
   -- wake_hours <= saved_hours;
   -- wake_mins <= saved_mins;
    display_2 <= counter_mins(7 downto 4);
    display_1 <= counter_mins(3 downto 0);
    display_4 <= counter_hours(7 downto 4);
    display_3 <= counter_hours(3 downto 0);
    if(hour = '1' and Minute ='1') then
      --wake_hours <= 0;
      --wake_mins <= 0;
    end if;
    --  Adjust is set to time changer
    if (Hour = '1') then
--      wake_hours <= wake_hours +1;
      while Hour = '1' loop
        end loop;
    end if;     
    if (Minute = '1') then
     -- wake_mins <= wake_mins +1;
      while Minute = '1' loop
      end loop;
    end if;
   -- saved_hours <= wake_hours;
    --saved_mins <= wake_mins;
  
 -- else
 --   display_2 <= counter_mins/10;
 --   display_1 <= counter_mins-display_2;
 --   display_4 <= counter_hours/10;
 --   display_3 <= counter_hours-display_4;
 end if;
  
  if (Adjust = "10" ) then
    if(hour = '1' and Minute ='1') then
      --this is not goint to work in real life, must be rewritten..
    --     counter_hours <= 0;
    --     counter_mins<= 0;
         while (hour = '1' and Minute = '1') loop
           end loop;
    end if;
    --Adjust is set to time changer
    if (Hour = '1') then
--      counter_hours <= counter_hours +1;
      while  Hour = '1' loop
        end loop;
    end if;
    if (Minute = '1') then
  --    counter_mins <= counter_mins +1;
      while Minute = '0' loop
        end loop;
    end if;
  end if; 
       
--ALARMCLOCKclock code:
--  if(Alarm = '1') then
--    if (counter_hours = wake_hours and counter_mins = wake_mins) then
--      Buzz <= '1';    
--    end if;
--    if (Buzz = '1' and Snooze = '1') then 
--      Buzz <= '0';
      --set an alternative alarm time 10 min after the snooze button is hit.
--      wake_mins <= wake_mins+10;
--      if (wake_mins > 59) then
--        wake_mins <= wake_mins-60;
--      end if;
--      if(wake_hours > 23) then
--        wake_hours <= 0;
--      end if;     
--    end if;
--  else
--  wake_hours <= saved_hours;
--  wake_mins <= saved_mins;
-- end if;
end process;
end architecture;

