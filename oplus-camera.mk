# Copyright (C) 2022 Paranoid Android
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

# Blob dependencies
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V3-ndk.vendor \
    libcamera2ndk_vendor

# Frameworks
TARGET_CAMERA_PACKAGE_NAME := com.oplus.packageName

# Configurations
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/oplus_google_lens_config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/oplus_google_lens_config.xml \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-oplus.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-oplus.xml \
    $(LOCAL_PATH)/configs/sysconfig/hiddenapi-package-oplus-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/hiddenapi-package-oplus-whitelist.xml

# Init
PRODUCT_PACKAGES += \
    init.oplus.camera.rc

# Oplus Framework
PRODUCT_PACKAGES += \
    oplus-fwk.lahaina

PRODUCT_BOOT_JARS += \
    oplus-fwk.lahaina

# OPLUS wrapper
PRODUCT_BOOT_JARS += \
    oplus-support-wrapper

# Properties
PRODUCT_PRODUCT_PROPERTIES += \
    persist.vendor.camera.privapp.list=com.oplus.camera \
    ro.com.google.lens.oem_camera_package=com.oplus.camera \
    ro.com.google.lens.oem_image_package=com.oneplus.gallery

# Sepolicy
include vendor/oplus/camera/sepolicy/SEPolicy.mk

# Oplus Camera
$(call inherit-product, vendor/oplus/camera/camera-vendor.mk)
