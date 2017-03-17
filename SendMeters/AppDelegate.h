//
//  AppDelegate.h
//  SendMeters
//
//  Created by Oleg Pavlichenkov on 17/03/2017.
//  Copyright © 2017 Oleg Pavlichenkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

