include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/wlan.mk

.PHONY: wlan_tp wlan_tp_modules

wlan_tp: wlan_tp_modules

wlan_tp_modules: $(WLAN_MODULES_VENDOR)
