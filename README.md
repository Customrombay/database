# Customrombay database
A repository for syncing data with custom ROMs' creators. It includes files for hundreds of devices and scripts for synchronizing the data with upstream repositories.

## State of scripts for synchronizing with different custom ROMs' creators:
**<span style="color:lime">[✓]</span>** LineageOS - conflicts fixed [here](https://github.com/LineageOS/lineage_wiki/commit/97360174e8eab338d7b848db4b626ef0ce8cd72e), using the mainstream [device directory](https://github.com/LineageOS/lineage_wiki/tree/master/_data/devices), 402/402 devices supported \
**<span style="color:yellow">[/]</span>** EvolutionX - using the mainstream [devices.json file](https://github.com/Evolution-X-Devices/official_devices/blob/master/devices.json), 55/59 devices supported \
**<span style="color:yellow">[/]</span>** crDroid - using a [mainstream file from the official website](https://crdroid.net/devices_handler/compiled.json), an [important issue](https://github.com/crdroidandroid/crdroid.net/issues/10) ignored by the authors, 148/169 devices supported \
**<span style="color:yellow">[/]</span>** HavocOS - using a local copy of the [OTA repository](https://github.com/Havoc-OS/OTA) due to an issue in a JSON file, [fix requested](https://github.com/Havoc-OS/OTA/pull/12), 86/109 devices supported \
**<span style="color:yellow">[/]</span>** CorvusOS - using a local copy of the [devices.json file](https://github.com/CorvusRom-Devices/jenkins/blob/main/devices.json) due to duplicate declarations, [fixes requested](https://github.com/CorvusRom-Devices/jenkins/pull/45), 42/52 devices supported \
**<span style="color:yellow">[/]</span>** ArrowOS - using the mainstream [arrow_ota.json file](https://github.com/ArrowOS/arrow_ota/blob/master/arrow_ota.json), no support for checking if a device is discontinued found, 82/86 devices supported \
**<span style="color:orange">[\\]</span>** /e/OS - using a local copy of the [devices directory](https://gitlab.e.foundation/e/documentation/user/-/tree/master/htdocs/_data/devices) due to duplicate declarations, 252/270 devices supported \
**<span style="color:red">[-]</span>** PixelExperience - no syncing script, this will be fixed in the future \
**<span style="color:red">[-]</span>** GrapheneOS - no parsable file found, devices added manually and not synced \
**<span style="color:red">[-]</span>** AwakenOS - no parsable file found, devices added manually and not synced
