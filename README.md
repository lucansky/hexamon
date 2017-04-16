# Hexamon.io - modular wireless beehive weighting system
Beehive monitoring platform with integrated electronics.

TODO: IMG

## Architecture overview
### Master
Master unit consist of a Raspberry Pi with a CAN shield with RJ11 connector.
CAN shield is a board with SPI MCP2515 CAN controller and SN65HVD23x CAN transceiver.

### Power management
The system is powered through a 18V solar panel, charging 12V battery.
Enclosure with master unit has power management board for charging circuit with under-voltage protection, as well as 5V USB ports for output.

20W solar panel was selected for a prototype, due to it's ability to supply sufficient energy even during cloudy days for a Raspberry Pi.

### Bus unit
Under each beehive, assuming that whole chain of beehives is no longer than 100m, is placed platform with load cells for measuring the weight and bus unit in an enclosure. First beehive in chain contains Master and Bus unit at once.

Bus unit has STM32F042F6P6 in an TSSOP20 package with CAN transceiver and two RJ11 connectors for daisy-chaining to other bus units, as well as two holders for HX711 breakout boards. These board can be purchased through eBay or AliExpress.

### Weight acquisition
As an ADC with pre-amplifier was selected chip HX711 integrated on a beakout board with all the necessary electronics around.

## Hardware
### Platform
What you'll need per beehive:
4x L aluminium profile 50x50
2x Load cell Zemic L6E or equivalent
4x Spacer (see spacer.stl)

Middle bars may be optional, depending on the situation:
2x Rectangle aluminium profile 25x15x3mm 25cm
2x Rectangle aluminium profile 25x30x3mm 25cm
These fit perfectly together. By drilling holes, pitch can be adjusted easily.

### Load cells
Selected load cells should have capacity at least 100kg, dimensions of a load cell can be found [here](https://www.zemiceurope.com/media/Documentation/L6E_Datasheet.pdf).

## Modularity
Several beehives can be chained together with a telephone cable with RJ11 jack through Bus unit under beehive, while master unit is sending captured data wirelessly to server through 3G/GSM modem.

## Software
### Master unit
Raspberry Pi 3 running Raspbian system, with an SPI overlay, provides can0 network interface which can be easily interfaced through linux socket. Main program is written in Haskell and is basically flipping frames received on CAN bus to HTTP requests to webservers where the data are further processed.

### Bus unit
STM32F042 MCU on board has 32kB of Flash memory and 6kB SRAM. Ivory language has been selected for generation of the C code, and Ivory framework as a hardware abstraction layer, message passing and RTOS interaction. Therefore whole project is 100% Haskell except the web.

### Web
Web interface on a http://hexamon.io provides charts for all sensors connected to the network as well as dashboard defined by user for aggregated statistics.