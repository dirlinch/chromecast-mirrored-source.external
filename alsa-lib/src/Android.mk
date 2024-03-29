LOCAL_PATH := $(call my-dir)

ALSA_PATH := $(LOCAL_PATH)

ALSA_STATIC_LIBS := \
	control \
	hwdep \
	mixer \
	pcm \
	rawmidi \
	seq \
	timer

include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
	async.c \
	confmisc.c \
	conf.c \
	dlmisc.c \
	error.c \
	input.c \
	names.c \
	output.c \
	shmarea.c \
	socket.c \
	ucm/main.c \
	ucm/parser.c \
	ucm/utils.c \
	userfile.c
ALSA_LIB_CFLAGS := -DHAVE_CONFIG_H -D_GNU_SOURCE
LOCAL_CFLAGS := $(ALSA_LIB_CFLAGS)
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../include
LOCAL_MODULE := libasound
LOCAL_MODULE_TAGS := optional
LOCAL_WHOLE_STATIC_LIBRARIES := $(addprefix lib, $(ALSA_STATIC_LIBS))
ALSA_INSTALL_HEADERS := \
	asoundef.h \
	asoundlib.h \
	conf.h \
	control_external.h \
	control.h \
	error.h \
	global.h \
	hwdep.h \
	iatomic.h \
	input.h \
	mixer_abst.h \
	mixer.h \
	output.h \
	pcm_external.h \
	pcm_extplug.h \
	pcm.h \
	pcm_ioplug.h \
	pcm_old.h \
	pcm_plugin.h \
	pcm_rate.h \
	rawmidi.h \
	seq_event.h \
	seq.h \
	seqmid.h \
	seq_midi_event.h \
	sound/asound_fm.h \
	sound/emu10k1.h \
	sound/hdsp.h \
	sound/hdspm.h \
	sound/sb16_csp.h \
	sound/sscape_ioctl.h \
	sound/type_compat.h \
	timer.h \
	use-case.h \
	version.h
LOCAL_TOOLCHAIN_PREBUILTS := $(join \
	$(addprefix $(LOCAL_PATH)/../include/,$(ALSA_INSTALL_HEADERS)),\
	$(addprefix :usr/include/alsa/,$(ALSA_INSTALL_HEADERS))\
	)
include $(BUILD_SHARED_LIBRARY)

# sub makefiles for static modules
sub_makefiles := $(addprefix $(LOCAL_PATH)/,$(addsuffix /Android.mk, \
	$(ALSA_STATIC_LIBS) \
))

include $(sub_makefiles)

include $(CLEAR_VARS)
SOURCE_ALSA_CONF_PATH := $(ALSA_PATH)/conf
LOCAL_MODULE :=alsa-conf
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := acp
TARGET_ALSA_CONF_PATH := $(TARGET_OUT)/usr/share/alsa
include $(BUILD_PHONY_PACKAGE)

.PHONY: copy_alsa_conf
copy_alsa_conf:
	mkdir -p $(TARGET_ALSA_CONF_PATH)
	rsync -a $(SOURCE_ALSA_CONF_PATH)/alsa.conf $(TARGET_ALSA_CONF_PATH)
	rsync -a $(SOURCE_ALSA_CONF_PATH)/cards $(TARGET_ALSA_CONF_PATH)
	rsync -a $(SOURCE_ALSA_CONF_PATH)/pcm $(TARGET_ALSA_CONF_PATH)

$(LOCAL_BUILT_MODULE): copy_alsa_conf
