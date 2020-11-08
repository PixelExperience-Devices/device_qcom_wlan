# Add supported chips for autodetection
TARGET_WLAN_CHIP := wlan qca6750

WLAN_CHIPSET := qca_cld3

#WPA
WPA := wpa_cli

PRODUCT_PACKAGES += wifilearner
PRODUCT_PACKAGES += $(WPA)
PRODUCT_PACKAGES += lowirpcd
PRODUCT_PACKAGES += qsh_wifi_test

#Enable WIFI AWARE FEATURE
WIFI_HIDL_FEATURE_AWARE := true

PRODUCT_COPY_FILES += \
			device/qcom/wlan/lahaina/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
			device/qcom/wlan/lahaina/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
			device/qcom/wlan/lahaina/icm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/icm.conf \
			device/qcom/wlan/lahaina/vendor_cmd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/vendor_cmd.xml \
			frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
			frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
			frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml

# Enable STA + SAP Concurrency.
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Enable SAP + SAP Feature.
QC_WIFI_HIDL_FEATURE_DUAL_AP := true

# Enable vendor properties.
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.aware.interface=wifi-aware0

######## For multiple ko support ########

# WLAN driver configuration file
ifeq ($(strip $(shell expr $(words $(strip $(TARGET_WLAN_CHIP))) \>= 2)), 1)
PRODUCT_COPY_FILES += \
		      $(foreach chip, $(TARGET_WLAN_CHIP), \
		      device/qcom/wlan/lahaina/WCNSS_qcom_cfg_$(chip).ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/$(chip)/WCNSS_qcom_cfg.ini)
else
TARGET_WLAN_CHIP := wlan
PRODUCT_COPY_FILES += \
		      device/qcom/wlan/lahaina/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini
endif


PRODUCT_PACKAGES += $(foreach chip, $(TARGET_WLAN_CHIP), $(WLAN_CHIPSET)_$(chip).ko)

# Enable STA + STA Feature.
QC_WIFI_HIDL_FEATURE_DUAL_STA := true

#Disable DMS MAC address feature in cnss-daemon
TARGET_USES_NO_DMS_QMI_CLIENT := true

# Use default_config for all chips. Used with TARGET_WLAN_CHIP.
WLAN_CFG_USE_DEFAULT := true

# Inject Kbuild options per chip
#
# Select proper chip configuration for building WLAN driver module. Currently
# driver supports only one chip configuration per build.
#
WLAN_KBUILD_OPTIONS_wlan := CONFIG_CNSS_QCA6490=y
WLAN_KBUILD_OPTIONS_qca6750 := CONFIG_CNSS_QCA6750=y
