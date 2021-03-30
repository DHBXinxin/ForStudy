//
//  ViewController.m
//  iOSLocal
//
//  Created by 李欣欣 on 2021/3/30.
//

#import "ViewController.h"
#import "NSBundle+Language.h"
//这样的方法更官方一点儿、如果感觉用这个很不顺手也可以自建一个类来保存中英文、
@interface ViewController ()

@end

@implementation ViewController

static int a = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 44, 44)];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self getSystemLanguage];
}
- (void)getSystemLanguage {
    NSString *phoneLanguage  = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSLog(@"%@",phoneLanguage);
}
- (void)changeLaunge:(NSString *)launge {
    [NSBundle setLanguage:launge];
    NSLog(@"保存当前语言");
    [[NSUserDefaults standardUserDefaults] setObject:launge forKey:@"Language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@",NSLocalizedString(@"test", nil));
}
- (IBAction)change:(id)sender {
    if (a == 0) {
        [self changeLaunge:@"zh-Hans"];
        a = 1;
    } else {
        [self changeLaunge:@"en"];
        a = 0;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
