
libsvc_SRCS += \
	libsvc.c \
	misc.c \
	task.c \
	htsbuf.c \
	htsmsg.c \
	htsmsg_json.c \
	htsmsg_binary.c \
	json.c \
	dbl.c \
	dial.c \
	utf8.c \
	tcp.c \
	trace.c \
	irc.c \
	cfg.c \
	cmd.c \
	talloc.c \
	memstream.c \
	sock.c \

libsvc_INCS += \
	libsvc.h \
	misc.h \
	task.h \
	htsbuf.h \
	htsmsg.h \
	htsmsg_json.h \
	htsmsg_binary.h \
	json.h \
	dbl.h \
	dial.h \
	utf8.h \
	tcp.h \
	trace.h \
	irc.h \
	cfg.h \
	cmd.h \
	talloc.h \
	memstream.h \
	sock.h \

##############################################################
# Curl
##############################################################
ifeq (${WITH_CURL},yes)

ifeq ($(shell uname),Darwin)
LDFLAGS += -lcurl -lssh2 -lz -liconv
endif

ifeq ($(shell uname),Linux)
CFLAGS  += $(shell pkg-config --cflags libcurl)
LDFLAGS += $(shell pkg-config --libs libcurl)
endif

libsvc_SRCS += urlshorten.c
libsvc_SRCS += curlhelpers.c

libsvc_INCS += urlshorten.h
libsvc_INCS += curlhelpers.h
endif

##############################################################
# MYSQL
##############################################################

ifeq (${WITH_MYSQL},yes)
libsvc_SRCS    +=  db.c
libsvc_INCS    +=  db.h
FLAGS  += $(shell mysql_config --cflags) -DWITH_MYSQL
LDFLAGS += $(shell mysql_config --libs_r)
endif

##############################################################
# Websocket server
##############################################################

ifeq (${WITH_WS_SERVER},yes)
libsvc_SRCS    +=  websocket_server.c
libsvc_INCS    +=  websocket_server.h
WITH_HTTP_SERVER := yes
WITH_ASYNCIO := yes
CFLAGS += -DWITH_WS_SERVER
endif

##############################################################
# Websocket client
##############################################################

ifeq (${WITH_WS_CLIENT},yes)
libsvc_SRCS    +=  websocket_client.c
libsvc_INCS    +=  websocket_client.h
WITH_ASYNCIO := yes
CFLAGS += -DWITH_WS_CLIENT
endif

##############################################################
# HTTP Server
##############################################################

ifeq (${WITH_HTTP_SERVER},yes)
libsvc_SRCS    +=  http.c
libsvc_INCS    +=  http.h
WITH_TCP_SERVER := yes
CFLAGS += -DWITH_HTTP_SERVER
endif

##############################################################
# TCP server
##############################################################

ifeq (${WITH_TCP_SERVER},yes)
CFLAGS +=  -DWITH_TCP_SERVER
libsvc_SRCS    +=  tcp_server.c
endif

##############################################################
# AsyncIO
##############################################################

ifeq (${WITH_ASYNCIO},yes)
libsvc_SRCS +=  asyncio.c
libsvc_INCS +=  asyncio.h
CFLAGS +=  -DWITH_ASYNCIO
endif

##############################################################
# libgit2
##############################################################

ifeq (${WITH_LIBGIT2},yes)
CFLAGS +=  -DWITH_LIBGIT2
ALLDEPS += ${BUILDDIR}/libgit2/include/git2.h
CFLAGS  += -I${BUILDDIR}/libgit2/include/
LDFLAGS += -L${BUILDDIR}/libgit2/lib -lgit2 -lssh2 -lz

${BUILDDIR}/libgit2/include/git2.h:
	mkdir -p ${BUILDDIR}/libgit2/build
	cd ${BUILDDIR}/libgit2/build && cmake ${CURDIR}/libgit2 -DCMAKE_INSTALL_PREFIX=${BUILDDIR}/libgit2 -DBUILD_SHARED_LIBS=OFF -DTHREADSAFE=ON -DUSE_SSH=ON
	cd ${BUILDDIR}/libgit2/build && cmake --build . --target install
endif


##############################################################
# Control socket
##############################################################
ifeq (${WITH_CTRLSOCK},yes)
libsvc_SRCS +=  ctrlsock.c
libsvc_INCS +=  ctrlsock.h
CFLAGS += -DWITH_CTRLSOCK
endif
