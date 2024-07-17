library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_rom is
  generic (
    ADDR_WIDTH : natural := 12;
    DATA_WIDTH : natural := 8
  );
  port (
    -- clock
    clk : in std_logic;

    -- chip select
    cs : in std_logic := '1';

    -- address
    addr : in unsigned(ADDR_WIDTH-1 downto 0);

    -- data out
    dout : out std_logic_vector(DATA_WIDTH-1 downto 0);

    -- write enable
    we : in std_logic := '0'
  );
end single_port_rom;

architecture arch of single_port_rom is
    type rom is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory : rom;
begin
  
  process(clk)
  begin
    if rising_edge(clk) then
      if (we = '1') then
        memory(to_integer(unsigned(addr))) <= x"CA";
      else
        dout <= memory(to_integer(unsigned(addr)));
      end if;
    end if;
  end process;

end architecture;
