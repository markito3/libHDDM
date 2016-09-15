WHICH_HDDM-C = $(shell which hddm-c)
WHICH_HDDM-CPP = $(shell which hddm-cpp)

all: env_check library

env_check:
ifeq ($(strip $(WHICH_HDDM-C)),)
	@echo error: hddm-c not in path ; exit 1
else
	@echo hddm-c found in path: $(WHICH_HDDM-C)
endif
ifeq ($(strip $(WHICH_HDDM-CPP)),)
	@echo error: hddm-cpp not in path ; exit 1
else
	@echo hddm-cpp found in path: $(WHICH_HDDM-CPP)
endif

library: hddm_s.h hddm_s.c hddm_s.hpp hddm_s++.cpp \
         hddm_r.h hddm_r.c hddm_r.hpp hddm_r++.cpp \
         hddm_mc_s.h hddm_mc_s.c hddm_mc_s.hpp hddm_mc_s++.cpp
	make -f Makefile.static
#	make -C shlib

install: all
	make -f Makefile.static install

depclean:
	make -f Makefile.static depclean

clean:

	make -f Makefile.static clean
#	make -C shlib clean

pristine:
	make -f Makefile.static pristine

hddm_s.h hddm_s.c: event.xml
	hddm-c $<

hddm_r.h hddm_r.c: rest.xml
	hddm-c $<

hddm_mc_s.h hddm_mc_s.c: mc.xml
	hddm-c $<

hddm_s.hpp hddm_s++.cpp: event.xml
	hddm-cpp $<
	mv hddm_s.cpp hddm_s++.cpp

hddm_r.hpp hddm_r++.cpp: rest.xml
	hddm-cpp $<
	mv hddm_r.cpp hddm_r++.cpp

hddm_mc_s.hpp hddm_mc_s++.cpp: mc.xml
	hddm-cpp $<
	mv hddm_mc_s.cpp hddm_mc_s++.cpp

t_rest: t_rest.cpp
	g++ -O4 -o $@ -g -std=c++11 $^ -I. -I$(HALLD_HOME)/$(BMS_OSNAME)/include \
    -L$(HALLD_HOME)/$(BMS_OSNAME)/lib -lHDDM -lxstream -lbz2 -lz -lpthread -lrt
