# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit savedconfig

if [[ ${PV} == 99999999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/${PN}.git"
else
	GIT_COMMIT="711d3297bac870af42088a467459a0634c1970ca"
	SRC_URI="https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="Linux firmware files"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git"

LICENSE="GPL-2 GPL-2+ GPL-3 BSD MIT || ( MPL-1.1 GPL-2 )
	redistributable? (
		linux-fw-redistributable ( BSD-2 BSD BSD-4 ISC MIT no-source-code ) )
	unknown-license? ( all-rights-reserved )"
SLOT="0"
IUSE="+redistributable savedconfig unknown-license"
RESTRICT="binchecks strip
	redistributable? ( bindist )
	unknown-license? ( bindist )"

RDEPEND="!savedconfig? (
		redistributable? (
			!sys-firmware/alsa-firmware[alsa_cards_ca0132]
			unknown-license? (
				!sys-firmware/alsa-firmware[alsa_cards_korg1212]
				!sys-firmware/alsa-firmware[alsa_cards_maestro3]
				!sys-firmware/alsa-firmware[alsa_cards_sb16]
				!sys-firmware/alsa-firmware[alsa_cards_ymfpci]
			)
			!media-tv/cx18-firmware
			!<sys-firmware/ivtv-firmware-20080701-r1
			!media-tv/linuxtv-dvb-firmware[dvb_cards_cx231xx]
			!media-tv/linuxtv-dvb-firmware[dvb_cards_cx23885]
			!media-tv/linuxtv-dvb-firmware[dvb_cards_usb-dib0700]
			!net-dialup/ueagle-atm
			!net-dialup/ueagle4-atm
			!net-wireless/ar9271-firmware
			!net-wireless/i2400m-fw
			!net-wireless/libertas-firmware
			!sys-firmware/rt61-firmware
			!net-wireless/rt73-firmware
			!net-wireless/rt2860-firmware
			!net-wireless/rt2870-firmware
			!sys-block/qla-fc-firmware
			!sys-firmware/amd-ucode
			!sys-firmware/iwl1000-ucode
			!sys-firmware/iwl2000-ucode
			!sys-firmware/iwl2030-ucode
			!sys-firmware/iwl3945-ucode
			!sys-firmware/iwl4965-ucode
			!sys-firmware/iwl5000-ucode
			!sys-firmware/iwl5150-ucode
			!sys-firmware/iwl6000-ucode
			!sys-firmware/iwl6005-ucode
			!sys-firmware/iwl6030-ucode
			!sys-firmware/iwl6050-ucode
			!sys-firmware/iwl3160-ucode
			!sys-firmware/iwl7260-ucode
			!sys-firmware/iwl7265-ucode
			!sys-firmware/iwl3160-7260-bt-ucode
			!sys-firmware/radeon-ucode
		)
	)"
#add anything else that collides to this

src_unpack() {
	if [[ ${PV} == 99999999* ]]; then
		git-r3_src_unpack
	else
		default
		# rename directory from git snapshot tarball
		mv ${PN}-*/ ${P} || die
	fi
}

src_prepare() {
	# source and documentation files, not to be installed
	local source_files=(
		README
		WHENCE
		"LICEN[CS]E*"
		"GPL*"
		configure
		Makefile
		check_whence.py
		atusb/ChangeLog
		av7110/Boot.S
		av7110/Makefile
		carl9170fw/
		cis/Makefile
		cis/src/
		dsp56k/bootstrap.asm
		dsp56k/concat-bootstrap.pl
		dsp56k/Makefile
		"isci/*.[ch]"
		isci/Makefile
		isci/README
		"keyspan_pda/*.S"
		keyspan_pda/Makefile
		usbdux/
	)

	# whitelist of images with a free software license
	local free_software=(
		# keyspan_pda (GPL-2+)
		keyspan_pda/keyspan_pda.fw
		keyspan_pda/xircom_pgs.fw
		# dsp56k (GPL-2+)
		dsp56k/bootstrap.bin
		# ath9k_htc (BSD GPL-2+ MIT)
		ath9k_htc/htc_7010-1.4.0.fw
		ath9k_htc/htc_9271-1.4.0.fw
		# pcnet_cs, 3c589_cs, 3c574_cs, serial_cs (dual GPL-2/MPL-1.1)
		cis/LA-PCM.cis
		cis/PCMLM28.cis
		cis/DP83903.cis
		cis/NE2K.cis
		cis/tamarack.cis
		cis/PE-200.cis
		cis/PE520.cis
		cis/3CXEM556.cis
		cis/3CCFEM556.cis
		cis/MT5634ZLX.cis
		cis/RS-COM-2P.cis
		cis/COMpad2.cis
		cis/COMpad4.cis
		# serial_cs (GPL-3)
		cis/SW_555_SER.cis
		cis/SW_7xx_SER.cis
		cis/SW_8xx_SER.cis
		# dvb-ttpci (GPL-2+)
		av7110/bootcode.bin
		# usbdux, usbduxfast, usbduxsigma (GPL-2+)
		usbdux_firmware.bin
		usbduxfast_firmware.bin
		usbduxsigma_firmware.bin
		# brcmfmac (GPL-2+)
		brcm/brcmfmac4330-sdio.Prowise-PT301.txt
		brcm/brcmfmac43340-sdio.meegopad-t08.txt
		brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt
		brcm/brcmfmac43362-sdio.lemaker,bananapro.txt
		brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt
		brcm/brcmfmac43430a0-sdio.ONDA-V80 PLUS.txt
		brcm/brcmfmac43430-sdio.AP6212.txt
		brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt
		brcm/brcmfmac43430-sdio.MUR1DX.txt
		brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt
		brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt
		brcm/brcmfmac4356-pcie.gpd-win-pocket.txt
		# isci (GPL-2)
		isci/isci_firmware.bin
		# carl9170 (GPL-2+)
		carl9170-1.fw
		# atusb (GPL-2+)
		atusb/atusb-0.2.dfu
		atusb/atusb-0.3.dfu
		atusb/rzusb-0.3.bin
		# mlxsw_spectrum (dual BSD/GPL-2)
		mellanox/mlxsw_spectrum-13.1420.122.mfa2
		mellanox/mlxsw_spectrum-13.1530.152.mfa2
		mellanox/mlxsw_spectrum-13.1620.192.mfa2
		mellanox/mlxsw_spectrum-13.1702.6.mfa2
		mellanox/mlxsw_spectrum-13.1703.4.mfa2
		mellanox/mlxsw_spectrum-13.1910.622.mfa2
		mellanox/mlxsw_spectrum-13.2000.1122.mfa2
	)

	# blacklist of images with unknown license
	local unknown_license=(
		atmsar11.fw
		korg/k1212.dsp
		ess/maestro3_assp_kernel.fw
		ess/maestro3_assp_minisrc.fw
		yamaha/ds1_ctrl.fw
		yamaha/ds1_dsp.fw
		yamaha/ds1e_ctrl.fw
		tr_smctr.bin
		ttusb-budget/dspbootcode.bin
		emi62/bitstream.fw
		emi62/loader.fw
		emi62/midi.fw
		emi62/spdif.fw
		ti_3410.fw
		ti_5052.fw
		mts_mt9234mu.fw
		mts_mt9234zba.fw
		whiteheat.fw
		whiteheat_loader.fw
		intelliport2.bin
		cpia2/stv0672_vp4.bin
		vicam/firmware.fw
		edgeport/boot.fw
		edgeport/boot2.fw
		edgeport/down.fw
		edgeport/down2.fw
		edgeport/down3.bin
		sb16/mulaw_main.csp
		sb16/alaw_main.csp
		sb16/ima_adpcm_init.csp
		sb16/ima_adpcm_playback.csp
		sb16/ima_adpcm_capture.csp
		sun/cassini.bin
		acenic/tg1.bin
		acenic/tg2.bin
		adaptec/starfire_rx.bin
		adaptec/starfire_tx.bin
		yam/1200.bin
		yam/9600.bin
		3com/3C359.bin
		ositech/Xilinx7OD.bin
		qlogic/isp1000.bin
		myricom/lanai.bin
		yamaha/yss225_registers.bin
		lgs8g75.fw
	)

	default

	# remove sources and documentation (wildcards are expanded)
	rm -r ${source_files[@]} || die

	if use !unknown-license; then
		# remove files in the unknown_license blacklist
		rm "${unknown_license[@]}" || die
	fi

	if use !redistributable; then
		# remove files _not_ in the free_software whitelist
		local file remove=()
		while IFS= read -d "" -r file; do
			has "${file#./}" "${free_software[@]}" || remove+=("${file}")
		done < <(find * ! -type d -print0 || die)
		printf "%s\0" "${remove[@]}" | xargs -0 rm || die
	fi

	echo "# Remove files that shall not be installed from this list." > ${PN}.conf
	find * ! -type d ! -name ${PN}.conf >> ${PN}.conf

	if use savedconfig; then
		restore_config ${PN}.conf

		local file preserved_files=() remove=()

		while IFS= read -r file; do
			# Ignore comments.
			if [[ ${file} != "#"* ]]; then
				preserved_files+=("${file}")
			fi
		done < ${PN}.conf || die

		while IFS= read -d "" -r file; do
			has "${file}" "${preserved_files[@]}" || remove+=("${file}")
		done < <(find * ! -type d ! -name ${PN}.conf -print0 || die)
		printf "%s\0" "${remove[@]}" | xargs -0 --no-run-if-empty rm || die
	fi

	# remove empty directories, bug #396073
	find -type d -empty -delete || die
}

src_install() {
	if use !savedconfig; then
		save_config ${PN}.conf
	fi
	rm ${PN}.conf || die
	insinto /lib/firmware/
	doins -r *
}

pkg_preinst() {
	if use savedconfig; then
		ewarn "USE=savedconfig is active. You must handle file collisions manually."
	fi
}

pkg_postinst() {
	elog "If you are only interested in particular firmware files, edit the saved"
	elog "configfile and remove those that you do not want."

	local ver
	for ver in ${REPLACING_VERSIONS}; do
		if ver_test ${ver} -lt 20190514; then
			elog
			elog 'Starting with version 20190514, installation of many firmware'
			elog 'files is controlled by USE flags. Please review your USE flag'
			elog 'and package.license settings if you are missing some files.'
			break
		fi
	done
}
