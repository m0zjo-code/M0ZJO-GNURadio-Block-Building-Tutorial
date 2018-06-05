#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Copyright 2018 <+YOU OR YOUR COMPANY+>.
# 
# This is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
# 
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this software; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
# 

import numpy as np 
import pmt
import pyfftw
#from scipy.fftpack import fft, ifft
from gnuradio import gr

class fft_calc(gr.sync_block):
    """
    Calculates the FFT or IFFT using scipy fftpack. The input is a numpy array encapsulated in a PMT message. 
    
    Please note the outout is a rolled FFT
    """
    def __init__(self, fwd_rev):
        self.fwd_rev = fwd_rev
        gr.sync_block.__init__(self,
            name="fft_calc",
            in_sig=None,
            out_sig=None)
        self.message_port_register_in(pmt.intern('msg_in'))
        self.message_port_register_out(pmt.intern('msg_out'))
        self.set_msg_handler(pmt.intern('msg_in'), self.handle_msg)


    def work(self, input_items, output_items):
        in0 = input_items[0]
        # <+signal processing here+>
        return len(input_items[0])
    
    def handle_msg(self, msg_pmt):
        msg = pmt.cdr(msg_pmt)
        input_array = pyfftw.byte_align(pmt.to_python(msg_pmt)[1])
        
        #array_length = len(input_array)
       # print(type(self.fwd_rev), self.fwd_rev)
        if self.fwd_rev:
            #print("FWD")
            #output_array = np.roll(fft(input_array), len(input_array)/2)
            
            fft_calc = pyfftw.interfaces.numpy_fft.fft(input_array)
            output_array = np.roll(fft_calc, len(input_array)/2)
            
            out_array = pmt.to_pmt(output_array)
            self.post_message(out_array)
        else:
            #print("REV")
            output_array = np.roll(input_array, len(input_array)/2)
            output_array = pyfftw.interfaces.numpy_fft.ifft(output_array)
            
            out_array = pmt.to_pmt(output_array)
            self.post_message(out_array)            
            
    
    def post_message(self, out_array):
        self.message_port_pub(pmt.intern('msg_out'), pmt.cons(pmt.PMT_NIL, out_array))

