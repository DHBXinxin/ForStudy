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
    NSLog(@"didload");
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
    
    [self semaphore];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
