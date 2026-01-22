library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity muxNto1 is
    generic (
        WIDTH : integer := 32;
        N     : integer := 4;
        SELW  : integer := 2
    );
    port (
        D   : in  STD_LOGIC_VECTOR(N*WIDTH-1 downto 0);
        SEL : in  STD_LOGIC_VECTOR(SELW-1 downto 0);
        Y   : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end muxNto1;

architecture Behavioral of muxNto1 is
begin
    process(D, SEL)
        variable index : integer;
    begin
        index := to_integer(unsigned(SEL));
        if index < N then
            Y <= D((index+1)*WIDTH-1 downto index*WIDTH);
        else
            Y <= (others => '0');
        end if;
    end process;
end Behavioral;
