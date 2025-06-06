#
# Copyright (C) 2020 The Android Open-Source Project
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

# Enable load module in parallel
BOARD_BOOTCONFIG += androidboot.load_modules_parallel=true

# The modules which need to be loaded in sequential
BOARD_KERNEL_CMDLINE += fips140.load_sequential=1
BOARD_KERNEL_CMDLINE += exynos_drm.load_sequential=1

ifdef PHONE_CAR_BOARD_PRODUCT
    include device/google_car/$(PHONE_CAR_BOARD_PRODUCT)/BoardConfig.mk
else
    TARGET_SCREEN_DENSITY := 420
endif

TARGET_BOARD_INFO_FILE := device/google/pantah/board-info.txt
TARGET_BOOTLOADER_BOARD_NAME := panther
BOARD_USES_GENERIC_AUDIO := true
USES_DEVICE_GOOGLE_CLOUDRIPPER := true
BOARD_KERNEL_CMDLINE += swiotlb=noforce

include device/google/gs201/BoardConfig-common.mk
-include vendor/google_devices/gs201/prebuilts/BoardConfigVendor.mk
include device/google/gs-common/check_current_prebuilt/check_current_prebuilt.mk
-include vendor/google_devices/panther/proprietary/BoardConfigVendor.mk
include device/google/pantah/sepolicy/panther-sepolicy.mk
include device/google/pantah/wifi/BoardConfig-wifi.mk

ifneq (,$(RELEASE_ETM_IN_USERDEBUG_ENG))
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
-include device/google/common/etm/BoardUserdebugModules.mk
endif
endif

DEVICE_PATH := device/google/pantah
VENDOR_PATH := vendor/google/panther
include $(DEVICE_PATH)/$(TARGET_BOOTLOADER_BOARD_NAME)/BoardConfigTpp.mk
