SUMMARY = "C library for encoding data in a QR Code symbol"
AUTHOR = "Kentaro Fukuchi"
HOMEPAGE = "http://fukuchi.org/works/qrencode/"
SECTION = "libs"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=2d5025d4aa3495befef8f17206a5b0a1"

SRC_URI = "git://github.com/fukuchi/libqrencode.git;tag=v4.0.0"

S = "${WORKDIR}/git"
DEPENDS = "libpng"
inherit autotools pkgconfig

EXTRA_OECONF += "--without-tests"

