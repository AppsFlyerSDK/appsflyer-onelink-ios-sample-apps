//
//  SceneDelegate.m
//  projectiv-c
//
//  Created by Test1 on 13/12/2023.
//

#import "SceneDelegate.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

#pragma mark - [Matrix flag] SceneDelegate
@implementation SceneDelegate

- (void)scene:(UIScene *)scene
    willConnectToSession:(UISceneSession *)session
                 options:(UISceneConnectionOptions *)connectionOptions {
    NSUserActivity *userActivity = connectionOptions.userActivities.anyObject;
    if (userActivity) {
        [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:nil];
    }
    for (UIOpenURLContext *urlContext in connectionOptions.URLContexts) {
        [[AppsFlyerLib shared] handleOpenUrl:urlContext.URL options:nil];
    }
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:nil];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *urlContext in URLContexts) {
        [[AppsFlyerLib shared] handleOpenUrl:urlContext.URL options:nil];
    }
}

@end
