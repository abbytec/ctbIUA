#include <cstdint>

#ifndef PROYECTOASM_TEST_H
#define PROYECTOASM_TEST_H


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"

void miMain(uint32_t *pixels, st_control *c) {
    int x = 0;
    int y = 0;
    while (1) {
        if (c->izq) {
            x -= 1;
        }
        if (c->der) {
            x += 1;
        }
        if (c->arriba) {
            y -= 1;
        }
        if (c->abajo) {
            y += 1;
        }
        memset(pixels, 255, 320 * 240 * sizeof(Uint32));
        for (int i = 0; i < nave.h; i++)
            for (int j = 0; j < nave.w; j++) {
                if (nave.datos[(i * nave.w + j)] != 0xff000000)
                    pixels[((y + i) * 320 + (j + x))] = nave.datos[(i * nave.w + j)];
            }


        while (!c->frame);
        c->frame = 0;
    }
}

#pragma clang diagnostic pop

#endif //PROYECTOASM_TEST_H
