//
//  ViewController.m
//  Thread
//
//  Created by DHSD on 2018/5/23.
//  Copyright © 2018年 DHSD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

@end

@implementation ViewController

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.center = self.view.center;
    return _imageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageView];
    _image = [UIImage imageNamed:@"柯南1"];
    NSAssert(_image, @"Image not set; required to use view controller");
    self.imageView.image = self.image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageNamed:@"柯南2"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAnotherImage:image];
        });
    });
    
//    [self queueBarrier];
    
//    [self group];
    
//    [self semaphore];
    [self source5];
}
- (void)showAnotherImage:(UIImage *)image {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}
- (void)queueBarrier {
    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);//并行
//    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_SERIAL);//串行
    dispatch_async(queue, ^{
        NSLog(@"1-----------------------1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2-------------------------2");
    });
//    dispatch_barrier_sync(queue, ^{//sync会阻塞代码运行、运行结果是3结束之后才运行4这行代码
//        sleep(0.5);
//        NSLog(@"3--------------------------3");
//        sleep(0.5);
//    });
    dispatch_barrier_async(queue, ^{//async不会阻塞代码运行
        sleep(0.5);
        NSLog(@"3--------------------------3");
        sleep(0.5);
    });//这两个都会阻塞线程、线程1、2运行之后运行3之后5、6
    NSLog(@"4------------------------------4");
    dispatch_async(queue, ^{
        
    });
    dispatch_async(queue, ^{
        NSLog(@"5----------------------5");
    });
    dispatch_async(queue, ^{
        NSLog(@"6------------------------6");
    });
}
- (void)group {
    
    dispatch_apply(3, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        NSLog(@"dispatch_apply");
    });
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(4);
        NSLog(@"group--------------------1");
    });
    dispatch_group_enter(group);
    NSLog(@"group------------------2");
    dispatch_group_leave(group);
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);//阻塞了主线程
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"main");
//    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"main");
    });
}
- (void)semaphore {
    //crate的value表示，最多几个线程同步执行
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);//发送信号、下个方法才能执行
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, timeout);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}
- (void)source {
#if DEBUG
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    static dispatch_source_t source = nil;
    __typeof(self) __weak weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGSTOP, 0, queue);//监听代表挂起指令的SIGSTOP信号
        if (source)
        {
            dispatch_source_set_event_handler(source, ^{
                // 添加或者隐藏断点的时候就log这一行
                NSLog(@"Hi, I am: %@", weakSelf);
            });
            dispatch_resume(source);
        }
    });
#endif
}

