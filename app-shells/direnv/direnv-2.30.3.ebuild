# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_ON="github.com/${PN}"
EGO_PN="${EGO_ON}/${PN}"

inherit go-module

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/BurntSushi/toml v0.4.1"
	"github.com/BurntSushi/toml v0.4.1/go.mod"
	"github.com/direnv/go-dotenv v0.0.0-20181227095604-4cce6d1a66f7"
	"github.com/direnv/go-dotenv v0.0.0-20181227095604-4cce6d1a66f7/go.mod"
	"github.com/direnv/go-dotenv v0.0.0-20210516213449-d90326084211"
	"github.com/direnv/go-dotenv v0.0.0-20210516213449-d90326084211/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-isatty v0.0.14"
	"github.com/mattn/go-isatty v0.0.14/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/mod v0.4.1"
	"golang.org/x/mod v0.4.1/go.mod"
	"golang.org/x/mod v0.5.1"
	"golang.org/x/mod v0.5.1/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
	"golang.org/x/sys v0.0.0-20211216021012-1d35b9e2eb4e"
	"golang.org/x/sys v0.0.0-20211216021012-1d35b9e2eb4e/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
)

go-module_set_globals

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
	KEYWORDS=""
else
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi

inherit golang-build

DESCRIPTION="Automatically load and unload environment variables depending on the current dir"
HOMEPAGE="https://direnv.net"
LICENSE="MIT"
SLOT="0"

S="${WORKDIR}/src/${EGO_PN}"

src_unpack() {
	default
	mkdir -p "${WORKDIR}/src/${EGO_ON}" || die
	mv "${WORKDIR}/${P}" "${S}" || die
	go-module_setup_proxy
}

src_compile() {
	GOPATH="${WORKDIR}" emake build
}

src_install() {
	dodoc LICENSE README.md CHANGELOG.md
	doman man/*.[1-8]
	dobin ${PN}
}

pkg_postinst() {
	elog "To activate ${PN} in your bash shells, you must add the following"
	elog "to your ~/.bashrc file:"
	elog ""
	elog '    eval "$(direnv hook bash)"'
	elog ""
	elog "If you use an alternate shell, see ${HOMEPAGE}"
}
