library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pi_comm_2 is
port (
   clock_50: in std_logic;
   key: in std_logic_vector(3 downto 0);
   
	gpio_0: inout std_logic_vector(35 downto 0);
	
	ledg: out std_logic_vector(7 downto 0); --
	ledr: out std_logic_vector(17 downto 0)
);
end pi_comm_2;

architecture behavioural of pi_comm_2 is
	signal reset: std_logic;
	signal valid_in, valid_out: std_logic;
	signal ack_in, ack_out: std_logic;
	signal data_in: std_logic_vector(7 downto 0);
	signal data_out : std_logic_vector(6 downto 0);
	signal done_in, done_out: std_logic;
	signal send, user_add : std_logic;
	signal count : std_logic_vector(2 downto 0) := "000";
	
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
		type state_types is (idle, idle_2, idle_3, idle_4, r_letter_1, r_letter_2, r_letter_3, r_letter_4, check_pwd, s_letter_0,
									s_letter_1, send_letter, wait_state, wait_state_1, wait_state_2, wait_state_3, wait_state_4, check_name);
		variable next_state: state_types := idle;
		--variable next_letter : std_logic_vector(7 downto 0);
		
		--variable letter_1, letter_2, letter_3, letter_4 : std_logic_vector(7 downto 0);
		variable letter_total : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable last_letters : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable pwd_total : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		variable s_letter : std_logic_vector(6 downto 0);
		variable user_valid : std_logic := '0';
		variable login 		: std_logic := '0';
		variable count_en		: std_logic:= '0';
	
		--variable id : std_logic_vector(1 downto 0);
		
begin
		if(reset = '1') then
			next_state := idle;
			letter_total := "00000000000000000000000000000000";
			ledr <= "000000000000000000";
			user_valid := '0';
			login := '0';
			count <= "000";
			ack_out <= '0';
			valid_out <= '0';
			done_out <= '0';
			ledg <= "00000000";
		elsif(rising_edge(CLOCK_50)) then
			case next_state is
				when idle =>
					--ledg <= "00000000";
					--ledr <= "000000000000000000";
					--ledr(17 downto 15) <= "000";
					letter_total := "00000000000000000000000000000000";
					ack_out <= '0';
					valid_out <= '0';
					next_state := r_letter_1;
					
				when r_letter_1 =>
					--ledr(0) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							
							letter_total(31 downto 24) := data_in;
