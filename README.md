# tmp36-spin
------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the Analog Devices TMP3x-series analog temperature sensors.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* Read temperature in hundredths of a degree
* Set number of ADC samples averaged per measurement

## Requirements

P1/SPIN1:
* spin-standard-library
* an external ADC and driver (see the spin-standard-library for signal.adc. drivers)

P2/SPIN2:
* p2-spin-standard-library
* an external ADC and driver (see the p2-spin-standard-library for signal.adc. drivers)
* or the P2 smart pins can be used in ADC mode (signal.adc.p2x8c4m64p.spin2 driver)

## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.1.1)	| Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.1.1)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.1.1)       | ~~NuCode~~   | FTBFS                 |
| P2        | SPIN2    | FlexSpin (6.1.1)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Hardware compatibility

* Tested with sensor: TMP36
* Tested with ADCs: MCP3202, ADS1115
* Tested with P2 smartpin-based ADC (basic functionality only)

## Limitations

* TBD

