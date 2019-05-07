//
//  main.c
//  test
//
//  Created by txooo on 2019/4/1.
//  Copyright © 2019 txooo. All rights reserved.
//

#include <stdio.h>
//#include <stdbool.h>
//#include <stdint.h>
//#include <stdatomic.h>
//#include <stdnoreturn.h>
//#include <stdlib.h>
#include <assert.h>
//#include <complex.h>
//
//#ifndef var
//#define var     __auto_type
//#endif
//


int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    static_assert(sizeof(long) == 8, "Not 64-bit environment!");
    return 0;
}


//int main() {
//    int a;
//    int b = 1;
//    a = b;
//    return a;
//}
