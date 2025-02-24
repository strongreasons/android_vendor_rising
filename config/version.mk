PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 4

RISING_FLAVOR := Tiramisu
RISING_VERSION := 1.4
RISING_CODENAME := Elysium
RISING_RELEASE_TYPE := FINAL
RISING_CODE := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
MAINTAINER_LIST = $(shell cat vendor/risingOTA/risingOS.maintainers)
DEVICE_LIST = $(shell cat vendor/risingOTA/risingOS.devices)

ifeq ($(filter $(CURRENT_DEVICE), $(DEVICE_LIST)), $(CURRENT_DEVICE))
   ifeq ($(filter $(RISING_MAINTAINER), $(MAINTAINER_LIST)), $(RISING_MAINTAINER))
      RISING_BUILDTYPE := OFFICIAL
  else 
     # the builder is overriding official flag on purpose
     ifeq ($(RISING_BUILDTYPE), OFFICIAL)
       $(error **********************************************************)
       $(error *     A violation has been detected, aborting build      *)
       $(error **********************************************************)
       RISING_BUILDTYPE := UNOFFICIAL
     else 
       $(warning **********************************************************************)
       $(warning *   There is already an official maintainer for $(CURRENT_DEVICE)    *)
       $(warning *              Setting build type to UNOFFICIAL                      *)
       $(warning *    Please contact current official maintainer before distributing  *)
       $(warning *              the current build to the community.                   *)
       $(warning **********************************************************************)
       RISING_BUILDTYPE := UNOFFICIAL
     endif
  endif
else
   ifeq ($(RISING_BUILDTYPE), OFFICIAL)
     $(error **********************************************************)
     $(error *     A violation has been detected, aborting build      *)
     $(error **********************************************************)
   endif
  RISING_BUILDTYPE := COMMUNITY
endif

LINEAGE_VERSION_APPEND_TIME_OF_DAY ?= true
ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d%H%M)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

ifeq ($(WITH_GMS), true)
	ifeq ($(TARGET_CORE_GMS), true)
    	RISING_PACKAGE_TYPE ?= CORE
	else 
    	RISING_PACKAGE_TYPE ?= GAPPS
	endif
else
    RISING_PACKAGE_TYPE ?= VANILLA
endif

# Internal version
LINEAGE_VERSION := risingOS-v$(RISING_VERSION)-$(RISING_CODENAME)-$(RISING_RELEASE_TYPE)-$(LINEAGE_BUILD_DATE)-$(CURRENT_DEVICE)-$(RISING_PACKAGE_TYPE)-$(RISING_BUILDTYPE)

# Display version
LINEAGE_DISPLAY_VERSION := risingOS-v$(RISING_VERSION)-$(RISING_CODENAME)-$(RISING_RELEASE_TYPE)-$(CURRENT_DEVICE)-$(RISING_PACKAGE_TYPE)-$(RISING_BUILDTYPE)
