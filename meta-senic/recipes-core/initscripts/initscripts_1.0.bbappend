FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://hwtests.sh \
    file://bluetooth_test.sh \
    file://wifi_test.sh \
"

do_install_append() {
    # Install shell scripts into /usr/bin/
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/hwtests.sh ${D}${bindir}/
    install -m 0755 ${WORKDIR}/bluetooth_test.sh ${D}${bindir}/
    install -m 0755 ${WORKDIR}/wifi_test.sh ${D}${bindir}/
}

RDEPENDS_${PN} +="bash"
RDEPENDS_${PN} += "qrencode"
