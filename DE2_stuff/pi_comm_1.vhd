library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pi_comm_1 is
port (
   clock_50: in std_logic;
   key: in std_logic_vector(3 downto 0);
   
	gpio_0: inout std_logic_vector(35 downto 0);
	
	ledg: out std_logic_vector(7 downto 0); --
	ledr: out std_logic_vector(17 downto 0)
);
end pi_comm_1;

architecture behavioural of pi_comm_1 is
	signal reset: std_logic;
	signal valid_in, valid_out: std_logic;
	signal ack_in, ack_out: std_logic;
	signal data_in: std_logic_vector(7 downto 0);
	signal data_out : std_logic_vector(6 downto 0);
	signal done_in, done_out: std_logic;
	signal send, user_add : std_logic;
	
begin
	
	reset <= not key(0);
	send <= gpio_0(0);
	
	 data_in <= '0' & gpio_0(17 downto 11);
	 gpio_0(35 downto 29) <= data_out;
	
	 ack_in <= gpio_0(26);
	 gpio_0(23) <= ack_out;
	
	 valid_in <= gpio_0(24);
	 gpio_0(27) <= valid_out;
	
	 done_in <= gpio_0(25);
	 gpio_0(28) <= done_out;
	
process(clock_50, reset)
		type state_types is (idle, r_letter_1, r_letter_2, r_letter_3, r_letter_4, 
									s_letter_1, send_letter, wait_state, wait_state_1, wait_state_2, wait_state_3, wait_state_4, check_name);
		variable next_state: state_types := idle;
		--variable next_letter : std_logic_vector(7 downto 0);
		
		--variable letter_1, letter_2, letter_3, letter_4 : std_logic_vector(7 downto 0);
		variable letter_total : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable s_letter : std_logic_vector(6 downto 0);
	
		--variable id : std_logic_vector(1 downto 0);
		
begin
		if(reset = '1') then
			next_state := idle;
			letter_total := x"00000000";
			ledr <= "000000000000000000";
			ledg <= "00000000";
		elsif(rising_edge(CLOCK_50)) then
			case next_state is
				when idle =>
					ledg <= "00000000";
					ledr <= "000000000000000000";
					--ledr(17 downto 15) <= "000";
					ack_out <= '0';
					next_state := r_letter_1;
					
				when r_letter_1 =>
					--ledr(0) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							
							letter_total(31 downto 24) := data_in;
							ledg <= letter_total(31 downto 24);
							next_state := wait_state_1;
						else
							ack_out <= '0'; -- 
							next_state := r_letter_1;
						end if;

					end if;
				
				when wait_state_1 =>
					if(valid_in = '0') then
						next_state := r_letter_2;
					else
						next_state := wait_state_1;
					end if;
					
				when r_letter_2 =>
					--ledr(1) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							letter_total(23 downto 16) := data_in;
							ledg <= letter_total(23 downto 16);
							next_state := wait_state_2;
						else		
							ack_out <= '0'; --
							next_state := r_letter_2;
						end if;
					end if;
				
				 when wait_state_2 =>
					if(valid_in = '0') then
						next_state := r_letter_3;
					else
						next_state := wait_state_2;
					end if;
					
				when r_letter_3 =>
					--ledr(2) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							letter_total(15 downto 8) := data_in;
							ledg <= letter_total(15 downto 8);
							next_state := wait_state_3;
						else		
							ack_out <= '0'; --
							next_state := r_letter_3;
						end if;

					end if;
				
				when wait_state_3 =>
					if(valid_in = '0') then
						next_state := r_letter_4;
					else
						next_state := wait_state_3;
					end if;
					
				when r_letter_4 =>
					--ledr(3) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							letter_total(7 downto 0) := data_in;
							ledg <= letter_total(7 downto 0);
							next_state := wait_state_4;
						else		
							ack_out <= '0';
							next_state := r_letter_4;
						end if;
					else
						next_state := wait_state_4;
					end if;
					
				when wait_state_4 =>
					if(done_in = '1') then
						next_state := check_name;
					else
						next_state := wait_state_4;
					end if;
					
				when check_name =>
					--ledr <= letter_total(31 downto 14);
					if((letter_total = "01010000011010000110100101101100") OR 
						(letter_total = "01000001011011010111001001101111") OR
						(letter_total = "01010011011101000110010101110000") OR 
						(letter_total = "01001010011011110110100001101110") OR
						(letter_total = "01001010011011110110010100000000"))then
						ledr(17) <= '1';
						s_letter := "1011001";
					else
						s_letter := "1001110";
					end if;
					
					if(send = '0') then
							--ledr(17) <= '1';
							next_state := s_letter_1;
					end if;

				when s_letter_1 =>
					--sending over name
					if(ack_in = '0') then
						done_out <= '0';
						data_out <= s_letter;
						valid_out <= '1';
						--ledr(6 downto 0) <= data_out;
						next_state := send_letter;
					end if;
					
				when send_letter =>
					if(ack_in = '1') then
						valid_out <= '0';
						next_state := wait_state;
					else
						next_state := send_letter;
					end if;
					
				when others =>
					done_out <= '1';
					next_state := idle;
					
				end case;
		end if;
	end process;
	
end behavioural;