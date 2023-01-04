WLAN_CHIPSET := qca_cld3

# WLAN wear specific defconfig
WLAN_PROFILE := wear

#WPA
WPA := wpa_cli

PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
PRODUCT_PACKAGES += wifilearner
PRODUCT_PACKAGES += $(WPA)
PRODUCT_PACKAGES += ctrlapp_dut

ifneq ($(TARGET_SUPPORTS_WEARABLES),true)
#Enable WIFI AWARE FEATURE
WIFI_HIDL_FEATURE_AWARE := true
endif

ifeq ($(BOARD_WLAN_DIR),)
    BOARD_WLAN_DIR := device/qcom/wlan
endif

PRODUCT_COPY_FILES += \
	$(BOARD_WLAN_DIR)/monaco/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
	$(BOARD_WLAN_DIR)/monaco/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
	$(BOARD_WLAN_DIR)/monaco/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
	$(BOARD_WLAN_DIR)/monaco/icm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/icm.conf

ifneq ($(TARGET_SUPPORTS_WEARABLES),true)
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
	frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml
endif

PRODUCT_PACKAGES += icnss2.ko
PRODUCT_PACKAGES += wlan_firmware_service.ko
PRODUCT_PACKAGES += cnss_prealloc.ko
PRODUCT_PACKAGES += cnss_utils.ko
PRODUCT_PACKAGES += cnss_nl.ko

WLAN_PLATFORM_KBUILD_OPTIONS := CONFIG_CNSS_OUT_OF_TREE=y CONFIG_ICNSS2=m \
				CONFIG_ICNSS2_QMI=y CONFIG_CNSS_QMI_SVC=m \
				CONFIG_ICNSS2_DEBUG=y CONFIG_CNSS_GENL=m \
				CONFIG_WCNSS_MEM_PRE_ALLOC=m CONFIG_CNSS_UTILS=m \
				KERNEL_SUPPORTS_NESTED_COMPOSITES=n

# WLAN specific aosp flag
TARGET_USES_AOSP_FOR_WLAN := false

# WLAN specific memory flag
WLAN_TARGET_MONACO_HAS_LOW_RAM := true

# Enable STA + SAP Concurrency.
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Enable SAP + SAP Feature.
QC_WIFI_HIDL_FEATURE_DUAL_AP := true

#Enable cal delete feature
TARGET_CAL_DATA_CLEAR := true

#Disable Perf tuner in cnss-daemon
TARGET_USES_NO_CNSS_DP := true

# Enable vendor properties.
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.aware.interface=wifi-aware0
