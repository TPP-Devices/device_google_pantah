#
# Copyright (C) 2021 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Restrict the visibility of Android.bp files to improve build analysis time
$(call inherit-product-if-exists, vendor/google/products/sources_pixel.mk)

ifdef RELEASE_GOOGLE_PANTHER_RADIO_DIR
RELEASE_GOOGLE_PRODUCT_RADIO_DIR := $(RELEASE_GOOGLE_PANTHER_RADIO_DIR)
endif
RELEASE_GOOGLE_BOOTLOADER_PANTHER_DIR ?= pdk# Keep this for pdk TODO: b/327119000
RELEASE_GOOGLE_PRODUCT_BOOTLOADER_DIR := bootloader/$(RELEASE_GOOGLE_BOOTLOADER_PANTHER_DIR)
$(call soong_config_set,pantah_bootloader,prebuilt_dir,$(RELEASE_GOOGLE_BOOTLOADER_PANTHER_DIR))
ifneq ($(filter trunk%, $(RELEASE_GOOGLE_BOOTLOADER_PANTHER_DIR)),)
$(call soong_config_set,pantah_fingerprint,prebuilt_dir,trunk)
else
$(call soong_config_set,pantah_fingerprint,prebuilt_dir,$(RELEASE_GOOGLE_BOOTLOADER_PANTHER_DIR))
endif

TARGET_KERNEL_DIR := device/google/pantah-kernels/6.1/25Q1-13202328
TARGET_BOARD_KERNEL_HEADERS := device/google/pantah-kernels/6.1/25Q1-13202328/kernel-headers
TARGET_PREBUILT_KERNEL := device/google/pantah-kernels/6.1/25Q1-13202328/Image.lz4

$(call inherit-product-if-exists, vendor/google_devices/pantah/prebuilts/device-vendor-panther.mk)
$(call inherit-product-if-exists, vendor/google_devices/gs201/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/gs201/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/pantah/proprietary/panther/device-vendor-panther.mk)
$(call inherit-product-if-exists, vendor/google_devices/panther/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/pantah/proprietary/WallpapersPanther.mk)

DEVICE_PACKAGE_OVERLAYS += device/google/pantah/panther/overlay

include device/google/pantah/audio/panther/audio-tables.mk
include device/google/gs201/device-shipping-common.mk
include device/google/gs-common/bcmbt/bluetooth.mk
include device/google/gs-common/touch/focaltech/focaltech.mk

# go/lyric-soong-variables
$(call soong_config_set,lyric,camera_hardware,panther)
$(call soong_config_set,lyric,tuning_product,panther)
$(call soong_config_set,google3a_config,target_device,panther)

# Init files
PRODUCT_COPY_FILES += \
	device/google/pantah/conf/init.pantah.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.pantah.rc \
	device/google/pantah/conf/init.panther.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.panther.rc

# Recovery files
PRODUCT_COPY_FILES += \
        device/google/pantah/conf/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.panther.rc

# insmod files. Kernel 5.10 prebuilts don't provide these yet, so provide our
# own copy if they're not in the prebuilts.
# TODO(b/369686096): drop this when 5.10 is gone.
ifeq ($(wildcard $(TARGET_KERNEL_DIR)/init.insmod.*.cfg),)
PRODUCT_COPY_FILES += \
	device/google/pantah/init.insmod.panther.cfg:$(TARGET_COPY_OUT_VENDOR_DLKM)/etc/init.insmod.panther.cfg
endif

# MIPI Coex Configs
PRODUCT_COPY_FILES += \
    device/google/pantah/panther/radio/panther_display_primary_mipi_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/display_primary_mipi_coex_table.csv \
    device/google/pantah/panther/radio/panther_camera_front_mipi_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/camera_front_mipi_coex_table.csv \
    device/google/pantah/panther/radio/panther_camera_rear_wide_mipi_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/camera_rear_wide_mipi_coex_table.csv \
    device/google/pantah/panther/radio/panther_camera_front_dbr_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/camera_front_dbr_coex_table.csv

# Camera
PRODUCT_COPY_FILES += \
	device/google/pantah/media_profiles_panther.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Media Performance Class 13
