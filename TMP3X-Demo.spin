{
----------------------------------------------------------------------------------------------------
    Filename:       TMP3X-Demo.spin
    Description:    Demo of the TMP3x-series analog temperature sensor driver
        * Temperature output
    Author:         Jesse Burt
    Started:        Jun 30, 2023
    Updated:        Sep 19, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------

    NOTE: The preprocessor symbol TMP3X_ADC must be defined with the filename of the driver of
        the connected ADC (.spin extension optional).
}

' Uncomment one of the lines below to choose an ADC
'#define TMP3X_ADC "signal.adc.ad799x"
'#define TMP3X_ADC "signal.adc.adc083x"
'#define TMP3X_ADC "signal.adc.adc124s021"
#define TMP3X_ADC "signal.adc.mcp320x"
'#define TMP3X_ADC "signal.adc.ads1115"

#ifdef TMP3X_ADC
# pragma exportdef TMP3X_ADC
#endif

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    sensor: "sensor.temperature.tmp3x" |

' uncomment one of the below definitions based on the ADC chosen above
    'adc:    TMP3X_ADC | {I2C} SCL=28, SDA=29, I2C_FREQ=100_000, I2C_ADDR=0
    adc:    TMP3X_ADC | {SPI} CS=0, SCK=1, MOSI=2, MISO=3


PUB main() | temp, tscl

    setup()
    sensor.temp_scale(sensor.C)

    repeat
        ser.pos_xy(0, 3)
        temp := sensor.temperature()
        tscl := lookupz(sensor.temp_scale(-2): "C", "F", "K")
        ser.printf3(@"Temp. (deg %c): %3.3d.%02.2d\n\r", tscl, (temp / 100), ||(temp // 100))


PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( adc.start() )
        ser.strln(@"ADC started")
    else
        ser.strln(@"ADC failed to start - halting")
        repeat

    sensor.start(@adc)                          ' point the driver to your ADC (REQUIRED)

    { optional settings (check ADC driver for specific availability) }
    'adc.opmode(adc.CONT)                        ' enable (continuous) measurement mode
    'adc.set_model(3202)                         ' MCP320x: set the correct model
    'adc.adc_scale(2_048)                        ' ADS1115: minimum should be 2_048mV scale
    'sensor.set_sample_averages(64)              ' optional; may improve stability on noisy ADCs

    adc.set_adc_channel(0)                      ' make sure this is the channel the sensor is
                                                '   connected to


DAT
{
Copyright 2024 Jesse Burt

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

