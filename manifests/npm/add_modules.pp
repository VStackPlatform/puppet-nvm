define nvm::npm::add_modules (
  $node_version=$::nvm::npm::node_version,
  $users=$::nvm::npm::users,
  $modules
) {

  each ($users) |$user| {
    $home = $user ? {
      root    => "/root",
      default => "/home/${user}"
    }
    $path = "${home}/.nvm"
    each( $modules ) |$module| {
      exec{ "npm_install_${module}_${node_version}_${user}":
        path        => flatten([$::path, "${path}/versions/node/v${node_version}/bin"]),
        command     => "npm install -g ${module}",
        unless      => "${path}/versions/node/v${node_version}/bin/npm list -g ${module}",
        environment => [ "HOME=${home}", "NVM_DIR=${path}" ],
        require     => Exec["nodejs_default_${node_version}_${user}"],
        user        => $user
      }
    }
  }
}