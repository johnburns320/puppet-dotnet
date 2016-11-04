#
define dotnet::install::package(
  $ensure = 'present',
  $version = '',
  $package_dir = ''
) {

  include ::dotnet::params

  $url = $dotnet::params::version[$version]['url']
  $exe = $dotnet::params::version[$version]['exe']
  $key = $dotnet::params::version[$version]['key']


  if "x${package_dir}x" == 'xx' {
    $source_dir = 'C:\Windows\Temp'
    if $ensure == 'present' {
      download_file { "download-dotnet-${version}" :
        url                   => $url,
        destination_directory => $source_dir,
      }
    } else {
      file { "C:/Windows/Temp/${exe}":
        ensure => 'absent',
      }
    }
  } else {
    $source_dir = $package_dir
  }

  package { "Microsoft .NET Framework ${version}":
    ensure          => $ensure,
    source          => "${source_dir}\\${exe}",
    install_options => [ '/q', '/norestart' ],
  }
}
