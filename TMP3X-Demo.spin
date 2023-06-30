{
    --------------------------------------------
    Filename: TMP3X-Demo.spin
    Author: Jesse Burt
    Description: Demo of the TMP3x-series analog temperature sensor driver
        * Temperature output
    Copyright (c) 2023
    Started Jun 30, 2023
    Updated Jun 30, 2023
    See end of file for terms of use.
    --------------------------------------------

    Usage:

    The preprocessor symbol TMP3X_ADC must be defined with the filename of the driver of
        the connected ADC (.spin extension optional).

    Examples:
        To build this demo and use an MCP300x/320x-series ADC to read the temperature sensor:
        flexspin -DTMP3X_ADC=\"signal.adc.mcp320x\" -I$SPIN1_STD_LIB TMP3X-Demo.spin

        The same, but with the ADS1015/ADS1115:
        flexspin -DTMP3X_ADC=\"signal.adc.ads1115\" -I$SPIN1_STD_LIB TMP3X-Demo.spin

        and an ADC083x:
        flexspin -DTMP3X_ADC=\"signal.adc.adc083x\" -I$SPIN1_STD_LIB TMP3X-Demo.spin

        Note that it's assumed SPIN1_STD_LIB is an environment variable in your OS defined to the
            location of 'spin-standard-library/library'. This must be defined as above or any
            equivalent (the library must be visible to flexspin).
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-defined constants
    SER_BAUD    = 115_200

    { I2C ADCs }
    SCL_PIN     = 28
    SDA_PIN     = 29
    I2C_FREQ    = 100_000
    ADDR_BITS   = 0

    { SPI ADCs }
    CS_PIN      = 8
    SCK_PIN     = 9
    MOSI_PIN    = 10
    MISO_PIN    = 11
    SCK_FREQ    = 400_000

' --

OBJ

    cfg:    "boardcfg.flip"
    ser:    "com.serial.terminal.ansi"
    time:   "time"
    sensor: "sensor.temperature.tmp3x"
    adc:    TMP3X_ADC

PUB main()

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")


' -- Uncomment one of the following pairs of lines depending on the connected ADC:
    { I2C ADCs (ADS1015, 1115) }
    if ( adc.startx(SCL_PIN, SDA_PIN, I2C_FREQ, ADDR_BITS) )
        ser.strln(@"ADC started")

    { SPI ADCs (MCP300x, MCP320x, ADC083x) }
'    if ( adc.startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN, SCK_FREQ) )
'        ser.strln(@"ADC started")
' --
    else
        ser.strln(@"ADC failed to start - halting")
        repeat
    sensor.start(@adc)                          ' point the driver to your ADC (REQUIRED)

    { optional settings (check ADC driver for specific availability) }
    adc.opmode(adc.CONT)
    adc.set_adc_channel(0)
    sensor.temp_scale(sensor.C)
    'adc.set_model(3202)
    adc.adc_scale(2_048)                        ' ADS1115: minimum should be 2_048mV scale
    'sensor.set_sample_averages(64)              ' optional; may improve stability on noisy ADCs

    repeat
        ser.pos_xy(0, 3)
        show_temp_data()

#include "tempdemo.common.spinh"                ' use demo code common to all temp sensors

DAT
{
Copyright 2023 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

