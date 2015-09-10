# Copyright (c) 2015 Tintri.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

class plugin_tintri_cinder::controller {

    include cinder::params

    case $::osfamily {
      'Debian': {
        package { 'nfs-common': }
      }
      'RedHat': {
        package { 'nfs-utils': } ->
        service {'rpcbind':
          ensure => running,
        } ->
        service {'rpcidmapd':
          ensure => running,
        } ->
        service {'nfs':
          ensure => running,
        }
      }
      default: {}
    }

    if $::cinder::params::volume_package {
      package { $::cinder::params::volume_package:
        ensure => present,
      }
      Package[$::cinder::params::volume_package] -> Cinder_config<||>
    }

    $plugin_settings = $::fuel_settings["tintri_cinder"]

    $section = 'tintri'
    cinder_config {
      "DEFAULT/enabled_backends": value => "${section}";
      "${section}/volume_driver": value => 'cinder.volume.drivers.tintri.TintriDriver';
      "${section}/tintri_server_hostname": value => $plugin_settings['tintri_server_hostname'];
      "${section}/tintri_server_username": value => $plugin_settings['tintri_server_username'];
      "${section}/tintri_server_password": value => $plugin_settings['tintri_server_password'];
      "${section}/tintri_api_version": value => $plugin_settings['tintri_api_version'];
      "${section}/nfs_mount_options": value => $plugin_settings['nfs_mount_options'];
      "${section}/nfs_shares_config": value => $plugin_settings['nfs_shares_config'];
    }

    $shares = $plugin_settings['nfs_mounts']  # Set for template
    file { 'nfs_shares':
      path    => $plugin_settings['nfs_shares_config'],
      content => template('plugin_tintri_cinder/nfs_shares'),
      owner   => cinder,
      mode    => '0600',
    }

    Cinder_config<||> ~> Service[cinder_volume]
    File[nfs_shares] ~> Service[cinder_volume]

    service { 'cinder_volume':
      ensure     => running,
      name       => $::cinder::params::volume_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

}
