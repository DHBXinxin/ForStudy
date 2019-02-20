//
//  CatchCrash.m
//  ForRunLoop
//
//  Created by DHSD on 2019/2/19.
//  Copyright © 2019 DHSD. All rights reserved.
//

#import "CatchCrash.h"

#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>



NSString * const kSignalExceptionName = @"kSignalExceptionName";
NSString * const kSignalKey = @"kSignalKey";
NSString * const kCaughtExceptionStackInfoKey = @"kCaughtExceptionStackInfoKey";

void HandleException(NSException *exception);
void SingnalHandle(int signal);

@interface CatchCrash (){
    
    BOOL ignore;
    
}

@end
@implementation CatchCrash

static CatchCrash *crash;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crash = [[CatchCrash alloc]init];
    });
    return crash;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crash = [super allocWithZone:zone];
    });
    return crash;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setCatchExceptionHandler];
    }
    return self;
}

- (void)setCatchExceptionHandler
{
    
    // 1.捕获一些异常导致的崩溃
    NSSetUncaughtExceptionHandler(&HandleException);
    
    // 2.捕获非异常情况，通过signal传递出来的崩溃
    signal(SIGABRT, SingnalHandle);
    signal(SIGILL, SingnalHandle);
    signal(SIGSEGV, SingnalHandle);
    signal(SIGFPE, SingnalHandle);
    signal(SIGBUS, SingnalHandle);
    signal(SIGPIPE, SingnalHandle);
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0) {
        ignore = YES;
    } else if (anIndex == 1) {
        NSLog(@"起死回生");
    }
}
- (void)handleException:(NSException *)exception {
    NSString *message = [NSString stringWithFormat:@"崩溃原因如下:\n%@\n%@",
                         [exception reason],
                         [[exception userInfo] objectForKey:kCaughtExceptionStackInfoKey]];
    NSLog(@"%@",message);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"程序崩溃了"
                                                    message:@"如果你能让程序起死回生，那你的决定是？"
                                                   delegate:self
                                          cancelButtonTitle:@"崩就蹦吧"
                                          otherButtonTitles:@"起死回生", nil];
    [alert show];
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runloop);
    
    while (!ignore) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.01, false);
        }
    }
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqualToString:kSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:kSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

+ (NSArray *)backTrace {
    
    void *callStack[128];
    int frames = backtrace(callStack, 128);
    char **strs = backtrace_symbols(callStack, frames);
    NSMutableArray *backTrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {
        [backTrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backTrace;
}

@end

void HandleException(NSException *exception)
{
    // 获取异常的堆栈信息
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:callStack forKey:kCaughtExceptionStackInfoKey];
    
    CatchCrash *crashObject = [CatchCrash shareInstance];
    NSException *customException = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    [crashObject performSelectorOnMainThread:@selector(handleException:) withObject:customException waitUntilDone:YES];
}

void SingnalHandle(int singal) {
    NSArray *callStack = [CatchCrash backTrace];
    NSLog(@"信号捕获崩溃，堆栈信息：%@",callStack);
    CatchCrash *obj = [CatchCrash shareInstance];
    
    NSException *exception = [NSException exceptionWithName:kSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signal] userInfo:@{kSignalKey : [NSNumber numberWithInt:singal]}];
    [obj performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}
