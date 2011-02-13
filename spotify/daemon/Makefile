TARGET=spdaemon
LDLIBS += -lreadline
CFLAGs += -Werror

include ../common.mk

$(TARGET): appkey.o main.o
	$(CXX) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $^ -o $@
ifdef DEBUG
ifeq ($(shell uname),Darwin)
	install_name_tool -change @loader_path/../Frameworks/libspotify.framework/libspotify @rpath/libspotify.so $@
endif
endif