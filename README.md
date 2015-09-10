# fuel-plugin-tintri-cinder

The Tintri Cinder plugin simplifies configuration of Mirantis OpenStack for use
with Tintri VMstore.

This plugin adds Tintri specific settings to the Fuel UI.


## Requirements

| Requirement                                              | Version/Comment |
|----------------------------------------------------------|-----------------|
| Mirantis OpenStack compatibility                         | >= 6.1          |
| Tintri VMstore accessible on network                     |                 |

## Limitations

The Tintri Cinder plugin does not support Icehouse.

For Juno and Kilo, the driver is not included in Cinder and must be downloaded
from the Tintri support portal.

## Installation

### Build the RPM

If you do not have the plugin as an RPM, you will need to build it from source.

You will need to install fuel-plugin-builder: `pip install
fuel-plugin-builder`.  Now, in this directory run `fpb --build .` You should
see an newly created RPM.

### Install the plugin

Move the plugin RPM to the fuel master and install: `fuel plugins --install
tintri_cinder-*.rmp`

Use `fuel -plugins --list` to make sure that the Tintri Cinder plugin was
installed.


## Usage

After installation of the plugin, the next environment you create in Fuel
should have an additional section for Tintri configuration in the settings
section.
