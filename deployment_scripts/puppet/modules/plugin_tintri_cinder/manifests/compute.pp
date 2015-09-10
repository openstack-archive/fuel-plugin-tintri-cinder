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

class plugin_tintri_cinder::compute {

    include nova::params

    if $::nova::params::compute_package_name {
      package { $::nova::params::compute_package_name:
        ensure => present,
      }
      Package[$::nova::params::compute_package_name] -> Nova_config<||>
    }

    $plugin_settings = $::fuel_settings['tintri_cinder']
    nova_config {
      'DEFAULT/nfs_mount_options': value => $plugin_settings['nfs_mount_options']
    }

    Nova_config<||> ~> Service[nova_compute]

    service { 'nova_compute':
      ensure     => running,
      name       => $::nova::params::compute_service_name,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
}
