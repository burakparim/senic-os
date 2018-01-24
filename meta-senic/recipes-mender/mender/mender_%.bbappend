FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

MENDER_SERVER_URL = "https://hosted.mender.io"

SRC_URI += "file://mender-device-identity \
            file://artifact-verify-key.pem"

do_install_append() {
  install -m 0755 ${WORKDIR}/mender-device-identity ${D}/usr/share/mender/identity/mender-device-identity
}