--							if(user_valid = '1') then 
--								ledg <= letter_total(31 downto 24);
--							end if;
							next_state := wait_state_1;
						else
							ack_out <= '0'; -- 
							next_state := idle;
						end if;
					--MIGHT BE THE PROBLEM DAWG, JUST ATTEMPTING TO FIX BUGINESSS	
					else
						next_state := r_letter_1;
					end if;
				
				when wait_state_1 =>
					if(valid_in = '0') then
						next_state := r_letter_2;
					else
						next_state := wait_state_1;
					end if;
					
				when idle_2 =>
					letter_total(23 downto 0) := "000000000000000000000000";
					ack_out <= '0';
					valid_out <= '0';
					next_state := r_letter_2;
					
				when r_letter_2 =>
					--ledr(1) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							letter_total(23 downto 16) := data_in;
							--ledg <= letter_total(23 downto 16);
							next_state := wait_state_2;
						else		
							ack_out <= '0'; --
							next_state := idle_2;
						end if;
					--SAME HERE
					else
						next_state := r_letter_2;
					end if;
				
				 when wait_state_2 =>
					if(valid_in = '0') then
						next_state := r_letter_3;
					else
						next_state := wait_state_2;
					end if;
				
				when idle_3 =>
					letter_total(15 downto 0) := "0000000000000000";
					ack_out <= '0';
					valid_out <= '0';
					next_state := r_letter_3;
					
				when r_letter_3 =>
					--ledr(2) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							letter_total(15 downto 8) := data_in;
							--ledg <= letter_total(15 downto 8);
							next_state := wait_state_3;
						else		
							ack_out <= '0'; --
							next_state := idle_3;
						end if;
					else
						next_state := r_letter_3;
					end if;
				
				when wait_state_3 =>
					if(valid_in = '0') then
						next_state := r_letter_4;
					else
						next_state := wait_state_3;
					end if;
				
				when idle_4 =>
					letter_total(7 downto 0) := "00000000";
					ack_out <= '0';
					valid_out <= '0';
					next_state := r_letter_4;
					
				when r_letter_4 =>
					--ledr(3) <= '1';
					if(done_in = '0') then
						
						if(valid_in = '1') then
							ack_out <= '1';
							letter_total(7 downto 0) := data_in;
							--ledg <= letter_total(7 downto 0);
							next_state := wait_state_4;
						else		
							ack_out <= '0';
							next_state := idle_4;
						end if;
					else
						next_state := r_letter_4;
					end if;
					
				when wait_state_4 =>
					if(done_in = '1') then
						if(user_valid = '0') then
							next_state := check_name;
						else
							next_state := check_pwd;
						end if;
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
						ledr(17 downto 15) <= "111";
						last_letters := letter_total;
						user_valid := '1';
						s_letter := "1011001";
						
					elsif(letter_total = "01000010010011110100111101010100") then
						s_letter := "1011001";
						user_valid := '0';
						login := '0';
					elsif((letter_total = "01000001010011000100111101001110") AND (login = '1')) then
						gpio_0(1) <= '1';
						ledg <= "11111111";
						ledr <= "111111111111111111";
						s_letter := "1011001";
					elsif((letter_total = "01000001010011000100111101000110") AND (login = '1')) then
						gpio_0(1) <= '0';
						ledg <= "00000000";
						ledr <= "000000000000000000";
						s_letter := "1011001";
					elsif((letter_total = "01100111011011000100111101001110") AND (login = '1')) then
						ledg <= "11111111";
						s_letter := "1011001";
					elsif((letter_total = "01000111010100000100111101001110") AND (login = '1')) then
						gpio_0(1) <= '1';
						s_letter := "1011001";
					elsif((letter_total = "01000111010011110100011001000110") AND (login = '1')) then
						gpio_0(1) <= '0';
						s_letter := "1011001";
					elsif((letter_total = "01100111010011110100011001000110") AND (login = '1')) then
						ledg <= "00000000";
						s_letter := "1011001";
					elsif((letter_total = "01110010011011000100111101001110") AND (login = '1')) then
						ledr <= "111111111111111111";
						s_letter := "1011001";
					elsif((letter_total = "01110010010011110100011001000110") AND (login = '1')) then
						ledr <= "000000000000000000";
						s_letter := "1011001";
					elsif((letter_total = "01101100011011110110011101001111") AND (login = '1')) then
						login := '0';
						ledg <= "00000000";
						ledr <= "000000000000000000";
						s_letter := "1011001";
					elsif((letter_total = "01100111010011010100100101001110") AND (login = '1') AND (count_en = '1')) then
						count_en := '0';
						if(count = "000") then
							ledg <= "00000000";
						else
							if (count = "001") then
								count <= "000";
								ledg <= "00000000";
							elsif (count = "010") then
								count <= "001";
								ledg <= "00000001";
							elsif (count = "011") then
								count <= "010";
								ledg <= "00000011";
							elsif (count = "100") then
								count <= "011";
								ledg <= "00000111";
							elsif (count = "101") then
								count <= "100";
								ledg <= "00001111";
							elsif (count = "110") then
								count <= "101";
								ledg <= "00011111";
							elsif (count = "111") then
								count <= "110";
								ledg <= "00111111"; 								
							end if;
						end if;
						
					elsif((letter_total = "01100111010100000100110001010011") AND (login = '1')AND (count_en = '1')) then
						count_en := '0';
						if(count = "111") then
							ledg <= "01111111";
						else
							if (count = "000") then
								count <= "001";
								ledg <= "00000001";
							elsif (count = "001") then
								count <= "010";
								ledg <= "00000011";
							elsif (count = "010") then
								count <= "011";
								ledg <= "00000011";
							elsif (count = "011") then
								count <= "100";
								ledg <= "00000111";
							elsif (count = "100") then
								count <= "101";
								ledg <= "00001111";
							elsif (count = "101") then
								count <= "110";
								ledg <= "00011111";
							elsif (count = "110") then
								count <= "111";
								ledg <= "00111111"; 							
							else 
								ledg <= "01111111";
							end if;
						end if;
					else
						--ledr(0) <= '1';
						s_letter := "1001110";
					end if;
					
					if(send = '0') then
						--ledr(17) <= '1';
						next_state := s_letter_1;
					end if;
				
				when check_pwd =>
					user_valid := '0';
					ledr(17 downto 15) <= "000";
					if(((letter_total = "01010111011001010100010001101111") AND (last_letters = "01010000011010000110100101101100")) OR 
						((letter_total = "01010000011011110111010101110010") AND(last_letters = "01000001011011010111001001101111"))OR
						((letter_total = "01110011011000010110110001101101") AND(last_letters = "01010011011101000110010101110000"))OR 
						((letter_total = "01111010011110010110011101101111") AND(last_letters = "01001010011011110110100001101110"))OR
						((letter_total = "01010100010000010111101001110010")AND(last_letters = "01001010011011110110010100000000")))then
						--ledr(17) <= '1';
						login := '1';
						s_letter := "1011001";
					else
						ledr(17 downto 15) <= "000";
						login := '0';
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
						--ledr(6 downto 0) <= "1111111";
						valid_out <= '0';
						count_en := '1';
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
