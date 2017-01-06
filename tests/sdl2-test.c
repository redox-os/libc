#include <SDL2/SDL.h>
#include <stdio.h>
#include <time.h>

int log_events(){
    SDL_Event event;
    if(SDL_PollEvent(&event)){  /* Loop until there are no events left on the queue */
        switch(event.type){  /* Process the appropiate event type */
            case SDL_KEYDOWN:  /* Handle a KEYDOWN event */
                printf("Key down %d\n", event.key.keysym.sym);
                if(event.key.keysym.sym == SDLK_ESCAPE){
                    return 0;
                }
                break;
            case SDL_KEYUP:
                printf("Key up: %d\n", event.key.keysym.sym);
                break;
            case SDL_MOUSEMOTION:
                printf("Mouse motion\n");
                break;
            case SDL_QUIT:
                printf("Quit\n");
                return 0;
            default: /* Report an unhandled event */
                printf("Unknown Event: %d\n", event.type);
                break;
        }
    }
    return 1;
}

int main(int argc, char* argv[]) {
    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window * win = SDL_CreateWindow("Hello World!", 640, 480, 32, 0, SDL_WINDOW_SHOWN);

    if (win == NULL) {
        printf("Could not create window: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Renderer *ren = SDL_CreateRenderer(win, -1, 0);
    if (ren == NULL) {
        printf("Could not create renderer: %s\n", SDL_GetError());
        return 1;
    }

    time_t start = time(NULL);

    SDL_SetRenderDrawColor(ren, 0, 0, 0, 255);
    SDL_RenderFillRect(ren, NULL);
    SDL_RenderPresent(ren);

    while(time(NULL) - start < 1){
        log_events();
    }

    SDL_SetRenderDrawColor(ren, 255, 0, 0, 255);
    SDL_RenderFillRect(ren, NULL);
    SDL_RenderPresent(ren);

    while(time(NULL) - start < 2){
        log_events();
    }

    SDL_SetRenderDrawColor(ren, 0, 255, 0, 255);
    SDL_RenderFillRect(ren, NULL);
    SDL_RenderPresent(ren);

    while(time(NULL) - start < 3){
        log_events();
    }

    SDL_SetRenderDrawColor(ren, 0, 0, 255, 255);
    SDL_RenderFillRect(ren, NULL);
    SDL_RenderPresent(ren);

    while(time(NULL) - start < 4){
        log_events();
    }

    SDL_SetRenderDrawColor(ren, 255, 255, 255, 255);
    SDL_RenderFillRect(ren, NULL);
    SDL_RenderPresent(ren);

    while(log_events()){}

    SDL_Quit();

    return 0;
}
