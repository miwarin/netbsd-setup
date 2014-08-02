

PREFIX= test
#PREFIX=

# system
NETBSD_SRC_DIR= ${PREFIX}/usr
NETBSD_TAG= netbsd-6-0-RELEASE

# config file
MAKECONF=${PREFIX}/etc/mk.conf
RCCONF=${PREFIX}/etc/rc.conf
IFCONF=${PREFIX}/etc/ifconfig.wm0
RESOLVCONF=${PREFIX}/etc/resolv.conf


# network
HOSTNAME= madoka
DOMAIN= example.jp
NAMESERVER= 192.168.0.1
IP_ADDR= 192.168.0.10
#EXT_IF= wm0

# user
USER= user


# pkgsrc
PKGSRC_DIR= ${PREFIX}/usr/pkgsrc
PKGSRC_TAG= 2012Q4

_PACKAGES=   converters/nkf  devel/bmake  devel/mercurial  devel/subversion  devel/scmgit
_PACKAGES+=  editors/vim
_PACKAGES+=  lang/ruby193-base  lang/python33  lang/perl5
_PACKAGES+=  misc/lv  misc/rubygems  misc/screen
_PACKAGES+=  mail/quickml  mail/postfix
_PACKAGES+=  net/wget  net/rsync  net/djbdns
_PACKAGES+=  pkgtools/url2pkg  pkgtools/pkglint  pkgtools/port2pkg  pkgtools/pkg_chk
_PACKAGES+=  shells/zsh security/sudo
_PACKAGES+=  www/apache24  www/w3m


# ruby gems
_RUBY_GEMS=   activesupport  domain_name  i18n
_RUBY_GEMS+=  mail  mechanize  mime-types  minitest  multi_json
_RUBY_GEMS+=  net-http-digest_auth  net-http-persistent  nokogiri  ntlm-http
_RUBY_GEMS+=  polyglot  rake  rdoc  redcarpet
_RUBY_GEMS+=  treetop  twitter-text  unf  unf_ext  webrobots  yajl-ruby


# build targets
TARGETS=
TARGETS+= user_add
TARGETS+= rc_conf rc_mkconf rc_ifconfig rc_resolvconf
TARGETS+= src_get
TARGETS+= pkg_get pkg_install
#TARGETS+= rubygems_install


all: ${TARGETS}


user_add:
	useradd -m ${USER}


rc_conf:
	@echo wscons=yes >> ${RCCONF}
	@echo defaultroute=192.168.0.1 >> ${RCCONF}
	@echo hostname=${hostname}.${domain} >> ${RCCONF}
	@echo sshd=yes >> ${RCCONF}
	@echo apache=yes >> ${RCCONF}
	@echo apache_start=start >> ${RCCONF}
	@echo postfix=no >> ${RCCONF}
	@echo quickml=no >> ${RCCONF}
	@echo ntpd=no >> ${RCCONF}
	@echo ntpdate=yes >> ${RCCONF}
	@echo tinydns=no >> ${RCCONF}
	@echo tinydns_ip=${ip_addr} >> ${RCCONF}
	@echo axfrdns=no >> ${RCCONF}
	@echo dnscache=no >> ${RCCONF}
	@echo rbldns=no >> ${RCCONF}
	@echo pf=no >> ${RCCONF}
	@echo pflogd=no >> ${RCCONF}
	@echo smbd=no >> ${RCCONF}
	@echo nmbd=no >> ${RCCONF}
	@echo winbindd=no >> ${RCCONF}
	@echo samba=no >> ${RCCONF}
	@echo munin_node=no >> ${RCCONF}
	@echo denyhosts=no >> ${RCCONF}


rc_ifconfig:
	@echo up > ${IFCONF}
	@echo ${IP_ADDR} netmask 255.255.255.0 media autoselect >> ${IFCONF}


rc_resolvconf:
	@echo ameserver ${NAMESERVER} > ${RESOLVCONF}


