# coding: utf-8

require 'pit'
config = Pit.get('netbsd', :require => {
    :username => 'your username',
    :server => 'your server address'
  })

set :application, 'netbsd'
server config[:server], :app
set :user, config[:username]

namespace :pkgsrc do
  task :checkout, :roles => :app do
    run 'export CVSROOT="anoncvs@anoncvs.NetBSD.org:/cvsroot"'
    run 'export CVS_RSH="ssh"'
    run 'cd /usr'
    run 'cvs checkout -P pkgsrc'
  end

  task :update, :roles => :app do
    run 'export CVSROOT="anoncvs@anoncvs.NetBSD.org:/cvsroot"'
    run 'export CVS_RSH="ssh"'
    run 'cd /usr/pkgsrc'
    run 'cvs update -dP'
  end
end

namespace :package do
  task: install, :roles => :app do
    pkgs = %w[
      converters/nkf
      devel/bmake
      devel/mercurial
      devel/subversion
      devel/scmgit
      editors/vim
      lang/ruby
      lang/python
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
      www/apache2
      www/w3m
    ]
    
    pkgs.each { |pkg|
      run "cd /usr/pkgsrc/#{pkg} && make install clean clean-depends"
    }
  end
end
