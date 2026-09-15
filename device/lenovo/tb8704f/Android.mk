LOCAL_PATH := $(call my-dir)

ifneq ($(filter tb8704f,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
