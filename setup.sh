#!/bin/sh


initialize()
{
  export CVSROOT="anoncvs@anoncvs.NetBSD.org:/cvsroot"
  export CVS_RSH="ssh"
  pkgsrc_tag=2012Q4
  pkgsrc_dir=/usr/pkgsrc
  netbsd_tag=netbsd-6-0-RELEASE
  hostname=madoka
  domain=example.jp
  ip_addr=192.168.0.10
  ext_if=wm0
  user=oreore
  nameserver=192.168.0.1
  defaultroute=192.168.0.1
}


user_add()
{
  useradd -m ${user}
}


rc_conf()
{
cat << EOT >> /etc/rc.conf

wscons=yes
defaultroute=192.168.0.1
hostname=${hostname}.${domain}
sshd=yes
apache=yes
apache_start=start
postfix=no
quickml=no
ntpd=no
ntpdate=yes
tinydns=no
tinydns_ip=${ip_addr}
axfrdns=no
dnscache=no
rbldns=no
pf=no
pflogd=no
smbd=no
nmbd=no
winbindd=no
samba=no
munin_node=no
denyhosts=no

EOT

}


rc_ifconfig()
{
cat << EOT > /etc/ifconfig.${ext_if}
up
${ip_addr} netmask 255.255.255.0 media autoselect
EOT

}

rc_resolv_conf()
{
cat << EOT > /etc/resolv.conf
nameserver ${nameserver}

EOT

}

mk_conf()
{
cat << EOT > /etc/mk.conf
ACCEPTABLE_LICENSES= postfix-license
ACCEPTABLE_LICENSES= vim-license
ACCEPTABLE_LICENSES+= ruby-license
#USE_X11=no
PKG_OPTIONS.ImageMagick= -x11 -jasper
ALLOW_VULNERABLE_PACKAGES= 1
PKG_DEVELOPER= yes
#PKG_OPTIONS.quickml= limit analog
X11_TYPE=modular
EOT
}




src_get()
{
  cd /usr
  cvs checkout -r ${netbsd_tag} -P src
#  cvs checkout -P src
}

pkg_get()
{
  cd /usr
  cvs -q -z2 -d anoncvs@anoncvs.NetBSD.org:/cvsroot checkout -r pkgsrc-${pkgsrc_tag} -P pkgsrc
#  cvs checkout -P pkgsrc
}

pkg_install()
{
  pkgs="
  converters/nkf
  devel/bmake
  devel/mercurial
  devel/subversion
  devel/scmgit
  editors/vim
  lang/ruby193-base
  lang/python33
  lang/perl5
  misc/lv
  misc/rubygems
  misc/screen
  mail/quickml
  mail/postfix
  net/wget
  net/rsync
  net/djbdns
  pkgtools/url2pkg
  pkgtools/pkglint
  pkgtools/port2pkg
  pkgtools/pkg_chk
  shells/zsh
  security/sudo
  shells/zsh
  www/apache24
  "
  
  for p in $pkgs; do
    cd ${pkgsrc_dir}/${p} && make update clean clean-depends
  done
}


rubygems_install()
{

  gems="
  activesupport
  domain_name
  i18n
  mail
  mechanize
  mime-types
  minitest
  multi_json
  net-http-digest_auth
  net-http-persistent
  nokogiri
  ntlm-http
  polyglot
  rake
  rdoc
  redcarpet
  treetop
  twitter-text
  unf
  unf_ext
  webrobots
  yajl-ruby
  "
  
  for g in $gems; do
    gems193 install $g
  done
  
}


main()
{
  initialize $@
  user_add $@
  rc_conf $@
  rc_ifconfig $@
  rc_resolv_conf $@
  src_get $@
  pkg_get $@
  pkg_install $@
  rubygems_install $@
}


main $@

