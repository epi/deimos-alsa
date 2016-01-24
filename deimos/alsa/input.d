module deimos.alsa.input;

import core.sys.posix.sys.types : ssize_t;
import core.stdc.stdio : FILE;

extern(C):

struct snd_input_t;

enum snd_input_type_t
{
	SND_INPUT_STDIO,
	SND_INPUT_BUFFER
}

int snd_input_stdio_open(snd_input_t** inputp, const(char)* file, const(char)* mode);
int snd_input_stdio_attach(snd_input_t** inputp, FILE* fp, int _close);
int snd_input_buffer_open(snd_input_t** inputp, const(char)* buffer, ssize_t size);
int snd_input_close(snd_input_t* input);
int snd_input_scanf(snd_input_t* input, const(char)* format, ...);
char* snd_input_gets(snd_input_t* input, char* str, size_t size);
int snd_input_getc(snd_input_t* input);
int snd_input_ungetc(snd_input_t* input, int c);
