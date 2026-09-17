# The kernel is consumed through TARGET_PREBUILT_KERNEL in BoardConfig.mk.

PRODUCT_COPY_FILES += \
    device/lenovo/tb_8704f/recovery/root/init.recovery.qcom.rc:recovery/root/init.recovery.qcom.rc \
    device/lenovo/tb_8704f/recovery/root/sbin/change_blockdev:recovery/root/sbin/change_blockdev \
    device/lenovo/tb_8704f/recovery/root/sbin/qseecomd:recovery/root/sbin/qseecomd \
    device/lenovo/tb_8704f/recovery/root/vendor/lib64/libQSEEComAPI.so:recovery/root/vendor/lib64/libQSEEComAPI.so \
    device/lenovo/tb_8704f/recovery/root/vendor/lib64/libdiag.so:recovery/root/vendor/lib64/libdiag.so \
    device/lenovo/tb_8704f/recovery/root/vendor/lib64/libdrmfs.so:recovery/root/vendor/lib64/libdrmfs.so \
    device/lenovo/tb_8704f/recovery/root/vendor/lib64/hw/keystore.msm8953.so:recovery/root/vendor/lib64/hw/keystore.msm8953.so
