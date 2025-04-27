#
# SPDX-FileCopyrightText: 2021-2024 The LineageOS Project
# SPDX-FileCopyrightText: 2021-2024 The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(DEVICE_PATH)/device-tpp.mk)

DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/$(DEVICE_CODENAME)/overlay-lineage

# HBM
PRODUCT_PACKAGES += \
    HbmSVManagerOverlayPanther

# Init
PRODUCT_PACKAGES += \
    init.recovery.panther.touch.rc
