/*
 
 BigClockWithSeconds - A simple clock app for iOS
 Written in 2009 by Christoph Bodenstein github@restekueche.de
 
 To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 
*/

#import <UIKit/UIKit.h>

@interface BigClockWithSecondsViewController : UIViewController {
	UILabel *timeLabel;
	UILabel *dateLabel;
	UILabel *secondsLabel;
	UILabel *weekLabel;
    
    UILabel *activeLabel;
    
	UIView  *thisView;
	NSTimer *myTimer;
	NSString *actDate;
	NSString *actTime;
	NSString *actSeconds;
	NSMutableString *actWeek;
	
	CGSize dateTextSize;
	CGSize timeTextSize;
	CGSize secondsTextSize;
	CGPoint datePosition;
	CGPoint timePosition;
	CGPoint secondsPosition;
	CGPoint weekPosition;
    CGPoint subLocation;
	int middleCounter;
	
	NSDateFormatter *dateFormatter;
	NSDateFormatter *timeFormatter;
	NSDateFormatter *secondsFormatter;
	NSDateFormatter *weekFormatter;
	NSDate *now;
    
    CGPoint MIDDLEPOSPortrait;
    CGPoint MIDDLEPOSLandscape;
    
    CGPoint POSTimePortrait;
    CGPoint POSTimeLandscape;
    CGPoint POSSecondsPortrait;
    CGPoint POSSecondsLandscape;
    CGPoint POSDatePortrait;
    CGPoint POSDateLandscape;
    CGPoint POSWeekPortrait;
    CGPoint POSWeekLandscape;
    
    
    CGRect TimeFrameLandscape;
    CGRect SecondsFrameLandscape;
    CGRect DateFrameLandscape;
    CGRect WeekFrameLandscape;
    
    CGRect TimeFramePortrait;
    CGRect SecondsFramePortrait;
    CGRect DateFramePortrait;
    CGRect WeekFramePortrait;
    
    
    float TimeSizeLandscape;
    float TimeSizePortrait;
    float SecondsSizeLandscape;
    float SecondsSizePortrait;
    
    UIButton *editSurfaceButton;
    UIButton *editResetButton;
    UIButton *infoButton;
    
    
    
    NSMutableArray *resizeImageViewArray;
    NSMutableArray *labelArray;//Contains all actual used Label-Object!
    NSMutableArray *invisibleButtonAray;
    NSMutableArray *defaultFramesLandscape;
    NSMutableArray *defaultFramesPortrait;
    NSMutableArray *labelsHiddenArrayPortrait;
    NSMutableArray *labelsHiddenArrayLandscape;
    NSMutableArray *labelArrayLandscape;
    NSMutableArray *labelArrayPortrait;
    

    
    UIWebView *webView;
    
    UIDeviceOrientation CurrentOrientation;
    
    UIInterfaceOrientation editOrientation;
    
    BOOL editMode,resizeMode,requestDefaultPositions, infoWebSiteAvailable;
    
    int smallButtonSize;
    
	
	
	
}
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondsLabel;
@property (nonatomic, strong) IBOutlet UILabel *weekLabel;
@property (nonatomic, strong) IBOutlet UILabel *activeLabel;
@property (nonatomic, strong) IBOutlet UIView *thisView;
@property (nonatomic, strong) IBOutlet UIButton *editSurfaceButton;
@property (nonatomic, strong) IBOutlet UIButton *timeLabelResizeButton;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UIButton *editResetButton;




- (IBAction)didChangeValue:(id)sender;
- (void)updateClock;
- (void)timerUpdate:(NSTimer*)theTimer;
- (void)startTimer;
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (CGPoint)stepToPos: (CGPoint)startPoint stopPoint:(CGPoint)stopPoint stepping:(float)stepping;
- (float)minx:(float)x y:(float)y;
- (float)maxx:(float)x y:(float)y;
- (void)labelsToMiddlePos;
-(void)checkLabelFrames;

-(IBAction)changeEditMode:(id)sender;
-(void)showEditControls;
-(void)hideEditControls;
-(IBAction)labelButtonPressed:(id)sender;
-(IBAction)enableResizeMode:(id)sender;
-(IBAction)disableResizeMode:(id)sender;

-(IBAction)touchStart:(id)sender;
-(IBAction)touchDrag:(id)sender;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
-(IBAction)infoButtonPressed:(id)sender;
-(IBAction)editResetButtonPressed:(id)sender;
-(void)resetLabelsToDefaultPositions;
-(void)resetButtonPositions:(UIDeviceOrientation)orientation;
-(BOOL)networkIsReachable:(id)sender;
-(void)resetInfoWebView;
@end

