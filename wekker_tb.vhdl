library ieee;
use ieee.STD_LOGIC_1164.all;

entity wekker_tb is
end wekker_tb;

architecture test of wekker_tb is
  component ALARMCLOCK 
    port( Alarm, Snooze, Minute, Hour, Clock, Dselect: in std_logic;
         Adjust: in std_logic_vector(1 downto 0);
         Buzz, led: out std_logic;
         Display_data, Display_select: out std_logic_vector(3 downto 0));
  end component;

--  wekker0:ALARMCLOCK use entity work.ALARMCLOCK;
  signal Alarm_tb, Snooze_tb, Minute_tb, Hour_tb, Clock_tb, Dselect_tb: std_logic;
  signal Adjust_tb: std_logic_vector(1 downto 0) := "00";
  signal Buzz_tb, led_tb:  std_logic;
  signal Display_data_tb: std_logic_vector(3 downto 0) := "0000";
    signal Display_select_tb: std_logic_vector(3 downto 0) := "0000";

begin
  test: ALARMCLOCK  port map(Display_select => Display_select_tb, Alarm => Alarm_tb, Snooze =>Snooze_tb, Minute => Minute_tb, Hour=> Hour_tb, Clock=> Clock_tb, Dselect =>Dselect_tb, Adjust => Adjust_tb, Buzz => Buzz_tb, led=> led_tb, Display_data=>Display_data_tb);

  master_clck: process is
  begin
    Clock_tb <= '0';
    wait for 50 ns;
    Clock_tb <= '1';
    wait for 50 ns;
  end process master_clck;

  time_keeping: process is
  begin
    Alarm_tb <= '0';
    Adjust_tb <= "00";
    Buzz_tb <= '0';
    Snooze_tb <= '0';
    Minute_tb <= '0';
    Hour_tb <= '0';
    Dselect_tb <='0';
    Display_data_tb <= "0000";
    Display_select_tb <= "0000";
    
    wait for 6200  ns;
    Dselect_tb <= '1';
    assert Display_select_tb = "1110" report "display display select is wrong" severity note;
    assert Display_data_tb = "0001" report " counter is wrong" severity note;
    
    wait;
  end process time_keeping;
end;
