entity bus_interconnect is
    generic (
        N    : integer := 4;
        WIDTH: integer := 32;
        SELW : integer := 2
    );
    port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        addr  : in  STD_LOGIC_VECTOR(31 downto 0);
        wr_en : in  STD_LOGIC;
        rd_en : in  STD_LOGIC;
        wdata : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        rdata : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end bus_interconnect;


architecture Behavioral of bus_interconnect is
    signal sel        : STD_LOGIC_VECTOR(SELW-1 downto 0);
    signal slave_rdata: STD_LOGIC_VECTOR(N*WIDTH-1 downto 0);
    signal slave_we   : STD_LOGIC_VECTOR(N-1 downto 0);
    signal slave_re   : STD_LOGIC_VECTOR(N-1 downto 0);
begin

    -- Address decoding
    decoder: entity work.addr_decoder
        generic map(N=>N, SELW=>SELW)
        port map(addr => addr, sel => sel);

    -- Write/Read enable per slave
    gen_we_re: for i in 0 to N-1 generate
        slave_we(i) <= '1' when (wr_en='1' and sel = std_logic_vector(to_unsigned(i, SELW))) else '0';
        slave_re(i) <= '1' when (rd_en='1' and sel = std_logic_vector(to_unsigned(i, SELW))) else '0';
    end generate;

    -- Instantiate slaves
    gen_slave: for i in 0 to N-1 generate
        slave_inst: entity work.slave_reg
            port map(
                clk   => clk,
                rst   => rst,
                wr_en => slave_we(i),
                rd_en => slave_re(i),
                wdata => wdata,
                rdata => slave_rdata((i+1)*WIDTH-1 downto i*WIDTH)
            );
    end generate;

    -- Read mux
    read_mux: entity work.muxNto1
        generic map(WIDTH=>WIDTH, N=>N, SELW=>SELW)
        port map(D=>slave_rdata, SEL=>sel, Y=>rdata);

end Behavioral;
