#ifndef MATRIX_H_
#define MATRIX_H_

#include <stdlib.h>
#include "bmp.h"

typedef unsigned char BYTE;

typedef struct 
{
    int width;
    int height;
    BYTE** data;
}Matrix;




Matrix* new_matrix(int height,int width,BYTE init_num);
int new_bmp_matrix(const char *filename,Matrix** image_R,Matrix** image_G,Matrix** image_B);
void write_bmp_matrix(const char *filename,Matrix* image_R,Matrix* image_G,Matrix* image_B);
void delete_matrix(Matrix* matrix);
BYTE anti_flow(int data);


#endif