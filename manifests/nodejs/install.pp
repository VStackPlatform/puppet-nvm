define nvm::nodejs::install(
  $version,
  $set_default = false,
  $users = $::nvm::users
) {

  each ($users) |$user| {
    $home = $user ? {
      root    => "/root",
      default => "/home/${user}"
    }
    $path = "${home}/.nvm"

    exec{ "nodejs_install_${version}_${user}":
      command     => ". ${path}/nvm.sh && nvm install ${version}",
      cwd         => $home,
      provider    => shell,
      unless      => "/usr/bin/test -e ${path}/versions/node/v${version}/bin/node",
      environment => [ "HOME=${home}", "NVM_DIR=${path}" ],
      user        => $user,
      require     => Exec["nvm_install_${user}"]
    }

    if $set_default {
      # Set it as the default version.
      exec{ "nodejs_default_${version}_${user}":
        command     => ". ${path}/nvm.sh && nvm alias default ${version}",
        cwd         => $home,
        provider    => shell,
        unless      => "/usr/bin/test -e ${path}/alias/default",
        environment => [ "HOME=${home}", "NVM_DIR=${path}" ],
        user        => 'root',
        require => Exec["nodejs_install_${version}_${user}"]
      }
    }
  }
}