module deimos.alsa.pcm;

import core.stdc.config;
import core.sys.posix.poll;

import deimos.alsa.conf : snd_config_t;
import deimos.alsa.global;
import deimos.alsa.output;

extern(C):

//#define SND_PCM_DLSYM_VERSION		_dlsym_pcm_001

struct snd_pcm_info_t;
struct snd_pcm_hw_params_t;
struct snd_pcm_sw_params_t;
struct snd_pcm_status_t;
struct snd_pcm_access_mask_t;
struct snd_pcm_format_mask_t;
struct snd_pcm_subformat_mask_t;

enum snd_pcm_class_t
{
	GENERIC = 0,
	MULTI,
	MODEM,
	DIGITIZER,
	LAST = DIGITIZER
}

enum snd_pcm_subclass_t
{
	GENERIC_MIX = 0,
	MULTI_MIX,
	LAST = MULTI_MIX
}

enum snd_pcm_stream_t {
	PLAYBACK = 0,
	CAPTURE,
	LAST = CAPTURE
}

enum snd_pcm_access_t
{
	MMAP_INTERLEAVED = 0,
	MMAP_NONINTERLEAVED,
	MMAP_COMPLEX,
	RW_INTERLEAVED,
	RW_NONINTERLEAVED,
	LAST = RW_NONINTERLEAVED
}

version(LittleEndian)
{
	enum snd_pcm_format_t
	{
		UNKNOWN = -1,
		S8 = 0,
		U8,
		S16_LE,
		S16_BE,
		U16_LE,
		U16_BE,
		S24_LE,
		S24_BE,
		U24_LE,
		U24_BE,
		S32_LE,
		S32_BE,
		U32_LE,
		U32_BE,
		FLOAT_LE,
		FLOAT_BE,
		FLOAT64_LE,
		FLOAT64_BE,
		IEC958_SUBFRAME_LE,
		IEC958_SUBFRAME_BE,
		MU_LAW,
		A_LAW,
		IMA_ADPCM,
		MPEG,
		GSM,
		SPECIAL = 31,
		S24_3LE = 32,
		S24_3BE,
		U24_3LE,
		U24_3BE,
		S20_3LE,
		S20_3BE,
		U20_3LE,
		U20_3BE,
		S18_3LE,
		S18_3BE,
		U18_3LE,
		U18_3BE,
		G723_24,
		G723_24_1B,
		G723_40,
		G723_40_1B,
		DSD_U8,
		DSD_U16_LE,
		LAST = DSD_U16_LE,

		S16 = S16_LE,
		U16 = U16_LE,
		S24 = S24_LE,
		U24 = U24_LE,
		S32 = S32_LE,
		U32 = U32_LE,
		FLOAT = FLOAT_LE,
		FLOAT64 = FLOAT64_LE,
		IEC958_SUBFRAME = IEC958_SUBFRAME_LE
	}
}
else version(BigEndian)
{
	enum snd_pcm_format_t
	{
		UNKNOWN = -1,
		S8 = 0,
		U8,
		S16_LE,
		S16_BE,
		U16_LE,
		U16_BE,
		S24_LE,
		S24_BE,
		U24_LE,
		U24_BE,
		S32_LE,
		S32_BE,
		U32_LE,
		U32_BE,
		FLOAT_LE,
		FLOAT_BE,
		FLOAT64_LE,
		FLOAT64_BE,
		IEC958_SUBFRAME_LE,
		IEC958_SUBFRAME_BE,
		MU_LAW,
		A_LAW,
		IMA_ADPCM,
		MPEG,
		GSM,
		SPECIAL = 31,
		S24_3LE = 32,
		S24_3BE,
		U24_3LE,
		U24_3BE,
		S20_3LE,
		S20_3BE,
		U20_3LE,
		U20_3BE,
		S18_3LE,
		S18_3BE,
		U18_3LE,
		U18_3BE,
		G723_24,
		G723_24_1B,
		G723_40,
		G723_40_1B,
		DSD_U8,
		DSD_U16_LE,
		LAST = DSD_U16_LE,

		S16 = S16_BE,
		U16 = U16_BE,
		S24 = S24_BE,
		U24 = U24_BE,
		S32 = S32_BE,
		U32 = U32_BE,
		FLOAT = FLOAT_BE,
		FLOAT64 = FLOAT64_BE,
		IEC958_SUBFRAME = IEC958_SUBFRAME_BE
	}
}
else
{
	static assert(0, "Unknown endian");
}


enum snd_pcm_subformat_t
{
	STD = 0,
	LAST = STD
}

enum snd_pcm_state_t
{
	OPEN = 0,
	SETUP,
	PREPARED,
	RUNNING,
	XRUN,
	DRAINING,
	PAUSED,
	SUSPENDED,
	DISCONNECTED,
	LAST = DISCONNECTED
}

enum snd_pcm_start_t
{
	DATA = 0,
	EXPLICIT,
	LAST = EXPLICIT
}

enum snd_pcm_xrun_t
{
	NONE = 0,
	STOP,
	LAST = STOP
}

