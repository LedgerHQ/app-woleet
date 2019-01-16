#*******************************************************************************
#   Ledger App
#   (c) 2017 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif
include $(BOLOS_SDK)/Makefile.defines

APPVERSION_M=1
APPVERSION_N=2
APPVERSION_P=4
APPVERSION=$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)

DEFINES   += COIN_P2PKH_VERSION=0 COIN_P2SH_VERSION=5 COIN_FAMILY=1 COIN_COINID=\"Bitcoin\" COIN_COINID_HEADER=\"WOLEET\" COIN_COLOR_HDR=0x85bb65 COIN_COLOR_DB=0xc2ddb2 COIN_COINID_NAME=\"Woleet\" COIN_COINID_SHORT=\"WLT\" COIN_KIND=COIN_KIND_BITCOIN
DEFINES   += WOLEET
APPNAME ="Woleet"
APP_PATH = ""
APP_LOAD_PARAMS= --curve secp256k1 $(COMMON_LOAD_PARAMS)
APP_LOAD_PARAMS += --path $(APP_PATH)
APP_LOAD_FLAGS=--appFlags 0x50
APP_LOAD_PARAMS += $(APP_LOAD_FLAGS)

ICONNAME=nanos_app_woleet.gif


################
# Default rule #
################

all: default

############
# Platform #
############

DEFINES   += OS_IO_SEPROXYHAL IO_SEPROXYHAL_BUFFER_SIZE_B=300
DEFINES   += HAVE_BAGL HAVE_SPRINTF
#DEFINES   += HAVE_PRINTF PRINTF=screen_printf
DEFINES   += PRINTF\(...\)=
DEFINES   += HAVE_IO_USB HAVE_L4_USBLIB IO_USB_MAX_ENDPOINTS=6 IO_HID_EP_LENGTH=64 HAVE_USB_APDU
DEFINES   += LEDGER_MAJOR_VERSION=$(APPVERSION_M) LEDGER_MINOR_VERSION=$(APPVERSION_N) LEDGER_PATCH_VERSION=$(APPVERSION_P) TCS_LOADER_PATCH_VERSION=0
DEFINES += CX_COMPLIANCE_141

DEFINES   += UNUSED\(x\)=\(void\)x
DEFINES   += APPVERSION=\"$(APPVERSION)\"

##############
# Compiler #
##############
#GCCPATH   := $(BOLOS_ENV)/gcc-arm-none-eabi-5_3-2016q1/bin/
#CLANGPATH := $(BOLOS_ENV)/clang-arm-fropi/bin/
CC       := $(CLANGPATH)clang

#CFLAGS   += -O0
CFLAGS   += -O3 -Os

AS     := $(GCCPATH)arm-none-eabi-gcc

LD       := $(GCCPATH)arm-none-eabi-gcc
LDFLAGS  += -O3 -Os
LDLIBS   += -lm -lgcc -lc

# import rules to compile glyphs(/pone)
include $(BOLOS_SDK)/Makefile.glyphs

### variables processed by the common makefile.rules of the SDK to grab source files and include dirs
APP_SOURCE_PATH  += src
SDK_SOURCE_PATH  += lib_stusb qrcode
#use the SDK U2F+HIDGEN USB profile
SDK_SOURCE_PATH  += lib_u2f lib_stusb_impl

DEFINES   += USB_SEGMENT_SIZE=64
DEFINES   += U2F_PROXY_MAGIC=\"BTC\"
DEFINES   += HAVE_IO_U2F HAVE_U2F
#DEFINES   += BLE_SEGMENT_SIZE=20
#DEFINES   += HAVE_USB_CLASS_CCID

load: all
	python -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

delete:
	python -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

# import generic rules from the sdk
include $(BOLOS_SDK)/Makefile.rules

#add dependency on custom makefile filename
dep/%.d: %.c Makefile


listvariants:
	@echo VARIANTS COIN woleet