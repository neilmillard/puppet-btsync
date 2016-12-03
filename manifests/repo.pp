# == Class: btsync::repo
#
#   Configure yeasoft repository for Debian or Ubuntu. See README.md for more
#   details.
#
# === Author
#
# Mickaël Canévet <mickael.canevet@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mickaël Canévet, unless otherwise noted.
#
class btsync::repo {
  case $::operatingsystem {
    Debian: {
      include ::apt
      apt::source { 'btsync':
        location          => 'http://debian.yeasoft.net/btsync',
        release           => $::lsbdistcodename,
        repos             => 'main contrib non-free',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => '6BF18B15',
        key_server        => 'pgp.mit.edu',
        include_src       => true,
      }
    }
    'Ubuntu': {
      include ::apt
      apt::ppa { 'ppa:tuxpoldo/btsync': }
    }
    'Centos','Amazon': {
      # https://www.resilio.com/blog/official-linux-packages-for-sync-now-available
      yumrepo {'btsync':
        enabled => 1,
        descr   => 'BitTorrent Sync $basearch',
        baseurl => 'http://linux-packages.getsync.com/btsync/rpm/$basearch',
        gpgcheck => 0,
      }
    }
    default: {
      fail "Unsupported Operating System: ${::operatingsystem}"
    }
  }
  Class['btsync::repo'] -> Class['btsync::install']
}
