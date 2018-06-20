//
//  main.c
//  proc
//
//  Created by DHSD on 2018/6/20.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <stdarg.h>
#include <assert.h>
#include <stdlib.h>
#include <malloc/malloc.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <spawn.h>
#include <errno.h>

#include <libkern/OSAtomic.h>

#include <dispatch/dispatch.h>

extern char **environ;
dispatch_queue_t qpf;
volatile int exitcount = 0;

// maximum value for exitcount before we quit
#define proccount  2


struct qp_msg {
    FILE *f;
    char *str;
};

void qpf_puts(void *m_) {
    struct qp_msg *m = m_;
    fputs(m->str, m->f);
    free(m->str);
    free(m);
}

void qfprintf(FILE *f, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    struct qp_msg *m = malloc(sizeof(struct qp_msg));
    assert(m);
    vasprintf(&m->str, fmt, ap);
    m->f = f;
    dispatch_async(qpf, ^(void) { qpf_puts(m); });
    va_end(ap);
}

#define qprintf(fmt...) qfprintf(stdout, ## fmt)

/* context structure, contains a process id and the
 * command line arguments used to launch it. Used to
 * provide context info to the block associated
 * with a process event source.
 */
struct pinfo {
    pid_t pid;
    dispatch_source_t source;
    char **argv;
};

/* pid_finalize() is called when the dispatch source is released.
 * this block is attached to the attribute that is passed to dispatch_source_proc_create(),
 * and is thus associated with the dispatch source. */
void pid_finalize(struct pinfo *pi) {
    qprintf("process %d is done watching %s (%d)\n", getpid(), pi->argv[0], pi->pid);
    dispatch_release(pi->source);
    if (OSAtomicIncrement32(&exitcount) == proccount) {
        qprintf("both processes exited\n");
        dispatch_sync(qpf,^{});
        exit(0);
    }
}


/* pid_event() is called from a block that is associated with a process event
 * source for a specific process id (via dispatch_source_proc_create()). When
 * such an event occurs, pid_event() calls dispatch_source_get_context() to
 * gain access to the pid and process name that were stored in the context at
 * the time the block was attached to the event source.
 */
#define FLAG(X) ((dispatch_source_get_data(src) & DISPATCH_PROC_##X) ? #X" " : "")

void pid_event(struct pinfo *pi) {
    dispatch_source_t src = pi->source;
    
    qprintf("process %d %s, flags: %x %s%s%s%s\n", pi->pid, pi->argv[0], dispatch_source_get_data(src), FLAG(EXIT), FLAG(FORK), FLAG(EXEC), FLAG(SIGNAL));
    if (dispatch_source_get_data(src) & DISPATCH_PROC_EXIT) {
        int s;
        waitpid(dispatch_source_get_handle(src), &s, WNOHANG);
        qprintf("  %s exit status %d\n", pi->argv[0], s);
        dispatch_source_cancel(src);
    }
}

/* proc_start() takes a context pointer (ppi), and a dispatch queue (pq),
 * and spawns the process named in ppi->argv[0]. The resulting process id
 * is stored in the context (ppi->pid). On successfully spawning the process,
 * it creates a dispatch source for the purpose of executing the routine pid_event(pi,ev)
 * when certain events (exit, fork, exec, reap, or signal) occur to the process.
 */
void proc_start(void *ppi, dispatch_queue_t pq) {
    struct pinfo *pi = ppi;
    
    int rc = posix_spawnp(&pi->pid, pi->argv[0], NULL, NULL, pi->argv, environ);
    if (rc) {
        int e = errno;
        qprintf("Can't spawn %s (rc=%d, e=%d %s)\n", pi->argv[0], rc, e, strerror(e));
    } else {
        
        dispatch_source_t dsp = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, pi->pid, DISPATCH_PROC_EXIT|DISPATCH_PROC_FORK|DISPATCH_PROC_EXEC|DISPATCH_PROC_SIGNAL, pq);
        dispatch_source_set_event_handler_f(dsp, (dispatch_function_t)pid_event);
        dispatch_source_set_cancel_handler_f(dsp,  (dispatch_function_t)pid_finalize);
        pi->source = dsp;
        dispatch_set_context(dsp, pi);
        dispatch_resume(dsp);
        
        qprintf("process %d spawned %s: %d, watching with event source: %p\n", getpid(), pi->argv[0], pi->pid, dsp);
        
    }
}

int main(int argc, char *argv[]) {
    struct pinfo pi, pi2, pi3;
    struct pinfo  *ppi2 = & pi2, *ppi3 = &pi3;
    
    char *av[] = {argv[0], NULL}; // set up context info (struct pinfo) for this process.
    pi.pid = getpid();
    pi.argv = av;
    
    char *av2[] = {"sleep", "3", NULL};    // set up context info (struct pinfo) for the sleep tool
    pi2.argv = av2;
    
    char *av3[] = {"script", "/tmp/LOG", "banner", "-w80", "!", NULL}; // set up context info (struct pinfo) for the script tool
    pi3.argv = av3;
    
    dispatch_queue_t pq = dispatch_queue_create("PQ", NULL);    // create our main processing queue
    
    qpf = dispatch_queue_create("qprintf", NULL);                // create a separate queue for printf
    
    /* create a dispatch source that will call the routine pid_event(pi,ev)
     * when certain events occur to the specified process (pi->pid). The dispatch source is
     * associated with the dispatch queue that was created in this routine (pq). This example
     * requests the block be executed whenever one of the following events occurs:
     *        exit, fork, exec, reap, or signal.
     */
    dispatch_source_t procSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, pi.pid, DISPATCH_PROC_EXIT|DISPATCH_PROC_FORK|DISPATCH_PROC_EXEC|DISPATCH_PROC_SIGNAL, pq);
    
    dispatch_source_set_event_handler_f(procSource, (dispatch_function_t)pid_event);
    dispatch_source_set_cancel_handler_f(procSource,  (dispatch_function_t)pid_finalize);
    pi.source = procSource;
    dispatch_set_context(procSource, &pi);
    dispatch_resume(procSource);
    
    /* create a block (which simply calls proc_start()), and dispatch it to the queue.
     * proc_start() will spawn the process named by ppiX->argv[0], and set up
     * another block (containing a call to pid_event()) on an event source that
     * will recieve process events...
     */
    dispatch_async(pq, ^(void) { proc_start( ppi2, pq ); });    // launch the sleep tool, and create the process watcher for it
    dispatch_async(pq, ^(void) { proc_start( ppi3, pq ); });    // launch the script tool, and create the process watcher for it
    
    
    dispatch_main();                                            // wait for all the queued and spawned items to finish...
}
