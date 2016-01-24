module deimos.alsa.output;

import core.sys.posix.sys.types : ssize_t;
import core.stdc.stdio : FILE;
import core.stdc.stdarg : va_list;

extern(C):

struct snd_output_t;

enum snd_output_type_t
{
	SND_OUTPUT_STDIO,
	SND_OUTPUT_BUFFER
}

int snd_output_stdio_open(snd_output_t** outputp, const(char)* file, const(char)* mode);
int snd_output_stdio_attach(snd_output_t** outputp, FILE* fp, int _close);
int snd_output_buffer_open(snd_output_t** outputp);
size_t snd_output_buffer_string(snd_output_t* output, char** buf);
int snd_output_close(snd_output_t* output);
int snd_output_printf(snd_output_t* output, const(char)* format, ...);
int snd_output_vprintf(snd_output_t* output, const(char)* format, va_list args);
int snd_output_puts(snd_output_t* output, const(char)* str);
int snd_output_putc(snd_output_t* output, int c);
int snd_output_flush(snd_output_t* output);
