LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),tb_8704f)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
