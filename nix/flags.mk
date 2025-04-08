MCU     = IMXRT1062
MCU_DEF = ARDUINO_TEENSY40

OPTIONS  = -DF_CPU=600000000 -DUSB_SERIAL -DLAYOUT_US_ENGLISH
OPTIONS += -D__$(MCU)__ -DARDUINO=10813 -DTEENSYDUINO=159 -D$(MCU_DEF)

CPU_OPTIONS = -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb

CPPFLAGS = -Wall -g -O2 $(CPU_OPTIONS) -MMD $(OPTIONS) -ffunction-sections -fdata-sections
CXXFLAGS = -felide-constructors -fno-exceptions -fpermissive -fno-rtti -Wno-error=narrowing -I$(TEENSY_PATH)/include

LDFLAGS = -T$(TEENSY_PATH)/include/$(MCU).ld -L$(TEENSY_PATH)/lib -Os -Wl,--gc-sections,--relax $(CPU_OPTIONS)
