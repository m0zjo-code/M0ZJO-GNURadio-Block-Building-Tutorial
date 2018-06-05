# M0ZJO GNURadio Message Blocks Overview
Below is a quick overview of the work carried out with GNURadio GRC message blocks. In the end the GRC method was abandoned due to throughput issues but I thought that others may find this work useful for building Python message blocks.

A wonderful tutorial on Python blocks is given here (albeit it does not cover message blocks). Please read this first and check that you are familiar with building stream blocks:
[Guided Tutorial GNU Radio in Python](https://wiki.gnuradio.org/index.php/Guided_Tutorial_GNU_Radio_in_Python)

### First we will follow the tutorial on making an amplifier block

    gr_modtool newmod tutorial
Then:

    gr_modtool add -t sync -l python
This creates a block as follows:

> GNU Radio module name identified: tutorial 
> Language: Python Enter name of block/code (without module name prefix): amp_py_cc      
> Block/code identifier: amp_py_cc 
> Enter valid argument list, including default arguments: multiple 
> Add Python QA code? [Y/n] y 
> Adding file 'python/amp_py_cc.py'...
>  Adding file 'python/qa_amp_py_cc.py'...
> Editing python/CMakeLists.txt... 
> Adding file 'grc/tutorial_amp_py_cc.xml'... 
> Editing grc/CMakeLists.txt...

The two main files that we are interested in are the **python/amp_py_cc.py** file that defines the block's function and **grc/tutorial_amp_py_cc.xml** that defines the high level layout.

The following work function defines the block function. In this example, we shall have an amplifier of variable gain.
```python
import numpy
from gnuradio import gr

class amp_py_cc(gr.sync_block):
    """
    docstring for block amp_py_cc.
    This is a software VGA.
    """
    def __init__(self, multiple):
        self.multiple = multiple ## This is the mult factor
        gr.sync_block.__init__(self,
            name="amp_py_cc",
            in_sig=[numpy.complex64],
            out_sig=[numpy.complex64])


    def work(self, input_items, output_items):
        in0 = input_items[0]
        out = output_items[0] 
        # <+signal processing here+>
        out[:] = in0 * self.multiple
        return len(output_items[0])
```
The XML definition is then modified to as below. Here we tell GRC the input type, output type and parameter information:
```xml
<?xml version="1.0"?>
<block>
  <name>amp_py_cc</name>
  <key>tutorial_amp_py_cc</key>
  <category>[tutorial]</category>
  <import>import tutorial</import>
  <make>tutorial.amp_py_cc($multiple)</make>
  <param>
    <name>Multiple</name>
    <key>multiple</key>
    <type>float</type>
  </param>
  <sink>
    <name>in</name>
    <type>complex</type>
  </sink>
  <source>
    <name>out</name>
    <type>complex</type>
  </source>
</block>

```

The block can then be compiled and installed with the following commands:
```bash
cd build
cmake ../
make
sudo make install
sudo ldconfig
```
When installed, this works as a VGA, yay! :)
### GRC Vector Blocks
To convert the block to work with NumPy vectors rather than stream elements is simple! The function definition is defined as below:
```python
def __init__(self, vec_size, multiple):
    self.vec_size = vec_size # Number of items in vector
    self.multiple = multiple # Gain
    gr.sync_block.__init__(self,
        name="amp_vector_cc",
        in_sig=[(numpy.complex64, self.vec_size)],
        out_sig=[(numpy.complex64, self.vec_size)])
```
Note that you need to specify the type and length.
The XML definitions are written as below:
```xml
<?xml version="1.0"?>
<block>
  <name>amp_vector_cc</name>
  <key>tutorial_amp_vector_cc</key>
  <category>[tutorial]</category>
  <import>import tutorial</import>
  <make>tutorial.amp_vector_cc($vec_size, $multiple)</make>
  <param>
    <name>Multiple</name>
    <key>multiple</key>
    <type>float</type>
  </param>
    <param>
    <name>Vector Length</name>
    <key>vec_size</key>
    <type>int</type>
  </param>
  <sink>
    <name>in</name>
    <type>complex</type>
    <vlen>$vec_size</vlen>
  </sink>
  <source>
    <name>out</name>
    <type>complex</type>
    <vlen>$vec_size</vlen>
  </source>
</block>
```
Important points to note:
 - Create a new module using the command "gr_modtool add -t sync -l python"
- The vlen option must be given in the source and sink defs.
 - ($vec_size, $multiple) - Each new element must be listed in the xml file
 - [(numpy.complex64, self.vec_size)] - You must define the NumPy array size and type
Apart from those - simple!

### Writing GRC Message Blocks
Messages work slightly differently compared to data blocks. 
You must register the ports outside the sync block definition. You must also register what to do when a message is received by setting a message handle function.
Data is stored in "Poly Morphic Types" that can be imported by importing the pmt library (import pmt).
Defining the block is as below:
``` python
def __init__(self, fwd_rev):
        self.fwd_rev = fwd_rev
        gr.sync_block.__init__(self,
            name="fft_calc",
            in_sig=None,
            out_sig=None)
        self.message_port_register_in(pmt.intern('msg_in'))
        self.message_port_register_out(pmt.intern('msg_out'))
        self.set_msg_handler(pmt.intern('msg_in'), self.handle_msg)
```
Message handling functions:
```python
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
```
In the example above, either a forward FFT or backward IFFT can be computed. This is set by the fwd_rev variable set by a enumerated drop-down box as defined below:
```xml
<?xml version="1.0"?>
<block>
  <name>fft_calc</name>
  <key>tutorial_fft_calc</key>
  <category>[tutorial]</category>
  <import>import tutorial</import>
  <make>tutorial.fft_calc($fwd_rev)</make>
  <!-- Make one 'param' node for every Parameter you want settable from the GUI.
       Sub-nodes:
       * name
       * key (makes the value accessible as $keyname, e.g. in the make node)
       * type -->
  <param>
      <name>Direction</name>
      <key>fwd_rev</key>
      <value>True</value>
      <type>enum</type>
        <option>
            <name>Forward</name>
            <key>True</key>
        </option>
        <option>
            <name>Reverse</name>
            <key>False</key>
        </option>
    </param>

  <!-- Make one 'sink' node per input. Sub-nodes:
       * name (an identifier for the GUI)
       * type
       * vlen
       * optional (set to 1 for optional inputs) -->
  <sink>
    <name>msg_in</name>
    <type>message</type>
  </sink>

  <!-- Make one 'source' node per output. Sub-nodes:
       * name (an identifier for the GUI)
       * type
       * vlen
       * optional (set to 1 for optional inputs) -->
  <source>
    <name>msg_out</name>
    <type>message</type>
  </source>
</block>
```
It can be seen above that you also need to register message source and sink ports, using the type "message". The name of the ports must match the registrations in the initial function definitions.

I hope that this helps! This technique was abandoned due to throughput issues (probably due to the fact that the blocks were written in Python and are therefore quite slow!) but should be useful for applications that require small asynchronous messages.