enum snd_pcm_tstamp_t {
	NONE = 0,
	ENABLE,
	MMAP = ENABLE,
	LAST = ENABLE
}

alias snd_pcm_uframes_t = c_ulong;
alias snd_pcm_sframes_t = c_long;

enum SND_PCM_NONBLOCK         = 0x00000001;
enum SND_PCM_ASYNC            = 0x00000002;
enum SND_PCM_ABORT            = 0x00008000;
enum SND_PCM_NO_AUTO_RESAMPLE = 0x00010000;
enum SND_PCM_NO_AUTO_CHANNELS = 0x00020000;
enum SND_PCM_NO_AUTO_FORMAT   = 0x00040000;
enum SND_PCM_NO_SOFTVOL       = 0x00080000;

struct snd_pcm_t;

enum snd_pcm_type_t {
	HW = 0,
	HOOKS,
	MULTI,
	FILE,
	NULL,
	SHM,
	INET,
	COPY,
	LINEAR,
	ALAW,
	MULAW,
	ADPCM,
	RATE,
	ROUTE,
	PLUG,
	SHARE,
	METER,
	MIX,
	DROUTE,
	LBSERVER,
	LINEAR_FLOAT,
	LADSPA,
	DMIX,
	JACK,
	DSNOOP,
	DSHARE,
	IEC958,
	SOFTVOL,
	IOPLUG,
	EXTPLUG,
	MMAP_EMUL,
	LAST = MMAP_EMUL
};

struct snd_pcm_channel_area_t
{
	void* addr;
	uint first;
	uint step;
}

union snd_pcm_sync_id_t
{
	ubyte[16] id;
	ushort[8] id16;
	uint[4]   id32;
}

struct snd_pcm_scope_t;


int snd_pcm_open(snd_pcm_t** pcm, const(char)* name, snd_pcm_stream_t stream, int mode);
int snd_pcm_open_lconf(snd_pcm_t** pcm, const(char)* name, snd_pcm_stream_t stream, int mode, snd_config_t* lconf);
int snd_pcm_open_fallback(snd_pcm_t** pcm, snd_config_t* root, const(char)* name, const(char)* orig_name, snd_pcm_stream_t stream, int mode);

int snd_pcm_close(snd_pcm_t* pcm);
const(char)* snd_pcm_name(snd_pcm_t* pcm);
snd_pcm_type_t snd_pcm_type(snd_pcm_t* pcm);
snd_pcm_stream_t snd_pcm_stream(snd_pcm_t* pcm);
int snd_pcm_poll_descriptors_count(snd_pcm_t* pcm);
int snd_pcm_poll_descriptors(snd_pcm_t* pcm, pollfd* pfds, uint space);
int snd_pcm_poll_descriptors_revents(snd_pcm_t* pcm, pollfd* pfds, uint nfds, ushort* revents);
int snd_pcm_nonblock(snd_pcm_t* pcm, int nonblock);
int snd_pcm_abort(snd_pcm_t* pcm) { return snd_pcm_nonblock(pcm, 2); }
int snd_async_add_pcm_handler(snd_async_handler_t** handler, snd_pcm_t* pcm, snd_async_callback_t callback, void* private_data);
snd_pcm_t* snd_async_handler_get_pcm(snd_async_handler_t* handler);
int snd_pcm_info(snd_pcm_t* pcm, snd_pcm_info_t* info);
int snd_pcm_hw_params_current(snd_pcm_t* pcm, snd_pcm_hw_params_t* params);
int snd_pcm_hw_params(snd_pcm_t* pcm, snd_pcm_hw_params_t* params);
int snd_pcm_hw_free(snd_pcm_t* pcm);
int snd_pcm_sw_params_current(snd_pcm_t* pcm, snd_pcm_sw_params_t* params);
int snd_pcm_sw_params(snd_pcm_t* pcm, snd_pcm_sw_params_t* params);
int snd_pcm_prepare(snd_pcm_t* pcm);
int snd_pcm_reset(snd_pcm_t* pcm);
int snd_pcm_status(snd_pcm_t* pcm, snd_pcm_status_t* status);
int snd_pcm_start(snd_pcm_t* pcm);
int snd_pcm_drop(snd_pcm_t* pcm);
int snd_pcm_drain(snd_pcm_t* pcm);
int snd_pcm_pause(snd_pcm_t* pcm, int enable);
snd_pcm_state_t snd_pcm_state(snd_pcm_t* pcm);
int snd_pcm_hwsync(snd_pcm_t* pcm);
int snd_pcm_delay(snd_pcm_t* pcm, snd_pcm_sframes_t* delayp);
int snd_pcm_resume(snd_pcm_t* pcm);
int snd_pcm_htimestamp(snd_pcm_t* pcm, snd_pcm_uframes_t* avail, snd_htimestamp_t* tstamp);
snd_pcm_sframes_t snd_pcm_avail(snd_pcm_t* pcm);
snd_pcm_sframes_t snd_pcm_avail_update(snd_pcm_t* pcm);
int snd_pcm_avail_delay(snd_pcm_t* pcm, snd_pcm_sframes_t* availp, snd_pcm_sframes_t* delayp);
snd_pcm_sframes_t snd_pcm_rewindable(snd_pcm_t* pcm);
snd_pcm_sframes_t snd_pcm_rewind(snd_pcm_t* pcm, snd_pcm_uframes_t frames);
snd_pcm_sframes_t snd_pcm_forwardable(snd_pcm_t* pcm);
snd_pcm_sframes_t snd_pcm_forward(snd_pcm_t* pcm, snd_pcm_uframes_t frames);
snd_pcm_sframes_t snd_pcm_writei(snd_pcm_t* pcm, const(void)* buffer, snd_pcm_uframes_t size);
snd_pcm_sframes_t snd_pcm_readi(snd_pcm_t* pcm, void* buffer, snd_pcm_uframes_t size);
snd_pcm_sframes_t snd_pcm_writen(snd_pcm_t* pcm, void** bufs, snd_pcm_uframes_t size);
snd_pcm_sframes_t snd_pcm_readn(snd_pcm_t* pcm, void** bufs, snd_pcm_uframes_t size);
int snd_pcm_wait(snd_pcm_t* pcm, int timeout);

