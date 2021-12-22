# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Next generation OpenVPN client"
HOMEPAGE="https://openvpn.net"
LICENSE="GNU Affero General Public License v3.0"

EGIT_REPO_URI="https://github.com/OpenVPN/openvpn3-linux.git"
EGIT_COMMIT="v16_beta"
EGIT_SUBMODULES=( '*' )


SLOT="0"

KEYWORDS="~amd64"
IUSE="+openssl mbedtls"

CDEPEND="mbedtls? ( net-libs/mbedtls:= )
		openssl? ( >=dev-libs/openssl-1.0.2 )
"
RDEPEND="${CDEPEND}
		acct-group/openvpn
		acct-user/openvpn
		>=sys-devel/autoconf-2.69-r5
		>=sys-devel/autoconf-archive-2021.02.19
		>=sys-devel/automake-1.11.6-r3
		dev-libs/jsoncpp
		>=sys-libs/libcap-ng-0.8.2-r1
		>=app-arch/lz4-1.9.3-r1
		>=dev-libs/glib-2.68.2-r1
		>=dev-libs/tinyxml2-8.0.0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"


src_configure() {
	cat <<EOF >./version.m4
define([PRODUCT_NAME], [OpenVPN 3/Linux])
define([PRODUCT_VERSION], [${PRODVERSION}])
define([PRODUCT_GUIVERSION], [${GUIVERSION}])
define([PRODUCT_TARNAME], [openvpn3-linux])
define([PRODUCT_BUGREPORT], [openvpn-devel@lists.sourceforge.net])
EOF

	autoreconf -vi
	./configure \
		host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var
}

src_compile() {
	emake
}

src_install() {
	default
}

pkg_postinst() {
	mkdir -p /var/lib/openvpn3/configs
	chown -R openvpn:openvpn /var/lib/openvpn3
}
