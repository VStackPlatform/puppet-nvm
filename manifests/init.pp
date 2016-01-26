class nvm (
  $users    = [],
  $version  = 'v0.25.4'
) {

  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present,
    }
  }

  each ($users) |$user| {
    $home = $user ? {
      root    => "/root",
      default => "/home/${user}"
    }
    $path = "${home}/.nvm"

    exec{ "nvm_install_${user}":
      command => "/usr/bin/curl -o- https://raw.githubusercontent.com/creationix/nvm/${version}/install.sh | NVM_DIR=${path} bash",
      creates => "${path}/nvm.sh",
      unless => "/usr/bin/test -e ${path}/nvm.sh",
      environment => [ "HOME=${home}" ],
      user => $user
    }

  }
}