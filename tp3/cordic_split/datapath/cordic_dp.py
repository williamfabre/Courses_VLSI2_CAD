#!/usr/bin/env python

import sys
from   stratus import *


class Cordic_DP ( Model ):

	def Interface ( self ):
		print 'Cordic_DP.Interface()'
		self.x_p		= SignalIn ( 'x_p',		8 )
		self.y_p		= SignalIn ( 'y_p',		8 )

		self.nx_p		= SignalOut( 'nx_p',	8 )
		self.ny_p		= SignalOut( 'ny_p',	8 )

		self.xmkc_p		= SignalOut( 'xmkc_p',	2 )
		self.ymkc_p		= SignalOut( 'ymkc_p',	2 )
		self.xcmd_p		= SignalOut( 'xcmd_p',	4 )
		self.ymkc_p		= SignalOut( 'ymkc_p',	4 )
		self.i_p		= SignalOut( 'i_p',		4 )

		self.ck		 = CkIn	 ( 'ck'  )
		self.vdd		= VddIn	( 'vdd' )
		self.vss		= VddIn	( 'vss' )
		return


	def Netlist ( self ):
		print 'Cordic_DP.Netlist()'

		# MASTER CELL
		Generate( 'DpgenNmux2' ,  'nmux2_16b', param={'nbit':16,'behavioral':True,'physical':True,'flags':0} )
		Generate( 'DpgenMux2'  ,   'mux2_16b', param={'nbit':16,'behavioral':True,'physical':True,'flags':0} )

		self.instances = {}


		x = Signal( 'x', 16 )

		############  VALUE 0 ############
		zero_16b = Signal( 'zero_16b', 16 )
		self.instances['zero_16b'] = Inst( 'zero_16b', 'zero_16b'
										  , map = { 'q'   : zero_16b
												   , 'vdd' : self.vdd
												   , 'vss' : self.vss
												   } )

	
		############  MULTIPLEXOR X LAYER 1 ############
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

		############  MULTIPLEXOR X LAYER 2 ############
		self.instances['x_sra_i'] = Inst( 'mux2_16b', 'x_sra_i'
										   , map = { 'cmd' : self.i_p[2]
													, 'i0'  : x_sra_1_0
													, 'i1'  : x_sra_1_1
													, 'q'  : x_sra_i # pas nq
													, 'vdd' : self.vdd
													, 'vss' : self.vss
													} )




		############  MULTIPLEXOR Y LAYER 1 ############
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

		############  MULTIPLEXOR Y LAYER 2 ############
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




		return


	def Layout ( self ):
		print 'Cordic_DP.Layout()'

		# X processing.
		Place	 ( self.instances['zero_16b'		], NOSYM, XY( 0, 0 ) )
		PlaceRight( self.instances['x_sra_0_0'	   ], NOSYM )

		# Layout a completer.
		# ...

		return


	def ScriptMain ( **kw ):
		if kw.has_key('editor') and kw['editor']: setEditor( kw['editor'] )

		cordic_dp = Cordic_DP( "cordic_dp" )

		cordic_dp.Interface()
		cordic_dp.Netlist  ()
		cordic_dp.Layout   ()
		cordic_dp.Save	 (LOGICAL|PHYSICAL)
		return 1


	if __name__ == "__main__" :
		kw	  = {}
		success = ScriptMain( **kw )
		if not success: shellSuccess = 1

		sys.exit( shellSuccess )


