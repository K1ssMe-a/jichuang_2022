#include <stdio.h>
#include <pthread.h>

#include "bmp.h"
#include "matrix.h"
#include "LCDI.h"

void * R_thread(void *arg);
void * G_thread(void *arg);
void * B_thread(void *arg);
void test_LCDI(char src_address[],char des_address[],int number);
void test_thread_LCDI(char src_address[],char des_address[],int number);

Matrix * thread_srcR,* thread_srcG,* thread_srcB;
Matrix * thread_desR,* thread_desG,* thread_desB;



int main(void)
{
    char src_address[100]="/home/txr/Desktop/jichuang/picture/downscaled/";
    char des_address[100]="/home/txr/Desktop/jichuang/picture/3LCDI/";
    int number=46;


    test_LCDI(src_address,des_address,number);

    return 0;
}


void test_thread_LCDI(char src_address[],char des_address[],int number)
{
    char src_image_address[200]={0};
    char des_image_address[200]={0};


    for(int i=0;i<=number;i++)
    {
        sprintf(src_image_address,"%s/%d.bmp",src_address,i);
        sprintf(des_image_address,"%s/%d.bmp",des_address,i);

        new_bmp_matrix(src_image_address,&thread_srcR,&thread_srcG,&thread_srcB);

        pthread_t t_R_thread,t_G_thread,t_B_thread;

        pthread_create(&t_R_thread, NULL,R_thread, NULL);
        pthread_create(&t_G_thread, NULL,G_thread, NULL); 
        pthread_create(&t_B_thread, NULL,B_thread, NULL); 

        pthread_join(t_R_thread,NULL);
        pthread_join(t_G_thread,NULL);
        pthread_join(t_B_thread,NULL);
  
        write_bmp_matrix(des_image_address,thread_desR,thread_desG,thread_desB);
        
        delete_matrix(thread_srcR);
        delete_matrix(thread_srcG);
        delete_matrix(thread_srcB);
        delete_matrix(thread_desR);
        delete_matrix(thread_desG);
        delete_matrix(thread_desB);
    }     
}

void test_LCDI(char src_address[],char des_address[],int number)
{
    Matrix * srcR,* srcG,* srcB;
    Matrix * desR,* desG,* desB;
    
    char src_image_address[200]={0};
    char des_image_address[200]={0};


    for(int i=0;i<=number;i++)
    {
        sprintf(src_image_address,"%s/%d.bmp",src_address,i);
        sprintf(des_image_address,"%s/%d.bmp",des_address,i);

        new_bmp_matrix(src_image_address,&srcR,&srcG,&srcB);
        LCDI_channel(srcR,&desR);
        LCDI_channel(srcG,&desG);
        LCDI_channel(srcB,&desB);
        
        write_bmp_matrix(des_image_address,desR,desG,desB);
        
        delete_matrix(srcR);
        delete_matrix(srcG);
        delete_matrix(srcB);
        delete_matrix(desR);
        delete_matrix(desG);
        delete_matrix(desB);
    }    
}


void * R_thread(void *arg)
{
    LCDI_channel(thread_srcR,&thread_desR);
}

void * G_thread(void *arg)
{
    LCDI_channel(thread_srcG,&thread_desG);
}

void * B_thread(void *arg)
{
    LCDI_channel(thread_srcB,&thread_desB);
}
