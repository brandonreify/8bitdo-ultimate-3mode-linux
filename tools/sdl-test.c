#include <SDL2/SDL.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1");

    if (SDL_Init(SDL_INIT_GAMECONTROLLER) < 0) {
        fprintf(stderr, "%s\n", SDL_GetError());
        return 1;
    }

    if (argc > 1) {
        int count = SDL_GameControllerAddMappingsFromFile(argv[1]);
        printf("Mappings added: %d\n", count);
    }

    SDL_GameController *controller = NULL;

    for (int i = 0; i < SDL_NumJoysticks(); i++) {
        char guid[33];
        SDL_JoystickGetGUIDString(
            SDL_JoystickGetDeviceGUID(i), guid, sizeof(guid));

        printf("Device: %s\n", SDL_JoystickNameForIndex(i));
        printf("GUID: %s\n", guid);

        if (!controller &&
            SDL_JoystickGetDeviceVendor(i) == 0x2dc8 &&
            SDL_JoystickGetDeviceProduct(i) == 0x901b &&
            SDL_IsGameController(i)) {
            controller = SDL_GameControllerOpen(i);
        }
    }

    if (!controller) {
        fprintf(stderr, "Target game controller not available.\n");
        SDL_Quit();
        return 1;
    }

    char *mapping = SDL_GameControllerMapping(controller);
    printf("Active mapping: %s\n", mapping ? mapping : "(none)");
    SDL_free(mapping);

    printf("\nPress controller buttons. Ctrl+C to exit.\n");
    fflush(stdout);

    SDL_Event event;

    while (SDL_WaitEvent(&event)) {
        if (event.type == SDL_CONTROLLERBUTTONDOWN ||
            event.type == SDL_CONTROLLERBUTTONUP) {
            printf("Mapped button: %s | %s\n",
                SDL_GameControllerGetStringForButton(
                    event.cbutton.button),
                event.cbutton.state ? "PRESSED" : "RELEASED");
        }

        if (event.type == SDL_JOYBUTTONDOWN ||
            event.type == SDL_JOYBUTTONUP) {
            printf("Raw button: b%d | %s\n",
                event.jbutton.button,
                event.jbutton.state ? "PRESSED" : "RELEASED");
        }

        fflush(stdout);
    }

    SDL_GameControllerClose(controller);
    SDL_Quit();
    return 0;
}
