entity addr_decoder is
    generic (
        N    : integer := 4;
        SELW : integer := 2
    );
    port (
        addr : in  STD_LOGIC_VECTOR(31 downto 0);
        sel  : out STD_LOGIC_VECTOR(SELW-1 downto 0)
    );
end addr_decoder;

architecture Behavioral of addr_decoder is
begin
    process(addr)
    begin
        case addr(13 downto 12) is  -- 4KB spacing per slave
            when "00" => sel <= "00";
            when "01" => sel <= "01";
            when "10" => sel <= "10";
            when "11" => sel <= "11";
            when others => sel <= (others => '0');
        end case;
    end process;
end Behavioral;