rc_mkconf:
	@echo # Japan > ${MAKECONF}
	@echo # >> ${MAKECONF}
	@echo MASTER_SITE_CYGWIN=    ftp://ftp.dnsbalance.ring.gr.jp/archives/pc/gnu-win32/ >> ${MAKECONF}
	@echo MASTER_SITE_GNOME=     ftp://ftp.dnsbalance.ring.gr.jp/pub/X/gnome/ >> ${MAKECONF}
	@echo MASTER_SITE_GNU=       ftp://ftp.dnsbalance.ring.gr.jp/pub/GNU/ >> ${MAKECONF}
	@echo MASTER_SITE_MOZILLA=   ftp://ftp.dnsbalance.ring.gr.jp/pub/net/www/mozilla/ >> ${MAKECONF}
	@echo MASTER_SITE_PERL_CPAN= ftp://ftp.dnsbalance.ring.gr.jp/pub/lang/perl/CPAN/modules/by-module/ >> ${MAKECONF}
	@echo MASTER_SITE_OPENOFFICE=ftp://ftp.kddlabs.co.jp/office/openoffice/ \ >> ${MAKECONF}
	@echo                        ftp://ftp.dnsbalance.ring.gr.jp/pub/misc/openoffice/ >> ${MAKECONF}
	@echo MASTER_SITE_TEX_CTAN=  ftp://ftp.dnsbalance.ring.gr.jp/pub/text/CTAN/ >> ${MAKECONF}
	@echo MASTER_SITE_SUSE=      \ >> ${MAKECONF}
	@echo        ftp://ftp.kddlabs.co.jp/Linux/packages/SuSE/suse/${MACHINE_ARCH}/${SUSE_VERSION}/suse/ >> ${MAKECONF}
	@echo MASTER_SITE_SUNSITE=   ftp://sunsite.sut.ac.jp/pub/archives/linux/sunsite-unc/ >> ${MAKECONF}
	@echo MASTER_SITE_XCONTRIB=  ftp://ftp.dnsbalance.ring.gr.jp/pub/X/opengroup/contrib/ >> ${MAKECONF}
	@echo MASTER_SITE_XEMACS=    ftp://ftp.jp.xemacs.org/pub/GNU/xemacs/ >> ${MAKECONF}
	@echo MASTER_SITE_BACKUP=    \ >> ${MAKECONF}
	@echo        ftp://ftp.dnsbalance.ring.gr.jp/pub/NetBSD/packages/distfiles/ \ >> ${MAKECONF}
	@echo        ftp://ftp.jp.NetBSD.org/pub/NetBSD/packages/distfiles/ >> ${MAKECONF}
	@echo  >> ${MAKECONF}
	@echo  >> ${MAKECONF}
	@echo  >> ${MAKECONF}
	@echo ACCEPTABLE_LICENSES= postfix-license >> ${MAKECONF}
	@echo ACCEPTABLE_LICENSES= vim-license >> ${MAKECONF}
	@echo ACCEPTABLE_LICENSES+= ruby-license >> ${MAKECONF}
	@echo #USE_X11=no >> ${MAKECONF}
	@echo PKG_OPTIONS.ImageMagick= -x11 -jasper >> ${MAKECONF}
	@echo ALLOW_VULNERABLE_PACKAGES= 1 >> ${MAKECONF}
	@echo PKG_DEVELOPER= yes >> ${MAKECONF}
	@echo #PKG_OPTIONS.quickml= limit analog >> ${MAKECONF}
	@echo  >> ${MAKECONF}
	@echo X11_TYPE=modular >> ${MAKECONF}


src_get:
	cd ${SRC_DIR} && \
	cvs -q -z2 -d anoncvs@anoncvs.NetBSD.org:/cvsroot checkout -r ${NETBSD_TAG} -P src
#	cvs checkout -r ${NETBSD_TAG} -P src
#  cvs checkout -P src


pkg_get:
	cd ${SRC_DIR} && \
	cvs -q -z2 -d anoncvs@anoncvs.NetBSD.org:/cvsroot checkout -r pkgsrc-${PKGSRC_TAG} -P pkgsrc
#  cvs checkout -P pkgsrc


pkg_install: pkg_get
.for p in ${_PACKAGES}
	cd ${PKGSRC_DIR}/${p} && \
	make update clean clean-depends
.endfor


rubygems_install: pkg_install
.for g in ${_RUBY_GEMS}
	gem193 install $g
.endfor

