#!/usr/bin/env python

import sys
import symbolic.cmos
from   stratus import *


class Cordic_DP ( Model ):

    def Interface ( self ):
        print 'Cordic_DP.Interface()'
        self.ck         = CkIn     ( 'ck'  )
        self.x_p        = SignalIn ( 'x_p',    8 )
        self.y_p        = SignalIn ( 'y_p',    8 )
        self.nx_p       = SignalOut( 'nx_p',   8 )
        self.ny_p       = SignalOut( 'ny_p',   8 )

        self.i_p                        = SignalIn( 'i_p'                       , 4 )
        self.cmd_n_0                    = SignalIn( 'cmd_n_0'                   , 1 )
        self.cmd_n_1_1                  = SignalIn( 'cmd_n_1_1'                 , 1 )
        self.cmd_n_1_0                  = SignalIn( 'cmd_n_1_0'                 , 1 )
        self.cmd_n                      = SignalIn( 'cmd_n'                     , 1 )
        self.cmd_adder_pm_xkc           = SignalIn( 'cmd_adder_pm_xkc'          , 1 )
        self.cmd_adder_pm_ykc           = SignalIn( 'cmd_adder_pm_ykc'          , 1 )
        self.cmd_post0_adder_1          = SignalIn( 'cmd_post0_adder_1'         , 1 )
        self.cmd_post0_adder            = SignalIn( 'cmd_post0_adder'           , 1 )
        self.cmd_post0_adder_0          = SignalIn( 'cmd_post0_adder_0'         , 1 )
        self.cmd_post1_adder            = SignalIn( 'cmd_post1_adder'           , 1 )
        self.cmd_adder_x_pm_y_sra_i     = SignalIn( 'cmd_adder_x_pm_y_sra_i'    , 1 )
        self.cmd_adder_y_pm_x_sra_i     = SignalIn( 'cmd_adder_y_pm_x_sra_i'    , 1 )

        self.vdd        = VddIn    ( 'vdd' )
        self.vss        = VddIn    ( 'vss' )
        return


    def Netlist ( self ):
        print 'Cordic_DP.Netlist()'
        #######################################################################
        # MASTER CELL
        #######################################################################
        Generate( 'DpgenNmux2'  ,  'nmux2_16b'  , param={'nbit':16,     'behavioral':True,'physical':True,'flags':0} )
        Generate( 'DpgenMux2'   ,  'mux2_16b'   , param={'nbit':16,     'behavioral':True,'physical':True,'flags':0} )
        # Generate( 'DpgenOr2'  ,  'or2'        , param={'nbit': 1,'physical'  :True,'behavioral':True} )
        Generate( 'DpgenOr2'    , 'or2_1'       , param={'nbit': 1,     'physical' : True })
        Generate ( 'DpgenAdsb2f', 'adder_16'    , param={'nbit': 16,   'physical' : True })
        Generate ( 'DpgenConst' , 'zero_16b'    , param={'nbit': 16,   'const': "0x0000" , 'physical' : True })
        Generate ( 'DpgenConst' , 'zero_7b'     , param={'nbit': 7,     'const' : "0b0000000" , 'physical' : True })
        Generate ( 'DpgenConst' , 'zero_1b'     , param={'nbit': 1,     'const' : "0b0" , 'physical' : True })
        Generate ( 'DpgenConst' , 'one_1b'      , param={'nbit': 1,     'const' : "0b1" , 'physical' : True })
        Generate ( 'DpgenSff'   , 'sff_16'      , param={'nbit': 16, 'physical' : True })
        Generate ( 'DpgenInv'   , 'inv_16'      , param={'nbit': 16, 'physical' : True })
        #######################################################################

        #######################################################################
        # LISTE DES INSTANCES
        #######################################################################
        self.instances = {}
        #######################################################################

        #######################################################################
        ############################## SIGNALS ################################
        #######################################################################
        ######################### CONSTANT SIGNALS ############################
        #######################################################################
        zero_16b_0_x        = Signal( 'zero_16b_0_x',    16 )
        zero_16b_1_x        = Signal( 'zero_16b_1_x',    16 )
        zero_16b_0_y        = Signal( 'zero_16b_0_y',    16 )
        zero_16b_1_y        = Signal( 'zero_16b_1_y',    16 )
        zero_7b_x           = Signal( 'zero_7b_x' ,       7 )
        zero_7b_y           = Signal( 'zero_7b_y' ,       7 )
        zero_1b_x           = Signal( 'zero_1b_x',        1 )
        zero_1b_y           = Signal( 'zero_1b_y',        1 )
        #one_1b              = Signal( 'one_1b',          1 )
        self.instances['zero_16b_0_x'] = Inst( 'zero_16b', 'zero_16b_0_x'
                                          , map = { 'q'   : zero_16b_0_x
                                                   , 'vdd' : self.vdd
                                                   , 'vss' : self.vss
                                                   } )
        self.instances['zero_16b_1_x'] = Inst( 'zero_16b', 'zero_16b_1_x'
                                          , map = { 'q'   : zero_16b_1_x
                                                   , 'vdd' : self.vdd
                                                   , 'vss' : self.vss
                                                   } )
        self.instances['zero_16b_0_y'] = Inst( 'zero_16b', 'zero_16b_0_y'
                                          , map = { 'q'   : zero_16b_0_y
                                                   , 'vdd' : self.vdd
                                                   , 'vss' : self.vss
                                                   } )
        self.instances['zero_16b_1_y'] = Inst( 'zero_16b', 'zero_16b_1_y'
                                          , map = { 'q'   : zero_16b_1_y
                                                   , 'vdd' : self.vdd
                                                   , 'vss' : self.vss
                                                   } )
        self.instances['zero_7b_x'] = Inst( 'zero_7b', 'zero_7b_x'
                                         , map = { 'q'   : zero_7b_x
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        self.instances['zero_7b_y'] = Inst( 'zero_7b', 'zero_7b_y'
                                         , map = { 'q'   : zero_7b_y
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        self.instances['zero_1b_x'] = Inst( 'zero_1b', 'zero_1b_x'
                                         , map = { 'q'   : zero_1b_x
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        self.instances['zero_1b_y'] = Inst( 'zero_1b', 'zero_1b_y'
                                         , map = { 'q'   : zero_1b_y
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        # self.instances['one_1b'] = Inst( 'one_1b', 'one_1b'
        #                                  , map = { 'q'   : one_1b
        #                                           , 'vdd' : self.vdd
        #                                           , 'vss' : self.vss
        #                                           } )
        #######################################################################
        ########################## DEPENDENCY SIGNALS #########################
        #######################################################################
        pm_xkc              = Signal( 'pm_xkc'  ,      16 )
        pm_ykc              = Signal( 'pm_ykc'  ,      16 )#
#
        x_sra_i             = Signal( 'x_sra_i' ,      16 )
        y_sra_i             = Signal( 'y_sra_i' ,      16 )
        #######################################################################
        ########################## x_sra_i SIGNALS ############################
        #######################################################################
        x                   = Signal( 'x',              16 )
        ### shift_cat
        x_sra_1             = Signal( 'x_sra_1',        16 )
        x_sra_1.Alias( Cat( x[15],x[15:1] ) )
        x_sra_2             = Signal( 'x_sra_2',        16 )
        x_sra_2.Alias( Cat( x[15],x[15],x[15:2] ) )
        x_sra_3             = Signal( 'x_sra_3',        16 )
        x_sra_3.Alias( Cat( x[15],x[15],x[15],x[15:3] ) )
        x_sra_4             = Signal( 'x_sra_4',        16 )
        x_sra_4.Alias( Cat( x[15],x[15],x[15],x[15],x[15:4] ) )
        x_sra_5             = Signal( 'x_sra_5',        16 )
        x_sra_5.Alias( Cat( x[15],x[15],x[15],x[15],x[15],x[15:5] ) )
        x_sra_6             = Signal( 'x_sra_6',        16 )
        x_sra_6.Alias( Cat( x[15],x[15],x[15],x[15],x[15],x[15],x[15:6] ) )
        x_sra_7             = Signal( 'x_sra_7',        16 )
        x_sra_7.Alias( Cat( x[15],x[15],x[15],x[15],x[15],x[15],x[15],x[15:7] ) )
        ### x7_x_0 cat_SIGNALS
        x7_x_0              = Signal( 'x7_x_0',         16 )
        x7_x_0.Alias( Cat( self.x_p[7],self.x_p,zero_7b_x ) )
        #######################################################################

        #######################################################################
        ############################## SHIFTER X ##############################
        #######################################################################
        ######################## MULTIPLEXOR X LAYER 1 ########################
        ####### x_sra_0_j SIGNALS//first stage of x_sra MUX : x_sra_0_j #######
        x_sra_0_0           = Signal( 'x_sra_0_0',      16 )
        x_sra_0_1           = Signal( 'x_sra_0_1',      16 )
        x_sra_0_2           = Signal( 'x_sra_0_2',      16 )
        x_sra_0_3           = Signal( 'x_sra_0_3',      16 )
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

        self.instances['x_sra_0_2'] = Inst( 'nmux2_16b', 'x_sra_0_2'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x_sra_4
                                                    , 'i1'  : x_sra_5
                                                    , 'nq'  : x_sra_0_2
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['x_sra_0_3'] = Inst( 'nmux2_16b', 'x_sra_0_3'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x_sra_6
                                                    , 'i1'  : x_sra_7
                                                    , 'nq'  : x_sra_0_3
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )
        ######################## MULTIPLEXOR X LAYER 2 ########################
        ###### x_sra_1_k SIGNALS //second stage of x_sra MUX : x_sra_0_j ######
        x_sra_1_0           = Signal( 'x_sra_1_0',      16 )
        x_sra_1_1           = Signal( 'x_sra_1_1',      16 )
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
                                                    , 'i0'  : x_sra_0_2
                                                    , 'i1'  : x_sra_0_3
                                                    , 'nq'  : x_sra_1_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )
        ######################## MULTIPLEXOR X LAYER 2 ########################
        ######## x_sra_i SIGNALS //last stage of x_sra MUX : x_sra_0_j ########
        #DEPENDENCY# x_sra_i             = Signal( 'x_sra_i'  ,      16 )
        self.instances['x_sra_i'] = Inst( 'mux2_16b', 'x_sra_i'
                                         , map = { 'cmd' : self.i_p[2]
                                                  , 'i0'  : x_sra_1_0
                                                  , 'i1'  : x_sra_1_1
                                                  , 'q'  : x_sra_i # pas nq
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ######################################################################END SHIFTX


        ######################################################################
        ############################# xkc BLOCK ##############################BEGIN
        xkc                 = Signal( 'xkc',                16 )
        ########################## xkc_post0_adder ###########################
        ######################################################################
        xkc_post0_adder_0   = Signal( 'xkc_post0_adder_0',  16 )
        xkc_post0_adder_1   = Signal( 'xkc_post0_adder_1',  16 )
        self.instances['xkc_post0_adder_0'] = Inst( 'nmux2_16b', 'xkc_post0_adder_0'
                                                      , map = { 'cmd'  : self.cmd_post0_adder_0
                                                               , 'i0'  : x_sra_1
                                                               , 'i1'  : zero_16b_0_x
                                                               , 'nq'  : xkc_post0_adder_0
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        self.instances['xkc_post0_adder_1'] = Inst( 'nmux2_16b', 'xkc_post0_adder_1'
                                                      , map = { 'cmd'  : self.cmd_post0_adder_1
                                                               , 'i0'  : x_sra_5
                                                               , 'i1'  : x_sra_4
                                                               , 'nq'  : xkc_post0_adder_1
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        xkc_post0_adder     = Signal( 'xkc_post0_adder',    16 )
        self.instances['xkc_post0_adder'] = Inst( 'nmux2_16b', 'xkc_post0_adder'
                                                      , map = { 'cmd'  : self.cmd_post0_adder
                                                               , 'i0'  : xkc_post0_adder_0
                                                               , 'i1'  : xkc_post0_adder_1
                                                               , 'nq'  : xkc_post0_adder
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        ######################################################################END xkc_post0_adder

        ######################################################################
        ########################## xkc_post1_adder ###########################
        ######################################################################
        xkc_post1_adder     = Signal( 'xkc_post1_adder',    16 )
        self.instances['xkc_post1_adder'] = Inst( 'mux2_16b', 'xkc_post1_adder'
                                                      , map = { 'cmd'  : self.cmd_post1_adder
                                                               , 'i0'  : x_sra_7
                                                               , 'i1'  : xkc
                                                               , 'q'   : xkc_post1_adder
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        ######################################################################END xkc_post1_adder

        ############  ADDER/SUBBER 0 X  ############
        n_xkc_adder               = Signal( 'n_xkc_adder',              16 )
        n_xkc_adder_signed_overflow_0         = Signal( 'n_xkc_adder_signed_overflow_0',    1 )
        n_xkc_adder_unsigned_overflow_0       = Signal( 'n_xkc_adder_unsigned_overflow_0',  1 )
        self.instances['n_xkc_adder']     = Inst ( 'adder_16', 'n_xkc_adder'
                                                   , map = { 'i0'       : xkc_post0_adder
                                                            , 'i1'      : xkc_post1_adder
                                                            , 'q'       : n_xkc_adder
                                                            , 'add_sub' : zero_1b_x
                                                            , 'c30'     : n_xkc_adder_signed_overflow_0
                                                            , 'c31'     : n_xkc_adder_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })
        ############  REGISTER AFTER ADDER/SUBBER 0 X  ############
        self.instances['xkc_reg']       = Inst ( 'sff_16', 'xkc_reg'
                                                    , map = { "wen" : self.ck
                                                             , "ck"  : self.ck
                                                             , "i0"  : n_xkc_adder
                                                             ,  "q"  : xkc
                                                             , 'vdd' : self.vdd
                                                             , 'vss' : self.vss
                                                             })
        ######################################################################END xkc BLOCK
        
        ######################################################################
        ################################ pm BLOCK ############################BEGIN
        #!# pm_xkc              = Signal( 'pm_xkc',             16 )
        pm_xkc_signed_overflow_0        = Signal( 'pm_xkc_signed_overflow_0',    1 )
        pm_xkc_unsigned_overflow_0      = Signal( 'pm_xkc_unsigned_overflow_0',  1 )
        self.instances['adder_pm_xkc']        = Inst ( 'adder_16', 'adder_pm_xkc'
                                                   , map = { 'i0'       : zero_16b_1_x
                                                            , 'i1'      : xkc
                                                            , 'add_sub' : self.cmd_adder_pm_xkc
                                                            , 'q'       : pm_xkc
                                                            ,    'c30'     : pm_xkc_signed_overflow_0
                                                            ,    'c31'     : pm_xkc_unsigned_overflow_0
                                                            ,    'vdd'     : self.vdd
                                                            ,    'vss'     : self.vss
                                                            })

        x_pm_y_sra_i              = Signal( 'x_pm_y_sra_i',             16 )
        x_pm_y_sra_i_signed_overflow_0        = Signal( 'x_pm_y_sra_i_signed_overflow_0',    1 )
        x_pm_y_sra_i_unsigned_overflow_0      = Signal( 'x_pm_y_sra_i_unsigned_overflow_0',  1 )
        self.instances['adder_x_pm_y_sra_i']        = Inst ( 'adder_16', 'adder_x_pm_y_sra_i'
                                                   , map = { 'i0'       : x
                                                            , 'i1'      : y_sra_i
                                                            , 'add_sub' : self.cmd_adder_x_pm_y_sra_i
                                                            , 'q'       : x_pm_y_sra_i
                                                            , 'c30'     : x_pm_y_sra_i_signed_overflow_0
                                                            , 'c31'     : x_pm_y_sra_i_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })
        ######################################################################END pm BLOCK

        ######################################################   ################
        ############################### NX STAGES SHIFTER ####   ################
        ############################### STAGE 0 ##############   ################
        n_x_0              = Signal( 'n_x_0',             16 )   
        self.instances['n_x_0'] = Inst( 'mux2_16b', 'n_x_0'
                                         , map = { 'cmd' : self.cmd_n_0
                                                  , 'i0'  : x
                                                  , 'i1'  : x7_x_0
                                                  , 'q'   : n_x_0 # pas nq
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ############################### STAGE 1 ##############################
        n_x_1_0              = Signal( 'n_x_1_0',             16 )
        n_x_1_1              = Signal( 'n_x_1_1',             16 )
        self.instances['n_x_1_0'] = Inst( 'nmux2_16b', 'n_x_1_0'
                                         , map = { 'cmd' : self.cmd_n_1_0
                                                  , 'i0'  : x_pm_y_sra_i
                                                  , 'i1'  : n_x_0
                                                  , 'nq'  : n_x_1_0
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        self.instances['n_x_1_1'] = Inst( 'nmux2_16b', 'n_x_1_1'
                                         , map = { 'cmd' : self.cmd_n_1_1
                                                  , 'i0'  : pm_xkc
                                                  , 'i1'  : pm_ykc
                                                  , 'nq'  : n_x_1_1
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ############################### STAGE 2 ##############################
        n_x              = Signal( 'n_x',             16 )
        self.instances['n_x'] = Inst( 'nmux2_16b', 'n_x'
                                         , map = { 'cmd' : self.cmd_n
                                                  , 'i0'  : n_x_1_0
                                                  , 'i1'  : n_x_1_1
                                                  , 'nq'  : n_x
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ######################################################################END NX STAGES SHIFTER

        ######################################################################
        ############################### X REG ################################
        self.instances['x_reg']       = Inst ( 'sff_16', 'x_reg'
                                                    , map = { "wen" : self.ck
                                                             , "ck"  : self.ck
                                                             , "i0"  : n_x
                                                             ,  "q"  : x
                                                             , 'vdd' : self.vdd
                                                             , 'vss' : self.vss
                                                             })
        ######################################################################END X REG

#######################################END X DATAPATH#################################

######################################################################################
######################################################################################
######################################################################################
######################################################################################
######################################################################################

#######################################BEGIN Y DATAPATH###############################




        #######################################################################
        ########################## y_sra_i SIGNALS ############################
        #######################################################################
        y                   = Signal( 'y',              16 )
        ### shift_cat
        y_sra_1             = Signal( 'y_sra_1',        16 )
        y_sra_1.Alias( Cat( y[15],y[15:1] ) )
        y_sra_2             = Signal( 'y_sra_2',        16 )
        y_sra_2.Alias( Cat( y[15],y[15],y[15:2] ) )
        y_sra_3             = Signal( 'y_sra_3',        16 )
        y_sra_3.Alias( Cat( y[15],y[15],y[15],y[15:3] ) )
        y_sra_4             = Signal( 'y_sra_4',        16 )
        y_sra_4.Alias( Cat( y[15],y[15],y[15],y[15],y[15:4] ) )
        y_sra_5             = Signal( 'y_sra_5',        16 )
        y_sra_5.Alias( Cat( y[15],y[15],y[15],y[15],y[15],y[15:5] ) )
        y_sra_6             = Signal( 'y_sra_6',        16 )
        y_sra_6.Alias( Cat( y[15],y[15],y[15],y[15],y[15],y[15],y[15:6] ) )
        y_sra_7             = Signal( 'y_sra_7',        16 )
        y_sra_7.Alias( Cat( y[15],y[15],y[15],y[15],y[15],y[15],y[15],y[15:7] ) )
        ### y7_y_0 cat_SIGNALS
        y7_y_0              = Signal( 'y7_y_0',         16 )
        y7_y_0.Alias( Cat( self.y_p[7],self.y_p,zero_7b_y ) )
        #######################################################################

        #######################################################################
        ############################## SHIFTER Y ##############################
        #######################################################################
        ######################## MULTIPLEXOR Y LAYER 1 ########################
        ####### y_sra_0_j SIGNALS//first stage of y_sra MUX : y_sra_0_j #######
        y_sra_0_0           = Signal( 'y_sra_0_0',      16 )
        y_sra_0_1           = Signal( 'y_sra_0_1',      16 )
        y_sra_0_2           = Signal( 'y_sra_0_2',      16 )
        y_sra_0_3           = Signal( 'y_sra_0_3',      16 )
        self.instances['y_sra_0_0'] = Inst( 'nmux2_16b', 'y_sra_0_0'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : y
                                                    , 'i1'  : y_sra_1
                                                    , 'nq'  : y_sra_0_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_0_1'] = Inst( 'nmux2_16b', 'y_sra_0_1'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : y_sra_2
                                                    , 'i1'  : y_sra_3
                                                    , 'nq'  : y_sra_0_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_0_2'] = Inst( 'nmux2_16b', 'y_sra_0_2'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : y_sra_4
                                                    , 'i1'  : y_sra_5
                                                    , 'nq'  : y_sra_0_2
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_0_3'] = Inst( 'nmux2_16b', 'y_sra_0_3'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : y_sra_6
                                                    , 'i1'  : y_sra_7
                                                    , 'nq'  : y_sra_0_3
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )
        ######################## MULTIPLEXOR X LAYER 2 ########################
        ###### y_sra_1_k SIGNALS //second stage of y_sra MUX : y_sra_0_j ######
        y_sra_1_0           = Signal( 'y_sra_1_0',      16 )
        y_sra_1_1           = Signal( 'y_sra_1_1',      16 )
        self.instances['y_sra_1_0'] = Inst( 'nmux2_16b', 'y_sra_1_0'
                                           , map = { 'cmd' : self.i_p[1]
                                                    , 'i0'  : y_sra_0_0
                                                    , 'i1'  : y_sra_0_1
                                                    , 'nq'  : y_sra_1_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        self.instances['y_sra_1_1'] = Inst( 'nmux2_16b', 'y_sra_1_1'
                                           , map = { 'cmd' : self.i_p[1]
                                                    , 'i0'  : y_sra_0_2
                                                    , 'i1'  : y_sra_0_3
                                                    , 'nq'  : y_sra_1_1
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )
        ######################## MULTIPLEXOR X LAYER 2 ########################
        ######## y_sra_i SIGNALS //last stage of y_sra MUX : y_sra_0_j ########
        #DEPENDENCY# y_sra_i             = Signal( 'y_sra_i'  ,      16 )
        self.instances['y_sra_i'] = Inst( 'mux2_16b', 'y_sra_i'
                                         , map = { 'cmd' : self.i_p[2]
                                                  , 'i0'  : y_sra_1_0
                                                  , 'i1'  : y_sra_1_1
                                                  , 'q'  : y_sra_i # pas nq
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ######################################################################END SHIFTX


        ######################################################################
        ############################# ykc BLOCK ##############################BEGIN
        ykc                 = Signal( 'ykc',                16 )
        ########################## ykc_post0_adder ###########################
        ######################################################################
        ykc_post0_adder_0   = Signal( 'ykc_post0_adder_0',  16 )
        ykc_post0_adder_1   = Signal( 'ykc_post0_adder_1',  16 )
        self.instances['ykc_post0_adder_0'] = Inst( 'nmux2_16b', 'ykc_post0_adder_0'
                                                      , map = { 'cmd'  : self.cmd_post0_adder_0
                                                               , 'i0'  : y_sra_1
                                                               , 'i1'  : zero_16b_0_y
                                                               , 'nq'  : ykc_post0_adder_0
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        self.instances['ykc_post0_adder_1'] = Inst( 'nmux2_16b', 'ykc_post0_adder_1'
                                                      , map = { 'cmd'  : self.cmd_post0_adder_1
                                                               , 'i0'  : y_sra_5
                                                               , 'i1'  : y_sra_4
                                                               , 'nq'  : ykc_post0_adder_1
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })

        ykc_post0_adder     = Signal( 'ykc_post0_adder',    16 )
        self.instances['ykc_post0_adder'] = Inst( 'nmux2_16b', 'ykc_post0_adder'
                                                      , map = { 'cmd'  : self.cmd_post0_adder
                                                               , 'i0'  : ykc_post0_adder_0
                                                               , 'i1'  : ykc_post0_adder_1
                                                               , 'nq'  : ykc_post0_adder
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        ######################################################################END ykc_post0_adder

        ######################################################################
        ########################## ykc_post1_adder ###########################
        ######################################################################
        ykc_post1_adder     = Signal( 'ykc_post1_adder',    16 )
        self.instances['ykc_post1_adder'] = Inst( 'mux2_16b', 'ykc_post1_adder'
                                                      , map = { 'cmd'  : self.cmd_post1_adder
                                                               , 'i0'  : y_sra_7
                                                               , 'i1'  : ykc
                                                               , 'q'   : ykc_post1_adder
                                                               , 'vdd' : self.vdd
                                                               , 'vss' : self.vss
                                                               })
        ######################################################################END ykc_post1_adder

        ############  ADDER/SUBBER 0 Y  ############
        n_ykc               = Signal( 'n_ykc',              16 )
        n_ykc_signed_overflow_0         = Signal( 'n_ykc_signed_overflow_0',    1 )
        n_ykc_unsigned_overflow_0       = Signal( 'n_ykc_unsigned_overflow_0',  1 )
        self.instances['ykc_adder']     = Inst ( 'adder_16', 'ykc_adder'
                                                   , map = { 'i0'       : ykc_post0_adder
                                                            , 'i1'      : ykc_post1_adder
                                                            , 'add_sub' : zero_1b_y
                                                            , 'q'       : n_ykc
                                                            , 'c30'     : n_ykc_signed_overflow_0
                                                            , 'c31'     : n_ykc_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })
        ############  REGISTER AFTER ADDER/SUBBER 0 Y  ############
        self.instances['ykc_reg']       = Inst ( 'sff_16', 'ykc_reg'
                                                    , map = { "wen" : self.ck
                                                             , "ck"  : self.ck
                                                             , "i0"  : n_ykc
                                                             ,  "q"  : ykc
                                                             , 'vdd' : self.vdd
                                                             , 'vss' : self.vss
                                                             })
        ######################################################################END ykc BLOCK
        
        ######################################################################
        ################################ pm BLOCK ############################BEGIN
        #!# pm_ykc              = Signal( 'pm_ykc',             16 )
        pm_ykc_signed_overflow_0        = Signal( 'pm_ykc_signed_overflow_0',    1 )
        pm_ykc_unsigned_overflow_0      = Signal( 'pm_ykc_unsigned_overflow_0',  1 )
        self.instances['adder_pm_ykc']        = Inst ( 'adder_16', 'adder_pm_ykc'
                                                   , map = { 'i0'       : zero_16b_1_y
                                                            , 'i1'      : ykc
                                                            , 'add_sub' : self.cmd_adder_pm_ykc
                                                            , 'q'       : pm_ykc
                                                            , 'c30'     : pm_ykc_signed_overflow_0
                                                            , 'c31'     : pm_ykc_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })

        y_pm_x_sra_i              = Signal( 'y_pm_x_sra_i',             16 )
        y_pm_x_sra_i_signed_overflow_0        = Signal( 'y_pm_x_sra_i_signed_overflow_0',    1 )
        y_pm_x_sra_i_unsigned_overflow_0      = Signal( 'y_pm_x_sra_i_unsigned_overflow_0',  1 )
        self.instances['adder_y_pm_x_sra_i']        = Inst ( 'adder_16', 'adder_y_pm_x_sra_i'
                                                   , map = { 'i0'       : y
                                                            , 'i1'      : x_sra_i
                                                            , 'add_sub' : self.cmd_adder_y_pm_x_sra_i
                                                            , 'q'       : y_pm_x_sra_i
                                                            , 'c30'     : y_pm_x_sra_i_signed_overflow_0
                                                            , 'c31'     : y_pm_x_sra_i_unsigned_overflow_0
                                                            , 'vdd'     : self.vdd
                                                            , 'vss'     : self.vss
                                                            })
        ######################################################################END pm BLOCK

        ######################################################################
        ############################### NY STAGES SHIFTER ####################
        ############################### STAGE 0 ##############################
        n_y_0              = Signal( 'n_y_0',             16 )
        self.instances['n_y_0'] = Inst( 'mux2_16b', 'n_y_0'
                                         , map = { 'cmd' : self.cmd_n_0
                                                  , 'i0'  : y
                                                  , 'i1'  : y7_y_0
                                                  , 'q'   : n_y_0 # pas nq
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ############################### STAGE 1 ##############################
        n_y_1_0              = Signal( 'n_y_1_0',             16 )
        n_y_1_1              = Signal( 'n_y_1_1',             16 )
        self.instances['n_y_1_0'] = Inst( 'nmux2_16b', 'n_y_1_0'
                                         , map = { 'cmd' : self.cmd_n_1_0
                                                  , 'i0'  : y_pm_x_sra_i
                                                  , 'i1'  : n_y_0
                                                  , 'nq'  : n_y_1_0
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        self.instances['n_y_1_1'] = Inst( 'nmux2_16b', 'n_y_1_1'
                                         , map = { 'cmd' : self.cmd_n_1_1
                                                  , 'i0'  : pm_ykc
                                                  , 'i1'  : pm_xkc
                                                  , 'nq'  : n_y_1_1
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ############################### STAGE 2 ##############################
        n_y              = Signal( 'n_y',             16 )
        self.instances['n_y'] = Inst( 'nmux2_16b', 'n_y'
                                         , map = { 'cmd' : self.cmd_n
                                                  , 'i0'  : n_y_1_0
                                                  , 'i1'  : n_y_1_1
                                                  , 'nq'  : n_y
                                                  , 'vdd' : self.vdd
                                                  , 'vss' : self.vss
                                                  } )
        ######################################################################END NY STAGES SHIFTER

        ######################################################################
        ############################### X REG ################################
        self.instances['y_reg']       = Inst ( 'sff_16', 'y_reg'
                                                    , map = { "wen" : self.ck
                                                             , "ck"  : self.ck
                                                             , "i0"  : n_y
                                                             ,  "q"  : y
                                                             , 'vdd' : self.vdd
                                                             , 'vss' : self.vss
                                                             })
        ######################################################################END Y REG

#######################################END Y DATAPATH#################################

        self.nx_p.Alias( Cat( x[14:7] ) )
        self.ny_p.Alias( Cat( y[14:7] ) )





        


        return


    def Layout ( self ):
        print 'Cordic_DP.Layout()'

        # X processing.
	Place     ( self.instances['x_sra_0_0'        ], NOSYM, XY( 0, 0 ) )
	PlaceRight( self.instances['zero_16b_0_x'     ], NOSYM )
	PlaceRight( self.instances['xkc_post0_adder_0'       ], NOSYM )
	PlaceRight( self.instances['x_reg'       ], SYM_X )
	PlaceRight( self.instances['n_x'       ], SYM_X )
	PlaceRight( self.instances['n_x_1_0'       ], SYM_X )
	PlaceRight( self.instances['n_x_0'       ], SYM_X )
	PlaceRight( self.instances['zero_7b_x'       ], SYM_X )
	PlaceRight( self.instances['x_sra_0_1'], NOSYM )
	PlaceRight( self.instances['x_sra_1_0'], NOSYM )
	PlaceRight( self.instances['xkc_post0_adder_1'], NOSYM )
	PlaceRight( self.instances['xkc_post0_adder'], NOSYM )
	PlaceRight( self.instances['zero_1b_x'], NOSYM )
	PlaceRight( self.instances['zero_16b_1_x'], NOSYM )
	PlaceRight( self.instances['n_x_1_1'       ], SYM_X )
	PlaceRight( self.instances['adder_x_pm_y_sra_i'       ], SYM_X )
	PlaceRight( self.instances['x_sra_0_2'], NOSYM )
	PlaceRight( self.instances['x_sra_1_1'], NOSYM )
	PlaceRight( self.instances['x_sra_i'], NOSYM )
	PlaceRight( self.instances['xkc_post1_adder'], NOSYM )
	PlaceRight( self.instances['n_xkc_adder'], NOSYM )
	PlaceRight( self.instances['xkc_reg'], NOSYM )
	PlaceRight( self.instances['adder_pm_xkc'], NOSYM )
	PlaceRight( self.instances['y_sra_0_3'], SYM_X )
	PlaceRight( self.instances['x_sra_0_3'], NOSYM )
	PlaceRight( self.instances['adder_pm_ykc'       ], SYM_X )
	PlaceRight( self.instances['ykc_reg'       ], SYM_X )
	PlaceRight( self.instances['ykc_adder'       ], SYM_X )
	PlaceRight( self.instances['ykc_post1_adder'       ], SYM_X )
	PlaceRight( self.instances['y_sra_i'       ], SYM_X )
	PlaceRight( self.instances['y_sra_1_1'       ], SYM_X )
	PlaceRight( self.instances['y_sra_0_2'       ], SYM_X )
	PlaceRight( self.instances['adder_y_pm_x_sra_i'], NOSYM )
	PlaceRight( self.instances['n_y_1_1'       ], NOSYM )
	PlaceRight( self.instances['zero_16b_1_y'       ], SYM_X )
	PlaceRight( self.instances['zero_1b_y'       ], SYM_X )
	PlaceRight( self.instances['ykc_post0_adder'       ], SYM_X )
	PlaceRight( self.instances['ykc_post0_adder_1'       ], SYM_X )
	PlaceRight( self.instances['y_sra_1_0'       ], SYM_X )
	PlaceRight( self.instances['y_sra_0_1'       ], SYM_X )
	PlaceRight( self.instances['zero_7b_y'], NOSYM )
	PlaceRight( self.instances['n_y_0'       ], NOSYM )
	PlaceRight( self.instances['n_y_1_0'       ], NOSYM )
	PlaceRight( self.instances['n_y'       ], NOSYM )
	PlaceRight( self.instances['y_reg'       ], NOSYM )
	PlaceRight( self.instances['ykc_post0_adder_0'       ], NOSYM )
	PlaceRight( self.instances['zero_16b_0_y'       ], SYM_X )
	PlaceRight( self.instances['y_sra_0_0'       ], SYM_X )

# ####### X - tentative 1
#         Place       ( self.instances['n_x_1_0'],            NOSYM, XY( 0, 0 ))#21

#         PlaceRight  ( self.instances['n_x'],                NOSYM)#23
#         PlaceRight  ( self.instances['x_sra_0_2'],          NOSYM)#7
#         PlaceRight  ( self.instances['x_sra_0_3'],          NOSYM)#8
#         PlaceRight  ( self.instances['x_sra_1_1'],          NOSYM)#10
#         PlaceRight  ( self.instances['xkc_post0_adder_1'],  NOSYM)#13
#         PlaceRight  ( self.instances['xkc_post1_adder'],    NOSYM)#15
#         PlaceRight  ( self.instances['zero_1b_x'],          NOSYM)#

#         SetRefIns   ( self.instances['n_x_1_0'] )
#         ## END LINE 0

#         PlaceBottom ( self.instances['zero_7b_x'],          NOSYM)#

#         PlaceRight  ( self.instances['n_x_0'],              NOSYM)#20
#         PlaceRight  ( self.instances['x_reg'],              NOSYM)#24
#         PlaceRight  ( self.instances['zero_16b_0_x'],       NOSYM)#
#         PlaceRight  ( self.instances['x_sra_i'],            NOSYM)#11
#         PlaceRight  ( self.instances['xkc_post0_adder'],    NOSYM)#14
#         PlaceRight  ( self.instances['n_xkc_adder'],        NOSYM)#16
#         PlaceRight  ( self.instances['zero_16b_1_x'],       NOSYM)#

#         SetRefIns   ( self.instances['zero_7b_x'] )
#         ##END LINE 1

#         PlaceBottom ( self.instances['adder_x_pm_y_sra_i'], NOSYM)#19

#         PlaceRight  ( self.instances['n_x_1_1'],            NOSYM)#22
#         PlaceRight  ( self.instances['x_sra_0_0'],          NOSYM)#5
#         PlaceRight  ( self.instances['x_sra_0_1'],          NOSYM)#6
#         PlaceRight  ( self.instances['x_sra_1_0'],          NOSYM)#9
#         PlaceRight  ( self.instances['xkc_post0_adder_0'],  NOSYM)#12
#         PlaceRight  ( self.instances['xkc_reg'],            NOSYM)#17
#         PlaceRight  ( self.instances['adder_pm_xkc'],       NOSYM)#18

#         #SetRefIns   ( self.instances['adder_x_pm_y_sra_i'] )
#         ## END LINE 2

# ####### X - tentative 2
#         Place       ( self.instances['n_x_1_0'],            NOSYM, XY( 0, 0 ))#21

#         PlaceRight  ( self.instances['n_x'],                NOSYM)#23
#         PlaceRight  ( self.instances['x_sra_0_2'],          NOSYM)#7
#         PlaceRight  ( self.instances['x_sra_0_3'],          NOSYM)#8
#         PlaceRight  ( self.instances['x_sra_1_1'],          NOSYM)#10
#         PlaceRight  ( self.instances['xkc_post0_adder_1'],  NOSYM)#13
#         PlaceRight  ( self.instances['xkc_post1_adder'],    NOSYM)#15
#         PlaceRight  ( self.instances['n_xkc_adder'],        NOSYM)#16
#         PlaceRight  ( self.instances['zero_1b_x'],          NOSYM)#

#         SetRefIns   ( self.instances['n_x_1_0'] )
#         ## END LINE 0

#         PlaceBottom ( self.instances['zero_7b_x'],          NOSYM)#

#         PlaceRight  ( self.instances['n_x_0'],              NOSYM)#20
#         PlaceRight  ( self.instances['x_reg'],              NOSYM)#24
#         PlaceRight  ( self.instances['zero_16b_0_x'],       NOSYM)#
#         PlaceRight  ( self.instances['x_sra_i'],            NOSYM)#11
#         PlaceRight  ( self.instances['xkc_post0_adder'],    NOSYM)#14
#         PlaceRight  ( self.instances['xkc_reg'],            NOSYM)#17
#         PlaceRight  ( self.instances['zero_16b_1_x'],       NOSYM)#

#         SetRefIns   ( self.instances['zero_7b_x'] )
#         ##END LINE 1

#         PlaceBottom ( self.instances['adder_x_pm_y_sra_i'], NOSYM)#19

#         PlaceRight  ( self.instances['n_x_1_1'],            NOSYM)#22
#         PlaceRight  ( self.instances['x_sra_0_0'],          NOSYM)#5
#         PlaceRight  ( self.instances['x_sra_0_1'],          NOSYM)#6
#         PlaceRight  ( self.instances['x_sra_1_0'],          NOSYM)#9
#         PlaceRight  ( self.instances['xkc_post0_adder_0'],  NOSYM)#12
        
#         PlaceRight  ( self.instances['adder_pm_xkc'],       NOSYM)#18

#         #SetRefIns   ( self.instances['adder_x_pm_y_sra_i'] )
#         ## END LINE 2

####### X - tentative 3
        # Place       ( self.instances['n_x_1_0'],            NOSYM, XY( 0, 0 ))#21
        # PlaceRight  ( self.instances['n_x'],                NOSYM)#23
        # PlaceRight  ( self.instances['x_sra_0_2'],          NOSYM)#7
        # PlaceRight  ( self.instances['x_sra_0_3'],          NOSYM)#8
        # PlaceRight  ( self.instances['x_sra_1_1'],          NOSYM)#10
        # PlaceRight  ( self.instances['xkc_post0_adder_1'],  NOSYM)#13
        # PlaceRight  ( self.instances['xkc_post1_adder'],    NOSYM)#15
        # PlaceRight  ( self.instances['n_xkc_adder'],        NOSYM)#16
        # PlaceRight  ( self.instances['zero_1b_x'],          NOSYM)#
        # PlaceRight  ( self.instances['zero_16b_1_x'],       NOSYM)#
        # SetRefIns   ( self.instances['n_x_1_0'] )
        # ## END LINE 0

        # PlaceBottom ( self.instances['adder_x_pm_y_sra_i'], NOSYM)#19
        # PlaceRight  ( self.instances['n_x_0'],              NOSYM)#20
        # PlaceRight  ( self.instances['x_reg'],              NOSYM)#24
        # PlaceRight  ( self.instances['zero_16b_0_x'],       NOSYM)#
        # PlaceRight  ( self.instances['x_sra_i'],            NOSYM)#11
        # PlaceRight  ( self.instances['xkc_post0_adder'],    NOSYM)#14
        # PlaceRight  ( self.instances['xkc_reg'],            NOSYM)#17
        # SetRefIns   ( self.instances['adder_x_pm_y_sra_i'] )
        # ##END LINE 1

        # PlaceBottom ( self.instances['zero_7b_x'],          NOSYM)#
        # PlaceRight  ( self.instances['n_x_1_1'],            NOSYM)#22
        # PlaceRight  ( self.instances['x_sra_0_0'],          NOSYM)#5
        # PlaceRight  ( self.instances['x_sra_0_1'],          NOSYM)#6
        # PlaceRight  ( self.instances['x_sra_1_0'],          NOSYM)#9
        # PlaceRight  ( self.instances['xkc_post0_adder_0'],  NOSYM)#12
        # PlaceRight  ( self.instances['adder_pm_xkc'],       NOSYM)#18

        #SetRefIns   ( self.instances['zero_7b_x'] )
        ## END LINE 2

####### Y
        # PlaceBottom ( self.instances['adder_y_pm_x_sra_i'], SYM_X)
        # PlaceLeft   ( self.instances['n_y_1_1'],            SYM_X)
        # PlaceLeft   ( self.instances['y_sra_0_0'],          SYM_X)
        # PlaceLeft   ( self.instances['y_sra_0_1'],          SYM_X)
        # PlaceLeft   ( self.instances['y_sra_1_0'],          SYM_X)
        # PlaceLeft   ( self.instances['ykc_post0_adder_0'],  SYM_X)
        # PlaceLeft   ( self.instances['ykc_reg'],            SYM_X)
        # PlaceLeft   ( self.instances['adder_pm_ykc'],       SYM_X)
        # SetRefIns   ( self.instances['adder_y_pm_x_sra_i'] )
        # ## END LINE 3

        # PlaceBottom ( self.instances['zero_7b_y'],          SYM_X)
        # PlaceLeft   ( self.instances['n_y_0'],              SYM_X)
        # PlaceLeft   ( self.instances['y_reg'],              SYM_X)
        # PlaceLeft   ( self.instances['zero_16b_0_y'],       SYM_X)
        # PlaceLeft   ( self.instances['y_sra_i'],            SYM_X)
        # PlaceLeft   ( self.instances['ykc_post0_adder'],    SYM_X)
        # PlaceLeft   ( self.instances['ykc_adder'],          SYM_X)
        # PlaceLeft   ( self.instances['zero_16b_1_y'],       SYM_X)
        # SetRefIns   ( self.instances['zero_7b_y'] )
        # ## END LINE 4

        # PlaceBottom ( self.instances['n_y_1_0'],            SYM_X)
        # PlaceLeft   ( self.instances['n_y'],                SYM_X)
        # PlaceLeft   ( self.instances['y_sra_0_2'],          SYM_X)
        # PlaceLeft   ( self.instances['y_sra_0_3'],          SYM_X)
        # PlaceLeft   ( self.instances['y_sra_1_1'],          SYM_X)
        # PlaceLeft   ( self.instances['ykc_post0_adder_1'],  SYM_X)
        # PlaceLeft   ( self.instances['ykc_post1_adder'],    SYM_X)
        # PlaceLeft   ( self.instances['zero_1b_y'],          SYM_X)
        ## END LINE 5

# ####### Y - tentative 3
        # PlaceBottom ( self.instances['n_y_1_0'],            SYM_X)#21
        # PlaceLeft   ( self.instances['n_y'],                SYM_X)#23
        # PlaceLeft   ( self.instances['y_sra_0_2'],          SYM_X)#7
        # PlaceLeft   ( self.instances['y_sra_0_3'],          SYM_X)#8
        # PlaceLeft   ( self.instances['y_sra_1_1'],          SYM_X)#10
        # PlaceLeft   ( self.instances['ykc_post0_adder_1'],  SYM_X)#13
        # PlaceLeft   ( self.instances['ykc_post1_adder'],    SYM_X)#15
        # PlaceLeft   ( self.instances['ykc_adder'],        SYM_X)#16
        # PlaceLeft   ( self.instances['zero_1b_y'],          SYM_X)#
        # PlaceLeft   ( self.instances['zero_16b_1_y'],       SYM_X)#
        # SetRefIns   ( self.instances['n_y_1_0'] )
        # ## END LINE 0

        # PlaceBottom ( self.instances['adder_y_pm_x_sra_i'], SYM_X)#19
        # PlaceLeft   ( self.instances['n_y_0'],              SYM_X)#20
        # PlaceLeft   ( self.instances['y_reg'],              SYM_X)#24
        # PlaceLeft   ( self.instances['zero_16b_0_y'],       SYM_X)#
        # PlaceLeft   ( self.instances['y_sra_i'],            SYM_X)#11
        # PlaceLeft   ( self.instances['ykc_post0_adder'],    SYM_X)#14
        # PlaceLeft   ( self.instances['ykc_reg'],            SYM_X)#17
        # SetRefIns   ( self.instances['adder_y_pm_x_sra_i'] )
        # ##END LINE 1

        # PlaceBottom ( self.instances['zero_7b_y'],          SYM_X)#
        # PlaceLeft   ( self.instances['n_y_1_1'],            SYM_X)#22
        # PlaceLeft   ( self.instances['y_sra_0_0'],          SYM_X)#5
        # PlaceLeft   ( self.instances['y_sra_0_1'],          SYM_X)#6
        # PlaceLeft   ( self.instances['y_sra_1_0'],          SYM_X)#9
        # PlaceLeft   ( self.instances['ykc_post0_adder_0'],  SYM_X)#12
        # PlaceLeft   ( self.instances['adder_pm_ykc'],       SYM_X)#18

        #SetRefIns   ( self.instances['zero_7b_y'] )
        ## END LINE 2

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
    shellSuccess = 0
    if not success: shellSuccess = 1
    
    sys.exit( shellSuccess )


