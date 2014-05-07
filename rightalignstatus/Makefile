TARGET := iphone:7.0:2.0
ARCHS := armv6 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RightAlignStatus
RightAlignStatus_FILES = Tweak.xm
RightAlignStatus_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = RightAlignStatusSettings
RightAlignStatusSettings_FILES = Preferences.m
RightAlignStatusSettings_INSTALL_PATH = /Library/PreferenceBundles
RightAlignStatusSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RightAlignStatus.plist$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard; killall -9 backboardd"
