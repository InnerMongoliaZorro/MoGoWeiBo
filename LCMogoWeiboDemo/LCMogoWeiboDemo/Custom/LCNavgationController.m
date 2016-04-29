//
//  LCNavgationController.m
//  MoGoWeiBo
//
//  Created by 李策 on 16/4/7.
//  Copyright © 2016年 李策. All rights reserved.
//

#import "LCNavgationController.h"
#import "UIBarButtonItem+Extension.h"
@interface LCNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation LCNavgationController
#warning todo 重新注释
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     状态栏
     */
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    [self.navigationBar addSubview:statusBarView];
    
    self.interactivePopGestureRecognizer.delegate = self;
        // Do any additional setup after loading the view.
}
/**
 * 右滑手势返回
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
#pragma mark**设置导航栏的主题  背景色，字体颜色，大小 ，主题色，只需设置一次**
+(void)initialize{
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[NSForegroundColorAttributeName] = [UIColor orangeColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    //按钮不能点击的颜色
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
    dict1[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    dict1[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:dict1 forState:UIControlStateDisabled];

    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTitleTextAttributes:dict];

    /**
     *  一旦你设置了navigationBar的- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics接口，那么上面的setBarTintColor接口就不能改变statusBar的背景色，statusBar的背景色就会变成纯黑色。
     */
//    [navBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
//  设置透明的导航栏
    [navBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]] forBarMetrics:UIBarMetricsDefault];
// 设置阴影线为透明
//    [navBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]]];

    

#pragma mark**导航栏颜色,这个会让状态栏和导航栏的颜色一样**
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

//    navBar.barStyle = UIStatusBarStyleDefault;
//    [navBar setTintColor:[UIColor greenColor]];
//    [navBar setBarTintColor:[UIColor blueColor]];
//    navBar.barTintColor = [UIColor colorWithHexString:@"f9f9f9"];
//    navBar.backgroundColor = [UIColor yellowColor];
    
//    navBar.alpha = 0.3000;
    /**
     *  透明度
     */
    [navBar setTranslucent:YES];
    /**
     *  tintColor: 导航栏的按钮(如返回)颜色
        titleTextAttributes: 标题颜色
        barTintColor: 背景颜色
        translucent: 是否透明
     */
    
    
}
+ (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    /**
     *  我们可以使用UIApplication的statusBarStyle方法来设置状态栏，不过，首先需要停止使用View controller-based status bar appearance。在project target的Info tab中，插入一个新的key，名字为View controller-based status bar appearance，并将其值设置为NO。
     */
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    /**
     *  上面的方法在ios9中会有警告,建议使用这个方法,使用这个方法要在project target的Info tab中，插入一个新的key，名字为View controller-based status bar appearance，并将其值设置为YES
     */
    return UIStatusBarStyleDefault;
}
//这个方法可以在某个VC中控制状态栏的显示与隐藏 info.plist中这个值 View controller-based status bar appearance必须为YES否则无效
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popToVC) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];

        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)popToVC{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
