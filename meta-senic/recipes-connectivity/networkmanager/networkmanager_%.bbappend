SYSTEMD_SERVICE_${PN} = "NetworkManager.service NetworkManager-dispatcher.service NetworkManager-wait-online.service "

do_install_append() {
    rm -r ${D}${sysconfdir}/NetworkManager/system-connections
    ln -sf /data/senic-hub/etc/NetworkManager/system-connections ${D}${sysconfdir}/NetworkManager/
}