PRODUCT_PROPERTY_OVERRIDES += ro.odm.build.media_performance_class=33

# Display Config
PRODUCT_COPY_FILES += \
        device/google/pantah/panther/display_colordata_dev_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_dev_cal0.pb \
        device/google/pantah/panther/display_golden_sdc-s6e3fc3-p10_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_sdc-s6e3fc3-p10_cal0.pb

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

#config of primary display frames to reach LHBM peak brightness
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.primarydisplay.lhbm.frames_to_reach_peak_brightness=2

# NFC
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	device/google/pantah/nfc/libnfc-hal-st-proto1.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st-proto1.conf \
	device/google/pantah/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
    device/google/pantah/nfc/libnfc-nci-panther.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += \
	$(RELEASE_PACKAGE_NFC_STACK) \
	Tag \
	android.hardware.nfc-service.st \
	NfcOverlayPanther

# Shared Modem Platform
SHARED_MODEM_PLATFORM_VENDOR := lassen

# Shared Modem Platform
include device/google/gs-common/modem/modem_svc_sit/shared_modem_platform.mk

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element@1.2-service-gto \
	android.hardware.secure_element@1.2-service-gto-ese2

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
	frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
	device/google/pantah/nfc/libse-gto-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal.conf \
	device/google/pantah/nfc/libse-gto-hal2.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal2.conf

DEVICE_MANIFEST_FILE += \
	device/google/pantah/nfc/manifest_se.xml

# Thermal Config
PRODUCT_COPY_FILES += \
	device/google/pantah/thermal_info_config_panther.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json \
	device/google/pantah/thermal_info_config_charge_panther.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_charge.json \
	device/google/pantah/thermal_info_config_proto.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_proto.json

# Power HAL config
PRODUCT_COPY_FILES += \
	device/google/pantah/powerhint-panther.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json
PRODUCT_COPY_FILES += \
	device/google/pantah/powerhint-panther-a0.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint-a0.json

# Spatial Audio
PRODUCT_PACKAGES += \
	libspatialaudio

# Bluetooth HAL
PRODUCT_COPY_FILES += \
	device/google/pantah/bluetooth/bt_vendor_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor_overlay.conf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.a2dp_offload.supported=true \
    persist.bluetooth.a2dp_offload.disabled=false \
    persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac-opus

# Enable Bluetooth AutoOn feature
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.server.automatic_turn_on=true

# Bluetooth hci_inject test tool
PRODUCT_PACKAGES_ENG += \
    hci_inject

# Bluetooth OPUS codec
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.opus.enabled=true

# Bluetooth Tx power caps
PRODUCT_COPY_FILES += \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits.csv \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther_G03Z5_JP.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_G03Z5_JP.csv \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther_GVU6C_CA.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GVU6C_CA.csv \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther_GQML3_EU.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GQML3_EU.csv \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther_GVU6C_EU.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GVU6C_EU.csv \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther_GQML3_US.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GQML3_US.csv \
    device/google/pantah/bluetooth/bluetooth_power_limits_panther_GVU6C_US.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GVU6C_US.csv

# Bluetooth SAR test tool
PRODUCT_PACKAGES_ENG += \
    sar_test
# default BDADDR for EVB only
PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.bluetooth.evb_bdaddr="22:22:22:33:44:55"

# Bluetooth LE Audio
PRODUCT_PRODUCT_PROPERTIES += \
    ro.bluetooth.leaudio_offload.supported=true \
    persist.bluetooth.leaudio_offload.disabled=false \
    ro.bluetooth.leaudio_switcher.supported=true \
    bluetooth.profile.bap.unicast.client.enabled?=true \
    bluetooth.profile.csip.set_coordinator.enabled?=true \
    bluetooth.profile.hap.client.enabled?=true \
    bluetooth.profile.mcp.server.enabled?=true \
    bluetooth.profile.ccp.server.enabled?=true \
    bluetooth.profile.vcp.controller.enabled?=true \

# Bluetooth LE Audio CIS handover to SCO
# Set the property only if the controller doesn't support CIS and SCO
# simultaneously. More details in b/242908683.
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.leaudio.notify.idle.during.call=true

