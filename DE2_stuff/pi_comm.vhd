library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pi_comm_DE2 is
port (
   clock_50: in std_logic;
   key: in std_logic_vector(3 downto 0);
   
	gpio_0: inout std_logic_vector(35 downto 0);
	
	ledg: out std_logic_vector(7 downto 0); --
	ledr: out std_logic_vector(17 downto 0)
);
end pi_comm_DE2;

architecture behavioural of pi_comm_DE2 is
	signal reset: std_logic;
	signal valid: std_logic;
	signal ack: std_logic;
	signal data: std_logic_vector(7 downto 0);
	signal done: std_logic;
	
begin
	
	reset <= not key(0);
	valid <= gpio_0(24);
	data <= '0' & gpio_0(17 downto 11);
	gpio_0(23) <= ack;
	done <= gpio_0(25);
	
	
	process(clock_50, reset)
		type state_types is (idle, letter_1, letter_2, letter_3, letter_4, letter_5, waste, incorrect, correct_name, send_name, wait_state, check_name );
		variable next_state: state_types := idle;
		variable next_letter : std_logic_vector(7 downto 0);
		variable id : std_logic_vector(1 downto 0);
		--variable first_byte, second_byte, third_byte, fourth_byte : std_logic_vector(7 downto 0);
	begin
		if(reset = '1') then
			next_state := idle;
		elsif(rising_edge(CLOCK_50)) then
			case next_state is
				when idle =>
					ledg <= "00000000";
					ledr(7 downto 0) <= "00000000";
					ledr(17 downto 15) <= "000";
					ack <= '0';
					next_state := letter_1;
				when letter_1 =>
					if(done = '0') then
						ack <= '0';
						if(valid = '1') then
							ack <= '1';
							--ledg <= data;
							if(data = x"50") then --P
								--first_byte := x"50";
								next_letter := x"68"; -- h
								id := "00";
								ledg(7 downto 0) <= data;
								next_state := letter_2;
							elsif(data = x"41") then -- A
								--first_byte := x"41";
								next_letter := x"6D" ;--m
								id := "01";
								ledg(7 downto 0) <= data;
								next_state := letter_2;
							else
								next_state := letter_1;
							end if;
						end if;
					else
						next_state := incorrect;
					end if;
					
				when letter_2 =>
					if(done = '0') then
						ack <= '0';
						if(valid = '1') then
							ack <= '1';
							--ledg <= data;
							if(data = next_letter) then
								--second_byte := next_letter;
								if(id = "00") then --Phil second letter
									id := "00";
									--second_byte := next_letter;
									next_letter := x"69";
									ledg(7 downto 0) <= data;
									next_state := letter_3;
								elsif(id = "01") then --Amro second letter
									id := "01";
									next_letter := x"72";
									ledg(7 downto 0) <= data;
									next_state := letter_3;
								end if;
							else
								next_state := letter_2;
							end if;
						end if;
					else
						next_state := incorrect;
					end if;
					
				when letter_3 =>
					if(done = '0') then
						ack <= '0';
						if(valid = '1') then
							ack <= '1';
							--ledg <= data;
							if(data = next_letter) then
								--third_byte := next_letter;
								if(id = "00") then --Phil second letter
									id := "00";
									next_letter := x"6C";
									ledg(7 downto 0) <= data;
									next_state := letter_4;
								elsif(id = "01") then --Amro second letter
									id := "01";
									next_letter := x"6F";
									ledg(7 downto 0) <= data;
									next_state := letter_4;
								end if;
							else
								next_state := letter_3;
							end if;
						end if;
					else
						next_state := incorrect;
					end if;
					
				when letter_4 =>
					if(done = '0') then
						ack <= '0';
						if(valid = '1') then
							ack <= '1';
							--ledg <= data;
							if(data = next_letter) then
								--fourth_byte := next_letter;
								if(id = "00") then --Phil second letter
									id := "00";
									next_letter := x"6C";
									ledg(7 downto 0) <= data;
									next_state := send_name; --check_name;
								elsif(id = "01") then --Amro second letter
									id := "01";
									next_letter := x"6F";
									ledg(7 downto 0) <= data;
									next_state := send_name; --check_name;
								end if;
							else
								next_state := letter_4;
							end if;
						end if;
					else
						next_state := incorrect;
					end if;
--				when check_name =>
--					if(done = '0') then
--						ack <= '0';
--						if(valid = '1') then
--						ack <= '1';
--						next_state := incorrect;
--						end if;
--					else 
--						next_state := send_name;
--					end if;

--				when waste =>
--					if(done = '0') then
--						if(valid = '1') then	
--							ack <= '1';	
--						else
--							ack <= '0';
--						end if;
--					end if;
--					ledg(7 downto 0) <= "11111111";
--					next_state := incorrect;
				when incorrect => 
----					first_byte := x"58"; --X
----					second_byte := x"58"; --X
----					third_byte := x"58"; --X
----					fourth_byte := x"58"; --X
					id := "11"; --incorrect id
					ledr(17 downto 15) <= "111";
					--next_state := send_name;
					next_state := wait_state;
				when send_name =>
					--sending over name
					if (id /= "11") then
						ledr(7 downto 0) <= "11111111";
						next_state := wait_state;
					else
						next_state := wait_state;--to do
					end if;	
				when others =>
					next_state := wait_state;
					
				end case;
		end if;
	end process;
	
	--process()
end behavioural;