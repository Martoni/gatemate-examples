--   __   __     __  __     __         __
--  /\ "-.\ \   /\ \/\ \   /\ \       /\ \
--  \ \ \-.  \  \ \ \_\ \  \ \ \____  \ \ \____
--   \ \_\\"\_\  \ \_____\  \ \_____\  \ \_____\
--    \/_/ \/_/   \/_____/   \/_____/   \/_____/
--   ______     ______       __     ______     ______     ______
--  /\  __ \   /\  == \     /\ \   /\  ___\   /\  ___\   /\__  _\
--  \ \ \/\ \  \ \  __<    _\_\ \  \ \  __\   \ \ \____  \/_/\ \/
--   \ \_____\  \ \_____\ /\_____\  \ \_____\  \ \_____\    \ \_\
--    \/_____/   \/_____/ \/_____/   \/_____/   \/_____/     \/_/
--
-- https://joshbassett.info
-- https://twitter.com/nullobject
-- https://github.com/nullobject
--
-- Copyright (c) 2020 Josh Bassett
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    ext_clk : in std_logic;
    led : out std_logic_vector(7 downto 0);
    rst : in std_logic -- /!\ inversé -> rst_n
  );
end top;

architecture arch of top is

  component CC_PLL is
  generic (
      REF_CLK         : string;  -- reference input in MHz
      OUT_CLK         : string;  -- pll output frequency in MHz
      PERF_MD         : string;  -- LOWPOWER, ECONOMY, SPEED
      LOW_JITTER      : integer; -- 0: disable, 1: enable low jitter mode
      CI_FILTER_CONST : integer; -- optional CI filter constant
      CP_FILTER_CONST : integer  -- optional CP filter constant
  );
  port (
      CLK_REF             : in  std_logic;
      USR_CLK_REF         : in  std_logic;
      CLK_FEEDBACK        : in  std_logic;
      USR_LOCKED_STDY_RST : in  std_logic;
      USR_PLL_LOCKED_STDY : out std_logic;
      USR_PLL_LOCKED      : out std_logic;
      CLK0                : out std_logic;
      CLK90               : out std_logic;
      CLK180              : out std_logic;
      CLK270              : out std_logic;
      CLK_REF_OUT         : out std_logic
  );
  end component;
 
  signal n : natural range 0 to 255;
  signal cen : std_logic;
  signal clk : std_logic;

begin

  socket_pll : CC_PLL
  generic map (
      REF_CLK         => "10.0",
      OUT_CLK         => "100.0",
      PERF_MD         => "ECONOMY",
      LOW_JITTER      => 1,
      CI_FILTER_CONST => 2,
      CP_FILTER_CONST => 4
  )
  port map (
      CLK_REF             => ext_clk,
      USR_CLK_REF         => '0',
      CLK_FEEDBACK        => '0',
      USR_LOCKED_STDY_RST => '0',
      USR_PLL_LOCKED_STDY => open,
      USR_PLL_LOCKED      => open,
      CLK0                => clk,
      CLK90               => open,
      CLK180              => open,
      CLK270              => open,
      CLK_REF_OUT         => open
  );

  clock_divider : entity work.clock_divider
  generic map (DIVISOR => 5000000)
  port map (clk => clk, cen => cen);

  counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        led <= x"AA";
        n <= 0;
      elsif cen = '1' then
        n <= n + 1;
        led <= std_logic_vector(to_unsigned(n, led'length));
      end if;
    end if;
  end process;
end arch;
