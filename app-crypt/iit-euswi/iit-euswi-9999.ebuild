# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker udev prefix

DESCRIPTION="JSC IIT End-User Ukraine cryptography library"
HOMEPAGE="https://iit.com.ua/"
LICENSE="JSC-IIT-EULA"
SLOT="0"

# NOTE: User-Agent should be valid
if [[ ${PV} = *9999* ]]; then
	SRC_URI="https://iit.com.ua/download/productfiles/euswi.64.deb"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

IUSE="pcsc-lite +udev"

RDEPEND="
	pcsc-lite? ( sys-apps/pcsc-lite )
	udev? ( virtual/udev )
"

QA_PREBUILT="*"
S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local f

	insinto /usr/$(get_libdir)/nsbrowser/plugins
	newins opt/iit/eu/sw/npeuscp.so npeuscp.so

	mv opt "${D}" || die

	insinto /etc/chromium/native-messaging-hosts
	newins "${FILESDIR}/ua.com.iit.eusign.nmh.json" ua.com.iit.eusign.nmh.json
	sed -i '/allowed_extensions/d' "${D}/etc/chromium/native-messaging-hosts/ua.com.iit.eusign.nmh.json" || die

	insinto /etc/opt/chrome/native-messaging-hosts
	newins "${FILESDIR}/ua.com.iit.eusign.nmh.json" ua.com.iit.eusign.nmh.json
	sed -i '/allowed_extensions/d' "${D}/etc/opt/chrome/native-messaging-hosts/ua.com.iit.eusign.nmh.json" || die

	insinto /usr/$(get_libdir)/mozilla/native-messaging-hosts
	newins "${FILESDIR}/ua.com.iit.eusign.nmh.json" ua.com.iit.eusign.nmh.json
	sed -i '/allowed_origins/d' "${D}/usr/$(get_libdir)/mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json" || die

	if use udev; then
		for f in etc/udev/rules.d/*.rules; do
			udev_newrules "${f}" "${f##*/}" || die
		done
	fi
}

pkg_postinst() {
	use udev && udev_reload
}

pkg_postrm() {
	use udev && udev_reload
}