int snd_pcm_link(snd_pcm_t* pcm1, snd_pcm_t* pcm2);
int snd_pcm_unlink(snd_pcm_t* pcm);

enum SND_CHMAP_API_VERSION = ((1 << 16) | (0 << 8) | 1);

enum snd_pcm_chmap_type
{
	NONE = 0,
	FIXED,
	VAR,
	PAIRED,
	LAST = PAIRED,
};

enum snd_pcm_chmap_position
{
	UNKNOWN = 0,
	NA,
	MONO,
	FL,
	FR,
	RL,
	RR,
	FC,
	LFE,
	SL,
	SR,
	RC,
	FLC,
	FRC,
	RLC,
	RRC,
	FLW,
	FRW,
	FLH,
	FCH,
	FRH,
	TC,
	TFL,
	TFR,
	TFC,
	TRL,
	TRR,
	TRC,
	TFLC,
	TFRC,
	TSL,
	TSR,
	LLFE,
	RLFE,
	BC,
	BLC,
	BRC,
	LAST = BRC,
}

enum SND_CHMAP_POSITION_MASK = 0xffff;
enum SND_CHMAP_PHASE_INVERSE = (0x01 << 16);
enum SND_CHMAP_DRIVER_SPEC   = (0x02 << 16);

struct snd_pcm_chmap_t
{
	uint channels;
	uint[0] pos;
}

struct snd_pcm_chmap_query_t
{
	snd_pcm_chmap_type type;
	snd_pcm_chmap_t map;
}

snd_pcm_chmap_query_t** snd_pcm_query_chmaps(snd_pcm_t* pcm);
snd_pcm_chmap_query_t** snd_pcm_query_chmaps_from_hw(int card, int dev, int subdev, snd_pcm_stream_t stream);
void snd_pcm_free_chmaps(snd_pcm_chmap_query_t** maps);
snd_pcm_chmap_t* snd_pcm_get_chmap(snd_pcm_t* pcm);
int snd_pcm_set_chmap(snd_pcm_t* pcm, const(snd_pcm_chmap_t)* map);

const(char)* snd_pcm_chmap_type_name(snd_pcm_chmap_type val);
const(char)* snd_pcm_chmap_name(snd_pcm_chmap_position val);
const(char)* snd_pcm_chmap_long_name(snd_pcm_chmap_position val);
int snd_pcm_chmap_print(const(snd_pcm_chmap_t)* map, size_t maxlen, char* buf);
uint snd_pcm_chmap_from_string(const(char)* str);
snd_pcm_chmap_t* snd_pcm_chmap_parse_string(const(char)* str);

int snd_pcm_recover(snd_pcm_t* pcm, int err, int silent);
int snd_pcm_set_params(snd_pcm_t* pcm,
                       snd_pcm_format_t format,
                       snd_pcm_access_t access,
                       uint channels,
                       uint rate,
                       int soft_resample,
                       uint latency);
int snd_pcm_get_params(snd_pcm_t* pcm,
                       snd_pcm_uframes_t* buffer_size,
                       snd_pcm_uframes_t* period_size);


size_t snd_pcm_info_sizeof();

