/WLAN_CHIPSET := qca_cld3
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko

#Enable WIFI AWARE FEATURE
WIFI_HIDL_FEATURE_AWARE := true

PRODUCT_COPY_FILES += \
	device/qcom/wlan/talos/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
	device/qcom/wlan/talos/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
	device/qcom/wlan/talos/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
	device/qcom/wlan/talos/icm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/icm.conf \
	frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
	frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml

# Enable STA + SAP Concurrency.
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Enable SAP + SAP Feature.
QC_WIFI_HIDL_FEATURE_DUAL_AP := true
