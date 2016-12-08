//
//  AppDelegate.m
//  talkingphoto
//
//  Created by Walid Sassi on 23/10/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize splashView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    
    NSString *destinationPath= [doumentDirectoryPath stringByAppendingPathComponent:@"list.plist"];
    
    if ([fileManger fileExistsAtPath:destinationPath]){
        NSLog(@"database localtion %@",destinationPath);
        
    }
    NSString *sourcePath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"list.plist"];
    
    [fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    UIImage* myImage;
     CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        myImage = [UIImage imageNamed:@"Default-568h@2x.png"];
     	self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, 320, screenHeight-20)];
    } else {
        myImage = [UIImage imageNamed:@"Default@2x.png"];
      	self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, screenHeight)];
    }
    
    self.splashView.image = myImage;
	
    [self.window addSubview:self.splashView];
    [self.window bringSubviewToFront:self.splashView];
	
	// setup the animation of the splash screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:4.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	self.splashView.alpha = 0.0;
	[UIView commitAnimations];
    return YES;
}
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self.splashView removeFromSuperview];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
