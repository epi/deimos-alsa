module deimos.alsa.conf;

import core.stdc.config;

import deimos.alsa.input;
import deimos.alsa.output;

extern(C):

// #define SND_CONFIG_DLSYM_VERSION_EVALUATE	_dlsym_config_evaluate_001
// #define SND_CONFIG_DLSYM_VERSION_HOOK		_dlsym_config_hook_001

enum snd_config_type_t
{
    SND_CONFIG_TYPE_INTEGER,
    SND_CONFIG_TYPE_INTEGER64,
    SND_CONFIG_TYPE_REAL,
    SND_CONFIG_TYPE_STRING,
    SND_CONFIG_TYPE_POINTER,
	SND_CONFIG_TYPE_COMPOUND = 1024
}

struct snd_config_t;

struct _snd_config_iterator;
alias snd_config_iterator_t = _snd_config_iterator*;

struct snd_config_update_t;

extern __gshared snd_config_t* snd_config;

int snd_config_top(snd_config_t** config);

int snd_config_load(snd_config_t* config, snd_input_t* in_);
int snd_config_load_override(snd_config_t* config, snd_input_t* in_);
int snd_config_save(snd_config_t* config, snd_output_t* out_);
int snd_config_update();
int snd_config_update_r(snd_config_t** top, snd_config_update_t** update, const(char)* path);
int snd_config_update_free(snd_config_update_t* update);
int snd_config_update_free_global();

int snd_config_search(snd_config_t* config, const(char)* key, snd_config_t** result);
int snd_config_searchv(snd_config_t* config, snd_config_t** result, ...);
int snd_config_search_definition(snd_config_t* config, const(char)* base, const(char)* key, snd_config_t** result);

int snd_config_expand(snd_config_t* config, snd_config_t* root, const(char)* args, snd_config_t* private_data, snd_config_t** result);
int snd_config_evaluate(snd_config_t* config, snd_config_t* root, snd_config_t* private_data, snd_config_t** result);

int snd_config_add(snd_config_t* config, snd_config_t* leaf);
int snd_config_delete(snd_config_t* config);
int snd_config_delete_compound_members(const(snd_config_t)* config);
int snd_config_copy(snd_config_t** dst, snd_config_t* src);

int snd_config_make(snd_config_t** config, const(char)* key,
		    snd_config_type_t type);
int snd_config_make_integer(snd_config_t** config, const(char)* key);
int snd_config_make_integer64(snd_config_t** config, const(char)* key);
int snd_config_make_real(snd_config_t** config, const(char)* key);
int snd_config_make_string(snd_config_t** config, const(char)* key);
int snd_config_make_pointer(snd_config_t** config, const(char)* key);
int snd_config_make_compound(snd_config_t** config, const(char)* key, int join);

int snd_config_imake_integer(snd_config_t** config, const(char)* key, const(c_long) value);
int snd_config_imake_integer64(snd_config_t** config, const(char)* key, const(long) value);
int snd_config_imake_real(snd_config_t** config, const(char)* key, const(double) value);
int snd_config_imake_string(snd_config_t** config, const(char)* key, const(char)* ascii);
int snd_config_imake_pointer(snd_config_t** config, const(char)* key, const(void)* ptr);

snd_config_type_t snd_config_get_type(const(snd_config_t)* config);

int snd_config_set_id(snd_config_t* config, const(char)* id);
int snd_config_set_integer(snd_config_t* config, c_long value);
int snd_config_set_integer64(snd_config_t* config, long value);
int snd_config_set_real(snd_config_t* config, double value);
int snd_config_set_string(snd_config_t* config, const(char)* value);
int snd_config_set_ascii(snd_config_t* config, const(char)* ascii);
int snd_config_set_pointer(snd_config_t* config, const(void)* ptr);
int snd_config_get_id(const(snd_config_t)* config, const(char)** value);
int snd_config_get_integer(const(snd_config_t)* config, c_long* value);
int snd_config_get_integer64(const(snd_config_t)* config, long* value);
int snd_config_get_real(const(snd_config_t)* config, double* value);
int snd_config_get_ireal(const(snd_config_t)* config, double* value);
int snd_config_get_string(const(snd_config_t)* config, const(char)** value);
int snd_config_get_ascii(const(snd_config_t)* config, char** value);
int snd_config_get_pointer(const(snd_config_t)* config, const(void)** value);
int snd_config_test_id(const(snd_config_t)* config, const(char)* id);

snd_config_iterator_t snd_config_iterator_first(const(snd_config_t)* node);
snd_config_iterator_t snd_config_iterator_next(const snd_config_iterator_t iterator);
snd_config_iterator_t snd_config_iterator_end(const(snd_config_t)* node);
snd_config_t* snd_config_iterator_entry(const snd_config_iterator_t iterator);

int snd_config_get_bool_ascii(const(char)* ascii);
int snd_config_get_bool(const(snd_config_t)* conf);
int snd_config_get_ctl_iface_ascii(const(char)* ascii);
int snd_config_get_ctl_iface(const(snd_config_t)* conf);

struct snd_devname
{
	char* name;
	char* comment;
	snd_devname_t* next;
};
alias snd_devname_t = snd_devname;

int snd_names_list(const(char)* iface, snd_devname_t** list);
void snd_names_list_free(snd_devname_t* list);