int snd_pcm_info_malloc(snd_pcm_info_t** ptr);
void snd_pcm_info_free(snd_pcm_info_t* obj);
void snd_pcm_info_copy(snd_pcm_info_t* dst, const(snd_pcm_info_t)* src);
uint snd_pcm_info_get_device(const snd_pcm_info_t* obj);
uint snd_pcm_info_get_subdevice(const snd_pcm_info_t* obj);
snd_pcm_stream_t snd_pcm_info_get_stream(const(snd_pcm_info_t)* obj);
int snd_pcm_info_get_card(const(snd_pcm_info_t)* obj);
const(char)* snd_pcm_info_get_id(const(snd_pcm_info_t)* obj);
const(char)* snd_pcm_info_get_name(const(snd_pcm_info_t)* obj);
const(char)* snd_pcm_info_get_subdevice_name(const(snd_pcm_info_t)* obj);
snd_pcm_class_t snd_pcm_info_get_class(const(snd_pcm_info_t)* obj);
snd_pcm_subclass_t snd_pcm_info_get_subclass(const(snd_pcm_info_t)* obj);
uint snd_pcm_info_get_subdevices_count(const(snd_pcm_info_t)* obj);
uint snd_pcm_info_get_subdevices_avail(const(snd_pcm_info_t)* obj);
snd_pcm_sync_id_t snd_pcm_info_get_sync(const(snd_pcm_info_t)* obj);
void snd_pcm_info_set_device(snd_pcm_info_t* obj, uint val);
void snd_pcm_info_set_subdevice(snd_pcm_info_t* obj, uint val);
void snd_pcm_info_set_stream(snd_pcm_info_t* obj, snd_pcm_stream_t val);

int snd_pcm_hw_params_any(snd_pcm_t* pcm, snd_pcm_hw_params_t* params);

