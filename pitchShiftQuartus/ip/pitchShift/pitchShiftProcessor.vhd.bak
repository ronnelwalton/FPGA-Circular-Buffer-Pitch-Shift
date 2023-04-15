library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pitchshiftprocessor is
	port (
		clk : in std_logic ;
		reset : in std_logic ;
		avalon_st_sink_valid : in std_logic ;
		avalon_st_sink_data : in std_logic_vector (23 downto 0);
		avalon_st_sink_channel : in std_logic_vector (0 downto 0);
		avalon_st_source_valid : out std_logic ;
		avalon_st_source_data : out std_logic_vector (23 downto 0);
		avalon_st_source_channel : out std_logic_vector (0 downto 0);
		avalon_mm_address : in std_logic_vector (1 downto 0);
		avalon_mm_read : in std_logic ;
		avalon_mm_readdata : out std_logic_vector (31 downto 0);
		avalon_mm_write : in std_logic ;
		avalon_mm_writedata : in std_logic_vector (31 downto 0)
	);
end entity pitchshiftprocessor ;

architecture pitchshiftprocessor_arch of pitchshiftprocessor is

	component pitchShift IS
	  PORT( clk                               :   IN    std_logic;
			  reset                             :   IN    std_logic;
			  clk_enable                        :   IN    std_logic;
			  AudioIn                           :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
			  Pitch                             :   IN    std_logic_vector(23 DOWNTO 0);  -- sfix24_En16
			  ce_out                            :   OUT   std_logic;
			  AudioOut                          :   OUT   std_logic_vector(23 DOWNTO 0)  -- sfix48_En39
			  );
	end component pitchShift;
	component lr2ast is
	  port (
		 clk                   : in    std_logic;
		 avalon_sink_channel   : in    std_logic;
		 avalon_sink_valid     : in    std_logic;
		 data_left             : in    std_logic_vector(23 downto 0);
		 data_right            : in    std_logic_vector(23 downto 0);
		 avalon_source_data    : out   std_logic_vector(23 downto 0);
		 avalon_source_channel : out   std_logic;
		 avalon_source_valid   : out   std_logic
	  );
	end component lr2ast;
	component ast2lr is
	  port (
		 clk                 : in    std_logic;
		 avalon_sink_data    : in    std_logic_vector(23 downto 0);
		 avalon_sink_channel : in    std_logic;
		 avalon_sink_valid   : in    std_logic;
		 data_left           : out   std_logic_vector(23 downto 0);
		 data_right          : out   std_logic_vector(23 downto 0)
	  );
	end component ast2lr;	
	-- delta1 - sfix24_En16 - default value = "000000001101011101000101" =~0.840896606445313
	signal delta1 : std_logic_vector (23 downto 0) := "000000001101011101000101";
	-- delta2 - sfix24_En16 - default value = "000000001011010100000101" =~0.707107543945313
	signal delta2 : std_logic_vector (23 downto 0) := "000000001011010100000101";
	-- enable -  - default value = "1" = 1
	signal enable : std_logic_vector (0 downto 0) := "1";
	
	signal left_data_sink : std_logic_vector(23 downto 0);
	signal right_data_sink : std_logic_vector(23 downto 0);
	signal left_data_source : std_logic_vector(23 downto 0);
	signal right_data_source : std_logic_vector(23 downto 0);

	begin
	bus_write : process (clk , reset) is
		begin
			if reset = '1' then
				delta1 <= "000000001101011101000101";
				delta2 <= "000000001011010100000101";
				enable <= "1"; -- 1
			elsif rising_edge (clk) and avalon_mm_write = '1' then
				case avalon_mm_address is
					when "00" =>
						delta1 <= std_logic_vector (resize( unsigned(avalon_mm_writedata ), 24));
					when "01" =>
						delta2 <= std_logic_vector (resize(signed(avalon_mm_writedata ), 24));
					when "10" =>
						enable <= std_logic_vector (resize(signed(avalon_mm_writedata ), 1));
					when others =>
						null;
				end case;
			end if;
		end process bus_write ;
	bus_read : process (clk) is
		begin
			if rising_edge (clk) and avalon_mm_read = '1' then
				case avalon_mm_address is
					when "00" =>
						avalon_mm_readdata <= std_logic_vector (resize(unsigned(delta1), 32));
					when "01" =>
						avalon_mm_readdata <= std_logic_vector (resize(signed(delta2), 32));
					when "10" =>
						avalon_mm_readdata <= std_logic_vector (resize(signed(enable), 32));
					when others =>
						avalon_mm_readdata <= (others => '0');
				end case;
			end if;
			end process bus_read;
			
			
	u_ast2lr : component ast2lr
		port map (
			clk => clk ,
			avalon_sink_data => avalon_st_sink_data ,
			avalon_sink_channel => avalon_st_sink_channel (0) ,
			avalon_sink_valid => avalon_st_sink_valid ,
			data_left => left_data_sink ,
			data_right => right_data_sink
		);
	u_lr2ast : component lr2ast
		port map (
			clk => clk ,
			avalon_sink_channel => avalon_st_sink_channel (0) ,
			avalon_sink_valid => avalon_st_sink_valid ,
			data_left => left_data_source ,
			data_right => right_data_source ,
			avalon_source_data => avalon_st_source_data ,
			avalon_source_channel => avalon_st_source_channel (0) ,
			avalon_source_valid => avalon_st_source_valid
			);
	u_pitchShift : component pitchShift
	  port map ( clk => clk,
			  reset => reset,
			  clk_enable => enable(0),
			  AudioIn => left_data_sink,
			  Pitch => delta1,
			  ce_out => open,
			  AudioOut => left_data_source
			  );
	
end architecture pitchshiftprocessor_arch;
