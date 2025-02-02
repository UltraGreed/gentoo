# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python bindings to y-crdt "
HOMEPAGE="
	https://pypi.org/project/ypy-websocket/
	https://github.com/y-crdt/ypy-websocket/
"
SRC_URI="
	https://github.com/y-crdt/ypy-websocket/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<dev-python/anyio-4[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.6.1[${PYTHON_USEDEP}]
	<dev-python/aiosqlite-1[${PYTHON_USEDEP}]
	>=dev-python/aiosqlite-0.18.0[${PYTHON_USEDEP}]
	<dev-python/y-py-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/y-py-0.6.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# Requires internet and nodejs
	tests/test_ypy_yjs.py
)

distutils_enable_tests pytest

src_prepare() {
	# lower the necessary version
	sed -i -e '/anyio/s:3.6.2:3.6.1:' pyproject.toml || die
	distutils-r1_src_prepare
}
