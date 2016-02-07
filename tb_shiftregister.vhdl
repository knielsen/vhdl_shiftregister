library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity tb_shiftregister is
end tb_shiftregister;

architecture testrun of tb_shiftregister is
  signal Din : std_logic;
  signal Dout : std_logic;
  signal outputs : std_logic_vector(7 downto 0);
  signal Latch : std_logic;
  signal Clock : std_logic;

  component shift_register
    port ( Din   : in   std_logic;
           Dout  : out  std_logic;
           O     : out  std_logic_vector(7 downto 0);
           Latch : in   std_logic;
           Clock : in   std_logic);
  end component;

begin
  UUT : shift_register
    port map (Din, Dout, outputs, Latch, Clock);

  testbed : block
  begin
  process
    -- 25 ns clock half-pulse width -> 20 MHz.
    constant DEL : time := 25 ns;
    variable L : Line;

    procedure step_clock is
    begin
      wait for DEL;
      Clock <= '1';
      wait for DEL;
      Clock <= '0';
    end procedure step_clock;

    procedure shift_word(constant word : in bit_vector) is
    begin
      for i in word'reverse_range loop
        Din <= to_stdulogic(word(i));
        step_clock;
      end loop;
    end procedure shift_word;

  begin
    Din <= '0';
    Clock <= '0';
    Latch <= '0';
    wait for DEL;

    write(L, string'("Testing shift register"));
    writeline(OUTPUT, L);

    shift_word("00000010");
    write(L, string'("Dout=")); write(L, Dout); writeline(OUTPUT, L);
    assert (Dout = '0') report "Leading 0 bit not visible on Dout" severity error;

    Din <= '1';
    step_clock;
    write(L, string'("Dout=")); write(L, Dout); writeline(OUTPUT, L);
    assert (Dout = '1') report "Following 1 bit not visible on Dout" severity error;

    Latch <= '1';
    wait for 2*DEL;
    Latch <= '0';
    write(L, string'("outputs=")); write(L, outputs); writeline(OUTPUT, L);
    assert (outputs = "10000001") report "Incorrect output after latch" severity error;
    assert (Dout = '1') report "Incorrect value on Dout" severity error;

    Din <= '1';
    step_clock;
    assert (Dout = '0') report "Incorrect value on Dout" severity error;
    assert (outputs = "10000001") report "Outputs changed without latch" severity error;

    Latch <= '1';
    wait for 2*DEL;
    Latch <= '0';
    write(L, string'("Dout=")); write(L, Dout); writeline(OUTPUT, L);
    assert (Dout = '0') report "Incorrect value on Dout" severity error;
    write(L, string'("outputs=")); write(L, outputs); writeline(OUTPUT, L);
    assert (outputs = "11000000") report "Outputs not correct after latch" severity error;

    shift_word("00000000");
    step_clock;
    step_clock;
    shift_word("00000111");
    Latch <= '1';
    wait for 2*DEL;
    Latch <= '0';
    write(L, string'("Dout=")); write(L, Dout); writeline(OUTPUT, L);
    assert (Dout = '1') report "Incorrect value on Dout" severity error;
    write(L, string'("outputs=")); write(L, outputs); writeline(OUTPUT, L);
    assert (outputs = "00000111") report "Outputs not correct after latch" severity error;

    write(L, string'("==== end of test ===="));
    writeline(OUTPUT, L);
  end process;
  end block testbed;
end architecture testrun;
