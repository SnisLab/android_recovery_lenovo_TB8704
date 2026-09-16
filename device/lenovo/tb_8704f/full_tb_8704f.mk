# Base Android product configuration.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# TB-8704F recovery device configuration.
$(call inherit-product, device/lenovo/tb_8704f/device.mk)

PRODUCT_DEVICE := tb_8704f
PRODUCT_NAME := full_tb_8704f
PRODUCT_BRAND := Lenovo
PRODUCT_MANUFACTURER := Lenovo
PRODUCT_MODEL := TB-8704F
