# Hexamon.io - modular wireless beehive weighting system

Beehive monitoring - solves data acquisition from load cells placed under the beehives, data transport to server and data visualization for user.

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/set_with_panel.jpg" height="250">

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/load_cell_under_beehive.jpg" height="250">

## Architecture overview
### Master
Master unit consist of a Raspberry Pi with a CAN shield with RJ12 connector.
CAN shield is a board with SPI [MCP2515 CAN controller](http://ww1.microchip.com/downloads/en/DeviceDoc/21801d.pdf) and [SN65HVD23x](http://www.ti.com/lit/ds/symlink/sn65hvd230.pdf) CAN transceiver.

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/shield_without_esd.jpg" height="250">

### Power management
The system is powered through a [18V solar panel](https://www.i4wifi.cz/Solarni-panely-1/Solarni-panely/Solarni-panel-GWL-Sunny-Poly-20-Wp-36-cells-MPPT-18V.html), charging [12V battery](https://www.gme.cz/oloveny-akumulator-shimastu-npg7-2-12-12v-7-2ah).
Enclosure with master unit has power management board for charging circuit with under-voltage protection, as well as 5V USB ports for output.

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/central_unit_in_box.jpg" height="250">

20W solar panel was selected for a prototype, due to it's ability to supply sufficient energy even during cloudy days for a Raspberry Pi.

### Bus unit
Under each beehive, assuming that whole chain of beehives is no longer than 100m, is placed platform with load cells for measuring the weight and bus unit in an enclosure. First beehive in chain contains Master and Bus unit at once.

Bus unit has STM32F042F6P6 in an TSSOP20 package with CAN transceiver and two RJ12 connectors for daisy-chaining to other bus units, as well as two holders for HX711 breakout boards. [Converters boards](https://www.aliexpress.com/item/10pcs-HX711-Weighing-Sensor-Dual-Channel-24-Bit-Precision-A-D-Module-Pressure-Sensor/32656264280.html) can be purchased through eBay or AliExpress.

Schematics & board design can be found in _boards_ directory.

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/bus_unit.jpg" height="250">

### Weight acquisition
As an ADC with differential amplifier was selected chip HX711 integrated on a beakout board with all the necessary electronics around.

## Hardware
### Platform
Simple two-rail platform consists of three components:
* Load cell Zemic L6E or equivalent
* 2x Spacer
* 50x50mm 45cm L profile with drilled holes to match load-cell

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/measuring_rail.jpg" height="250">

Middle bars may be optional, depending on the situation:
* 2x Rectangle aluminium profile 25x15x3mm 25cm
* 2x Rectangle aluminium profile 25x30x3mm 25cm
These fit perfectly together. By drilling holes, pitch can be adjusted.

As the platform was not part of the project assignment, [contact me](mailto:adamlucansky@gmail.com) in case of interest.

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/set.jpg" height="250">

### Load cells
During development, [Zemic L6E](https://www.zemiceurope.com/media/Documentation/L6E_Datasheet.pdf) were selected. For deployment, [L6G](https://www.zemiceurope.com/media/Documentation/L6G_Datasheet.pdf) are used. 

## Modularity
Several beehives can be chained together with a telephone cable with RJ12 jack through Bus unit under beehive, while master unit is sending captured data wirelessly to server through WiFi (3G/GSM modem option was tested and implemented, but is not further described, wvdial utility & whole ecosystem of linux drivers for modems make it diffucult for set-up).

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/deploy_busunits_mounted.jpg" height="250">
<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/deployment_set.jpg" height="250">

## Software
### Master unit
Raspberry Pi 3 running Raspbian system, with an SPI overlay, provides can0 network interface which can be easily interfaced through linux socket. [Main program](https://github.com/lucansky/hexamond) is written in Haskell and is basically flipping frames received on CAN bus to HTTP requests to webservers where the data are further processed.

### Bus unit
[STM32F042](http://www.st.com/en/microcontrollers/stm32f0x2.html) MCU on board has 32kB of Flash memory and 6kB SRAM. Ivory language has been selected for generation of the C code, and Ivory framework as a hardware abstraction layer, message passing and RTOS interaction. Therefore whole project is 100% Haskell except the web. Firmware can be found [HERE](https://github.com/lucansky/hexamon-firmware).

### Web
Web interface provides charts for all sensors connected to the network as well as dashboard defined by user for aggregated statistics. Each setup requires separate instance of the web with database. Source code can be found [HERE](https://github.com/lucansky/hexamon-web)

<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/chart_load_cell_with_bees.png">

# Results
System is deployed on a few beehives, needs a bit more tweaking (grounding of the metal platform with beehives, as interference is generated during thunderstorm) and better cable management.

__candump__ can be seed on monitor of the laptop of the deployment set. Battery is already charging from solar panel.
<img src="https://github.com/lucansky/hexamon/raw/master/manuals/images/running_system.jpg" height="250">

# Future work
Due to over-engineered solution, next iteration will be with [SIGFOX](https://en.wikipedia.org/wiki/Sigfox) - one module per beehive (just load cell cable connected to small box, 2xAA battery, optionally DS18B20 temperature sensor). Currently waiting for a [better signal coverage in Slovakia](http://www.simplecell.sk/pages/technologia_sigfox/), which is the reason SIGFOX was not considered from the beginning.
