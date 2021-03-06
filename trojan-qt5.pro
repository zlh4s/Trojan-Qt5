#
# Copyright (C) 2015-2016 Symeon Huang <hzwhuang@gmail.com>
# Copyright (C) 2019-2020 TheWanderingCoel <thewanderingcoel@protonmail.com>
#
# Trojan-Qt5 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Trojan-Qt5 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Trojan-Qt5; see the file LICENSE. If not, see
# <http://www.gnu.org/licenses/>.
#

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

QT_CONFIG -= no-pkg-config

RC_ICONS = $$PWD/resources/icons/trojan-qt5_new_white.ico
ICON = $$PWD/resources/icons/trojan-qt5_new.icns

TARGET = trojan-qt5

# Use OpenSource Version of Qt5
QT_EDITION = OpenSource

CONFIG += c++17
CONFIG += sdk_no_version_check
CONFIG += link_pkgconfig
# Sanitizer
#CONFIG += sanitizer sanitize_address

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
#DEFINES += QT_DEPRECATED_WARNINGS

# Define App Version
DEFINES += "APP_VERSION=\"\\\"1.2.0\\\"\""

# Set Build Info String
_TROJAN_QT5_BUILD_INFO_STR_=$$getenv(_TROJAN_QT5_BUILD_INFO_)
isEmpty(_TROJAN_QT5_BUILD_INFO_STR_) {
    _TROJAN_QT5_BUILD_INFO_STR_ = "Trojan-Qt5 build from local machine"
}
DEFINES += _TROJAN_QT5_BUILD_INFO_STR_=\"\\\"$${_TROJAN_QT5_BUILD_INFO_STR_}\\\"\"

# QHttpServer
DEFINES += QHTTPSERVER_EXPORT

# QtColorPicker
DEFINES += QT_QTCOLORPICKER_EXPORT

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# 3rdParty Headers
INCLUDEPATH += $$PWD/src/plog/include

# QtAwesome
include($$PWD/src/QtAwesome/QtAwesome/QtAwesome.pri)

# ShadowsocksR-uvw
include($$PWD/src/shadowsocksr-uvw/Shadowsocksr-uvw.pri)

# QHttpServer
include($$PWD/3rd/qhttpserver/qhttpserver.pri)

win32:CONFIG(debug, debug|release) {
    LIBS += -LC:\TQLibraries\Grpc\debug\lib -lgrpc -lgrpc++ -llibprotobufd -lgpr -lzlibd -lupb -lcares -labsl_strings -labsl_base -labsl_throw_delegate -laddress_sorting
    LIBS += $$PWD\3rd\yaml-cpp\Debug\yaml-cppd.lib
}

else:win32:CONFIG(release, debug|release) {
    LIBS += -LC:\TQLibraries\Grpc\lib -lgrpc -lgrpc++ -llibprotobuf -lgpr -lzlib -lupb -lcares -labsl_strings -labsl_base -labsl_throw_delegate -laddress_sorting
    LIBS += $$PWD\3rd\yaml-cpp\Release\yaml-cpp.lib
}

win32 {
    DEFINES += _WIN32_WINNT=0x600
    SOURCES += \
        src/systemproxy/windows.c \
        src/statusnotifier.cpp \
        src/urlscheme/urlschemeregister.cpp \
        src/theme/themehelper.cpp
    HEADERS += \
        src/systemproxy/windows.h \
        src/urlscheme/urlschemeregister.h
    INCLUDEPATH += C:\TQLibraries\ZBar\include
    INCLUDEPATH += C:\TQLibraries\OpenSSL-Win32\include
    INCLUDEPATH += C:\TQLibraries\QREncode\include
    INCLUDEPATH += C:\TQLibraries\WinSparkle\include
    INCLUDEPATH += C:\TQLibraries\Libsodium\include
    INCLUDEPATH += C:\TQLibraries\Libuv\include
    INCLUDEPATH += C:\TQLibraries\Grpc\include
    LIBS += -LC:\TQLibraries\ZBar\lib -llibzbar-0
    LIBS += -LC:\TQLibraries\OpenSSL-Win32\lib -llibcrypto -llibssl
    LIBS += -LC:\TQLibraries\QREncode\lib -lqrcodelib
    LIBS += -LC:\TQLibraries\WinSparkle\lib -lWinSparkle
    LIBS += -LC:\TQLibraries\Libsodium\lib -llibsodium
    LIBS += -LC:\TQLibraries\Libuv\lib -llibuv
    LIBS += -lwsock32 -lws2_32 -luserenv -liphlpapi
    LIBS += -lCrypt32 -lkernel32 -lpsapi -luser32
    DEFINES += WIN32_LEAN_AND_MEAN
    LIBS += $$PWD\3rd\trojan-qt5-core\trojan-qt5-core.lib
    QMAKE_CXXFLAGS_WARN_ON -= -w34100
    QMAKE_CXXFLAGS += -wd4251 -wd4996
    # Otherwise lupdate will not work
    TR_EXCLUDE += C:\TQLibraries\boost_1_72_0\*
}

