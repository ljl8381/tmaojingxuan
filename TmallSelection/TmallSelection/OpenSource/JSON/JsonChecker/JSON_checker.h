/* JSON_checker.h */

#ifndef __JSON_CHECKER_H__
#define __JSON_CHECKER_H__

typedef struct JSON_checker_struct {
    int state;
    int depth;
    int top;
    int* stack;
} * JSON_checker;


extern JSON_checker new_JSON_checker(int depth);

/* [modify by hujunjie, 2010/12/13 11:12] */
extern void	JSON_Init(JSON_checker jc);

extern int  JSON_checker_char(JSON_checker jc, int next_char);
extern int  JSON_checker_done(JSON_checker jc);

#endif // __JSON_CHECKER_H__

