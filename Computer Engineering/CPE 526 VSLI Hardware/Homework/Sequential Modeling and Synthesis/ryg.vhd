use WORK.all;
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use std.TEXTIO.all;

entity RYG is
port(CLK : in std_logic;
    RS : in std_logic_vector(1 downto 0);
    LI : out std_logic_vector(2 downto 0));
end RYG;

architecture SWITCH of RYG is
  type STATE_TYPE is (R0, Y1, G2, G3, G4); -- R0 for red, Y1 for yellow, G2 for green. G3, G4, G5 for waiting
  signal START_REQ : std_logic;
  signal STATE: STATE_TYPE;
begin

STR : process(CLK, RS(0))
begin
  if(RS(0) = '0') then
    START_REQ <= '1';
  elsif(CLK'event and CLK = '1') then 
    if(STATE /= R0) then
      START_REQ <= '0';
    end if;
  end if;
end process;

CONTROL : process (CLK, RS(1))
begin
  if(RS(1) = '0') then
    STATE <= R0;
  elsif (CLK'event and CLK = '1' and START_REQ = '1') then
    case STATE is
      when R0 => 
        STATE <= Y1; -- Next state is Y1 (yellow)
      when Y1 => 
        STATE <= G2; -- Next state is G2 (green)                       
      when G2 => 
        STATE <= G3; -- Next state is G3 (green)
      when G3 =>
        STATE <= G4; -- Next state is G4 (green)   
      when G4 =>
        STATE <= R0; -- Next state is R0 (red)        
    end case;    
  end if;
end process CONTROL;

OUTPUT: process (STATE, CLK)  -- Here is where we need to add the time delay. 
begin
    case STATE is
      when R0 =>      -- Red is active
        LI <= "100";
      when Y1 =>      -- Yellow is active
        LI <= "010";
      when G2 =>      -- Green is active (1s)
        LI <= "001";
      when G3 =>      -- Green is active (2s)
        LI <= "001";
      when G4 =>      -- Green is active (3s)
        LI <= "001";
    end case;
end process OUTPUT;
end SWITCH;