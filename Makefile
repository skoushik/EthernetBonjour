CC=avr-gcc
CXX=avr-g++
MCU=-mmcu=atmega328p
CPU_SPEED=-DF_CPU=16000000UL
VARIANTS=standard

ARDUINO_PATH=/home/alinrus/work/arduino-lite/Arduino

SPI_PATH=$(ARDUINO_PATH)/libraries/SPI
PINS_PATH=$(ARDUINO_PATH)/hardware/arduino/variants/$(VARIANTS)
WIRING_PATH=$(ARDUINO_PATH)/hardware/arduino/cores/arduino
ETHERNET_PATH=$(ARDUINO_PATH)/libraries/Ethernet

HEADER_PATHS=-I$(SPI_PATH) -I$(PINS_PATH) -I$(WIRING_PATH) -I$(ETHERNET_PATH) \
	-I$(ETHERNET_PATH)/utility -I.

ENABLE_FLAGS=-DARDUINO=100
CFLAGS=$(MCU) $(CPU_SPEED) $(ENABLE_FLAGS) -Os -w -funsigned-char \
	-funsigned-bitfields -fpack-struct -fshort-enums

SOURCES=EthernetBonjour.cpp utility/EthernetCompat.cpp utility/EthernetUtil.c
OBJECTS1=$(filter %.cpp, $(SOURCES))
OBJECTS2=$(filter %.c, $(SOURCES))
OBJECTS=$(OBJECTS1:.cpp=.o) $(OBJECTS2:.c=.o)

libzeroconf.a: $(OBJECTS)
	avr-ar rcs $@ $^
	rm $(OBJECTS)

%.o : %.c
	$(CC) $(HEADER_PATHS) $< $(CFLAGS) -c -o $@

%.o : %.cpp
	$(CXX) $(HEADER_PATHS) $< $(CFLAGS) -c -o $@
