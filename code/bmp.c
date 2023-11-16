#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "bmp.h"

BMPImage *bmp_read(const char *filename)
{
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        printf("file %s open failed!\n", filename);
        goto OPEN_FAIL;
    }

    BMPImage *img = malloc(sizeof(BMPImage));
    if (!img) {
        printf("image malloc fail!\n");
        goto IMG_MALLOC_FAIL;
    }

    fread(&img->header, 1, sizeof(BMPHeader), fp);
    if (img->header.type != 0x4D42) {
        printf("illegal bmp file %s", filename);
        goto NOT_BMP;
    }

    if (!img->header.image_size_bytes) {
        img->header.image_size_bytes = img->header.size - img->header.offset;
    }

    Pixel *pixel_data = malloc(img->header.image_size_bytes);
    if (!pixel_data) {
        printf("pixel data malloc fail!\n");
        goto PIX_MALLOC_FAIL;
    }

    rewind(fp);
    fread(pixel_data, 1, img->header.offset, fp);
    fread(pixel_data, 1,  img->header.image_size_bytes, fp);
    img->data = pixel_data;


    fclose(fp);

    return img;

PIX_MALLOC_FAIL:

NOT_BMP:
    free(img);
IMG_MALLOC_FAIL:
    fclose(fp);
OPEN_FAIL:
    return 0;
}


BMPImage *bmp_create(uint32_t width, uint32_t height) {
    BMPImage *img = malloc(sizeof(BMPImage));
    if (!img) {
        printf("img create malloc fail!\n");
        return 0;
    }
    memset(img, 0, sizeof(BMPImage));
    img->data = malloc(width * height * 3);
    if (!img->data) {
        printf("img create data malloc fail!\n");
        return 0;
    }

    BMPHeader *h = &img->header;
    h->type = 0x4D42;
    h->size = width * height * 3 + 54;
    h->offset = 54;
    h->dib_header_size = 40;
    h->width_px = width;
    h->height_px = height;
    h->num_planes = 1;
    h->bits_per_pixel = 24;
    h->compression = 0;
    h->image_size_bytes = width * height * 3;


    return img;
}


int32_t   bmp_write(BMPImage *img, const char *filename)
{
    FILE *fp = fopen(filename, "wb+");
    if (!fp) {
        printf("open/create file %s failed!\n", filename);
        return -1;
    }

    fwrite(&img->header, 1, sizeof(BMPHeader), fp);
    fwrite(img->data, 1, img->header.image_size_bytes, fp);
    return 0;
}

Pixel    *bmp_pixel_at(BMPImage *img, uint32_t x, uint32_t y)
{
    if (x >= img->header.width_px || y >= img->header.height_px) {
        return 0;
    }
    return (Pixel *)((void *)img->data + (x + y * img->header.width_px) * img->header.bits_per_pixel / 8);
}

void bmp_print_header(BMPImage *img)
{
    BMPHeader *h = &img->header;
    printf("type=%x\n", h->type);             
    printf("size=%u\n", h->size);            
    printf("reserved1=%u\n", h->reserved1);       
    printf("reserved2=%u\n", h->reserved2);       
    printf("offset=%u\n", h->offset);           
    printf("dib_header_size=%u\n", h->dib_header_size);  
    printf("width_px=%d\n", h->width_px);        
    printf("height_px=%d\n", h->height_px);       
    printf("num_planes=%u\n", h->num_planes);       
    printf("bits_per_pixel=%u\n", h->bits_per_pixel);  
    printf("compression=%u\n", h->compression);     
    printf("image_size_bytes=%u\n", h->image_size_bytes);
    printf("x_resolution_ppm=%d\n", h->x_resolution_ppm);
    printf("y_resolution_ppm=%d\n", h->y_resolution_ppm);
    printf("num_colors=%u\n", h->num_colors);      
    printf("important_colors=%u\n", h->important_colors);
}

void delete_bmp(BMPImage *img)
{
    free(img->data);
    free(img);
}
