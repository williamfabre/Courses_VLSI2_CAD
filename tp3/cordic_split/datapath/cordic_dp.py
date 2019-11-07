#!/usr/bin/env python

import sys
from   stratus import *


class Cordic_DP ( Model ):

    def Interface ( self ):
        print 'Cordic_DP.Interface()'
        self.x_p        = SignalIn ( 'x_p'       , 8 )
        self.y_p        = SignalIn ( 'y_p'       , 8 )

        # Interface a completer.
        # ...

        self.ck         = CkIn     ( 'ck'  )
        self.vdd        = VddIn    ( 'vdd' )
        self.vss        = VddIn    ( 'vss' )
        return


    def Netlist ( self ):
        print 'Cordic_DP.Netlist()'

        Generate( 'DpgenNmux2' ,  'nmux2_16b', param={'nbit':16,'behavioral':True,'physical':True,'flags':0} )
        Generate( 'DpgenMux2'  ,   'mux2_16b', param={'nbit':16,'behavioral':True,'physical':True,'flags':0} )

        self.instances = {}

        zero_16b = Signal( 'zero_16b', 16 )
        self.instances['zero_16b'] = Inst( 'zero_16b', 'zero_16b'
                                          , map = { 'q'   : zero_16b
                                                   , 'vdd' : self.vdd
                                                   , 'vss' : self.vss
                                                   } )

        x = Signal( 'x', 16 )

        self.instances['x_sra_0_0'] = Inst( 'nmux2_16b', 'x_sra_0_0'
                                           , map = { 'cmd' : self.i_p[0]
                                                    , 'i0'  : x
                                                    , 'i1'  : x_sra_1
                                                    , 'nq'  : x_sra_0_0
                                                    , 'vdd' : self.vdd
                                                    , 'vss' : self.vss
                                                    } )

        # Netlist a completer.
        # ...

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


