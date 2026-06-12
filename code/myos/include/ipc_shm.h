#ifndef __IPC_SHM_H__
#define __IPC_SHM_H__

#include "types.h"

#define USER_IPC_BASE  0x80460000UL

int ipc_shm_map(int pid);

#endif /* __IPC_SHM_H__ */
