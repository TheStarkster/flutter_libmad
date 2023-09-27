#include "mad.h"
#include <stdio.h>
#include <stdint.h>
// Define the callback type
typedef void (*DecodeCallback)(const int16_t *, int);

__attribute__((visibility("default"))) __attribute__((used)) void decode_file(const char *file_path, DecodeCallback callback);

void decode_file(const char *file_path, DecodeCallback callback) {
    printf("Entered decode_file\n");
    FILE *file = fopen(file_path, "rb");
    if (!file) {
        fprintf(stderr, "Failed to open file: %s\n", file_path);
        return;
    }
    printf("File opened successfully\n");

    struct mad_stream stream;
    struct mad_frame frame;
    struct mad_synth synth;

    mad_stream_init(&stream);
    mad_frame_init(&frame);
    mad_synth_init(&synth);

    unsigned char input_buffer[8192];
    while (1) {
        size_t bytes_read = fread(input_buffer, 1, sizeof(input_buffer), file);
        if (bytes_read == 0) {
            if (feof(file)) {
                printf("End of file reached\n");
            } else {
                fprintf(stderr, "Read error\n");
            }
            break;
        }
        printf("Read %zu bytes\n", bytes_read);

        mad_stream_buffer(&stream, input_buffer, bytes_read);

        while (1) {
            if (mad_frame_decode(&frame, &stream)) {
                if (MAD_RECOVERABLE(stream.error)) {
                    fprintf(stderr, "Recoverable frame error: %s\n", mad_stream_errorstr(&stream));
                    continue;
                } else if (stream.error == MAD_ERROR_BUFLEN) {
                    printf("Buffer length error\n");
                    break;
                } else {
                    fprintf(stderr, "Unrecoverable frame error: %s\n", mad_stream_errorstr(&stream));
                    return;
                }
            }
            printf("Frame decoded successfully\n");

            mad_synth_frame(&synth, &frame);
            printf("Synth frame successful\n");

            // Assuming 16-bit PCM output
            int16_t pcm_out[synth.pcm.length];
            for (int i = 0; i < synth.pcm.length; i++) {
                // Convert from libmad's fixed-point format to 16-bit PCM
                pcm_out[i] = (int16_t)(synth.pcm.samples[0][i] >> (MAD_F_FRACBITS - 15));
            }
            printf("PCM data prepared, invoking callback\n");

            // Call the callback function with the PCM data
            callback(pcm_out, synth.pcm.length);
        }
    }

    mad_synth_finish(&synth);
    mad_frame_finish(&frame);
    mad_stream_finish(&stream);
    fclose(file);
    printf("File closed, decoding complete\n");
}
