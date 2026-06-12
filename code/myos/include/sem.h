#ifndef __SEM_H__
#define __SEM_H__

#define SEM_MAX  16

void sem_init(void);
int  sem_create(int initial);
int  sem_getval(int id);
int  sem_wait(int id);
int  sem_post(int id);

#endif /* __SEM_H__ */