mac {
    HEADERS += \
        src/LetsMove/PFMoveApplication.h
    SOURCES += \
        src/statusnotifier.mm \
        src/LetsMove/PFMoveApplication.m \
        src/theme/themehelper.mm
    PKG_CONFIG = /usr/local/bin/pkg-config
    INCLUDEPATH += /usr/local/opt/zlib/include
    INCLUDEPATH += /usr/local/opt/openssl@1.1/include
    LIBS += -L/usr/local/opt/zlib/lib -lz
    LIBS += -L/usr/local/opt/openssl@1.1/lib -lssl -lcrypto
    LIBS += -L/usr/local/opt/grpc/lib -lupb -laddress_sorting
    LIBS += -framework Security -framework Cocoa
    # For Sparkle Usage
    SOURCES += \
        src/sparkle/AutoUpdater.cpp \
        src/sparkle/CocoaInitializer.mm \
        src/sparkle/SparkleAutoUpdater.mm
    HEADERS += \
        src/sparkle/AutoUpdater.h \
        src/sparkle/CocoaInitializer.h \
        src/sparkle/SparkleAutoUpdater.h
    QMAKE_LFLAGS += -Wl,-rpath,@loader_path/../Frameworks
    QMAKE_CXXFLAGS += -DOBJC_OLD_DISPATCH_PROTOTYPES=1 # Enable strict checking of objc_msgsend calls = NO
    QMAKE_CXXFLAGS += -fno-objc-arc
    LIBS += -framework AppKit
    LIBS += -framework Carbon
    LIBS += -framework Foundation
    LIBS += -framework ApplicationServices
    LIBS += -framework Sparkle
    LIBS += -framework LetsMove
    QMAKE_INFO_PLIST = resources/Info.plist
    # Otherwise lupdate will not work
    TR_EXCLUDE += /usr/local/opt/boost/*
}

unix:!mac {
    QT += dbus
    PKGCONFIG += openssl
    SOURCES += \
        src/statusnotifier.cpp \
        src/themehelper.cpp
    LIBS += -lz
    # Otherwise lupdate will not work
    TR_EXCLUDE += /usr/local/boost/*

    isEmpty(PREFIX) {
        PREFIX = /usr/local
    }

    target.path = $$PREFIX/bin
    shortcutfiles.files = src/trojan-qt5.desktop
    shortcutfiles.path = $$PREFIX/share/applications/
    data.files += resources/icons/trojan-qt5.png
    data.path = $$PREFIX/share/icons/hicolor/512x512/apps/

    INSTALLS += shortcutfiles
    INSTALLS += data
}

unix {
    PKGCONFIG += zbar libqrencode libuv libsodium grpc grpc++ protobuf gpr yaml-cpp
    LIBS += $$PWD/3rd/trojan-qt5-core/trojan-qt5-core.a
}

!isEmpty(target.path): INSTALLS += target

SOURCES += \
    src/widget/routewidget.cpp \
    src/widget/streamwidget.cpp \
    src/speedplot/speedplot.cpp \
    src/proxy/snellthread.cpp \
    src/proxyapi/snellgoapi.cpp \
    src/urlscheme/eventfilter.cpp \
    src/systemproxy/systemproxyhelper.cpp \
    src/proxy/ssthread.cpp \
    src/proxy/v2raythread.cpp \
    src/proxy/trojanthread.cpp \
    src/proxyapi/ssgoapi.cpp \
    src/proxyapi/v2rayapi.cpp \
    src/proxyapi/trojangoapi.cpp \
    src/proxydialog/socks5editdialog.cpp \
    src/proxydialog/httpeditdialog.cpp \
    src/proxydialog/sseditdialog.cpp \
    src/proxydialog/ssreditdialog.cpp \
    src/proxydialog/vmesseditdialog.cpp \
    src/proxydialog/trojaneditdialog.cpp \
    src/proxydialog/snelleditdialog.cpp \
    src/connectionsortfilterproxymodel.cpp \
    src/haproxythread.cpp \
    src/logger.cpp \
    src/midman.cpp \
    src/pac/pacserver.cpp \
    src/pac/pachelper.cpp \
    src/privilegeshelper.cpp \
    src/resourcehelper.cpp \
    src/routetablehelper.cpp \
    src/addresstester.cpp \
    src/confighelper.cpp \
    src/connection.cpp \
    src/connectionitem.cpp \
    src/connectiontablemodel.cpp \
    src/speedplot/speedplotview.cpp \
    src/speedplot/speedwidget.cpp \
    src/statusbar.cpp \
    src/ip4validator.cpp \
    src/main.cpp \
    src/mainwindow.cpp \
    src/portvalidator.cpp \
    src/qrcodecapturer.cpp \
    src/qrwidget.cpp \
    src/settingsdialog.cpp \
    src/sharedialog.cpp \
    src/subscribemanager.cpp \
    src/tqprofile.cpp \
    src/tqsubscribe.cpp \
    src/generalvalidator.cpp \
    src/tun2socksthread.cpp \
    src/urihelper.cpp \
    src/uriinputdialog.cpp \
    src/userrules.cpp \
    src/subscribedialog.cpp \
    src/httpproxy.cpp \
    src/socketstream.cpp \
    src/utils.cpp \
    src/aboutdialog.cpp \
    src/clickablelabel.cpp \
    src/qtcolorpicker.cpp

HEADERS += \
    src/widget/routewidget.h \
    src/widget/streamwidget.h \
    src/theme/themehelper.h \
    src/proxy/snellthread.h \
    src/proxyapi/snellgoapi.h \
    src/urlscheme/eventfilter.h \
    src/systemproxy/systemproxyhelper.h \
    src/proxy/ssthread.h \
    src/proxy/v2raythread.h \
    src/proxy/trojanthread.h \
    src/proxyapi/ssgoapi.h \
    src/proxyapi/v2rayapi.h \
    src/proxyapi/trojangoapi.h \
    src/proxydialog/socks5editdialog.h \
    src/proxydialog/httpeditdialog.h \
    src/proxydialog/sseditdialog.h \
    src/proxydialog/ssreditdialog.h \
    src/proxydialog/vmesseditdialog.h \
    src/proxydialog/trojaneditdialog.h \
    src/proxydialog/snelleditdialog.h \
    src/connectionsortfilterproxymodel.h \
    src/haproxythread.h \
    src/logger.h \
    src/midman.h \
    src/pac/pacserver.h \
    src/pac/pachelper.h \
    src/privilegeshelper.h \
    src/resourcehelper.h \
    src/routetablehelper.h \
    src/addresstester.h \
    src/confighelper.h \
    src/connection.h \
    src/connectionitem.h \
    src/connectiontablemodel.h \
    src/speedplot/speedplotview.hpp \
    src/speedplot/speedwidget.hpp \
    src/statusbar.h \
    src/ip4validator.h \
    src/mainwindow.h \
    src/portvalidator.h \
    src/qrcodecapturer.h \
    src/qrwidget.h \
    src/settingsdialog.h \
    src/sharedialog.h \
    src/subscribemanager.h \
    src/tqprofile.h \
    src/statusnotifier.h \
    src/tqsubscribe.h \
    src/generalvalidator.h \
    src/tun2socksthread.h \
    src/urihelper.h \
    src/uriinputdialog.h \
    src/userrules.h \
    src/subscribedialog.h \
    src/httpproxy.h \
    src/socketstream.h \
    src/utils.h \
    src/speedplot/speedplot.h \
    src/aboutdialog.h \
    src/clickablelabel.h \
    src/qtcolorpicker.h

FORMS += \
    ui/httpeditdialog.ui \
    ui/socks5editdialog.ui \
    ui/aboutdialog.ui \
    ui/routewidget.ui \
    ui/settingsdialog.ui \
    ui/mainwindow.ui \
    ui/sharedialog.ui \
    ui/speedplot.ui \
    ui/sseditdialog.ui \
    ui/ssreditdialog.ui \
    ui/streamwidget.ui \
    ui/subscribedialog.ui \
    ui/trojaneditdialog.ui \
    ui/uriinputdialog.ui \
    ui/userrules.ui \
    ui/snelleditdialog.ui \
    ui/vmesseditdialog.ui

TRANSLATIONS += \
    resources/i18n/trojan-qt5_en_US.ts \
    resources/i18n/trojan-qt5_zh_CN.ts \
    resources/i18n/trojan-qt5_zh_TW.ts \
    resources/i18n/trojan-qt5_zh_SG.ts

PROTOS += \
    $$PWD/src/proxyapi/ssgoapi.proto \
    $$PWD/src/proxyapi/v2rayapi.proto \
    $$PWD/src/proxyapi/trojangoapi.proto \
    $$PWD/src/proxyapi/snellgoapi.proto

include($$PWD/src/protobuf.pri)
include($$PWD/src/grpc.pri)

headers.path = /usr/include
headers.CONFIG = no_check_exist
headers.files = $${PROTOBUF_HEADERS}

INCLUDEPATH += \
    $$PWD/src \
    $$PWD/src/proxy \
    $$PWD/src/proxyapi \
    $$PWD/src/proxydialog \
    $$PWD/src/systemproxy \
    $$PWD/src/urlscheme \
    $$PWD/src/theme \
    $$PWD/src/pac \
    $$PWD/src/speedplot \
    $$PWD/src/widget \
    $$PWD/3rd/trojan-qt5-core \
    $$PWD/3rd/yaml-cpp/include

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin

RESOURCES += \
    resources/bin.qrc \
    resources/conf.qrc \
    resources/credits.qrc \
    resources/dat.qrc \
    resources/icons.qrc \
    resources/pac.qrc \
    resources/pem.qrc \
    resources/qss.qrc \
    resources/translations.qrc
