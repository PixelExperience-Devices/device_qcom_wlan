# Add supported chips for autodetection
TARGET_WLAN_CHIP := qca6490 qca6390

WLAN_CHIPSET := qca_cld3

#WPA
WPA := wpa_cli

PRODUCT_PACKAGES += wifilearner
PRODUCT_PACKAGES += $(WPA)

#Enable WIFI AWARE FEATURE
WIFI_HIDL_FEATURE_AWARE := true

PRODUCT_COPY_FILES += \
			device/qcom/wlan/kona/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
			device/qcom/wlan/kona/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
			device/qcom/wlan/kona/icm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/icm.conf \
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
		      device/qcom/wlan/kona/WCNSS_qcom_cfg_$(chip).ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/$(chip)/WCNSS_qcom_cfg.ini)
else
TARGET_WLAN_CHIP := wlan
PRODUCT_COPY_FILES += \
		      device/qcom/wlan/kona/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini
endif


PRODUCT_PACKAGES += $(foreach chip, $(TARGET_WLAN_CHIP), $(WLAN_CHIPSET)_$(chip).ko)

# Override WLAN configurations
# Usage:
# To disable WLAN_CFG_1/WLAN_CFG_3 and enable WLAN_CFG_2 for <wlan_chip>
# (<wlan_chip> is from $TARGET_WLAN_CHIP).
#  WLAN_CFG_OVERRIDE_<wlan_chip> := WLAN_CFG_1=n WLAN_CFG_2=y WLAN_CFG_3=n

WLAN_CFG_OVERRIDE_qca6390 := CONFIG_CNSS_QCA6390=y
WLAN_CFG_OVERRIDE_qca6490 := CONFIG_CNSS_QCA6490=y

# Use default_config for all chips. Used with TARGET_WLAN_CHIP.
WLAN_CFG_USE_DEFAULT := true

# Inject Kbuild options per chip
#
# Select proper chip configuration for building WLAN driver module. Currently
# driver supports only one chip configuration per build.
#
WLAN_KBUILD_OPTIONS_qca6390 := CONFIG_CNSS_QCA6390=y
WLAN_KBUILD_OPTIONS_qca6490 := CONFIG_CNSS_QCA6490=y

# Enable STA + STA Feature.
QC_WIFI_HIDL_FEATURE_DUAL_STA := true
