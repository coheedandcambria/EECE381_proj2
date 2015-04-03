library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pi_comm_DE2_recv is
port (
   clock_50: in std_logic;
   key: in std_logic_vector(3 downto 0);
   
	gpio_0: inout std_logic_vector(35 downto 0);
	
	ledg: out std_logic_vector(7 downto 0); --
	ledr: out std_logic_vector(17 downto 0)
);
end pi_comm_DE2_recv;

architecture behavioural of pi_comm_DE2_recv is
	signal reset: std_logic;
	signal valid: std_logic;
	signal valid_in: std_logic;
	signal ack_out: std_logic;
	signal done_in: std_logic;
	signal ack: std_logic;
	signal data_in: std_logic_vector(7 downto 0);
	signal data_out: std_logic_vector(7 downto 0);
	signal done: std_logic;
	signal flag : std_logic;
	
begin
	
	reset <= not key(0);
--	gpio_0(24) <= valdid;
--	data_out(7) <= '0';
--	gpio_0(17 downto 11) <= data_out(6 downto 0);
--	ack <= gpio_0(23);
--	gpio_0(25) <= done;
	flag <= gpio_0(0);
	
	
	process(clock_50, reset)
		type state_types is (idle, s_letter_1, s_letter_2, s_letter_3, s_letter_4, send_letter, wait_state );
		variable next_state: state_types := idle;
		variable next_letter : std_logic_vector(7 downto 0);
		variable id : std_logic_vector(1 downto 0) := "00";
		--variable first_byte, second_byte, third_byte, fourth_byte : std_logic_vector(7 downto 0);
	begin
		if(reset = '1') then
			next_state := idle;
		elsif(rising_edge(CLOCK_50)) then
			if (flag = '0') then --sending
				gpio_0(24) <= valid;
				data_out(7) <= '0';
				gpio_0(17 downto 11) <= data_out(6 downto 0);
				ack <= gpio_0(23);
				gpio_0(25) <= done;
			else --flag = 1 -- receiving
				valid_in <= gpio_0(24);
				data_in <= '0' & gpio_0(17 downto 11);
				gpio_0(23) <= ack_out;
				done_in <= gpio_0(25);
			end if;
		
			case next_state is
				when idle =>
					if(flag = '1') then
						ledr(16) <= '1';
						next_state := idle;
					else
						ledg <= "00000000";
						ledr(7 downto 0) <= "00000000";
						ledr(17 downto 15) <= "000";
						valid <= '0';
						done <= '0'; -- might be a problem, check
						next_state := s_letter_1;
					end if;
				when s_letter_1 =>
					if(ack = '0') then 
						ledr(7) <= '1';
						id := "00";
						done <= '0';
						data_out <= x"50";
						valid <= '1';
						next_state := send_letter;
					end if;
				when s_letter_2 =>
					if(ack = '0') then 
						ledr(6) <= '1';
						id := "01";
						done <= '0';
						data_out <= x"68";
						valid <= '1';
						next_state := send_letter;
					end if;
				when s_letter_3 =>
					if(ack = '0') then 
						ledr(5) <= '1';
						id := "10";
						done <= '0';
						data_out <= x"69";
						valid <= '1';
						next_state := send_letter;
					end if;		
				when s_letter_4 =>
					if(ack = '0') then 
						ledr(4) <= '1';
						id := "11";
						done <= '0';
						data_out <= x"6C";
						valid <= '1';
						next_state := send_letter;
					end if;
				when send_letter =>
					--sending over name
					if(ack = '1') then
						valid <= '0';
						if(id = "00") then
							next_state := s_letter_2;
						elsif(id = "01") then
							next_state := s_letter_3;
						elsif(id = "10") then
							next_state := s_letter_4;
						elsif(id = "11") then
							next_state := wait_state;
						end if;
					else 
						next_state := send_letter;	
					end if;
				when others =>
					done <= '1';
					ledg(7 downto 0) <= "11111111";
--					if(flag = '1') then
--						next_state := s_letter_1;
--					else
--						next_state := wait_state;
--					end if;
					
				end case;
		end if;
	end process;
	
	--process()
end behavioural;