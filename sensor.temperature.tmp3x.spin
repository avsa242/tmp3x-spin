{
    --------------------------------------------
    Filename: sensor.temperature.tmp3x.spin
    Author: Jesse Burt
    Description: Driver for the Analog Devices TMP3x-series temperature sensors
    Copyright (c) 2023
    Started Jun 29, 2023
    Updated Jun 29, 2023
    See end of file for terms of use.
    --------------------------------------------

    Requirements:
        * an ADC driver with the following interfaces:
            voltage() (ADC word scaled to microvolts)

    Usage:
        start() _must_ first be called from the parent object/application, with a pointer
            to the chosen ADC driver's OBJ symbol. That is how this driver is "attached"
            to the ADC.
        Example 'application.spin':
            OBJ

                adc:    TMP3X_ADC
                temp:   "sensor.temperature.tmp3x"

            PUB main()

                temp.init(@adc)                 ' point to the adc object

        The preprocessor symbol TMP3X_ADC must be set to the filename of your
        chosen ADC driver, _inside of escaped quotes_.
        Example:

        flexspin -DTMP3X_ADC=\"signal.adc.mcp320x\" -I$(SPIN1_STD_LIB_PATH) TMP3X-Demo.spin

            would build the demo utilizing the MCP320x driver as the chosen ADC
            (assuming SPIN1_STD_LIB_PATH is an environment variable set to the path of the
                spin-standard-library/library)

}

obj

    adc=    TMP3X_ADC

var

    long _instance
    byte _averages

PUB start(adc_driver)
' Initialize the driver
'   adc_driver: address of the chosen ADC driver
    attach_adc_driver(adc_driver)
    _averages := 1

pub stop()
' Stop the driver
'   Clear out variable space
    _instance := _averages := 0

pub bind = attach_adc_driver
pub attach = attach_adc_driver
pub attach_adc_driver(optr)
' Attach to an ADC driver
    _instance := optr

pub set_sample_averages(c)
' Set number of samples to average
    _averages := c

pub temp_data(): w | tmp
' Temperature data ADC word
'   Returns: ADC word (voltage)
    tmp := 0
    repeat _averages
        tmp += adc[_instance].voltage()
    w := (tmp / _averages)

pub temp_word2deg(w): temp
' Convert ADC word to hundredths of a degree Celsius
'   Returns: temperature, in hundredths of a degree, in chosen scale
    temp := (w - 50_0000) / 100

    case _temp_scale
        C:
            return temp
        F:
            return ((temp * 9) / 5) + 32_00

#include "sensor.temp.common.spinh"             ' use code common to all temp sensors

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

