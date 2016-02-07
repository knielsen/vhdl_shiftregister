library IEEE;
use IEEE.std_logic_1164.all;

entity shift_register is
  port ( Din   : in   std_logic;
         Dout  : out  std_logic;
         O     : out  std_logic_vector (7 downto 0);
         Latch : in   std_logic;
         Clock : in   std_logic);
end shift_register;

architecture BEHAVIORAL of shift_register is
  component shift_elem
    port ( Din   : in   std_logic;
           Dout  : out  std_logic;
           O     : out  std_logic;
           Latch : in   std_logic;
           Clock : in   std_logic);
  end component;

  signal ic : std_logic_vector(8 downto 0);
begin
  ic(8) <= Din;

  Build: for i in 7 downto 0 generate
    elem: shift_elem port map( Din => ic(i+1),
                               Dout => ic(i),
                               O => O(i),
                               Latch => Latch,
                               Clock => Clock);
    -- ToDo: Do we need to do something here to respect hold time?
    -- Otherwise, in case of clock skew, might we propagate a bit two
    -- elements at a time, in case Dout(i+1) flips fast enough that
    -- the clock edge of Din(i) picks up the new value?
    -- One way could be to update ic(i) or Dout(i) on the falling edge
    -- of the clock...
  end generate build;

  Dout <= ic(0);
end architecture BEHAVIORAL;