- (void)source2 {
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(0, 0));
    
    dispatch_source_set_event_handler(source, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            unsigned long i = dispatch_source_get_data(source);//有了这一句才走这个方法
            NSLog(@"%li",i);
            //更新UI
            self.imageView.image = self.image;
        });
    });
    
    dispatch_resume(source);//创建后处于suspend状态，
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //网络请求
        sleep(10);
        dispatch_source_merge_data(source, 1); //通知队列
    });
    
}
- (void)source3 {
    //创建source，以DISPATCH_SOURCE_TYPE_DATA_ADD的方式进行累加，而DISPATCH_SOURCE_TYPE_DATA_OR是对结果进行二进制或运算
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    
    //事件触发后执行的句柄--效果是相加
    dispatch_source_set_event_handler(source,^{
        
        NSLog(@"监听函数：%lu",dispatch_source_get_data(source));
        
    });
    
    //开启source
    dispatch_resume(source);
    
    dispatch_queue_t myqueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(myqueue, ^ {
        
        for(int i = 1; i <= 4; i++){
            
            NSLog(@"~~~~~~~~~~~~~~%d", i);
            
            //触发事件，向source发送事件，这里i不能为0，否则触发不了事件
            dispatch_source_merge_data(source,i);
            
            //当Interval的事件越长，则每次的句柄都会触发
            //[NSThread sleepForTimeInterval:0.0001];
        }
    });
}
- (void)source4 {
    //倒计时时间
    __block int timeout = 3;
    
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建timer
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置1s触发一次，0s的误差
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    //触发的事件
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            //取消dispatch源
            dispatch_source_cancel(_timer);
            
        }
        else{
            
            timeout--;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //更新主界面的操作
                
                NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
                
            });
        }
    });
    
    //开始执行dispatch源
    dispatch_resume(_timer);
}
- (void)suspend {
    //创建DISPATCH_QUEUE_SERIAL队列
    dispatch_queue_t queue1 = dispatch_queue_create("com.iOSChengXuYuan.queue1", 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.iOSChengXuYuan.queue2", 0);
    
    //创建group
    dispatch_group_t group = dispatch_group_create();
    
    //异步执行任务
    dispatch_async(queue1, ^{
        NSLog(@"任务 1 ： queue 1...");
        sleep(1);
        NSLog(@":white_check_mark:完成任务 1");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"任务 1 ： queue 2...");
        sleep(1);
        NSLog(@":white_check_mark:完成任务 2");
    });
    
    //将队列加入到group
    dispatch_group_async(group, queue1, ^{
        NSLog(@":no_entry_sign:正在暂停 1");
        dispatch_suspend(queue1);
    });
    
    dispatch_group_async(group, queue2, ^{
        NSLog(@":no_entry_sign:正在暂停 2");
        dispatch_suspend(queue2);
    });
    
    //等待两个queue执行完毕后再执行
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"＝＝＝＝＝＝＝等待两个queue完成, 再往下进行...");
    
    //异步执行任务
    dispatch_async(queue1, ^{
        NSLog(@"任务 2 ： queue 1");
    });
    dispatch_async(queue2, ^{
        NSLog(@"任务 2 ： queue 2");
    });
    
    //在这里将这两个队列重新恢复
    dispatch_resume(queue1);
    dispatch_resume(queue2);
    
    
    //当将dispatch_group_wait(group, DISPATCH_TIME_FOREVER);注释后，会产生崩溃，因为所有的任务都是异步执行的，在执行恢复queue1和queue2队列的时候，可能这个时候还没有执行queue1和queue2的挂起队列
}
- (void)source5 {
    //1、指定DISPATCH_SOURCE_TYPE_DATA_ADD，做成Dispatch Source(分派源)。设定Main Dispatch Queue 为追加处理的Dispatch Queue
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    
    __block NSUInteger totalComplete = 0;
    
    dispatch_source_set_event_handler(source, ^{
        
        //当处理事件被最终执行时，计算后的数据可以通过dispatch_source_get_data来获取。这个数据的值在每次响应事件执行后会被重置，所以totalComplete的值是最终累积的值。
        NSUInteger value = dispatch_source_get_data(source);
        
        totalComplete += value;
        
        NSLog(@"进度：%@", @((CGFloat)totalComplete/100));
        
        NSLog(@":large_blue_circle:线程号：%@", [NSThread currentThread]);
    });
    
    //分派源创建时默认处于暂停状态，在分派源分派处理程序之前必须先恢复。
    dispatch_resume(source);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2、恢复源后，就可以通过dispatch_source_merge_data向Dispatch Source(分派源)发送事件:
    for (NSUInteger index = 0; index < 100; index++) {
        
        dispatch_async(queue, ^{
            
            dispatch_source_merge_data(source, 1);
            
            NSLog(@":recycle:线程号：%@~~~~~~~~~~~~i = %ld", [NSThread currentThread], index);
            
            usleep(20000);//0.02秒
            
        });
    }
    
    //3、比较上面的for循环代码，将dispatch_async放在外面for循环的外面，打印结果不一样
    //dispatch_async(queue, ^{
    //
    //    for (NSUInteger index = 0; index < 100; index++) {
    //
    //        dispatch_source_merge_data(source, 1);
    //
    //        NSLog(@":recycle:线程号：%@~~~~~~~~~~~~i = %ld", [NSThread currentThread], index);
    //
    //        usleep(20000);//0.02秒
    //    }
    //});
    
    
    //2是将100个任务添加到queue里面，而3是在queue里面添加一个任务，而这一个任务做了100次循环
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
