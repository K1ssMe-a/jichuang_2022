#include "matrix.h"


Matrix* new_matrix(int height,int width,BYTE init_num)
{
    Matrix* matrix=(Matrix*)malloc(sizeof(Matrix));

    matrix->data = (BYTE**)malloc(height * sizeof(BYTE*));
    if(matrix->data==NULL)
    {
        return NULL;
    }
    matrix->data[0] = (BYTE*)malloc(height * width * sizeof(BYTE));

    if(matrix->data[0]==NULL)
    {
        return NULL;
    }

    for(int i=1;i<height;i++)
    {
        matrix->data[i] = matrix->data[0] + width * i;
    }

    matrix->width=width;
    matrix->height=height;
    for(int i=0;i<height;i++)
    {
        for(int j=0;j<width;j++)
        {
            matrix->data[i][j] = init_num;
        }
    }

    return matrix;
}

void delete_matrix(Matrix* matrix)
{
    if(matrix->data[0]!=NULL&&matrix->data!=NULL)
    {
        free(matrix->data[0]);
        free(matrix->data);
        matrix->width=0;
        matrix->height=0;
    }
}

int new_bmp_matrix(const char *filename,Matrix** image_R,Matrix** image_G,Matrix** image_B)
{
    BMPImage* bmp_image=bmp_read(filename);
    if(bmp_image==NULL)
    {
        return 0;
    }

    (*image_R)=new_matrix(bmp_image->header.height_px,bmp_image->header.width_px,0);
    (*image_B)=new_matrix(bmp_image->header.height_px,bmp_image->header.width_px,0);
    (*image_G)=new_matrix(bmp_image->header.height_px,bmp_image->header.width_px,0);
    
    if((*image_R)==NULL||(*image_B)==NULL||(*image_G)==NULL)
    {
        return 0;
    }


    Pixel* pixel=NULL;
    int height=bmp_image->header.height_px;
    for(int i=0;i<height;i++)
    {    
        for(int j=0;j<bmp_image->header.width_px;j++)
        {
            pixel=bmp_pixel_at(bmp_image,j,i);
            (*image_R)->data[height-1-i][j]=pixel->r;
            (*image_G)->data[height-1-i][j]=pixel->g;
            (*image_B)->data[height-1-i][j]=pixel->b;
        }
    }

    /*for(int i=0;i<height;i++)
    {    
        for(int j=0;j<bmp_image->header.width_px;j++)
        {
            pixel=bmp_pixel_at(bmp_image,j,i);
            (*image_R)->data[i][j]=pixel->r;
            (*image_G)->data[i][j]=pixel->g;
            (*image_B)->data[i][j]=pixel->b;
        }
    }*/

    delete_bmp(bmp_image);
    return 1;
}

void write_bmp_matrix(const char *filename,Matrix* image_R,Matrix* image_G,Matrix* image_B)
{
    BMPImage* bmp_image=bmp_create(image_R->width,image_R->height);
    

    Pixel* pixel=NULL;  char src_address[100]="/home/txr/Desktop/jichuang/picture/downscaled/";
    char des_address[100]="/home/txr/Desktop/jichuang/picture/3LCDI/";
    int number=46;
    int height=bmp_image->header.height_px;
    for(int i=0;i<height;i++)
    {    
        for(int j=0;j<bmp_image->header.width_px;j++)
        {
            pixel=bmp_pixel_at(bmp_image,j,i);
            pixel->b=image_B->data[height-1-i][j];
            pixel->g=image_G->data[height-1-i][j];
            pixel->r=image_R->data[height-1-i][j];
            pixel->a=0;
        }
    }

    /*for(int i=0;i<height;i++)
    {    
        for(int j=0;j<bmp_image->header.width_px;j++)
        {
            pixel=bmp_pixel_at(bmp_image,j,i);
            pixel->b=image_B->data[i][j];
            pixel->g=image_G->data[i][j];
            pixel->r=image_R->data[i][j];
            pixel->a=0;
        }
    }*/

    bmp_write(bmp_image,filename);
    delete_bmp(bmp_image);
}


BYTE anti_flow(int data)
{
    if(data<0)
    {
        return 0;
    }
    else if((data&0x80))
    {
        if( (data+256)&0xffff0000)
        {
            return 255;
        }
        else
        {
            return (data+256)>>8;
        }
    }
    else 
    {
        if( data&0xffff0000)
        {
            return 255;
        }
        else
        {
            return data>>8;
        }
    }
}
