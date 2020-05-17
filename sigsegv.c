#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "hiredis/hiredis.h"

void redisThread(int argc, char *argv[]){
    unsigned int j, isunix = 0;
    redisContext *c;
    redisReply *reply;
    const char *hostname = (argc > 1) ? argv[1] : "127.0.0.1";

    if (argc > 2) {
        if (*argv[2] == 'u' || *argv[2] == 'U') {
            isunix = 1;
            /* in this case, host is the path to the unix socket */
            printf("Will connect to unix socket @%s\n", hostname);
        }
    }

    int port = (argc > 2) ? atoi(argv[2]) : 6379;

    struct timeval timeout = { 1, 500000 }; // 1.5 seconds
    if (isunix) {
        c = redisConnectUnixWithTimeout(hostname, timeout);
    } else {
        c = redisConnectWithTimeout(hostname, port, timeout);
    }
    if (c == NULL || c->err) {
        if (c) {
            printf("Connection error: %s\n", c->errstr);
            redisFree(c);
        } else {
            printf("Connection error: can't allocate redis context\n");
        }
        exit(1);
    }

    freeReplyObject(redisCommand(c,"PING"));

    /* Let's check what we have inside the list */
    reply = (redisReply *)redisCommand(c,"SMEMBERS amniscient-nvr-54C3A3");
    printf("Number of elements in the list %zu\n", reply->elements);
    if (reply->type == REDIS_REPLY_ARRAY) {
        for (j = 0; j < reply->elements; j++) {
            printf("%u) %s\n", j, reply->element[j]->str);
        }
    }

    freeReplyObject(reply);
    redisFree(c);
}


int main(int argc, char **argv) {
    redisThread (argc, argv);
    return 0;
}
