/*
 
 BigClockWithSeconds - A simple clock app for iOS
 Written in 2009 by Christoph Bodenstein github@restekueche.de
 
 To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 
*/


#import <UIKit/UIKit.h>

@class BigClockWithSecondsViewController;

@interface BigClockWithSecondsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BigClockWithSecondsViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet BigClockWithSecondsViewController *viewController;

@end

