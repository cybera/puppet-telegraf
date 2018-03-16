# == Class: telegraf::install
#
# Conditionally handle InfluxData's official repos and install the necessary
# Telegraf package.
#
class telegraf::install {

  assert_private()

  $_operatingsystem = downcase($::operatingsystem)

  if $::telegraf::manage_repo {
    case $::osfamily {
      'Debian': {
        if $::telegraf::package_source == undef {
          $real_package_source = "https://dl.influxdata.com/telegraf/releases/telegraf_${::telegraf::version}-1_amd64.deb"
        } else {
          $real_pacakage_source = $::telegraf::package_source
        }

        wget::fetch { 'telegraf':
          source      => $real_package_source,
          destination => '/tmp/telegraf.deb',
        }

        package { 'telegraf':
          ensure   => latest,
          provider => 'dpkg',
          source   => '/tmp/telegraf.deb',
          require  => Wget::Fetch['telegraf'],
          notify   => Service['telegraf'],
        }

      }
    }
  }

  # Redhat, Windows stuff removed because it wasn't even remotely tested on our changes

}
