#!/bin/sh

progname=${0##*/}

initialize()
{
  
  netbsd_src_ver=6.1.4
  netbsd_src_uri=ftp://ftp4.jp.netbsd.org/pub/NetBSD/NetBSD-${netbsd_src_ver}/source/sets/
  pkgsrc_uri=ftp://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc.tar.gz

  pkgsrc_dir=/usr/pkgsrc
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
defaultroute=${defaultroute}
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
fail2ban=yes

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
  ftp -i ${netbsd_src_uri} <<EOS
  mget *
EOS
}

pkg_get()
{
  cd /usr
  ftp -i ${pkgsrc_uri} <<EOS
  mget *
EOS
}

pkg_install()
{
  pkgs="
  converters/nkf
  devel/bmake
  devel/git
  editors/vim
  lang/ruby
  lang/python
  lang/perl5
  lang/go
  misc/lv
#  mail/quickml
#  mail/postfix
#  net/wget
  www/curl
  net/rsync
#  net/djbdns
#  net/djbdns-run
  pkgtools/url2pkg
  pkgtools/pkglint
  pkgtools/port2pkg
  pkgtools/pkg_chk
  shells/zsh
#  security/py-denyhosts/
  security/sudo
#  www/apache24
#  security/fail2ban
  misc/gnuls
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

usage()
{
  cat << _usage_
Usage: ${progname} operation [...]

operations:
  user_add          Run useradd
  rc_conf           Create /etc/rc.conf
  rc_ifconfig       Create /etc/rc.ifconfig
  rc_resolv_conf    Create /etc/resolv.conf
  src_get           Download NetBSD src
  pkg_get           Download pkgsrc
  pkg_install       Install pkgsrc
  rubygems_install  Install rubygems
_usage_
  exit 1
}

main()
{
  initialize $@
  
  for op in $@; do
    case "${op}" in
    user_add)
      user_add $@
      ;;
    
    rc_conf)
      rc_conf $@
      ;;

    rc_ifconfig)
      rc_ifconfig $@
      ;;

    rc_resolv_conf)
      rc_resolv_conf $@
      ;;
      
    src_get)
      src_get $@
      ;;
      
    pkg_get)
      pkg_get $@
      ;;

    pkg_install)
      pkg_install $@
      ;;
      
    rubygems_install)
      rubygems_install $@
      ;;

    *)
      usage
      ;;
      
    esac
  done
}

main $@

