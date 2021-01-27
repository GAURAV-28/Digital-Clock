use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


---------component 1: digital clock---------------
entity dig_clock is
  port (
    clk : in std_logic;
    dm : in std_logic;
    ts : in std_logic;
    inc : in std_logic;
    dec : in std_logic;


    d1,d2,d3,d4 : out integer range 0 to 9;
    d1_dp, d2_dp, d3_dp, d4_dp: out std_logic
  ) ;
end dig_clock;

architecture arch of dig_clock is
    signal sec : integer range 0 to 60 := 0;
    signal min : integer range 0 to 60 := 0;
    signal hr : integer range 0 to 24 := 0;
    signal ss : integer range 0 to 60 := 0;
    signal mm : integer range 0 to 60 := 0;
    signal hh : integer range 0 to 24 := 0;
    signal count,count1 : integer := 0;
    type state_type is(s0,s1,s2,s3);
    signal state : state_type;
    signal clk_1hz : std_logic := 0;

    signal tsc : integer := 0;
    signal dmc : integer := 0;

    signal cc : integer := 0;
    signal dd : integer := 0;
    signal v : integer := 25000000;
    signal s : integer := 25000000;

begin
    button : process(clk)
    
    begin
        if ts=1 and rising_edge(clk) then
            tsc<=tsc+1;
            if tsc=25000000 then
                case state is
                    when s0 =>
                    state <= s2;
                    when s1 =>
                    state <= s2;
                    when s2 =>
                    state <= s0;
                    when s3 =>
                    state <= s0;
    
                end case;  
            end if ;
           
        elsif ts=0 and rising_edge(clk) then
            tsc<=0;
        
        elsif dm=1 and rising_edge(clk) then
            dmc<=dmc+1;
            if dmc=25000000 then
                case state is
                    when s0 =>
                    state <= s2;
                    when s1 =>
                    state <= s2;
                    when s2 =>
                    state <= s0;
                    when s3 =>
                    state <= s0;
    
                end case;  
            end if ;
               
        elsif dm=0 and rising_edge(clk) then
            dmc<=0;

        elsif(inc=1 and rising_edge(clk)) then
            cc<=cc+1;
        
            if cc=s and s<100000000 then
                if state=s3 then
                    mm <= mm+1;
                elsif state=s4 then
                    hh <= hh+1;
                end if; 
                s = s+25000000;     
            end if;    

            if cc=s and (s>100000000 or s=100000000) then
                if state=s3 then
                    mm <= mm+4;
                elsif state=s4 then
                    hh <= hh+4;
                end if; 
                s = s+25000000; 
            end if ;
        elsif inc=0 and rising_edge(clk) then
            cc<=0; 
            s<=25000000;  

        elsif dec=1 and rising_edge(clk) then
            dd<=dd+1;
        
            if dd=v and v<100000000 then
                if state=s3 then
                    mm <= mm-1;
                elsif state=s4 then
                    hh <= hh-1;
                end if; 
                v = v+25000000;     
            end if;    

            if dd=v and (v>100000000 or v=100000000 then
                if state=s3 then
                    mm <= mm-4;
                elsif state=s4 then
                    hh <= hh-4;
                end if; 
                v = v+25000000; 
            end if ;
        
        elsif dec=0 and rising_edge(clk) then
            dd<=0;  
            v<=25000000;     
        end if;

    end process; 

    normal_clock : process(clk)
    
    begin
        if rising_edge(clk) then
            count <= count+1;
            if(count=100000000) then
                count<=0;
                ss <= ss+1;
                if(ss=60) then
                    ss<=0;
                    mm <= mm+1;
                    if(mm=60) then
                        mm<=0;
                        hh <= hh+1;
                        if(hh=24) then
                            hh<=0;
                        end if;
                    end if;
                end if;
            end if;                
        end if ;
        
    end process;

    sec<=ss;
    min<=mm;
    hr<=hh;

    clk_1hz : process(clk)
    begin
        if rising_edge(clk) then
            count1<=count1+1;
            if(count1=50000000) then
                clk_1hz = not clk_1hz;
            end if;
        end if ;
    end process ; -- 1hz_clk

    if state=s0 then
        d1 <= hr/10;
        d2 <= hr mod 10;
        d3 <= min/10;
        d4 <= min mod 10;
        d1_dp <= 0;
        d2_dp <= 0;
        d3_dp <= 0;
        d4_dp <= clk_1hz;
    elsif state=s1 then
        d1 <= min/10;
        d2 <= min mod 10;
        d3 <= sec/10;
        d4 <= sec mod 10;
        d1_dp <= 0;
        d2_dp <= 0;
        d3_dp <= 0;
        d4_dp <= 0;
    elsif state=s2 then
        d1 <= hr/10;
        d2 <= hr mod 10;
        d3 <= min/10;
        d4 <= min mod 10;
        d1_dp <= 0;
        d2_dp <= 0;
        d3_dp <= 0;
        d4_dp <= 1; 
    elsif state=s3 then
        d1 <= hr/10;
        d2 <= hr mod 10;
        d3 <= min/10;
        d4 <= min mod 10;
        d1_dp <= 0;
        d2_dp <= 1;
        d3_dp <= 0;
        d4_dp <= 0;
    end if;

end arch; 

------component 2: seven segment display--------
entity ssd is
  port (
    clk : in std_logic;
    d1,d2,d3,d4 : in integer range 0 to 9;
    d1_dp,d2_dp,d3_dp,d4_dp : in std_logic;

    an : out std_logic_vector(3 downto 0);
    disp : out std_logic_vector(6 downto 0);
    dp : out std_logic
  ) ;
end ssd;

architecture arch_ssd of ssd is

    signal count : integer := 0;
    signal anc : integer range 0 to 3 := 0;
    signal an_temp : std_logic_vector(3 downto 0);

begin
    anode_clk : process(clk)
    begin
        if rising_edge(clk) then
            count <= count+1;
            if(count=250000) then
                
                if(anc=3) then
                    anc<=0;
                else anc<=anc+1;    
                end if;    
                count<=0;
            end if;
        end if;        
        
    end process ; -- anode_clk

    display : process(anc)
    begin
        an <= an_temp;
        
        case(anc) is
        
            when 0 =>
            an_temp <= "1110";
            dp<=d4_dp;
            if d4=0 then
                disp <= "0000001";
            elsif d4=1 then
                disp <= "1001111";
            elsif d4=2 then
                disp <= "0010010";   
            elsif d4=3 then
                disp <= "0000110";   
            elsif d4=4 then
                disp <= "1001100"; 
            elsif d4=5 then
                disp <= "0100100";
            elsif d4=6 then
                disp <= "0100000";   
            elsif d4=7 then
                disp <= "0001111";   
            elsif d4=8 then
                disp <= "0000000";  
            elsif d4=9 then
                disp <= "0000100";                        
            end if ;
        
            when 1 =>
            an_temp <= "1101";
            dp<=d3_dp;
            if d3=0 then
                disp <= "0000001";
            elsif d3=1 then
                disp <= "1001111";
            elsif d3=2 then
                disp <= "0010010";   
            elsif d3=3 then
                disp <= "0000110";   
            elsif d3=4 then
                disp <= "1001100"; 
            elsif d3=5 then
                disp <= "0100100";
            elsif d3=6 then
                disp <= "0100000";   
            elsif d3=7 then
                disp <= "0001111";   
            elsif d3=8 then
                disp <= "0000000";  
            elsif d3=9 then
                disp <= "0000100";                        
            end if ;
            
            when 2 =>
            an_temp <= "1011";
            dp<=d2_dp;
            if d2=0 then
                disp <= "0000001";
            elsif d2=1 then
                disp <= "1001111";
            elsif d2=2 then
                disp <= "0010010";   
            elsif d2=3 then
                disp <= "0000110";   
            elsif d2=4 then
                disp <= "1001100"; 
            elsif d2=5 then
                disp <= "0100100";
            elsif d2=6 then
                disp <= "0100000";   
            elsif d2=7 then
                disp <= "0001111";   
            elsif d2=8 then
                disp <= "0000000";  
            elsif d2=9 then
                disp <= "0000100";                        
            end if ;
        
            when 3 =>
            an_temp <= "0111";
            dp<=d1_dp;
            if d1=0 then
                disp <= "0000001";
            elsif d1=1 then
                disp <= "1001111";
            elsif d1=2 then
                disp <= "0010010";   
            elsif d1=3 then
                disp <= "0000110";   
            elsif d1=4 then
                disp <= "1001100"; 
            elsif d1=5 then
                disp <= "0100100";
            elsif d1=6 then
                disp <= "0100000";   
            elsif d1=7 then
                disp <= "0001111";   
            elsif d1=8 then
                disp <= "0000000";  
            elsif d1=9 then
                disp <= "0000100";                        
            end if ;

        end case ;
    end process ; -- display

end arch_ssd ; 

-------combined module---------------
entity ee is
  port (
    clk : in std_logic;
    dm : in std_logic;
    ts : in std_logic;
    inc : in std_logic;
    dec : in std_logic;

    an : out std_logic_vector(3 downto 0);
    disp : out std_logic_vector(6 downto 0);
    dp : out std_logic
  ) ;
end ee;

architecture aa of ee is

    signal d1,d2,d3,d4 : integer range 0 to 9;
    signal d1_dp,d2_dp,d3_dp,d4_dp : std_logic;

    component dig_clock is
        port (
        clk : in std_logic;
        dm : in std_logic;
        ts : in std_logic;
        inc : in std_logic;
        dec : in std_logic;

        d1,d2,d3,d4 : out integer range 0 to 9;
        d1_dp,d2_dp,d3_dp,d4_dp : out std_logic
        ) ;
    end component;

    component ssd is
        port (
        clk : in std_logic;
        d1,d2,d3,d4 : in integer range 0 to 9;
        d1_dp,d2_dp,d3_dp,d4_dp : in std_logic;

        an : out std_logic_vector(3 downto 0);
        disp : out std_logic_vector(6 downto 0);
        dp : out std_logic
        ) ;
    end component;

begin

    dig_clock : dig_clock port map(
        clk => clk,
        dm => dm,
        ts => ts,
        inc => inc,
        dec => dec,
        d1=>d1,
        d2=>d2,
        d3=>d3,
        d4=>d4,
        d1_dp=>d1_dp,
        d2_dp=>d2_dp,
        d3_dp=>d3_dp,
        d4_dp=>d4_dp
    );

    ssd : ssd port map(
        clk => clk,
        d1=>d1,
        d2=>d2,
        d3=>d3,
        d4=>d4,
        d1_dp=>d1_dp,
        d2_dp=>d2_dp,
        d3_dp=>d3_dp,
        d4_dp=>d4_dp,
        an=>an,
        disp=>disp,
        dp=>dp
    );
end aa ; 