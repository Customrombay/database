# Customrombay database
A repository for syncing data with custom ROMs' creators. It includes files for hundreds of devices and scripts for synchronizing the data with upstream repositories.

## State of scripts for synchronizing with different custom ROMs' creators:
**<span style="color:lime">[✓]</span>** LineageOS - conflicts fixed [here](https://github.com/LineageOS/lineage_wiki/commit/97360174e8eab338d7b848db4b626ef0ce8cd72e), using the mainstream [device directory](https://github.com/LineageOS/lineage_wiki/tree/master/_data/devices), 437/437 devices supported \
**<span style="color:lime">[✓]</span>** PixelExperience - using the mainstream [devices.json file](https://github.com/PixelExperience/official_devices/blob/master/devices.json), 142/142 devices supported \
**<span style="color:lime">[✓]</span>** ArrowOS - using the mainstream [arrow_ota.json file](https://github.com/ArrowOS/arrow_ota/blob/master/arrow_ota.json), no support for checking if a device is discontinued found, 90/90 devices supported \
**<span style="color:lime">[✓]</span>** EvolutionX - using the mainstream [devices.json file](https://github.com/Evolution-X-Devices/official_devices/blob/master/devices.json), 69/69 devices supported \
**<span style="color:lime">[✓]</span>** PixelOS - using the mainstream [devices.json file](https://github.com/PixelOS-AOSP/official_devices/blob/thirteen/API/devices.json), 45/45 devices supported \
**<span style="color:lime">[✓]</span>** PixysOS - using the mainstream [devices.json file](https://github.com/PixysOS/official_devices/blob/master/devices.json), 28/28 devices supported \
**<span style="color:lime">[✓]</span>** SuperiorOS - using files from the [official_devices](https://github.com/SuperiorOS-Devices/official_devices) and [official_devices-gapps](https://github.com/SuperiorOS-Devices/official_devices-gapps) repositories, 29/29 devices supported \
**<span style="color:yellow">[/]</span>** crDroid - using a [mainstream file from the official website](https://crdroid.net/devices_handler/compiled.json), an [important issue](https://github.com/crdroidandroid/crdroid.net/issues/10) ignored by the authors, 159/171 devices supported \
**<span style="color:yellow">[/]</span>** HavocOS - using a local copy of the [OTA repository](https://github.com/Havoc-OS/OTA) due to an issue in a JSON file, [fix requested](https://github.com/Havoc-OS/OTA/pull/12), 88/107 devices supported \
**<span style="color:yellow">[/]</span>** CorvusOS - using a local copy of the [devices.json file](https://github.com/CorvusRom-Devices/jenkins/blob/main/devices.json) due to duplicate declarations, [fixes requested](https://github.com/CorvusRom-Devices/jenkins/pull/45), 47/52 devices supported \
**<span style="color:yellow">[/]</span>** xiaomi.eu - using the [official MIUI 14 STABLE RELEASE thread](https://xiaomi.eu/community/threads/miui-14-stable-release.67685/), no support for automation, 84/132 devices supported \
**<span style="color:orange">[\\]</span>** /e/OS - using a local copy of the [devices directory](https://gitlab.e.foundation/e/documentation/user/-/tree/master/htdocs/_data/devices) due to duplicate declarations, 252/270 devices supported \
**<span style="color:red">[-]</span>** GrapheneOS - no parsable file found, devices added manually and not synced \
**<span style="color:red">[-]</span>** AwakenOS - no parsable file found, devices added manually and not synced
## State of scripts for synchronizing with custom recoveries:
**<span style="color:yellow">[/]</span>** TWRP - using the [twrpme repository](https://github.com/TeamWin/twrpme), 311/827 devices supported \
**<span style="color:yellow">[/]</span>** OrangeFox - using the [official API](https://api.orangefox.download/v3/devices/), 87/142 devices supported
