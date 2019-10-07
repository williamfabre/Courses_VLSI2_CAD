entity circuit is
  port ( vdd, vss, reset, ck,  jour, press_kbd, O, timer5_tm, timer120_tm : in bit;
          i : in bit_vector(3 downto 0);
          timer5_en, timer120_en, porte, alarm : out bit
       );
end circuit;

architecture MOORE of circuit is

  type ETAT_TYPE is (IDLE, NIGHT_PRESS, CORRECT5, CORRECT3, CORRECTA, CORRECT1, ALARM, DOOR_OPEN);
  signal EF, EP : ETAT_TYPE;

  -- pragma CURRENT_STATE EP
  -- pragma NEXT_STATE EF
  -- pragma CLOCK CK

begin

  process ( EP, press_kbd, reset )
  begin

    if ( reset = '1' ) then
      EF <= IDLE;
    else
      case EP is
        
        when IDLE =>
          if (press_kbd = '1') then
            if (jour = '1') then
              if (O = '1') then
                EF <= DOOR_OPEN;
              else
                EF <= IDLE;
              end if;
            else
              if (O = '1') then
                EF <= IDLE; -- alarme ou pas?
              else
                EF <= NIGHT_PRESS;
              end if;
            end if;
          else
            EF <= IDLE;
          end if;
        
        when ALARM =>
          if (timer120_tm = '1') then
            EF <= IDLE;
          else
            EF <= ALARM;
          end if;

        when NIGHT_PRESS =>
          if (i != 0x5) then
            EF <= ALARM;
          else
            EF <= CORRECT5;
          end if;

        when CORRECT5 =>
          if (press_kbd = '1') then
            if (i != 0x3) then
              EF <= ALARM;
            else
              EF <= CORRECT5;
            end if;
          else
            if (timer5_tm = '1') then
              EF <= IDLE;
            else
              EF <= CORRECT5;
            end if;
          end if;

        when CORRECT3 =>
          if (press_kbd = '1') then
            if (i != 0xA) then
              EF <= ALARM;
            else
              EF <= CORRECTA;
            end if;
          else
            if (timer5_tm = '1') then
              EF <= IDLE;
            else
              EF <= CORRECT3;
            end if;
          end if;

        when CORRECTA =>
          if (press_kbd = '1') then
            if (i != 0x1) then
              EF <= ALARM;
            else
              EF <= CORRECT1;
            end if;
          else
            if (timer5_tm = '1') then
              EF <= IDLE;
            else
              EF <= CORRECTA;
            end if;
          end if;

        when CORRECT1 =>
          if (press_kbd = '1') then
            if (i != 0x7) then
              EF <= ALARM;
            else
              EF <= DOOR_OPEN;
            end if;
          else
            if (timer5_tm = '1') then
              EF <= IDLE;
            else
              EF <= CORRECT1;
            end if;
          end if;

        when DOOR_OPEN =>
          if (timer5_tm = '1') then
            EF <= IDLE;
          else
            EF <= DOOR_OPEN;
          end if;          

        when others => assert ('1')
          report "etat illegal";
      end case;
    end if;

    case EP is --timer5_en, timer120_en, porte, alarm
      
      when IDLE =>
        porte <= '0';
        alarm <= '0';
        timer5_en <= '0';
        timer120_en <= '0';
      
      when NIGHT_PRESS =>
        porte <= '0';
        alarm <= '0';
        timer5_en <= '0';
        timer120_en <= '0';
      
      when CORRECT5 =>
        porte <= '0';
        alarm <= '0';
        timer5_en <= '1';
        timer120_en <= '0';
      
      when CORRECT3 =>
        porte <= '0';
        alarm <= '0';
        timer5_en <= '1';
        timer120_en <= '0';
      
      when CORRECTA =>
        porte <= '0';
        alarm <= '0';
        timer5_en <= '1';
        timer120_en <= '0';
      
      when CORRECT7 =>
        porte <= '0';
        alarm <= '0';
        timer5_en <= '1';
        timer120_en <= '0';

      when ALARM =>
        porte <= '0';
        alarm <= '1';
        timer5_en <= '0';
        timer120_en <= '1';

      when DOOR_OPEN =>
        porte <= '1';
        alarm <= '0';
        timer5_en <= '1';
        timer120_en <= '0';      
        
      when others => assert ('1')
        report "etat illegal";
    end case;

  end process;

  process( ck )
  begin
    if (ck='1' and not ck'stable) then
      EP <= EF;
    end if;
  end process;

end MOORE;