OPTEE_GET_TIME_EXT_VERSION = 1.0
OPTEE_GET_TIME_EXT_SOURCE = local
OPTEE_GET_TIME_EXT_SITE = $(BR2_PACKAGE_OPTEE_GET_TIME_EXT_SITE)
OPTEE_GET_TIME_EXT_SITE_METHOD = local
OPTEE_GET_TIME_EXT_INSTALL_STAGING = YES
OPTEE_GET_TIME_EXT_DEPENDENCIES = optee_client_ext host-python3-pycryptodomex
OPTEE_GET_TIME_EXT_SDK = $(BR2_PACKAGE_OPTEE_GET_TIME_EXT_SDK)
OPTEE_GET_TIME_EXT_CONF_OPTS = -DOPTEE_GET_TIME_SDK=$(OPTEE_GET_TIME_EXT_SDK)

define OPTEE_GET_TIME_EXT_BUILD_TAS
	@$(foreach f,$(wildcard $(@D)/*/ta/Makefile), \
		echo Building $f && \
			$(MAKE) CROSS_COMPILE="$(shell echo $(BR2_PACKAGE_OPTEE_GET_TIME_EXT_CROSS_COMPILE))" \
			O=out TA_DEV_KIT_DIR=$(OPTEE_GET_TIME_EXT_SDK) \
			PYTHON3=$(HOST_DIR)/bin/python3 \
			$(TARGET_CONFIGURE_OPTS) -C $(dir $f) all &&) true
endef

define OPTEE_GET_TIME_EXT_INSTALL_TAS
	@$(foreach f,$(wildcard $(@D)/*/ta/out/*.ta), \
		mkdir -p $(TARGET_DIR)/lib/optee_armtz && \
		$(INSTALL) -v -p  --mode=444 \
			--target-directory=$(TARGET_DIR)/lib/optee_armtz $f \
			&&) true
endef

OPTEE_GET_TIME_EXT_POST_BUILD_HOOKS += OPTEE_GET_TIME_EXT_BUILD_TAS
OPTEE_GET_TIME_EXT_POST_INSTALL_TARGET_HOOKS += OPTEE_GET_TIME_EXT_INSTALL_TAS

$(eval $(cmake-package))
