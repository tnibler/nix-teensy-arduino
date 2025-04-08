include $(TEENSY_PATH)/include/flags.mk

BUILDDIR = build

ifdef NO_BEAR
	BEAR_PREFIX := 
else
	BEAR_PREFIX := bear --append -- 
endif


CC := $(BEAR_PREFIX) arm-none-eabi-gcc
CXX := $(BEAR_PREFIX) arm-none-eabi-g++
OBJCOPY := arm-none-eabi-objcopy
SIZE := arm-none-eabi-size

CXXFLAGS += -std=gnu++20 -I$(GCCARM_INCLUDE_PATH) $(foreach d,$(TEENSY_INCLUDE_PATHS),-I$(d))

LIBS = -lm -lstdc++ -lteensy-core

CPP_FILES := $(foreach d,$(TEENSY_SOURCE_PATHS),$(wildcard $(d)/*.cpp)) $(wildcard src/*.cpp) 
CXXOBJECTS := $(CPP_FILES:%.cpp=$(BUILDDIR)/%.cpp.o) 

TARGET := $(BUILDDIR)/firmware.hex

all: $(TARGET)

-include $(CXXOBJECTS:.o=.d)

$(BUILDDIR)/%.cpp.o: %.cpp
	@echo Compiling $^
	@mkdir -p $(dir $@)
	@$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<

$(BUILDDIR)/%.elf: $(CXXOBJECTS)
	@$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

$(BUILDDIR)/%.hex: $(BUILDDIR)/%.elf
	$(SIZE) $<
	$(OBJCOPY) -O ihex -R .eeprom $< $@

directories:
	@mkdir -p $(BUILDDIR)

.PHONY: flash clean

clean:
	rm -rf $(BUILDDIR)

flash: $(TARGET)
	@echo "Flashing... (Press button to put Teensy into loading mode)"
	@teensy-loader-cli --mcu=TEENSY40 -w $(TARGET)
