define nvm::npm::install(
  $cwd,
  $version    = $::nvm::node_version,
  $user,
  $production = false
) {
  $home = $user ? {
    root    => "/root",
    default => "/home/${user}"
  }
  $path = "${home}/.nvm"
  $command = "npm install"
  exec{ "npm_install_${version}_${cwd}":
    cwd         => $cwd,
    path        => flatten([$::path, "${path}/versions/node/v${version}/bin"]),
    command     => template('nvm/exec.erb'),
    environment => [ "HOME=${home}", "NVM_DIR=${path}" ],
    require     => Exec["nodejs_install_${version}_${user}"],
    user        => $user
  }
}