# BT controller not able to support LE Audio dual mic SWB call
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.leaudio.dual_bidirection_swb.supported=false

# LE Auido Offload Capabilities setting
PRODUCT_COPY_FILES += \
    device/google/pantah/bluetooth/le_audio_codec_capabilities.xml:$(TARGET_COPY_OUT_VENDOR)/etc/le_audio_codec_capabilities.xml

# LE Audio Unicast Allowlist
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.leaudio.allow_list=SM-R510,WF-1000XM5,SM-R630

# Support LE & Classic concurrent encryption (b/330704060)
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.ble.allow_enc_with_bredr=true

# Bluetooth EWP test tool
PRODUCT_PACKAGES_ENG += \
    ewp_tool

PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.firmware.selection=BCM.hcd

# Bluetooth AAC VBR
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.a2dp_aac.vbr_supported=true

# Override BQR mask to enable LE Audio Choppy report, remove BTRT logging
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.bqr.event_mask=262238
else
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.bqr.event_mask=94
endif

# declare use of spatial audio
PRODUCT_PROPERTY_OVERRIDES += \
       ro.audio.spatializer_enabled=true

# optimize spatializer effect
PRODUCT_PROPERTY_OVERRIDES += \
       audio.spatializer.effect.util_clamp_min=300

# Keymaster HAL
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# Gatekeeper HAL
#LOCAL_GATEKEEPER_PRODUCT_PACKAGE ?= android.hardware.gatekeeper@1.0-service.software


# Gatekeeper
# PRODUCT_PACKAGES += \
# 	android.hardware.gatekeeper@1.0-service.software

# Keymint replaces Keymaster
# PRODUCT_PACKAGES += \
# 	android.hardware.security.keymint-service

# Keymaster
#PRODUCT_PACKAGES += \
#	android.hardware.keymaster@4.0-impl \
#	android.hardware.keymaster@4.0-service

#PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.remote
#PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.remote
#LOCAL_KEYMASTER_PRODUCT_PACKAGE := android.hardware.keymaster@4.1-service
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# PRODUCT_PROPERTY_OVERRIDES += \
# 	ro.hardware.keystore_desede=true \
# 	ro.hardware.keystore=software \
# 	ro.hardware.gatekeeper=software

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/pantah/powerstats/panther \
    device/google/pantah

# Fingerprint HAL
GOODIX_CONFIG_BUILD_VERSION := g7_trusty
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_common.mk)
ifeq ($(filter factory%, $(TARGET_PRODUCT)),)
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_shipping.mk)
else
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_factory.mk)
endif

# Display
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_idle_timer_ms=1500
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.ignore_hdr_camera_layers=true

# WiFi Overlay
PRODUCT_PACKAGES += \
    WifiOverlay2022_P10

PRODUCT_SOONG_NAMESPACES += device/google/pantah/panther/

# Trusty liboemcrypto.so
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/pantah/prebuilts

# Location
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        device/google/pantah/location/lhd.conf.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/lhd.conf \
        device/google/pantah/location/scd.conf.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/scd.conf
    ifneq (,$(filter 6.1, $(TARGET_LINUX_KERNEL_VERSION)))
        PRODUCT_COPY_FILES += \
            device/google/pantah/location/gps.6.1.xml.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    else
        PRODUCT_COPY_FILES += \
            device/google/pantah/location/gps.xml.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    endif
else
    PRODUCT_COPY_FILES += \
        device/google/pantah/location/lhd_user.conf.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/lhd.conf \
        device/google/pantah/location/scd_user.conf.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/scd.conf
    ifneq (,$(filter 6.1, $(TARGET_LINUX_KERNEL_VERSION)))
        PRODUCT_COPY_FILES += \
            device/google/pantah/location/gps_user.6.1.xml.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    else
        PRODUCT_COPY_FILES += \
            device/google/pantah/location/gps_user.xml.p10:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    endif
endif

# Set support one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Set zram size
PRODUCT_VENDOR_PROPERTIES += \
	vendor.zram.size=3g

