#!/usr/bin/env python

import sys
import symbolic.cmos
from   stratus   import *

from   Hurricane import DbU
import CRL
import plugins.RSavePlugin


class Cordic_Net ( Model ):

    def Interface ( self ):
        print 'Cordic_Net.Interface()'
        self.raz        = SignalIn ( 'raz'       , 1  )

        self.wr_axy_p   = SignalIn ( 'wr_axy_p'  , 1  )
        self.a_p        = SignalIn ( 'a_p'       , 10 )
        self.x_p        = SignalIn ( 'x_p'       , 8  )
        self.y_p        = SignalIn ( 'y_p'       , 8  )
        self.wok_axy_p  = SignalOut( 'wok_axy_p' , 1  )

        self.rd_nxy_p   = SignalIn ( 'rd_nxy_p'  , 1  )
        self.nx_p       = SignalOut( 'nx_p'      , 8  )
        self.ny_p       = SignalOut( 'ny_p'      , 8  )
        self.rok_nxy_p  = SignalOut( 'rok_nxy_p' , 1  )

        self.ck         = CkIn     ( 'ck'  )
        self.vdd        = VddIn    ( 'vdd' )
        self.vss        = VddIn    ( 'vss' )
        return


    def Netlist ( self ):
        print 'Cordic_Net.Netlist()'

        i                       = Signal('i'                       , 3 )
        cmd_n_0                 = Signal('cmd_n_0'                 , 1 )
        cmd_n_1_1	        = Signal('cmd_n_1_1'               , 1 )
        cmd_n_1_0               = Signal('cmd_n_1_0'               , 1 )
        cmd_n                   = Signal('cmd_n'                   , 1 )
        cmd_adder_pm		= Signal('cmd_adder_pm'        , 1 )
        cmd_post0_adder_1       = Signal('cmd_post0_adder_1'       , 1 )
        cmd_post0_adder	        = Signal('cmd_post0_adder'         , 1 )
        cmd_post0_adder_0	= Signal('cmd_post0_adder_0'       , 1 )
        cmd_post1_adder         = Signal('cmd_post1_adder'         , 1 )
        cmd_adder_x_pm_y_sra_i  = Signal('cmd_adder_x_pm_y_sra_i'  , 1 )
        cmd_adder_y_pm_x_sra_i  = Signal('cmd_adder_y_pm_x_sra_i'  , 1 )

        self.instances = {}

        self.instances['ctl'] = Inst( 'cordic_ctl', 'ctl'
                                    , map = { 'ck'         : self.ck
                                            , 'raz'        : self.raz
                                            , 'wr_axy_p'   : self.wr_axy_p
                                            , 'a_p'        : self.a_p
                                            , 'wok_axy_p'  : self.wok_axy_p
                                            , 'rd_nxy_p'   : self.rd_nxy_p
                                            , 'rok_nxy_p'  : self.rok_nxy_p
                                            , 'i_p'                     : i
                                            # , 'cmd_n_0'	                : cmd_n_0
                                            , 'cmd_n_1_1'	            : cmd_n_1_1
                                            , 'cmd_n_1_0'	            : cmd_n_1_0
                                            , 'cmd_n'	                : cmd_n
                                            , 'cmd_adder_pm'            : cmd_adder_pm
                                            , 'cmd_post0_adder_1'	    : cmd_post0_adder_1
                                            , 'cmd_post0_adder'	        : cmd_post0_adder
                                            , 'cmd_post0_adder_0'	    : cmd_post0_adder_0
                                            , 'cmd_post1_adder'	        : cmd_post1_adder
                                            , 'cmd_adder_x_pm_y_sra_i'	: cmd_adder_x_pm_y_sra_i
                                            , 'cmd_adder_y_pm_x_sra_i'	: cmd_adder_y_pm_x_sra_i
                                            , 'vdd'        : self.vdd
                                            , 'vss'        : self.vss
                                            } )

        self.instances['dp'] = Inst( 'cordic_dp', 'dp'
                                   , map = { 'ck'         : self.ck
                                           , 'x_p'        : self.x_p
                                           , 'y_p'        : self.y_p
                                           , 'nx_p'       : self.nx_p
                                           , 'ny_p'       : self.ny_p
                                           , 'i_p'                      : i
                                           , 'cmd_n_0'	                : cmd_n_0
                                           , 'cmd_n_1_1'	            : cmd_n_1_1
                                           , 'cmd_n_1_0'	            : cmd_n_1_0
                                           , 'cmd_n'	                : cmd_n
                                           , 'cmd_adder_pm'             : cmd_adder_pm
                                           , 'cmd_post0_adder_1'	    : cmd_post0_adder_1
                                           , 'cmd_post0_adder'	        : cmd_post0_adder
                                           , 'cmd_post0_adder_0'	    : cmd_post0_adder_0
                                           , 'cmd_post1_adder'	        : cmd_post1_adder
                                           , 'cmd_adder_x_pm_y_sra_i'	: cmd_adder_x_pm_y_sra_i
                                           , 'cmd_adder_y_pm_x_sra_i'	: cmd_adder_y_pm_x_sra_i
                                           , 'vdd'        : self.vdd
                                           , 'vss'        : self.vss
                                           } )
        return


    def Layout ( self ):
        print 'Cordic_Net.Layout()'

        Place( self.instances['dp'], NOSYM, XY( 0, 0 ) )
        ResizeAb( 0, 0, 0, DbU.fromLambda( 100.0 ) )

        return


def ScriptMain ( **kw ):
    for entry in os.listdir('.'):
      if os.path.isfile(entry):
        if    entry.endswith('.vst') \
           or entry.endswith('.vbe') \
           or entry.endswith('.ap'):
          print 'Removing previous run file "%s".' % entry
          os.unlink( entry )

    views   = CRL.Catalog.State.Logical|CRL.Catalog.State.VstUseConcat
    ctlCell = CRL.Blif.load( 'cordic_ctl', CRL.Catalog.State.Logical|CRL.Catalog.State.VstUseConcat )
    ctlKw   = {'cell':ctlCell, 'views':views}
    plugins.RSavePlugin.ScriptMain( **ctlKw )

    if kw.has_key('editor') and kw['editor']: setEditor( kw['editor'] )

    buildModel( 'cordic_dp', DoNetlist|DoLayout, className='Cordic_DP' )

    cordic_net = Cordic_Net( "cordic_net" )

    cordic_net.Interface()
    cordic_net.Netlist  ()
    cordic_net.Layout   ()
    cordic_net.Save     (LOGICAL|PHYSICAL)
    return 1


if __name__ == "__main__" :
    kw      = {}
    success = ScriptMain( **kw )

    shellSuccess = 0
    if not success: shellSuccess = 1

    sys.exit( shellSuccess )

