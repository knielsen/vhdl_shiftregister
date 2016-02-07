library IEEE;
use IEEE.std_logic_1164.all;

entity shift_elem is
  port ( Din   : in   std_logic;
         Dout  : out  std_logic;
         O     : out  std_logic;
         Latch : in   std_logic;
         Clock : in   std_logic);
end shift_elem;

architecture BEHAVIORAL of shift_elem is
  signal tmp : std_logic;
begin
  process(clock)
  begin
    if (clock = '1' and clock'EVENT) then
    tmp <= Din;
    end if;
  end process;

  Dout <= tmp;

  process(latch)
  begin
    if (latch = '1' and latch'EVENT) then
      O <= tmp;
    end if;
  end process;
end architecture BEHAVIORAL;
