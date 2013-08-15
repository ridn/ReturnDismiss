include theos/makefiles/common.mk

TWEAK_NAME = returndismiss
returndismiss_FILES = Tweak.xm
returndismiss_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk
