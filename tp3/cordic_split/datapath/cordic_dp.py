#!/usr/bin/env python

import sys
import symbolic.cmos
from   stratus import *


class Cordic_DP ( Model ):

    def Interface ( self ):
        print 'Cordic_DP.Interface()'

        self.x_p        = SignalIn ( 'x_p',    8 )
        self.y_p        = SignalIn ( 'y_p',    8 )

        self.nx_p       = SignalOut( 'nx_p',   8 )
        self.ny_p       = SignalOut( 'ny_p',   8 )

        self.xmkc_p     = SignalIn( 'xmkc_p', 2 )
        self.ymkc_p     = SignalIn( 'ymkc_p', 2 )
        self.xcmd_p     = SignalIn( 'xcmd_p', 4 )
        self.ycmd_p     = SignalIn( 'ycmd_p', 4 )
        self.i_p        = SignalIn( 'i_p',    4 )
        self.A          = SignalIn( 'A',      1 )
        self.B          = SignalIn( 'B',      1 )
        self.C          = SignalIn( 'C',      1 )
        self.D          = SignalIn( 'D',      1 )
        self.E          = SignalIn( 'E',      1 )
        self.F          = SignalIn( 'F',      1 )
        self.G          = SignalIn( 'G',      1 )
        self.H          = SignalIn( 'H',      1 )
        self.I          = SignalIn( 'I',      1 )
        self.J          = SignalIn( 'J',      1 )
        self.C0         = SignalIn( 'C0',     1 )
        self.C1         = SignalIn( 'C1',     1 )

        self.ck         = CkIn     ( 'ck'  )
        self.vdd        = VddIn    ( 'vdd' )
        self.vss        = VddIn    ( 'vss' )
        return


    def Netlist ( self ):
        print 'Cordic_DP.Netlist()'
        # SIGNALS 
        zero_16b            = Signal( 'zero_16b',       16 )
        zero_1b             = Signal( 'zero_1b',         1 )
        one_1b              = Signal( 'one_1b',          1 )

        n_x                 = Signal( 'n_x',            16 )
        x                   = Signal( 'x',              16 )

        n_y                 = Signal( 'n_y',            16 )
        y                   = Signal( 'y',              16 )

        #n_xkc_p_internal_mux        = Signal( 'nxkc_p_internal_mux',        16 )
        n_xkc_p_internal_mux_out0   = Signal( 'n_xkc_p_internal_mux_out0',  16 )
        n_xkc_p_internal_mux_out1   = Signal( 'n_xkc_p_internal_mux_out1',  16 )
        #n_xkc_p_mux_0               = Signal( 'n_xkc_p_mux_0',              16 )
        n_xkc_p_mux_out_0           = Signal( 'n_xkc_p_mux_out_0',          16 )
        #n_xkc_p_mux_1               = Signal( 'n_xkc_p_mux_1',              16 )
        n_xkc_p_mux_out_1           = Signal( 'n_xkc_p_mux_out_1',          16 )
        x_mkc_command               = Signal( 'x_mkc_command',              1  )
        x_signed_overflow_0         = Signal( 'x_signed_overflow_0',        1  )
        x_unsigned_overflow_0       = Signal( 'x_unsigned_overflow_0',      1  )
        x_signed_overflow_1         = Signal( 'x_signed_overflow_0',        1  )
        x_unsigned_overflow_1       = Signal( 'x_unsigned_overflow_0',      1  )
        x_adder_16_0                = Signal( 'x_adder_16_0',               16 )
        x_adder_16_1                = Signal( 'x_adder_16_1',               16 )
        x_plus_minus_y_sra_i        = Signal( 'x_plus_minus_y_sra_i',      16 )

        p_m_xkc                   = Signal('p_m_xkc'                    16 )
        p_m_xkc_signed_overflow_0 = Signal('p_m_xkc_signed_overflow_0'  16 )
        p_m_xkc_unsigned_overflow_0 = Signal('p_m_xkc_unsigned_overflow_0'16)

        n_xkc               = Signal( 'n_xkc',          16 )
        #not_xkc             = Signal( 'not_xkc',        16 )
        xkc                 = Signal( 'xkc',            16 )


        n_ykc_p_internal_mux        = Signal( 'nukc_p_internal_mux',        16 )
        n_ykc_p_internal_mux_out    = Signal( 'n_ykc_p_internal_mux_out',   16 )
        n_ykc_p_mux_0               = Signal( 'n_ykc_p_mux_0',              16 )
        n_ykc_p_mux_out_0           = Signal( 'n_ykc_p_mux_out_0',          16 )
        n_ykc_p_mux_1               = Signal( 'n_ykc_p_mux_1',              16 )
        n_ykc_p_mux_out_1           = Signal( 'n_ykc_p_mux_out_1',          16 )
        y_mkc_command               = Signal( 'y_mkc_command',              1  )
        y_signed_overflow_0         = Signal( 'x_signed_overflow_0',        1  )
        y_unsigned_overflow_0       = Signal( 'x_unsigned_overflow_0',      1  )
        y_signed_overflow_1         = Signal( 'x_signed_overflow_1',        1  )
        y_unsigned_overflow_1       = Signal( 'x_unsigned_overflow_1',      1  )
        y_adder_16_0                = Signal( 'y_adder_16_0',               16 )
        y_adder_16_1                = Signal( 'y_adder_16_1',               16 )
        y_plus_minus_x_sra_i        = Signal( 'y_plus_minus_x_sra_i',       16 )

        minus_ykc                   = Signal('minus_ykc'                    16 )
        minus_ykc_signed_overflow_0 = Signal('minus_ykc_signed_overflow_0'  16 )
        minus_ykc_unsigned_overflow_0 = Signal('minus_ykc_unsigned_overflow_0'16)


        n_ykc               = Signal( 'n_ykc',          16 )
        not_ykc             = Signal( 'not_ykc',        16 )
        ykc                 = Signal( 'ykc',            16 )





        x_sra_1             = Signal( 'x_sra_1',        16 )
        x_sra_2             = Signal( 'x_sra_2',        16 )
        x_sra_3             = Signal( 'x_sra_3',        16 )
        x_sra_4             = Signal( 'x_sra_4',        16 )
        x_sra_5             = Signal( 'x_sra_5',        16 )
        x_sra_6             = Signal( 'x_sra_6',        16 )
        x_sra_7             = Signal( 'x_sra_7',        16 )
        x_sra_1             = Signal( 'x_sra_1',        16 )

        y_sra_1             = Signal( 'y_sra_1',        16 )
        y_sra_2             = Signal( 'y_sra_2',        16 )
        y_sra_3             = Signal( 'y_sra_3',        16 )
        y_sra_4             = Signal( 'y_sra_4',        16 )
        y_sra_5             = Signal( 'y_sra_5',        16 )
        y_sra_6             = Signal( 'y_sra_6',        16 )
        y_sra_7             = Signal( 'y_sra_7',        16 )
        y_sra_1             = Signal( 'y_sra_1',        16 )




        # MASTER CELL
        #######################################################################
        Generate( 'DpgenNmux2'  ,  'nmux2_16b'  , param={'nbit':16,     'behavioral':True,'physical':True,'flags':0} )
        Generate( 'DpgenMux2'   ,  'mux2_16b'   , param={'nbit':16,     'behavioral':True,'physical':True,'flags':0} )
        # Generate( 'DpgenOr2'  ,  'or2'        , param={'nbit': 1,'physical'  :True,'behavioral':True} )
        Generate( 'DpgenOr2'    , 'or2_1'       , param={'nbit': 1,     'physical' : True })
        Generate ( 'DpgenAdsb2f', 'adder_16'    , param={'nbit': 16,   'physical' : True })
        Generate ( 'DpgenConst' , 'zero_16b'    , param={'nbit': 16,   'const': "0x0000" , 'physical' : True })
        Generate ( 'DpgenConst' , 'zero_1b'     , param={'nbit': 1,     'const' : "0b0" , 'physical' : True })
        Generate ( 'DpgenConst' , 'one_1b'      , param={'nbit': 1,     'const' : "0b1" , 'physical' : True })
        Generate ( 'DpgenSff'   , 'sff_16'      , param={'nbit': 16, 'physical' : True })
        Generate ( 'DpgenInv'   , 'inv_16'      , param={'nbit': 16, 'physical' : True })
        

        #######################################################################

        # LISTE DES INSTANCES
        #######################################################################
        self.instances = {}
        #######################################################################



        ############  VALUE 0 ############
        #######################################################################
        self.instances['zero_16b'] = Inst( 'zero_16b', 'zero_16b'
                                          , map = { 'q'   : zero_16b
                                                   , 'vdd' : self.vdd
                                                   , 'vss' : self.vss
                                                   } )
        self.instances['zero_1b'] = Inst( 'zero_1b', 'zero_1b'
                                         , map = { 'q'   : zero_1b
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        #######################################################################



        ############  SHIFTER X ############
        ############  MULTIPLEXOR X LAYER 1 ############
        #######################################################################
        self.instances['x_sra_0_0'] = Inst( 'nmux2_16b', 'x_sra_0_0'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x
                                                    , 'i1'  : x_sra_1
                                                    , 'nq'  : x_sra_0_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['x_sra_0_1'] = Inst( 'nmux2_16b', 'x_sra_0_1'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x_sra_2
                                                    , 'i1'  : x_sra_3
                                                    , 'nq'  : x_sra_0_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['x_sra_0_3'] = Inst( 'nmux2_16b', 'x_sra_0_3'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x_sra_4
                                                    , 'i1'  : x_sra_5
                                                    , 'nq'  : x_sra_0_3
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['x_sra_0_4'] = Inst( 'nmux2_16b', 'x_sra_0_4'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x_sra_6
                                                    , 'i1'  : x_sra_7
                                                    , 'nq'  : x_sra_0_4
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        ############  MULTIPLEXOR X LAYER 2 ############
        self.instances['x_sra_1_0'] = Inst( 'nmux2_16b', 'x_sra_1_0'
                                           , map = { 'cmd' : self.i_p[1]
                                                    , 'i0'  : x_sra_0_0
                                                    , 'i1'  : x_sra_0_1
                                                    , 'nq'  : x_sra_1_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['x_sra_1_1'] = Inst( 'nmux2_16b', 'x_sra_1_1'
                                           , map = { 'cmd' : self.i_p[1]
                                                    , 'i0'  : x_sra_0_3
                                                    , 'i1'  : x_sra_0_4
                                                    , 'nq'  : x_sra_1_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        ############  MULTIPLEXOR X LAYER 3 ###########
        self.instances['x_sra_i'] = Inst( 'mux2_16b', 'x_sra_i'
                                         , map = { 'cmd' : self.i_p[2]
                                                  , 'i0'  : x_sra_1_0
                                                  , 'i1'  : x_sra_1_1
                                                  , 'q'  : x_sra_i # pas nq
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        #######################################################################




        ############  SHIFTER Y ############
        ############  MULTIPLEXOR Y LAYER 0 ############
        #######################################################################
        self.instances['y_sra_0_0'] = Inst( 'nmux2_16b', 'y_sra_0_0'
                                           , map = { 'cmd'  : self.i_p[0]
                                                    , 'i0'  : y
                                                    , 'i1'  : y_sra_1
                                                    , 'nq'  : y_sra_0_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_0_1'] = Inst( 'nmux2_16b', 'y_sra_0_1'
                                           , map = { 'cmd'  : self.i_p[0]
                                                    , 'i0'  : y_sra_2
                                                    , 'i1'  : y_sra_3
                                                    , 'nq'  : y_sra_0_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_0_3'] = Inst( 'nmux2_16b', 'y_sra_0_3'
                                           , map = { 'cmd'  : self.i_p[0]
                                                    , 'i0'  : y_sra_4
                                                    , 'i1'  : y_sra_5
                                                    , 'nq'  : y_sra_0_3
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_0_4'] = Inst( 'nmux2_16b', 'y_sra_0_4'
                                           , map = { 'cmd'  : self.i_p[0]
                                                    , 'i0'  : y_sra_6
                                                    , 'i1'  : y_sra_7
                                                    , 'nq'  : y_sra_0_4
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        ############  MULTIPLEXOR Y LAYER 1 ############
        self.instances['y_sra_1_0'] = Inst( 'nmux2_16b', 'y_sra_1_0'
                                           , map = { 'cmd'  : self.i_p[1]
                                                    , 'i0'  : y_sra_0_0
                                                    , 'i1'  : y_sra_0_1
                                                    , 'nq'  : y_sra_1_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_1_1'] = Inst( 'nmux2_16b', 'y_sra_1_1'
                                           , map = { 'cmd'  : self.i_p[1]
                                                    , 'i0'  : y_sra_0_3
                                                    , 'i1'  : y_sra_0_4
                                                    , 'nq'  : y_sra_1_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        ############  MULTIPLEXOR Y LAYER 2 ############
        self.instances['y_sra_i']   = Inst( 'mux2_16b', 'y_sra_i'
                                           , map = { 'cmd'  : self.i_p[2]
                                                    , 'i0'  : y_sra_1_0
                                                    , 'i1'  : y_sra_1_1
                                                    , 'q'   : y_sra_i # pas nq
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )




        ############  MULTIPLEXOR BEFORE ADD FOR N_XKC ############
        ############  (before n_xkc_p_mux_0) MULTIPLEXOR commanded by xmkc_p LAYER 0 ############
        ############  MULTIPLEXOR 0 commanded by xmkc_p LAYER 0 ############
        self.instances['n_xkc_p_internal_mux0'] = Inst( 'nmux2_16b', 'n_xkc_p_internal_mux0'
                                                      , map = { 'cmd'  : self.I
                                                               , 'i0'  : x_sra_1
                                                               , 'i1'  : zero_16b
                                                               , 'q'   : n_xkc_p_internal_mux_out1
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        self.instances['n_xkc_p_internal_mux1'] = Inst( 'nmux2_16b', 'n_xkc_p_internal_mux1'
                                                      , map = { 'cmd'  : self.G
                                                               , 'i0'  : x_sra_5
                                                               , 'i1'  : x_sra_4
                                                               , 'q'   : n_xkc_p_internal_mux_out0
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        
        self.instances['n_xkc_p_mux_0'] = Inst( 'nmux2_16b', 'n_xkc_p_mux_0'
                                               , map = { 'cmd'  : self.H
                                                        , 'i0'  : n_xkc_p_internal_mux_out0
                                                        , 'i1'  : n_xkc_p_internal_mux_out1
                                                        , 'q'   : n_xkc_p_mux_out_0
                                                        , 'vdd' : self.vdd
                                                        , 'vss' : self.vss
                                                        })

        self.instances['n_xkc_p_mux_1'] = Inst( 'mux2_16b', 'n_xkc_p_mux_1'
                                               , map = { 'cmd'  : self.J
                                                        , 'i0'  : x_sra_7
                                                        , 'i1'  : xkc
                                                        , 'q'   : n_xkc_p_mux_out_1
                                                        , 'vdd' : self.vdd
                                                        , 'vss' : self.vss
                                                        })

        ############  ADDER/SUBBER 0 X  ############
        self.instances['x_adder_16_0']     = Inst ( 'adder_16', 'x_adder_16_0'
                                                   , map = { 'i0'       : n_xkc_p_mux_out_0
                                                            , 'i1'      : n_xkc_p_mux_out_1
                                                            , 'add_sub' : zero_16b
                                                            , 'q'       : n_xkc
                                                            , 'c30'     : x_signed_overflow_0
                                                            , 'c31'     : x_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })


        ############  REGISTER AFTER ADDER/SUBBER 0 X  ############
        self.instances['xkc_register']      = Inst ( 'sff_16', 'xkc_register'
                                                    , map = { "wen" : self.ck
                                                             , "ck"  : self.ck
                                                             , "i0"  : n_xkc
                                                             ,  "q"  : xkc
                                                             , 'vdd' : self.vdd
                                                             , 'vss' : self.vss
                                                             })

        
        
        self.instances['p_m_xkc']         = Inst ( 'adder_16', 'p_m_xkc'
                                                   , map = { 'i0'       : zero_16b
                                                            , 'i1'      : xkc
                                                            , 'add_sub' : self.E
                                                            , 'q'       : p_m_xkc
                                                            , 'c30'     : p_m_xkc_signed_overflow_0
                                                            , 'c31'     : p_m_xkc_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })



        ############  ADDER/SUBBER 1 X  ############
        self.instances['x_adder_16_1']     = Inst ( 'adder_16', 'x_adder_16_1'
                                                   , map = { 'i0'       : x
                                                            , 'i1'      : y_sra_i
                                                            , 'add_sub' : self.C0
                                                            , 'q'       : x_plus_minus_y_sra_i
                                                            , 'c30'     : x_signed_overflow_1
                                                            , 'c31'     : x_unsigned_overflow_1
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })

        ############  OUTPUT MUX 5 TO 1 GIVE nx  ############
        ############  OUTPUT MULTI LAYER OF MUX2  ############
        self.instances['nx_mux_2_1_layer0_A']   = Inst( 'mux2_16b', 'nx_mux_2_1_layer0_A'
                                                      , map = { 'cmd'  : self.A
                                                               , 'i0'  : x
                                                               , 'i1'  : X##TODO trouver comment générer la pseudo-constante X <= x7|x|0000000 et la sortie nx_p du circuit nx_p <=  x(14 downto 7); 
                                                               , 'q'   : nx_internal_mux0_A
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
                                                               
        self.instances['nx_mux_2_1_layer1_B']   = Inst( 'mux2_16b', 'nx_mux_2_1_layer0_B'
                                                      , map = { 'cmd'  : self.B
                                                               , 'i0'  : p_m_xkc
                                                               , 'i1'  : p_m_ykc
                                                               , 'q'   : nx_internal_mux1_B
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        self.instances['nx_mux_2_1_layer1_C']   = Inst( 'mux2_16b', 'nx_mux_2_1_layer0_C'
                                                      , map = { 'cmd'  : self.C
                                                               , 'i0'  : x_plus_minus_y_sra_i
                                                               , 'i1'  : nx_internal_mux0_A
                                                               , 'q'   : nx_internal_mux1_C
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        self.instances['nx_mux_2_1_layer2_D']   = Inst( 'mux2_16b', 'nx_mux_2_1_layer2_D'
                                                      , map = { 'cmd'  : self.D
                                                               , 'i0'  : nx_internal_mux1_C
                                                               , 'i1'  : nx_internal_mux1_B
                                                               , 'q'   : n_x
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        self.instances['x_register']      = Inst ( 'sff_16', 'x_register'
                                                    , map = { "wen" : self.ck
                                                             , "ck"  : self.ck
                                                             , "i0"  : n_x
                                                             ,  "q"  : x
                                                             , 'vdd' : self.vdd
                                                             , 'vss' : self.vss
                                                             })

        ############  MULTIPLEXOR BEFORE ADD FOR N_YKC ############
        ############  (before n_ykc_p_mux_0) MULTIPLEXOR commanded by ymkc_p LAYER 0 ############
        self.instances['n_ykc_p_internal_mux'] = Inst( 'mux2_16b', 'n_ykc_p_internal_mux'
                                                      , map = { 'cmd'  : self.ymkc_p
                                                               , 'i0'  : y_sra_4
                                                               , 'i1'  : y_sra_5
                                                               , 'q'   : n_ykc_p_internal_mux_out
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        self.instances['or2_1']         = Inst ( 'or2_1', 'inst'
                                                , map = { 'i0'  : self.ymkc_p[1]
                                                         , 'i1'  : self.ymkc_p[0]
                                                         , 'q'   : ymkc_command
                                                         , 'vdd' : self.vdd
                                                         , 'vss' : self.vss
                                                         })


        ############  MULTIPLEXOR 0 commanded by ymkc_p LAYER 1 ############
        self.instances['n_ykc_p_mux_0'] = Inst( 'mux2_16b', 'n_ykc_p_mux_0'
                                               , map = { 'cmd'  : xmkc_command
                                                        , 'i0'  : y_sra_1
                                                        , 'i1'  : n_ykc_p_internal_mux_out
                                                        , 'q'   : n_ykc_p_mux_out_0
                                                        , 'vdd' : self.vdd
                                                        , 'vss' : self.vss
                                                        })

        ############  COMMAND MULTIPLEXOR 1 ymkc_p[0] or ymkc_p[1] LAYER 2 ############
        self.instances['or2_1']         = Inst ( 'or2_1', 'inst'
                                                , map = { 'i0'  : self.ymkc_p[1]
                                                         , 'i1'  : self.ymkc_p[0]
                                                         , 'q'   : ymkc_command
                                                         , 'vdd' : self.vdd
                                                         , 'vss' : self.vss
                                                         })


        ############  MULTIPLEXOR 1 commanded by xmkc_p LAYER 1 ############
        self.instances['n_ykc_p_mux_1'] = Inst( 'mux2_16b', 'n_ykc_p_mux_1'
                                               , map = { 'cmd'  : ymkc_command
                                                        , 'i0'  : ykc
                                                        , 'i1'  : y_sra_7
                                                        , 'q'   : n_ykc_p_mux_out_1
                                                        , 'vdd' : self.vdd
                                                        , 'vss' : self.vss
                                                        })

        ############  ADDER/SUBBER 0 y  ############
        self.instances['y_adder_16_0']     = Inst ( 'adder_16', 'y_adder_16_0'
                                                   , map = { 'i0'       : n_ykc_p_mux_out_0
                                                            , 'i1'      : n_ykc_p_mux_out_1
                                                            , 'add_sub' : zero_16b
                                                            , 'q'       : n_ykc
                                                            , 'c30'     : y_signed_overflow_0
                                                            , 'c31'     : y_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })

        ############  REGISTER AFTER ADDER/SUBBER 0 Y  ############
        self.instances['ykc_register']       = Inst ( 'sff_16', 'ykc_register'
                                                     , map = { "wen" : self.ck
                                                              , "ck"  : self.ck
                                                              , "i0"  : n_ykc
                                                              ,  "q"  : ykc
                                                              , 'vdd' : self.vdd
                                                              , 'vss' : self.vss
                                                              })

        self.instances['y_inv']              = Inst ( 'inv_16', 'y_inv'
                                                  , map = { 'i0'  : ykc
                                                          , 'nq'  : not_ykc
                                                          , 'vdd' : self.vdd
                                                          , 'vss' : self.vss
                                                          })

        self.instances['minus_ykc']         = Inst ( 'adder_16', 'minus_ykc'
                                                   , map = { 'i0'       : not_ykc
                                                            , 'i1'      : zero_16b
                                                            , 'add_sub' : one_1b
                                                            , 'q'       : minus_ykc
                                                            , 'c30'     : minus_ykc_signed_overflow_0
                                                            , 'c31'     : minus_ykc_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })

        ############  ADDER/SUBBER 1 y  ############
        self.instances['y_adder_16_1']     = Inst ( 'adder_16', 'y_adder_16_1'
                                                   , map = { 'i0'       : y
                                                            , 'i1'      : x_sra_i
                                                            , 'add_sub' : self.ycmd_p[1]#TODO
                                                            , 'q'       : y_plus_minus_x_sra_i
                                                            , 'c30'     : y_signed_overflow_1
                                                            , 'c31'     : y_unsigned_overflow_1
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })



        return


    def Layout ( self ):
        print 'Cordic_DP.Layout()'

        # X processing.
        Place     ( self.instances['zero_16b'        ], NOSYM, XY( 0, 0 ) )
        PlaceRight( self.instances['x_sra_0_0'       ], NOSYM )

        # Layout a completer.
        # ...

        return


    def ScriptMain ( **kw ):
        if kw.has_key('editor') and kw['editor']: setEditor( kw['editor'] )

        cordic_dp = Cordic_DP( "cordic_dp" )

        cordic_dp.Interface()
        cordic_dp.Netlist  ()
        cordic_dp.Layout   ()
        cordic_dp.Save     (LOGICAL|PHYSICAL)
        return 1


    if __name__ == "__main__" :
        kw      = {}
        success = ScriptMain( **kw )
        if not success: shellSuccess = 1

        sys.exit( shellSuccess )


