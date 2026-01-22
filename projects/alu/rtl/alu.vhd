library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    generic (
        WIDTH : integer := 32   -- Operand width
    );
    port (
        A        : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        B        : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        OP       : in  STD_LOGIC_VECTOR(4 downto 0);  -- 5-bit for extended ops
        SIGNED_OP: in  STD_LOGIC := '0';              -- 1: signed operations
        Y        : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        Zero     : out STD_LOGIC;
        Carry    : out STD_LOGIC;
        Overflow : out STD_LOGIC;
        Negative : out STD_LOGIC;
        Parity   : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is

    signal A_int, B_int       : unsigned(WIDTH-1 downto 0);
    signal A_s, B_s           : signed(WIDTH-1 downto 0);
    signal res_int            : unsigned(WIDTH-1 downto 0);
    signal tmp_res            : unsigned(WIDTH downto 0);  -- for carry
    signal mul_res            : unsigned(2*WIDTH-1 downto 0);
    signal div_quot, div_rem  : unsigned(WIDTH-1 downto 0);

begin

    -- Convert inputs
    A_int <= unsigned(A);
    B_int <= unsigned(B);
    A_s   <= signed(A);
    B_s   <= signed(B);

    process(A_int, B_int, A_s, B_s, OP, SIGNED_OP)
        variable result_tmp : unsigned(WIDTH-1 downto 0);
    begin
        -- Default outputs
        res_int   <= (others => '0');
        tmp_res   <= (others => '0');
        Carry     <= '0';
        Overflow  <= '0';

        case OP is
            -- Arithmetic
            when "00000" =>  -- ADD
                if SIGNED_OP='1' then
                    tmp_res <= ('0' & unsigned(A_s + B_s));
                else
                    tmp_res <= ('0' & (A_int + B_int));
                end if;
                res_int  <= tmp_res(WIDTH-1 downto 0);
                Carry    <= tmp_res(WIDTH);
                Overflow <= tmp_res(WIDTH) xor tmp_res(WIDTH-1);

            when "00001" =>  -- SUB
                if SIGNED_OP='1' then
                    tmp_res <= ('0' & unsigned(A_s - B_s));
                else
                    tmp_res <= ('0' & (A_int - B_int));
                end if;
                res_int  <= tmp_res(WIDTH-1 downto 0);
                Carry    <= tmp_res(WIDTH);
                Overflow <= tmp_res(WIDTH) xor tmp_res(WIDTH-1);

            -- Logical
            when "00010" => res_int <= A_int and B_int;
            when "00011" => res_int <= A_int or B_int;
            when "00100" => res_int <= A_int xor B_int;
            when "00101" => res_int <= not A_int;

            -- Shift
            when "00110" => res_int <= A_int sll 1;
            when "00111" => res_int <= A_int srl 1;

            -- Rotate
            when "01000" =>  -- ROL
                res_int <= A_int(WIDTH-2 downto 0) & A_int(WIDTH-1);
            when "01001" =>  -- ROR
                res_int <= A_int(0) & A_int(WIDTH-1 downto 1);

            -- Pass B
            when "01010" => res_int <= B_int;

            -- Multiply (pipelined)
            when "01011" =>
                mul_res <= A_int * B_int;  -- unsigned multiply
                res_int <= mul_res(WIDTH-1 downto 0);

            -- Divide (pipelined)
            when "01100" =>
                if B_int /= 0 then
                    div_quot <= A_int / B_int;
                    div_rem  <= A_int mod B_int;
                else
                    div_quot <= (others=>'0');
                    div_rem  <= (others=>'0');
                end if;
                res_int <= div_quot;

            when others =>
                res_int <= (others=>'0');
        end case;

        -- Flags
        Zero     <= '1' when res_int = 0 else '0';
        Negative <= res_int(WIDTH-1);
        Parity   <= '1' when (res_int xor res_int(WIDTH-2 downto 0)) = (others=>'0') else '0'; -- simple parity
    end process;

    Y <= std_logic_vector(res_int);

end Behavioral;
