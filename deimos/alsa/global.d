module deimos.alsa.global;

import core.sys.posix.sys.time : timeval, timespec;

extern(C):

const(char)* snd_asoundlib_version();

struct snd_dlsym_link
{
	snd_dlsym_link* next;
	const(char)* dlsym_name;
	const(void)* dlsym_ptr;
};

extern snd_dlsym_link* snd_dlsym_start;

void* snd_dlopen(const(char)* file, int mode);
void* snd_dlsym(void* handle, const(char)* name, const(char)* version_);
int snd_dlclose(void* handle);

struct snd_async_handler_t;

alias snd_async_callback_t = void function(snd_async_handler_t *handler);

int snd_async_add_handler(snd_async_handler_t** handler, int fd, snd_async_callback_t callback, void* private_data);
int snd_async_del_handler(snd_async_handler_t* handler);
int snd_async_handler_get_fd(snd_async_handler_t* handler);
int snd_async_handler_get_signo(snd_async_handler_t* handler);
void* snd_async_handler_get_callback_private(snd_async_handler_t* handler);

struct snd_shm_area;

snd_shm_area* snd_shm_area_create(int shmid, void* ptr);
snd_shm_area* snd_shm_area_share(snd_shm_area* area);
int snd_shm_area_destroy(snd_shm_area* area);

int snd_user_file(const(char)* file, char** result);

alias snd_timestamp_t = timeval;
alias snd_htimestamp_t = timespec;
