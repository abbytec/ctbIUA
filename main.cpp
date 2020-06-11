#include <iostream>
#include <SDL.h>
#include <thread>
#include "imagenes.h"

typedef struct {
    uint8_t izq;       // 0
    uint8_t der;       // 1
    uint8_t arriba;    // 2
    uint8_t abajo;     // 3
    uint8_t A;         // 4
    uint8_t S;         // 5
    uint8_t D;         // 6
    uint8_t espacio;   // 7
    uint8_t frame;     // 8
} st_control;

//#include "test.h"

extern "C" void miMain(uint32_t *pixels, st_control *c);

const unsigned int width = 320;
const unsigned int height = 240;

Uint32 *pixels = new Uint32[width * height];
st_control cont;

int main() {
    bool quit = false;
    int startTicks;
    SDL_Event event;

    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window *window = SDL_CreateWindow("Parcial",
                                          SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, 0);

    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, 0);
    SDL_Texture *texture = SDL_CreateTexture(renderer,
                                             SDL_PIXELFORMAT_ARGB8888,
                                             SDL_TEXTUREACCESS_STATIC, width, height);

    memset(pixels, 255, width * height * sizeof(Uint32));

    std::thread th1(miMain, pixels, &cont);
    th1.detach();

    //Get the current clock time
    startTicks = SDL_GetTicks();
    while (!quit) {
        SDL_UpdateTexture(texture, NULL, pixels, width * sizeof(Uint32));


        while (SDL_PollEvent(&event)) {

            switch (event.type) {
                case SDL_QUIT:
                    quit = true;
                    break;

                case SDL_KEYDOWN:
                case SDL_KEYUP: {
                    int key = (event.type == SDL_KEYDOWN) ? 1 : 0;

                    switch (event.key.keysym.sym) {
                        case SDLK_LEFT:
                            cont.izq = key;
                            break;
                        case SDLK_RIGHT:
                            cont.der = key;
                            break;
                        case SDLK_UP:
                            cont.arriba = key;
                            break;
                        case SDLK_DOWN:
                            cont.abajo = key;
                            break;
                        case SDLK_a:
                            cont.A = key;
                            break;
                        case SDLK_s:
                            cont.S = key;
                            break;
                        case SDLK_d:
                            cont.D = key;
                            break;
                        case SDLK_SPACE:
                            cont.espacio = key;
                            break;
                    }

                }
                    break;
            }
        }

        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);
        cont.frame = 1;

        //If we want to cap the frame rate
        if( ( (SDL_GetTicks() - startTicks) < 1000 / 25 ) )
        {
            //Sleep the remaining frame time
            SDL_Delay( ( 1000 / 25 ) - (SDL_GetTicks() - startTicks) );
        }
//        std::cout << SDL_GetTicks() - startTicks << std::endl;
        startTicks = SDL_GetTicks();
    }

    delete[] pixels;
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);

    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
