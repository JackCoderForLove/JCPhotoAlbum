//
//  AppDelegate.m
//  JCPhotoAlbum
//
//  Created by xingjian on 2017/9/6.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JCNavViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    JCNavViewController *jcNav = [[JCNavViewController alloc]initWithRootViewController:[ViewController new]];
    self.window.rootViewController = jcNav;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"shortcutType = %@",shortcutItem.type);
     NSString *type = shortcutItem.type;
    if ([type isEqualToString:@"2"]) {
       
        NSString *textToShare = @"";
        UIImage *imageToShare = [UIImage imageNamed:@"cancan_share"];
        NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%8F%82%E5%8F%82-%E5%AD%A9%E5%AD%90%E4%BD%93%E6%80%81%E5%81%A5%E5%BA%B7%E5%8A%A9%E6%89%8B/id1196645318?mt=8"];
        NSArray *activityItems = @[textToShare,urlToShare];
        //创建分享视图控制器，初始化UIActivityViewController
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        
        // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
        //关闭系统的一些Activity类型,不需要的功能关掉。
        activityVC.excludedActivityTypes = @[UIActivityTypePostToVimeo];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
            UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
            {
                NSLog(@"activityType :%@", activityType);
                if (completed)
                {
                    NSLog(@"completed");
                }
                else
                {
                    NSLog(@"cancel");
                }
                
            };
            
            // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
            activityVC.completionWithItemsHandler = myBlock;
        }else{
            //此Block回调方法在iOS8.0之后就弃用了，被上面的所取代
            UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
            {
                NSLog(@"activityType :%@", activityType);
                if (completed)
                {
                    NSLog(@"completed");
                }
                else
                {
                    NSLog(@"cancel");
                }
                
            };
            // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
            activityVC.completionHandler = myBlock;
        }
        //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
       
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
    }
    completionHandler(NO);
}

@end
