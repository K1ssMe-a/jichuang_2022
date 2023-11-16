#include "LCDI.h"

static int get_index(int G0,int G1);

static int classify(int G0);



void LCDI_channel(Matrix* src,Matrix** des)
{
    Matrix* tmp_inter=new_matrix(2160,960,0);
    *des=new_matrix(2160,3840,0);

    for(int i=0;i<540;i++)
    {
        int up_index=i-1;
        int low_index=i+1;
        if(i==0)
        {
            up_index=0;
        }
        if(i==539)
        {
            low_index=539;
        }

        for(int j=0;j<960;j++)
        {
            int data_up =src->data[up_index][j];
            int data_mid=src->data[i][j];
            int data_low=src->data[low_index][j];

            int C0=data_up-data_mid;
            int C1=data_low-data_mid;

            int index=get_index(C0,C1);

            tmp_inter->data[i*4][j]  =anti_flow(W_VU1[index][0]*data_up+W_VU1[index][1]*data_mid+W_VU1[index][2]*data_low);
            tmp_inter->data[i*4+1][j]=anti_flow(W_VU2[index][0]*data_up+W_VU2[index][1]*data_mid+W_VU2[index][2]*data_low);
            tmp_inter->data[i*4+2][j]=anti_flow(W_VL1[index][0]*data_up+W_VL1[index][1]*data_mid+W_VL1[index][2]*data_low);
            tmp_inter->data[i*4+3][j]=anti_flow(W_VL2[index][0]*data_up+W_VL2[index][1]*data_mid+W_VL2[index][2]*data_low);
        }
    }

    for(int i=0;i<960;i++)
    {
        int left_index=i-1;
        int right_index=i+1;

        if(i==34)
        {
            left_index=i-1;
        }

        if(i==0)
        {
            left_index=0;
        }
        if(i==959)
        {
            right_index=959;
        }
            
        for(int j=0;j<2160;j++)
        {
            int data_up =tmp_inter->data[j][left_index];
            int data_mid=tmp_inter->data[j][i];
            int data_low=tmp_inter->data[j][right_index];
            int C0=data_up-data_mid;
            int C1=data_low-data_mid;
            int index=get_index(C0,C1);

            (*des)->data[j][i*4]  =anti_flow(W_HL1[index][0]*data_up+W_HL1[index][1]*data_mid+W_HL1[index][2]*data_low);
            (*des)->data[j][i*4+1]=anti_flow(W_HL2[index][0]*data_up+W_HL2[index][1]*data_mid+W_HL2[index][2]*data_low);
            (*des)->data[j][i*4+2]=anti_flow(W_HR1[index][0]*data_up+W_HR1[index][1]*data_mid+W_HR1[index][2]*data_low);
            (*des)->data[j][i*4+3]=anti_flow(W_HR2[index][0]*data_up+W_HR2[index][1]*data_mid+W_HR2[index][2]*data_low);
        }
    }

    delete_matrix(tmp_inter);
}


int get_index(int G0,int G1)
{
    return classify(G0)+9*classify(G1);
}

int classify(int G0)
{
    int Sub_C;

    if(G0>=-4 && G0<4)
       Sub_C = 4;
    else if(G0>=-16 && G0<-4)
       Sub_C = 5;
    else if(G0>=4 && G0<16)
       Sub_C = 3;
    else if(G0>=-32 && G0<-16)
       Sub_C = 6;
    else if(G0>=16 && G0<32)
       Sub_C = 2;
    else if(G0>=-48 && G0<-32)
       Sub_C = 7;
    else if(G0>=32 && G0<48)
       Sub_C = 1;
    else if(G0<-48)
       Sub_C = 8;
    else
       Sub_C = 0;

    return Sub_C;
}