int snd_pcm_hw_params_can_mmap_sample_resolution(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_is_double(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_is_batch(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_is_block_transfer(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_is_monotonic(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_can_overrange(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_can_pause(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_can_resume(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_is_half_duplex(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_is_joint_duplex(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_can_sync_start(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_can_disable_period_wakeup(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_supports_audio_wallclock_ts(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_get_rate_numden(const(snd_pcm_hw_params_t)* params,
				      uint* rate_num,
				      uint* rate_den);
int snd_pcm_hw_params_get_sbits(const(snd_pcm_hw_params_t)* params);
int snd_pcm_hw_params_get_fifo_size(const(snd_pcm_hw_params_t)* params);

size_t snd_pcm_hw_params_sizeof();
int snd_pcm_hw_params_malloc(snd_pcm_hw_params_t** ptr);
void snd_pcm_hw_params_free(snd_pcm_hw_params_t* obj);
void snd_pcm_hw_params_copy(snd_pcm_hw_params_t* dst, const(snd_pcm_hw_params_t)* src);

int snd_pcm_hw_params_get_access(const(snd_pcm_hw_params_t)* params, snd_pcm_access_t* _access);
int snd_pcm_hw_params_test_access(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_access_t _access);
int snd_pcm_hw_params_set_access(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_access_t _access);
int snd_pcm_hw_params_set_access_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_access_t* _access);
int snd_pcm_hw_params_set_access_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_access_t* _access);
int snd_pcm_hw_params_set_access_mask(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_access_mask_t* mask);
int snd_pcm_hw_params_get_access_mask(snd_pcm_hw_params_t* params, snd_pcm_access_mask_t* mask);

int snd_pcm_hw_params_get_format(const(snd_pcm_hw_params_t)* params, snd_pcm_format_t* val);
int snd_pcm_hw_params_test_format(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_format_t val);
int snd_pcm_hw_params_set_format(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_format_t val);
int snd_pcm_hw_params_set_format_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_format_t* format);
int snd_pcm_hw_params_set_format_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_format_t* format);
int snd_pcm_hw_params_set_format_mask(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_format_mask_t* mask);
void snd_pcm_hw_params_get_format_mask(snd_pcm_hw_params_t* params, snd_pcm_format_mask_t* mask);

int snd_pcm_hw_params_get_subformat(const(snd_pcm_hw_params_t)* params, snd_pcm_subformat_t* subformat);
int snd_pcm_hw_params_test_subformat(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_subformat_t subformat);
int snd_pcm_hw_params_set_subformat(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_subformat_t subformat);
int snd_pcm_hw_params_set_subformat_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_subformat_t* subformat);
int snd_pcm_hw_params_set_subformat_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_subformat_t* subformat);
int snd_pcm_hw_params_set_subformat_mask(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_subformat_mask_t* mask);
void snd_pcm_hw_params_get_subformat_mask(snd_pcm_hw_params_t* params, snd_pcm_subformat_mask_t* mask);

int snd_pcm_hw_params_get_channels(const(snd_pcm_hw_params_t)* params, uint* val);
int snd_pcm_hw_params_get_channels_min(const(snd_pcm_hw_params_t)* params, uint* val);
int snd_pcm_hw_params_get_channels_max(const(snd_pcm_hw_params_t)* params, uint* val);
int snd_pcm_hw_params_test_channels(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val);
int snd_pcm_hw_params_set_channels(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val);
int snd_pcm_hw_params_set_channels_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);
int snd_pcm_hw_params_set_channels_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);
int snd_pcm_hw_params_set_channels_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* min, uint* max);
int snd_pcm_hw_params_set_channels_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);
int snd_pcm_hw_params_set_channels_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);
int snd_pcm_hw_params_set_channels_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);

int snd_pcm_hw_params_get_rate(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_rate_min(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_rate_max(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_test_rate(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_rate(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_rate_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_rate_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_rate_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* min, int* mindir, uint* max, int* maxdir);
int snd_pcm_hw_params_set_rate_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_rate_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_rate_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_rate_resample(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val);
int snd_pcm_hw_params_get_rate_resample(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);
int snd_pcm_hw_params_set_export_buffer(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val);
int snd_pcm_hw_params_get_export_buffer(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);
int snd_pcm_hw_params_set_period_wakeup(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val);
int snd_pcm_hw_params_get_period_wakeup(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val);

int snd_pcm_hw_params_get_period_time(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_period_time_min(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_period_time_max(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_test_period_time(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_period_time(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_period_time_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_period_time_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_period_time_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* min, int* mindir, uint* max, int* maxdir);
int snd_pcm_hw_params_set_period_time_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_period_time_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_period_time_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);

int snd_pcm_hw_params_get_period_size(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* frames, int* dir);
int snd_pcm_hw_params_get_period_size_min(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* frames, int* dir);
int snd_pcm_hw_params_get_period_size_max(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* frames, int* dir);
int snd_pcm_hw_params_test_period_size(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t val, int dir);
int snd_pcm_hw_params_set_period_size(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t val, int dir);
int snd_pcm_hw_params_set_period_size_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val, int* dir);
int snd_pcm_hw_params_set_period_size_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val, int* dir);
int snd_pcm_hw_params_set_period_size_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* min, int* mindir, snd_pcm_uframes_t* max, int* maxdir);
int snd_pcm_hw_params_set_period_size_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val, int* dir);
int snd_pcm_hw_params_set_period_size_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val, int* dir);
int snd_pcm_hw_params_set_period_size_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val, int* dir);
int snd_pcm_hw_params_set_period_size_integer(snd_pcm_t* pcm, snd_pcm_hw_params_t* params);

int snd_pcm_hw_params_get_periods(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_periods_min(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_periods_max(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_test_periods(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_periods(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_periods_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_periods_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_periods_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* min, int* mindir, uint* max, int* maxdir);
int snd_pcm_hw_params_set_periods_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_periods_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_periods_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_periods_integer(snd_pcm_t* pcm, snd_pcm_hw_params_t* params);

int snd_pcm_hw_params_get_buffer_time(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_buffer_time_min(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_buffer_time_max(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_test_buffer_time(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_buffer_time(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_buffer_time_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_buffer_time_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_buffer_time_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* min, int* mindir, uint* max, int* maxdir);
int snd_pcm_hw_params_set_buffer_time_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_buffer_time_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_buffer_time_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);

int snd_pcm_hw_params_get_buffer_size(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_get_buffer_size_min(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_get_buffer_size_max(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_test_buffer_size(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_hw_params_set_buffer_size(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_hw_params_set_buffer_size_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_set_buffer_size_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_set_buffer_size_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* min, snd_pcm_uframes_t* max);
int snd_pcm_hw_params_set_buffer_size_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_set_buffer_size_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val);
int snd_pcm_hw_params_set_buffer_size_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, snd_pcm_uframes_t* val);

int snd_pcm_hw_params_get_min_align(const(snd_pcm_hw_params_t)* params, snd_pcm_uframes_t* val);

size_t snd_pcm_sw_params_sizeof();

int snd_pcm_sw_params_malloc(snd_pcm_sw_params_t** ptr);
void snd_pcm_sw_params_free(snd_pcm_sw_params_t* obj);
void snd_pcm_sw_params_copy(snd_pcm_sw_params_t* dst, const(snd_pcm_sw_params_t)* src);
int snd_pcm_sw_params_get_boundary(const(snd_pcm_sw_params_t)* params, snd_pcm_uframes_t* val);

int snd_pcm_sw_params_set_tstamp_mode(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_tstamp_t val);
int snd_pcm_sw_params_get_tstamp_mode(const(snd_pcm_sw_params_t)* params, snd_pcm_tstamp_t* val);
int snd_pcm_sw_params_set_avail_min(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_sw_params_get_avail_min(const(snd_pcm_sw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_sw_params_set_period_event(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, int val);
int snd_pcm_sw_params_get_period_event(const(snd_pcm_sw_params_t)* params, int* val);
int snd_pcm_sw_params_set_start_threshold(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_sw_params_get_start_threshold(const(snd_pcm_sw_params_t)* paramsm, snd_pcm_uframes_t* val);
int snd_pcm_sw_params_set_stop_threshold(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_sw_params_get_stop_threshold(const(snd_pcm_sw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_sw_params_set_silence_threshold(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_sw_params_get_silence_threshold(const(snd_pcm_sw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_sw_params_set_silence_size(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_sw_params_get_silence_size(const(snd_pcm_sw_params_t)* params, snd_pcm_uframes_t* val);


size_t snd_pcm_access_mask_sizeof();

int snd_pcm_access_mask_malloc(snd_pcm_access_mask_t** ptr);
void snd_pcm_access_mask_free(snd_pcm_access_mask_t* obj);
void snd_pcm_access_mask_copy(snd_pcm_access_mask_t* dst, const(snd_pcm_access_mask_t)* src);
void snd_pcm_access_mask_none(snd_pcm_access_mask_t* mask);
void snd_pcm_access_mask_any(snd_pcm_access_mask_t* mask);
int snd_pcm_access_mask_test(const(snd_pcm_access_mask_t)* mask, snd_pcm_access_t val);
int snd_pcm_access_mask_empty(const(snd_pcm_access_mask_t)* mask);
void snd_pcm_access_mask_set(snd_pcm_access_mask_t* mask, snd_pcm_access_t val);
void snd_pcm_access_mask_reset(snd_pcm_access_mask_t* mask, snd_pcm_access_t val);

size_t snd_pcm_format_mask_sizeof();

int snd_pcm_format_mask_malloc(snd_pcm_format_mask_t** ptr);
void snd_pcm_format_mask_free(snd_pcm_format_mask_t* obj);
void snd_pcm_format_mask_copy(snd_pcm_format_mask_t* dst, const(snd_pcm_format_mask_t)* src);
void snd_pcm_format_mask_none(snd_pcm_format_mask_t* mask);
void snd_pcm_format_mask_any(snd_pcm_format_mask_t* mask);
int snd_pcm_format_mask_test(const(snd_pcm_format_mask_t)* mask, snd_pcm_format_t val);
int snd_pcm_format_mask_empty(const(snd_pcm_format_mask_t)* mask);
void snd_pcm_format_mask_set(snd_pcm_format_mask_t* mask, snd_pcm_format_t val);
void snd_pcm_format_mask_reset(snd_pcm_format_mask_t* mask, snd_pcm_format_t val);

size_t snd_pcm_subformat_mask_sizeof();

int snd_pcm_subformat_mask_malloc(snd_pcm_subformat_mask_t** ptr);
void snd_pcm_subformat_mask_free(snd_pcm_subformat_mask_t* obj);
void snd_pcm_subformat_mask_copy(snd_pcm_subformat_mask_t* dst, const(snd_pcm_subformat_mask_t)* src);
void snd_pcm_subformat_mask_none(snd_pcm_subformat_mask_t* mask);
void snd_pcm_subformat_mask_any(snd_pcm_subformat_mask_t* mask);
int snd_pcm_subformat_mask_test(const(snd_pcm_subformat_mask_t)* mask, snd_pcm_subformat_t val);
int snd_pcm_subformat_mask_empty(const(snd_pcm_subformat_mask_t)* mask);
void snd_pcm_subformat_mask_set(snd_pcm_subformat_mask_t* mask, snd_pcm_subformat_t val);
void snd_pcm_subformat_mask_reset(snd_pcm_subformat_mask_t* mask, snd_pcm_subformat_t val);

size_t snd_pcm_status_sizeof();

int snd_pcm_status_malloc(snd_pcm_status_t** ptr);
void snd_pcm_status_free(snd_pcm_status_t* obj);
void snd_pcm_status_copy(snd_pcm_status_t* dst, const(snd_pcm_status_t)* src);
snd_pcm_state_t snd_pcm_status_get_state(const(snd_pcm_status_t)* obj);
void snd_pcm_status_get_trigger_tstamp(const(snd_pcm_status_t)* obj, snd_timestamp_t* ptr);
void snd_pcm_status_get_trigger_htstamp(const(snd_pcm_status_t)* obj, snd_htimestamp_t* ptr);
void snd_pcm_status_get_tstamp(const(snd_pcm_status_t)* obj, snd_timestamp_t* ptr);
void snd_pcm_status_get_htstamp(const(snd_pcm_status_t)* obj, snd_htimestamp_t* ptr);
void snd_pcm_status_get_audio_htstamp(const(snd_pcm_status_t)* obj, snd_htimestamp_t* ptr);
snd_pcm_sframes_t snd_pcm_status_get_delay(const(snd_pcm_status_t)* obj);
snd_pcm_uframes_t snd_pcm_status_get_avail(const(snd_pcm_status_t)* obj);
snd_pcm_uframes_t snd_pcm_status_get_avail_max(const(snd_pcm_status_t)* obj);
snd_pcm_uframes_t snd_pcm_status_get_overrange(const(snd_pcm_status_t)* obj);

const(char)* snd_pcm_type_name(snd_pcm_type_t type);
const(char)* snd_pcm_stream_name(const(snd_pcm_stream_t) stream);
const(char)* snd_pcm_access_name(const(snd_pcm_access_t) _access);
const(char)* snd_pcm_format_name(const(snd_pcm_format_t) format);
const(char)* snd_pcm_format_description(const(snd_pcm_format_t) format);
const(char)* snd_pcm_subformat_name(const(snd_pcm_subformat_t) subformat);
const(char)* snd_pcm_subformat_description(const(snd_pcm_subformat_t) subformat);
snd_pcm_format_t snd_pcm_format_value(const(char)* name);
const(char)* snd_pcm_tstamp_mode_name(const(snd_pcm_tstamp_t) mode);
const(char)* snd_pcm_state_name(const(snd_pcm_state_t) state);

int snd_pcm_dump(snd_pcm_t* pcm, snd_output_t* out_);
int snd_pcm_dump_hw_setup(snd_pcm_t* pcm, snd_output_t* out_);
int snd_pcm_dump_sw_setup(snd_pcm_t* pcm, snd_output_t* out_);
int snd_pcm_dump_setup(snd_pcm_t* pcm, snd_output_t* out_);
int snd_pcm_hw_params_dump(snd_pcm_hw_params_t* params, snd_output_t* out_);
int snd_pcm_sw_params_dump(snd_pcm_sw_params_t* params, snd_output_t* out_);
int snd_pcm_status_dump(snd_pcm_status_t* status, snd_output_t* out_);

int snd_pcm_mmap_begin(snd_pcm_t* pcm,
		       const(snd_pcm_channel_area_t)** areas,
		       snd_pcm_uframes_t* offset,
		       snd_pcm_uframes_t* frames);
snd_pcm_sframes_t snd_pcm_mmap_commit(snd_pcm_t* pcm,
				      snd_pcm_uframes_t offset,
				      snd_pcm_uframes_t frames);
snd_pcm_sframes_t snd_pcm_mmap_writei(snd_pcm_t* pcm, const(void)* buffer, snd_pcm_uframes_t size);
snd_pcm_sframes_t snd_pcm_mmap_readi(snd_pcm_t* pcm, void* buffer, snd_pcm_uframes_t size);
snd_pcm_sframes_t snd_pcm_mmap_writen(snd_pcm_t* pcm, void** bufs, snd_pcm_uframes_t size);
snd_pcm_sframes_t snd_pcm_mmap_readn(snd_pcm_t* pcm, void** bufs, snd_pcm_uframes_t size);

int snd_pcm_format_signed(snd_pcm_format_t format);
int snd_pcm_format_unsigned(snd_pcm_format_t format);
int snd_pcm_format_linear(snd_pcm_format_t format);
int snd_pcm_format_float(snd_pcm_format_t format);
int snd_pcm_format_little_endian(snd_pcm_format_t format);
int snd_pcm_format_big_endian(snd_pcm_format_t format);
int snd_pcm_format_cpu_endian(snd_pcm_format_t format);
int snd_pcm_format_width(snd_pcm_format_t format);			/* in bits */
int snd_pcm_format_physical_width(snd_pcm_format_t format);		/* in bits */
snd_pcm_format_t snd_pcm_build_linear_format(int width, int pwidth, int unsignd, int big_endian);
ssize_t snd_pcm_format_size(snd_pcm_format_t format, size_t samples);
ubyte snd_pcm_format_silence(snd_pcm_format_t format);
ushort snd_pcm_format_silence_16(snd_pcm_format_t format);
uint snd_pcm_format_silence_32(snd_pcm_format_t format);
ulong snd_pcm_format_silence_64(snd_pcm_format_t format);
int snd_pcm_format_set_silence(snd_pcm_format_t format, void* buf, uint samples);

snd_pcm_sframes_t snd_pcm_bytes_to_frames(snd_pcm_t* pcm, ssize_t bytes);
ssize_t snd_pcm_frames_to_bytes(snd_pcm_t* pcm, snd_pcm_sframes_t frames);
c_long snd_pcm_bytes_to_samples(snd_pcm_t* pcm, ssize_t bytes);
ssize_t snd_pcm_samples_to_bytes(snd_pcm_t* pcm, c_long samples);

int snd_pcm_area_silence(const snd_pcm_channel_area_t* dst_channel, snd_pcm_uframes_t dst_offset,
			 uint samples, snd_pcm_format_t format);
int snd_pcm_areas_silence(const snd_pcm_channel_area_t* dst_channels, snd_pcm_uframes_t dst_offset,
			  uint channels, snd_pcm_uframes_t frames, snd_pcm_format_t format);
int snd_pcm_area_copy(const snd_pcm_channel_area_t* dst_channel, snd_pcm_uframes_t dst_offset,
		      const snd_pcm_channel_area_t* src_channel, snd_pcm_uframes_t src_offset,
		      uint samples, snd_pcm_format_t format);
int snd_pcm_areas_copy(const snd_pcm_channel_area_t* dst_channels, snd_pcm_uframes_t dst_offset,
		       const snd_pcm_channel_area_t* src_channels, snd_pcm_uframes_t src_offset,
		       uint channels, snd_pcm_uframes_t frames, snd_pcm_format_t format);

enum snd_pcm_hook_type_t
{
	HW_PARAMS = 0,
	HW_FREE,
	CLOSE,
	LAST = CLOSE
}

struct snd_pcm_hook_t;
alias snd_pcm_hook_func_t = int function(snd_pcm_hook_t* hook);
snd_pcm_t* snd_pcm_hook_get_pcm(snd_pcm_hook_t* hook);
void* snd_pcm_hook_get_private(snd_pcm_hook_t* hook);
void snd_pcm_hook_set_private(snd_pcm_hook_t* hook, void* private_data);
int snd_pcm_hook_add(snd_pcm_hook_t** hookp, snd_pcm_t* pcm,
		     snd_pcm_hook_type_t type,
		     snd_pcm_hook_func_t func, void* private_data);
int snd_pcm_hook_remove(snd_pcm_hook_t* hook);

struct snd_pcm_scope_ops_t
{
	int function(snd_pcm_scope_t* scope_) enable;
	void function(snd_pcm_scope_t* scope_) disable;
	void function(snd_pcm_scope_t* scope_) start;
	void function(snd_pcm_scope_t* scope_) stop;
	void function(snd_pcm_scope_t* scope_) update;
	void function(snd_pcm_scope_t* scope_) reset;
	void function(snd_pcm_scope_t* scope_) close;
}

snd_pcm_uframes_t snd_pcm_meter_get_bufsize(snd_pcm_t* pcm);
uint snd_pcm_meter_get_channels(snd_pcm_t* pcm);
uint snd_pcm_meter_get_rate(snd_pcm_t* pcm);
snd_pcm_uframes_t snd_pcm_meter_get_now(snd_pcm_t* pcm);
snd_pcm_uframes_t snd_pcm_meter_get_boundary(snd_pcm_t* pcm);
int snd_pcm_meter_add_scope(snd_pcm_t* pcm, snd_pcm_scope_t* scope_);
snd_pcm_scope_t* snd_pcm_meter_search_scope(snd_pcm_t* pcm, const(char)* name);
int snd_pcm_scope_malloc(snd_pcm_scope_t** ptr);
void snd_pcm_scope_set_ops(snd_pcm_scope_t* scope_,
			   const snd_pcm_scope_ops_t* val);
void snd_pcm_scope_set_name(snd_pcm_scope_t* scope_, const(char)* val);
const(char)* snd_pcm_scope_get_name(snd_pcm_scope_t* scope_);
void* snd_pcm_scope_get_callback_private(snd_pcm_scope_t* scope_);
void snd_pcm_scope_set_callback_private(snd_pcm_scope_t* scope_, void* val);
int snd_pcm_scope_s16_open(snd_pcm_t* pcm, const(char)* name, snd_pcm_scope_t** scopep);
short* snd_pcm_scope_s16_get_channel_buffer(snd_pcm_scope_t* scope_, uint channel);

enum snd_spcm_latency_t
{
	STANDARD = 0,
	MEDIUM,
	REALTIME
}

enum snd_spcm_xrun_type_t
{
	IGNORE = 0,
	STOP
}

enum snd_spcm_duplex_type_t
{
	LIBERAL = 0,
	PEDANTIC
}

int snd_spcm_init(snd_pcm_t* pcm,
		  uint rate,
		  uint channels,
		  snd_pcm_format_t format,
		  snd_pcm_subformat_t subformat,
		  snd_spcm_latency_t latency,
		  snd_pcm_access_t _access,
		  snd_spcm_xrun_type_t xrun_type);

int snd_spcm_init_duplex(snd_pcm_t* playback_pcm,
			 snd_pcm_t* capture_pcm,
			 uint rate,
			 uint channels,
			 snd_pcm_format_t format,
			 snd_pcm_subformat_t subformat,
			 snd_spcm_latency_t latency,
			 snd_pcm_access_t _access,
			 snd_spcm_xrun_type_t xrun_type,
			 snd_spcm_duplex_type_t duplex_type);

int snd_spcm_init_get_params(snd_pcm_t* pcm,
			     uint* rate,
			     snd_pcm_uframes_t* buffer_size,
			     snd_pcm_uframes_t* period_size);

/* Deprecated functions, for compatibility */
deprecated:

const(char)* snd_pcm_start_mode_name(snd_pcm_start_t mode);
const(char)* snd_pcm_xrun_mode_name(snd_pcm_xrun_t mode);
int snd_pcm_sw_params_set_start_mode(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_start_t val);
snd_pcm_start_t snd_pcm_sw_params_get_start_mode(const(snd_pcm_sw_params_t)* params);
int snd_pcm_sw_params_set_xrun_mode(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_xrun_t val);
snd_pcm_xrun_t snd_pcm_sw_params_get_xrun_mode(const(snd_pcm_sw_params_t)* params);

int snd_pcm_sw_params_set_xfer_align(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, snd_pcm_uframes_t val);
int snd_pcm_sw_params_get_xfer_align(const(snd_pcm_sw_params_t)* params, snd_pcm_uframes_t* val);
int snd_pcm_sw_params_set_sleep_min(snd_pcm_t* pcm, snd_pcm_sw_params_t* params, uint val);
int snd_pcm_sw_params_get_sleep_min(const(snd_pcm_sw_params_t)* params, uint* val);

int snd_pcm_hw_params_get_tick_time(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_tick_time_min(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_get_tick_time_max(const(snd_pcm_hw_params_t)* params, uint* val, int* dir);
int snd_pcm_hw_params_test_tick_time(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_tick_time(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint val, int dir);
int snd_pcm_hw_params_set_tick_time_min(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_tick_time_max(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_tick_time_minmax(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* min, int* mindir, uint* max, int* maxdir);
int snd_pcm_hw_params_set_tick_time_near(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_tick_time_first(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
int snd_pcm_hw_params_set_tick_time_last(snd_pcm_t* pcm, snd_pcm_hw_params_t* params, uint* val, int* dir);
