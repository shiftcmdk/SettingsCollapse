PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SettingsCollapse
SettingsCollapse_FILES = Tweak.xm AppsPagingView.m CustomHeaderFooterView.m AppIconCell.m
SettingsCollapse_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = com.shiftcmdk.settingscollapse

com.shiftcmdk.settingscollapse_INSTALL_PATH = /Library/Application Support/

include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += settingscollapsepreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
