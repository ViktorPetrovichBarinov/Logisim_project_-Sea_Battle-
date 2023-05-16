#include <stdio.h>
int numberOfMessages = 17;
char * array[256] = {   /*1*/"This game is \"Sea Battle\"!\n"
                        "Have a good time!\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*2*/"Well, we need to arrange the ships.\n"
                        "There is a keyboard below.\n"
                        "Enter the coordinates of the ships\n"
                        "I will ask for.\n"
                        "First a letter, then a digit.\n"
                        "For example: A2 or a2\n"
                        "\n"
                        "Click the \"Red Button\" to continue.",

                        /*3*/"Ships cannot be neighbors.\n"
                        "You will have:\n"
                        "1 ship with a length of 4.\n"
                        "2 ships 3 in length.\n"
                        "3 ships 2 in length.\n"
                        "4 ships 1 in length.\n"
                        "\n"
                        "Click the \"Red Button\" to continue.",

                        /*4*/"Enter the first coordinate\n"
                        "of the ship of length 4\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*5*/"Enter the second coordinate\n"
                        "of the ship of length 4\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*6*/"Enter the first coordinate\n"
                        "of the ship of length 3\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*7*/"Enter the second coordinate\n"
                        "of the ship of length 3\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*8*/"Enter the first coordinate\n"
                        "of the ship of length 2\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*9*/"Enter the second coordinate\n"
                        "of the ship of length 2\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*10*/"Enter one coordinate "
                              "for a ship of length 1\n"
                        "\n\n\n\n\n"
                        "Click the \"Red Button\" to continue.",

                        /*11*/"The field is being printed.\n"
                        "Please wait!\n"
                        "   Please wait!\n"
                        "      Please wait!\n"
                        "         Please wait!\n"
                        "            Please wait!\n"
                        "               Please wait!\n"
                        "                  Please wait!",

                        /*12*/"You have entered an incorrect symbols.\n"
                              "Please try again.\n"
                              "\n\n\n\n\n"
                              "Click the \"Red Button\" to continue.",

                        /*13*/"You have entered coordinates\n"
                              "of incorrect length.\n"
                              "Please try again.\n"
                              "\n\n\n\n"
                              "Click the \"Red Button\" to continue.",
                        /*14*/"You have entered incorrect coordinates\n"
                              "Please try again.\n"
                              "\n\n\n\n\n"
                              "Click the \"Red Button\" to continue.",
                        /*15*/"Your coordinates intersect\n"
                              "with other ships or are their neighbors.\n"
                              "\n\n\n\n\n"
                              "Click the \"Red Button\" to continue.",
                        /*16*/ "The ship was successfully delivered!\n"
                               "\n\n\n\n\n\n"
                              "Click the \"Red Button\" to continue.",
                        /*17*/ "L    OOOO  AA     D O N  N  GG\n"
                                    "L    O  O A  A  DDD I NN N    G\n"
                                    "L    O  O AAAA D  D I N NN GG G\n"
                                    "LLLL OOOO A  A  DDD I N  N  GG\n"
                                    "\n\n\n"
                                    "Please, wait!"


};




int main() {
    FILE * fileoutForMe = fopen("image.txt", "w");
    if (fileoutForMe == NULL) {
        printf("image.txt doesn't opened\n");
        return 1;
    }
    FILE * fileout = fopen("image_for_message.txt", "w");
    if (fileout == NULL) {
        printf("image_for_message.txt doesn't opened\n");
        return 1;
    }
    FILE * constfile = fopen("const.txt", "w");
    if (constfile == NULL) {
        printf("const.txt doesn't opened\n");
        return 1;
    }
    fprintf(fileout, "v2.0 raw\n");
    fprintf(fileoutForMe, "v2.0 raw\n");
    fprintf(constfile, "Quantity of messages - %d\n", numberOfMessages);


    int address = 0;//8 битов адресса

    // asdfasdf00000000|a000000000000000
    for (int i = 0; i < numberOfMessages; i++){
        int index = 0; //4 бита для блока
        fprintf(constfile, "Address - %d  ↓\n", address);// вывод в текстовый с константами для меня
        fprintf(constfile, "-----------------------------\n");
        while(1){

            fprintf(constfile, "%c", array[i][index]);
            fprintf(fileout, "%x\n", array[i][index]);
            fprintf(fileoutForMe, "%x\n", array[i][index]);
            if (array[i][index] == '\0'){
                index++;
                if (index % 16 == 0){
                    address += index / 16;
                }
                else {
                    address += (index / 16) + 1;
                }
                //address += index / 16;
                break;
            }

            index++;

        }
        fprintf(constfile, "\n-----------------------------\n");
        while(index % 16 != 0){
            fprintf(fileout, "00\n");
            fprintf(fileoutForMe, "00\n");
            index++;
        }
    }

    return 0;
}









