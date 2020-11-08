entity wekker_tb is
end wekker_tb;

architecture test of wekker_tb is
  component ALARMCLOCK
    port( Alarm, Snooze, Minute, Hour, Clock, Dselect: in std_logic;
         Adjust: in std_logic_vector(1 downto 0);
         Buzz, led: out std_logic;
         Display_data, Display_select: out std_logic_vector(3 downto 0));
  end component;
  
begin
  
  master_clck: process is
  begin
    Clock <= '1';
    wait for 100ns;
    Clock <= '0';
    wait for 100ns;
  end process;

  
