# ------------------------------------------------------------------------------
CUR_DIR=$(shell  pwd )
plat ?= x86

ifeq ($(plat),mips)
# CROSS_COMPILE=mipsel-linux-
# LDFLAGS += -L/home/mojies/work/sense2/sugr/third/__install/lib/
# LDFLAGS += -L/home/mojies/work/sense2/sugr/third/__install/lib/common/
# CFLAGS += -I/home/mojies/work/sense2/sugr/third/__install/include
# CFLAGS += -I/home/mojies/work/sense2/sugr/third/__install/include/common
# INSTALL_DIR = /home/mojies/work/sense2/sugr/third/__install
# LIBPATH = /home/mojies/work/sense2/sugr/third/__install/lib
else
LDFLAGS += -L./lib
CFLAGS += -I./include
INSTALL_DIR = $(CUR_DIR)
LIBPATH = $(CUR_DIR)/lib
endif
CC = ${CROSS_COMPILE}gcc
CXX = ${CROSS_COMPILE}g++
STRIP = ${CROSS_COMPILE}strip
AR = ${CROSS_COMPILE}ar

LIBSRCS += src/pb_common.c src/pb_decode.c src/pb_encode.c

SRCS_T_SIMPLE += test/simple/simple.c test/simple/simple.pb.c
TEST_LIBS += -lpb

# ------------------------------------------------------------------------------

all: libpb.so simple.t simple.t.run
	-@echo "build done"

test: aufifo.t
	-@echo "build test"

libpb.so:
	@$(CC) $(LIBSRCS) $(CFLAGS) -shared -fPIC -o $@ $(LDFLAGS)
	@test -d $(INSTALL_DIR)/lib || mkdir -p $(INSTALL_DIR)/lib
	@test -d $(INSTALL_DIR)/include || mkdir -p $(INSTALL_DIR)/include
	@mv $@ $(INSTALL_DIR)/lib/
	@cp src/pb_common.h src/pb_decode.h src/pb_encode.h src/pb.h $(INSTALL_DIR)/include/

simple.t:
	$(CC) $(CFLAGS) -o $@ $(SRCS_T_SIMPLE) $(LDFLAGS) $(TEST_LIBS)
	@test -d $(INSTALL_DIR)/bin || mkdir -p $(INSTALL_DIR)/bin
	@mv $@ bin


simple.t.run:
	LD_LIBRARY_PATH=$(LIBPATH) $(INSTALL_DIR)/bin/simple.t

clean:
	@rm -rf lib/*
	@rm -rf include/*
	@rm -rf bin/*

