library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bus_interconnect is
end tb_bus_interconnect;

architecture sim of tb_bus_interconnect is
    signal clk, rst   : std_logic := '0';
    signal addr       : std_logic_vector(31 downto 0);
    signal wr_en, rd_en: std_logic;
    signal wdata      : std_logic_vector(31 downto 0);
    signal rdata      : std_logic_vector(31 downto 0);
begin
    uut: entity work.bus_interconnect
        port map(clk=>clk, rst=>rst, addr=>addr, wr_en=>wr_en, rd_en=>rd_en, wdata=>wdata, rdata=>rdata);

    -- Clock
    clk_proc: process
    begin
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    -- Test sequence
    test_proc: process
    begin
        rst <= '1'; wait for 10 ns;
        rst <= '0';

        -- Write 0xAAAA to slave 0
        addr <= x"00000000"; wdata <= x"AAAA"; wr_en <= '1'; rd_en <= '0'; wait for 10 ns;
        wr_en <= '0'; wait for 10 ns;

        -- Write 0x5555 to slave 1
        addr <= x"00001000"; wdata <= x"5555"; wr_en <= '1'; wait for 10 ns;
        wr_en <= '0'; wait for 10 ns;

        -- Read slave 0
        addr <= x"00000000"; rd_en <= '1'; wait for 10 ns;
        assert rdata = x"0000AAAA" report "Slave0 read failed" severity error;
        rd_en <= '0'; wait for 10 ns;

        -- Read slave 1
        addr <= x"00001000"; rd_en <= '1'; wait for 10 ns;
        assert rdata = x"00005555" report "Slave1 read failed" severity error;
        rd_en <= '0'; wait for 10 ns;

        wait;
    end process;
end sim;
