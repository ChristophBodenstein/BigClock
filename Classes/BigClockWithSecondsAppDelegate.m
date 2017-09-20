/*
 
 BigClockWithSeconds - A simple clock app for iOS
 Written in 2009 by Christoph Bodenstein github@restekueche.de
 
 To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 
*/


#import "BigClockWithSecondsAppDelegate.h"
#import "BigClockWithSecondsViewController.h"

@implementation BigClockWithSecondsAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    	
    // Override point for customization after app launch
    [window setRootViewController:viewController];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	//*application setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
	application.idleTimerDisabled=YES;
	[viewController startTimer];
	
}


@end
