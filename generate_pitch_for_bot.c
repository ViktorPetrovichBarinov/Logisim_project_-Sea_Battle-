#include <stdio.h>
#include <stdlib.h>
int pitch[100];
FILE * fileout;


void print_pitch(){
    for (int i = 0; i < 10; i++){
        for (int j = 0; j < 10; j++){
            if (pitch[i * 10 + j] == 0){
                printf("~");
            }
            if (pitch[i * 10 + j] == 1){
                printf("#");
            }
            if (pitch[i * 10 + j] == 2){
                printf("!");
            }
        }
        printf("\n");
    }
}

void swap(int * a, int * b){
    if (*a > *b){
    }
    else{
        int tmp = *a;
        *a = *b;
        *b = tmp;
    }
}

void initial(){
    for (int i = 0; i < 10; i++){
        for (int j = 0; j < 10; j++){
            pitch[i*10 + j] = 0;
        }
    }
}

void load_cell(int a){
    pitch[a] = 1;
    if (a > 9 && a % 10 != 0){
        int leftup = a - 11;
        if (pitch[leftup] != 1){
            pitch[leftup] = 2;
        }
    }
    if (a > 9){
        int up = a - 10;
        if (pitch[up] != 1){
            pitch[up] = 2;
        }
    }
    if (a > 9 && a % 10 != 9){
        int rightup = a - 9;
        if (pitch[rightup] != 1){
            pitch[rightup] = 2;
        }
    }
    if (a % 10 != 9){
        int right = a + 1;
        if (pitch[right] != 1){
            pitch[right] = 2;
        }
    }
    if (a % 10 != 0){
        int left = a - 1;
        if (pitch[left] != 1){
            pitch[left] = 2;
        }
    }
    if (a < 90 && a % 10 != 0){
        int leftdown = a + 9;
        if (pitch[leftdown] != 1){
            pitch[leftdown] = 2;
        }
    }
    if (a < 90){
        int down = a + 10;
        if (pitch[down] != 1){
            pitch[down] = 2;
        }
    }
    if (a < 90 && a % 10 != 9){
        int downright = a + 11;
        if (pitch[downright] != 1){
            pitch[downright] = 2;
        }
    }
}


int load_ship(int a, int b, int len){

    swap(&a, &b);
    // a - большая корда, b - меньшая корда
    if (a - b != len && ((a - b)/10 != len && (a - b % 10) == 0)){
        return -1;
    }

    if (a - b == len){
        int current_index = b;
        while(1){
            if (pitch[current_index] != 0){
                return 0;
            }
            if (current_index == a){
                break;
            }
            current_index++;
        }
        current_index = b;
        while(1){
            load_cell(current_index);
            if (current_index == a){
                break;
            }
            current_index++;
        }
    }

    else{
        int current_index = b;
        while(1){
            if (pitch[current_index] != 0){
                return 0;
            }
            if (current_index == a){
                break;
            }
            current_index+= 10;
        }
        current_index = b;
        while(1){
            load_cell(current_index);
            if (current_index == a){
                break;
            }
            current_index+= 10;
        }
    }
    return 1;



}

void rand_load_ship(int len){
    while(1){
        int fst_random_cord = rand() % 100;
        int snd_random_cord;
        int random_direct = rand() % 2;
        if (random_direct){
            snd_random_cord = fst_random_cord + len;
        }
        else{
            snd_random_cord = fst_random_cord + len*10;
        }
        if (load_ship(fst_random_cord, snd_random_cord, len)){
            return;
        }
    }
}
//int current_index = 0;
void file_pitch(){
    for (int i = 0; i < 100; i++){
        if (pitch[i] == 0){
            fprintf(fileout, "%d\n", '~');
        }
        if (pitch[i] == 1){
            fprintf(fileout, "%d\n", '#');
        }
        if (pitch[i] == 2){
            fprintf(fileout, "%d\n", '!');
        }
    }
}

int main() {
    fileout = fopen("output.txt", "w");
    fprintf(fileout, "v2.0 raw\n");
    for (int i = 0; i < 40; i++){
        initial();
        rand_load_ship(3);
        rand_load_ship(2);
        rand_load_ship(2);
        rand_load_ship(1);
        rand_load_ship(1);
        rand_load_ship(1);
        rand_load_ship(0);
        rand_load_ship(0);
        rand_load_ship(0);
        rand_load_ship(0);
        print_pitch();
        printf("-------------------------------\n");
        file_pitch();


    }
    print_pitch();




    return 0;
}
