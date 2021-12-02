//
//  ViewController.m
//  AudioChange
//
//  Created by 李欣欣 on 2021/11/6.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
//切换听筒、扬声器
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应//添加监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeForPlay:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    

}

- (void)changeForPlay:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES) {
        NSLog(@"Device is close to user");
  
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    } else {
    
        NSLog(@"Device is not close to user");
  
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
  }
}
@end
