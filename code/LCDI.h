#ifndef LCDI_H_
#define LCDI_H_

#include "matrix.h"
#include "weight.h"
#include <pthread.h>

void LCDI(Matrix* sR,Matrix* sG,Matrix* sB,Matrix** dR,Matrix** dG,Matrix** dB);
void multi_thread_LCDI(Matrix* sR,Matrix* sG,Matrix* sB,Matrix** dR,Matrix** dG,Matrix** dB);
void LCDI_channel(Matrix* src,Matrix** des);

#endif
