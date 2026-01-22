library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu is
end tb_alu;

architecture sim of tb_alu is
    signal A, B: std_logic_vector(31 downto 0);
    signal OP: std_logic_vector(4 downto 0);
    signal SIGNED_OP: std_logic;
    signal Y: std_logic_vector(31 downto 0);
    signal Zero, Carry, Overflow, Negative, Parity: std_logic;
begin

    uut: entity work.alu
        port map(A=>A, B=>B, OP=>OP, SIGNED_OP=>SIGNED_OP,
                 Y=>Y, Zero=>Zero, Carry=>Carry, Overflow=>Overflow, Negative=>Negative, Parity=>Parity);

    process
    begin
        SIGNED_OP <= '1';
        -- Signed ADD
        A <= x"00000005"; B <= x"FFFFFFFD"; OP <= "00000"; wait for 10 ns;
        assert Y = x"00000002" report "Signed ADD failed" severity error;

        -- Rotate
        A <= x"80000001"; OP <= "01000"; wait for 10 ns;  -- ROL
        assert Y = x"00000003" report "ROL failed" severity error;

        A <= x"80000001"; OP <= "01001"; wait for 10 ns;  -- ROR
        assert Y = x"C0000000" report "ROR failed" severity error;

        -- Multiply
        A <= x"00000004"; B <= x"00000005"; OP <= "01011"; wait for 10 ns;
        assert Y = x"00000014" report "MUL failed" severity error;

        -- Divide
        A <= x"00000010"; B <= x"00000004"; OP <= "01100"; wait for 10 ns;
        assert Y = x"00000004" report "DIV failed" severity error;

        wait;
    end process;

end sim;
