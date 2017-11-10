SUMMARY = "Service responsible for attaching the BT module at startup"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
 

REQUIRED_DISTRO_FEATURES= "systemd"

SRC_URI += "file://btattach.service"

SYSTEMD_SERVICE_${PN} = "btattach.service"

inherit systemd

do_install () {

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/btattach.service ${D}${systemd_system_unitdir}
 
}


# This seems to end up installing the service to both
# etc/systemd/system/multi-user.target.wants/btattach.service
# and lib/systemd/system/btattach.service
# Not sure if the second one is required, could be dropped to
# not cause confusion

