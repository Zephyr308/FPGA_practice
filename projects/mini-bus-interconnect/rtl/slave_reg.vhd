entity slave_reg is
    port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        wr_en : in  STD_LOGIC;
        rd_en : in  STD_LOGIC;
        wdata : in  STD_LOGIC_VECTOR(31 downto 0);
        rdata : out STD_LOGIC_VECTOR(31 downto 0)
    );
end slave_reg;

architecture Behavioral of slave_reg is
    signal reg : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                reg <= (others => '0');
            elsif wr_en = '1' then
                reg <= wdata;
            end if;
        end if;
    end process;

    rdata <= reg when rd_en = '1' else (others => '0');
end Behavioral;