# Increment the SVN for any official public releases
ifdef RELEASE_SVN_PANTHER
TARGET_SVN ?= $(RELEASE_SVN_PANTHER)
else
# Set this for older releases that don't use build flag
TARGET_SVN ?= 61
endif

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.build.svn=$(TARGET_SVN)

# Set device family property for SMR
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.device_family=P10C10L10

# Set build properties for SMR builds
ifeq ($(RELEASE_IS_SMR), true)
    ifneq (,$(RELEASE_BASE_OS_PANTHER))
        PRODUCT_BASE_OS := $(RELEASE_BASE_OS_PANTHER)
    endif
endif

# Set build properties for EMR builds
ifeq ($(RELEASE_IS_EMR), true)
    ifneq (,$(RELEASE_BASE_OS_PANTHER))
        PRODUCT_PROPERTY_OVERRIDES += \
        ro.build.version.emergency_base_os=$(RELEASE_BASE_OS_PANTHER)
    endif
endif
# DCK properties based on target
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gms.dck.eligible_wcc=2 \
    ro.gms.dck.se_capability=1


# Set support hide display cutout feature
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_hide_display_cutout=true

PRODUCT_PACKAGES += \
    NoCutoutOverlay \
    AvoidAppsInCutoutOverlay

# SKU specific RROs
PRODUCT_PACKAGES += \
    SettingsOverlayG03Z5 \
    SettingsOverlayGQML3 \
    SettingsOverlayGVU6C \
    SettingsOverlayGVU6C_VN

# eng specific
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        device/google/gs201/init.hardware.wlc.rc.userdebug:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.wlc.rc
endif

# Fingerprint HAL
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.udfps.als_feed_forward_supported=true \
    persist.vendor.udfps.lhbm_controlled_in_hal_supported=true

# Vibrator HAL
$(call soong_config_set,haptics,kernel_ver,v$(subst .,_,$(TARGET_LINUX_KERNEL_VERSION)))
ACTUATOR_MODEL := luxshare_ict_081545
ADAPTIVE_HAPTICS_FEATURE := adaptive_haptics_v1
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.vibrator.hal.chirp.enabled=0 \
    ro.vendor.vibrator.hal.device.mass=0.195 \
    ro.vendor.vibrator.hal.loc.coeff=2.65 \
    persist.vendor.vibrator.hal.context.enable=false \
    persist.vendor.vibrator.hal.context.scale=60 \
    persist.vendor.vibrator.hal.context.fade=true \
    persist.vendor.vibrator.hal.context.cooldowntime=1600 \
    persist.vendor.vibrator.hal.context.settlingtime=5000

# Override Output Distortion Gain
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.hapticgenerator.distortion.output.gain=0.38

# Keyboard bottom padding in dp for portrait mode and height ratio
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_b=8 \
    ro.com.google.ime.height_ratio=1.075

# Enable camera exif model/make reporting
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.exif_reveal_make_model=true \
    persist.vendor.camera.front_720P_always_binning=true

# RKPD
PRODUCT_PRODUCT_PROPERTIES += \
    remote_provisioning.hostname=remoteprovisioning.googleapis.com \

##Audio Vendor property
PRODUCT_PROPERTY_OVERRIDES += \
	persist.vendor.audio.cca.enabled=false

# The default value of this variable is false and should only be set to true when
# the device allows users to enable the seamless transfer feature.
PRODUCT_PRODUCT_PROPERTIES += \
   euicc.seamless_transfer_enabled_in_non_qs=true

# Device features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Disable Settings large-screen optimization enabled by Window Extensions
PRODUCT_SYSTEM_PROPERTIES += \
    persist.settings.large_screen_opt.enabled=false

# Enable DeviceAsWebcam support
PRODUCT_VENDOR_PROPERTIES += \
    ro.usb.uvc.enabled=true

# Quick Start device-specific settings
PRODUCT_PRODUCT_PROPERTIES += \
    ro.quick_start.oem_id=00e0 \
    ro.quick_start.device_id=panther

# Bluetooth device id
# Panther: 0x4109
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.device_id.product_id=16649

# ETM
ifneq (,$(RELEASE_ETM_IN_USERDEBUG_ENG))
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
$(call inherit-product-if-exists, device/google/common/etm/device-userdebug-modules.mk)
endif
endif
