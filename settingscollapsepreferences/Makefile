include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SettingsCollapsePreferences
SettingsCollapsePreferences_FILES = SCOLRootListController.m CustomColorCell.m
SettingsCollapsePreferences_INSTALL_PATH = /Library/PreferenceBundles
SettingsCollapsePreferences_FRAMEWORKS = UIKit
SettingsCollapsePreferences_PRIVATE_FRAMEWORKS = Preferences

SettingsCollapsePreferences_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SettingsCollapsePreferences.plist$(ECHO_END)
