/*
 
 BigClockWithSeconds - A simple clock app for iOS
 Written in 2009 by Christoph Bodenstein github@restekueche.de
 
 To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 
*/


#import "BigClockWithSecondsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"


@implementation BigClockWithSecondsViewController

@synthesize timeLabel;
@synthesize dateLabel;
@synthesize secondsLabel;
@synthesize weekLabel;
@synthesize thisView;
@synthesize activeLabel;
@synthesize infoButton;
@synthesize editResetButton;
@synthesize editSurfaceButton;


- (IBAction)didChangeValue:(id)sender;{
	[self updateClock];
}

#define STRING_INDENT 20
#define DATELABEL_STEPPING 10
#define TIMELABEL_STEPPING 10
#define SECONDSLABEL_STEPPING 40
#define WEEKLABEL_STEPPING 10
#define MIDDLECOUNTERINIT 100
#define MIDDLEPOSX 0
#define MIDDLEPOSY 0
#define TIMEINTERVAL 0.01
#define EDITRECTBORDERSIZE 1
#define INVISIBLEIMAGENAME @"61-brightness.png"
#define RESIZEIMAGENAME @"292-crop.png"
#define EDITFINISHIMAGENAME @"258-checkmark.png"
#define EDITSTARTIMAGENAME @"20-gear-2.png"
#define MINLABELSIZE 30
#define INFOWEBSITEADDRESS @"http://tools.cbck.de/BigClock/relocateBigClock.php"
//TODO: Enter github address here

- (void)updateClock{
	now = [NSDate date];
	actDate=[dateFormatter stringFromDate:now];
	actTime=[timeFormatter stringFromDate:now];
	actSeconds=[secondsFormatter stringFromDate:now];
	actWeek=[[NSMutableString alloc] initWithString:@"W: "];
	[actWeek appendString: [weekFormatter stringFromDate:now]];

	timeLabel.text=actTime;
	secondsLabel.text=actSeconds;
	dateLabel.text=actDate;
	weekLabel.text=actWeek;
    [timeLabel setNeedsDisplay];
    [secondsLabel setNeedsDisplay];
    [dateLabel setNeedsDisplay];
    [weekLabel setNeedsDisplay];
    
    [self checkLabelFrames];
}

- (float)minx:(float)x y:(float)y{
			if(x>=y){return y;}
			if(y>x){return x;}
	return y;
}

- (CGPoint)stepToPos: (CGPoint)startPoint stopPoint: (CGPoint)stopPoint stepping: (float)stepping{
	float x,y;
	
	if(startPoint.x <= stopPoint.x){
		 x=[self minx: startPoint.x+stepping y:stopPoint.x];
	}
	if(startPoint.x >= stopPoint.x){
		 x=[self maxx: startPoint.x-stepping y:stopPoint.x];
	}
	if(startPoint.y <= stopPoint.y){
		 y=[self minx: startPoint.y+stepping y:stopPoint.y];
	}
	if(startPoint.y >= stopPoint.y){
		 y=[self maxx: startPoint.y-stepping y:stopPoint.y];
	}

	return CGPointMake(x,y);
}

- (float)maxx:(float)x y:(float)y{
	if(x>=y){return x;}
	if(y>x){return y;}
	return y;
}

-(void)checkLabelFrames{
    UIDeviceOrientation newOrientation=[[UIDevice currentDevice]orientation];
    
    if((UIDeviceOrientationIsPortrait(newOrientation))||(UIDeviceOrientationIsLandscape(newOrientation))){
    
    NSMutableArray *tmpFrameArray;
    NSMutableArray *tmpHiddenArray;
    
    if((newOrientation != CurrentOrientation)&&(!editMode)){
    if (UIDeviceOrientationIsPortrait(newOrientation)) {
        tmpFrameArray=labelArrayPortrait;
        tmpHiddenArray=labelsHiddenArrayPortrait;
        [infoButton setHidden:NO];
    }else{
        tmpFrameArray=labelArrayLandscape;
        tmpHiddenArray=labelsHiddenArrayLandscape;
        [infoButton setHidden:YES];
    }
    
    for(int i=0;i<4;i++){
        [[labelArray objectAtIndex:i] setFrame:[[tmpFrameArray objectAtIndex:i] CGRectValue]];
        if([[tmpHiddenArray objectAtIndex:i] boolValue]){
            [[labelArray objectAtIndex:i] setColor:[UIColor clearColor]];
        }else{
            [[labelArray objectAtIndex:i] setColor:[UIColor whiteColor]];
        }
        [[resizeImageViewArray objectAtIndex:i] setFrame:CGRectMake([[labelArray objectAtIndex:i] frame].size.width-smallButtonSize, [[labelArray objectAtIndex:i] frame].size.height-smallButtonSize, smallButtonSize, smallButtonSize)];
    }
    
    CurrentOrientation=[[UIDevice currentDevice] orientation];
    [timeLabel setAdjustsFontSizeToFitWidth:YES];
    [dateLabel setAdjustsFontSizeToFitWidth:YES];
    [secondsLabel setAdjustsFontSizeToFitWidth:YES];
    [weekLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self resetButtonPositions:CurrentOrientation];
    }
        
    }
    
}

-(void)resetLabelsToDefaultPositions{
    if (UIDeviceOrientationIsLandscape((UIDeviceOrientation)editOrientation)){
        for (int i=0; i<4; i++) {
            [[labelArray objectAtIndex:i] setFrame:[[defaultFramesLandscape objectAtIndex:i] CGRectValue]];
            [[resizeImageViewArray objectAtIndex:i] setFrame:CGRectMake([[labelArray objectAtIndex:i] frame].size.width-smallButtonSize, [[labelArray objectAtIndex:i] frame].size.height-smallButtonSize, smallButtonSize, smallButtonSize)];
            [[labelArray objectAtIndex:i] setColor:[UIColor whiteColor]];
            labelsHiddenArrayLandscape=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
        }
        
    }else{
        for(int i=0;i<4;i++){
            [[labelArray objectAtIndex:i] setFrame:[[defaultFramesPortrait objectAtIndex:i] CGRectValue]];
            [[resizeImageViewArray objectAtIndex:i] setFrame:CGRectMake([[labelArray objectAtIndex:i] frame].size.width-smallButtonSize, [[labelArray objectAtIndex:i] frame].size.height-smallButtonSize, smallButtonSize, smallButtonSize)];
            [[labelArray objectAtIndex:i] setColor:[UIColor whiteColor]];
            labelsHiddenArrayPortrait=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
        }
    }
    [self resetButtonPositions:(UIDeviceOrientation)editOrientation];
    
}


-(void)resetButtonPositions:(UIDeviceOrientation)orientation{
    float width=0;
    float height=0;
    if (UIDeviceOrientationIsLandscape(orientation)){
        width=[[UIScreen mainScreen] bounds].size.height;
        height=[[UIScreen mainScreen] bounds].size.width;
    }else{
        width=[[UIScreen mainScreen] bounds].size.width;
        height=[[UIScreen mainScreen] bounds].size.height;
        
    }
    [editSurfaceButton setFrame:CGRectMake(smallButtonSize, height-smallButtonSize*2, smallButtonSize*2, smallButtonSize*2)];
    [editResetButton setFrame:CGRectMake(smallButtonSize*3, height-smallButtonSize*2, smallButtonSize*2, smallButtonSize*2)];
    [infoButton setFrame:CGRectMake(width-smallButtonSize*2, height-smallButtonSize*2, smallButtonSize*2, smallButtonSize*2)];

}


-(void)loadLabelPositionsFromMemory{
    
    editOrientation=(UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    NSLog(@"Reading Label Positions etc...");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bigClockData.plist"];
    
    NSMutableArray *loadArray;
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    if([myFileManager fileExistsAtPath:filePath]){
    loadArray = (filePath != nil ? [NSMutableArray arrayWithContentsOfFile:filePath] : nil);
    }
    
    if((loadArray!=nil)){
        @try {
        int offset=10;
        for(int i=0;i<4;i++){

            int counter=offset*i;
            
            UILabel *tmpLabel=[[UILabel alloc] init];
            [tmpLabel setFrame:CGRectMake([[loadArray objectAtIndex:0+counter] floatValue], [[loadArray objectAtIndex:1+counter] floatValue], [[loadArray objectAtIndex:2+counter] floatValue], [[loadArray objectAtIndex:3+counter] floatValue])];
            
            bool tmpHidden=NO;
            if([[loadArray objectAtIndex:4+counter] isEqualToString:@"YES"])tmpHidden=YES;
            [labelsHiddenArrayPortrait replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:tmpHidden]];
            [labelArrayPortrait replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:tmpLabel.frame]];
            
            
            UILabel *tmpLabel1=[[UILabel alloc] init];
            [tmpLabel1 setFrame:CGRectMake([[loadArray objectAtIndex:5+counter] floatValue], [[loadArray objectAtIndex:6+counter] floatValue], [[loadArray objectAtIndex:7+counter] floatValue], [[loadArray objectAtIndex:8+counter] floatValue])];
            tmpHidden=NO;
            if([[loadArray objectAtIndex:9+counter] isEqualToString:@"YES"])tmpHidden=YES;
            
            [labelsHiddenArrayLandscape replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:tmpHidden]];
            [labelArrayLandscape replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:tmpLabel1.frame]];
            
        }
        
    [self resetButtonPositions:(UIDeviceOrientation)editOrientation];
        NSMutableArray *tmpArray;
        NSMutableArray *tmpHiddenArray;
        if(UIDeviceOrientationIsLandscape((UIDeviceOrientation)editOrientation)){
            tmpArray=labelArrayLandscape;
            tmpHiddenArray=labelsHiddenArrayLandscape;
        }else{
            tmpArray=labelArrayPortrait;
            tmpHiddenArray=labelsHiddenArrayPortrait;
        }
        for(int i=0;i<4;i++){
            [[labelArray objectAtIndex:i] setFrame:[[tmpArray objectAtIndex:i] CGRectValue]];
            if([[tmpHiddenArray objectAtIndex:i] boolValue]){
                [[labelArray objectAtIndex:i] setColor:[UIColor clearColor]];
            }else{
                [[labelArray objectAtIndex:i] setColor:[UIColor whiteColor]];
                }
            [[resizeImageViewArray objectAtIndex:i] setFrame:CGRectMake([[labelArray objectAtIndex:i] frame].size.width-smallButtonSize, [[labelArray objectAtIndex:i] frame].size.height-smallButtonSize, smallButtonSize, smallButtonSize)];
        }
        }
        @catch (NSException *exception) {
            NSLog(@"Not Able to load data from file. using defaults.");
            editOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
            [self resetLabelsToDefaultPositions];
            [self resetButtonPositions:(UIDeviceOrientation)editOrientation];
        }
        @finally {
        }
 
    }else{
        editOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
        [self resetLabelsToDefaultPositions];
        [self resetButtonPositions:(UIDeviceOrientation)editOrientation];
        [self saveLabelPositionsToMemory];
        }
    
 
    
}


-(void)saveLabelPositionsToMemory{
    NSLog(@"Saving Label Positions etc...");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bigClockData.plist"];
    
    if(UIDeviceOrientationIsLandscape((UIDeviceOrientation)editOrientation)){
    labelArrayLandscape=[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGRect:timeLabel.frame],[NSValue valueWithCGRect:secondsLabel.frame],[NSValue valueWithCGRect:dateLabel.frame],[NSValue valueWithCGRect:weekLabel.frame], nil ];
        
    }else{
    labelArrayPortrait=[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGRect:timeLabel.frame],[NSValue valueWithCGRect:secondsLabel.frame],[NSValue valueWithCGRect:dateLabel.frame],[NSValue valueWithCGRect:weekLabel.frame], nil ];
    }

    NSMutableArray *saveArray=[[NSMutableArray alloc]init];
    for(int i=0;i<4;i++){


        CGRect tmpLabel=[[labelArrayPortrait objectAtIndex:i] CGRectValue];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.origin.x]];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.origin.y]];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.size.width]];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.size.height]];
        NSString *hidden;
        if([[labelsHiddenArrayPortrait objectAtIndex:i] boolValue]){hidden=(@"YES");}else{hidden=(@"NO");}
        [saveArray addObject:hidden];
         
        tmpLabel=[[labelArrayLandscape objectAtIndex:i] CGRectValue];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.origin.x]];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.origin.y]];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.size.width]];
        [saveArray addObject:[NSString stringWithFormat:@"%f", tmpLabel.size.height]];
        NSString *hidden1;
        if([[labelsHiddenArrayLandscape objectAtIndex:i] boolValue]){hidden1=(@"YES");}else{hidden1=(@"NO");}
        [saveArray addObject:hidden1];
        
    }
    

    if([saveArray writeToFile:filePath atomically:YES]){
        NSLog(@"Saving Data succeeded.");
    }else{
        NSLog(@"Failure while saving data.");
    }


}



- (void)labelsToMiddlePos{
	middleCounter=MIDDLECOUNTERINIT;
	datePosition=CGPointMake(MIDDLEPOSX,MIDDLEPOSY);
	timePosition=CGPointMake(MIDDLEPOSX,MIDDLEPOSY);
	secondsPosition=CGPointMake(MIDDLEPOSX,MIDDLEPOSY);
} 
- (void)timerUpdate:(NSTimer*)theTimer{
	[self updateClock];
}

- (void)startTimer{
	//init Dateformatter
	NSLocale *locale = [NSLocale currentLocale];
	dateFormatter = [[NSDateFormatter alloc] init];
	timeFormatter = [[NSDateFormatter alloc] init];
	secondsFormatter =[[NSDateFormatter alloc] init];
	weekFormatter =[[NSDateFormatter alloc] init];
	[dateFormatter setLocale:locale];
	[timeFormatter setLocale:locale];
	[secondsFormatter setLocale:locale];
	[weekFormatter setLocale:locale];
	
	[timeFormatter setDateFormat:@"HH:mm"];
	[dateFormatter setDateFormat:@"EEE, d. MMM YYYY"];
	[secondsFormatter setDateFormat:@":ss"];
	[weekFormatter setDateFormat:@"w"];
	
	
	middleCounter=0;
	NSTimeInterval ti=TIMEINTERVAL;
	myTimer=[NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerUpdate:) userInfo:self repeats:YES];
	[self updateClock];
}



// Additional setup after loading the view
- (void)viewDidLoad {
    [super viewDidLoad];
    editMode=NO;
    resizeMode=NO;
    requestDefaultPositions=NO;
    CGSize ScreenBounds=[[UIScreen mainScreen] bounds].size;
    CurrentOrientation = [[UIDevice currentDevice] orientation];
    
    POSTimeLandscape=CGPointMake(-5*ScreenBounds.height/480, 20*ScreenBounds.width/320);
    POSDateLandscape=CGPointMake(70*ScreenBounds.height/480, 191*ScreenBounds.width/320);
    POSSecondsLandscape=CGPointMake(415*ScreenBounds.height/480, 125*ScreenBounds.width/320);
    POSWeekLandscape=CGPointMake(143*ScreenBounds.height/480, 254*ScreenBounds.width/320);
    TimeSizeLandscape=165*ScreenBounds.width/320;
    SecondsSizeLandscape=36*ScreenBounds.width/320;
    TimeFrameLandscape=CGRectMake(POSTimeLandscape.x, POSTimeLandscape.y, 425*ScreenBounds.height/480, 160*ScreenBounds.width/320);
    SecondsFrameLandscape=CGRectMake(POSSecondsLandscape.x, POSSecondsLandscape.y, 61*ScreenBounds.height/480, 38*ScreenBounds.width/320);
    
    
    POSTimePortrait=CGPointMake(-6*ScreenBounds.width/320, 23*ScreenBounds.height/480);
    POSDatePortrait=CGPointMake(0*ScreenBounds.width/320, 244*ScreenBounds.height/480);
    POSSecondsPortrait=CGPointMake(283*ScreenBounds.width/320, 85*ScreenBounds.height/480);
    POSWeekPortrait=CGPointMake(79*ScreenBounds.width/320, 334*ScreenBounds.height/480);
    TimeSizePortrait=110*ScreenBounds.height/480;
    SecondsSizePortrait=22*ScreenBounds.height/480;
    TimeFramePortrait=CGRectMake(POSTimePortrait.x, POSTimePortrait.y, 297*ScreenBounds.width/320, 90*ScreenBounds.height/480);
    SecondsFramePortrait=CGRectMake(POSSecondsPortrait.x, POSSecondsPortrait.y, 49*ScreenBounds.width/320, 28*ScreenBounds.height/480);
    
    
    //Calculation of every frame
    float width=ScreenBounds.width;
    float height=ScreenBounds.height;
    smallButtonSize=width/14;
    
    TimeFramePortrait=CGRectMake((0*width/14), (1*height/10), (5.5*width/7), (2.5*height/10));
    SecondsFramePortrait=CGRectMake((5.5*width/7), (2.15*height/10), (1.3*width/7), (1.1*height/10));
    DateFramePortrait=CGRectMake((0*width/7), (5*height/10), (7*width/7), (1*height/10));
    WeekFramePortrait=CGRectMake((2.5*width/7), (7*height/10), (2*width/7), (1*height/10));
    
    
    width=ScreenBounds.height;
    height=ScreenBounds.width;

    TimeFrameLandscape=CGRectMake((1*width/10), (0.5*height/7), (6.5*width/10), (3*height/7));
    SecondsFrameLandscape=CGRectMake((7.5*width/10), (2*height/7), (1.5*width/10), (1.1*height/7));
    DateFrameLandscape=CGRectMake((1*width/10), (4*height/7), (9*width/10), (1.3*height/7));
    WeekFrameLandscape=CGRectMake((4*width/10), (5.5*height/7), (3*width/10), (1*height/7));
    
    [timeLabel setAdjustsFontSizeToFitWidth:YES];
    timeLabel.font = [UIFont fontWithName:@"Arial" size: 500];
    [timeLabel setNumberOfLines:1];
    
    [dateLabel setAdjustsFontSizeToFitWidth:YES];
    dateLabel.font = [UIFont fontWithName:@"Arial" size: 500];
    [dateLabel setNumberOfLines:1];
    
    [secondsLabel setAdjustsFontSizeToFitWidth:YES];
    secondsLabel.font = [UIFont fontWithName:@"Arial" size: 500];
    [secondsLabel setNumberOfLines:1];
    
    [weekLabel setAdjustsFontSizeToFitWidth:YES];
    weekLabel.font = [UIFont fontWithName:@"Arial" size: 500];
    [weekLabel  setNumberOfLines:1];

    width = ScreenBounds.width;
    height = ScreenBounds.height;
    //Add button to edit the surface

    resizeImageViewArray=[[NSMutableArray alloc]init];
    labelArray=[[NSMutableArray alloc]init];
    invisibleButtonAray=[[NSMutableArray alloc]init];
    labelsHiddenArrayPortrait=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
    labelsHiddenArrayLandscape=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];
    
    
    defaultFramesLandscape=[[NSMutableArray alloc] initWithObjects: [NSValue valueWithCGRect:TimeFrameLandscape], [NSValue valueWithCGRect:SecondsFrameLandscape],[NSValue valueWithCGRect:DateFrameLandscape],[NSValue valueWithCGRect:WeekFrameLandscape],nil ];
    labelArrayLandscape=[[NSMutableArray alloc] initWithObjects: [NSValue valueWithCGRect:TimeFrameLandscape], [NSValue valueWithCGRect:SecondsFrameLandscape],[NSValue valueWithCGRect:DateFrameLandscape],[NSValue valueWithCGRect:WeekFrameLandscape],nil ];
    defaultFramesPortrait=[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGRect:TimeFramePortrait],[NSValue valueWithCGRect:SecondsFramePortrait],[NSValue valueWithCGRect:DateFramePortrait],[NSValue valueWithCGRect:WeekFramePortrait], nil ];
    labelArrayPortrait=[[NSMutableArray alloc]initWithObjects:[NSValue valueWithCGRect:TimeFramePortrait],[NSValue valueWithCGRect:SecondsFramePortrait],[NSValue valueWithCGRect:DateFramePortrait],[NSValue valueWithCGRect:WeekFramePortrait], nil ];

    //Load Info-Website on Startup
    infoWebSiteAvailable=NO;
    webView =[[UIWebView alloc]initWithFrame:CGRectMake(5, 5, width-6, height-5-smallButtonSize*2)];
    [webView setHidden:YES];
    [[self view] addSubview:webView];
    [self resetInfoWebView];
    
    
    [labelArray addObject:timeLabel];
    [labelArray addObject:secondsLabel];
    [labelArray addObject:dateLabel];
    [labelArray addObject:weekLabel];
    
    
    [self resetButtonPositions:CurrentOrientation];    
    
    for (int i=0; i<4; i++) {
        UILabel *tmpLabel=[labelArray objectAtIndex:i];
        UIImageView *tmpImageView=[[UIImageView alloc] initWithFrame:CGRectMake(tmpLabel.frame.size.width-smallButtonSize, tmpLabel.frame.size.height-smallButtonSize, smallButtonSize, smallButtonSize)];
        [tmpImageView setImage:[UIImage imageNamed:RESIZEIMAGENAME]];
        [tmpImageView setHidden:YES];
        [tmpImageView setUserInteractionEnabled:YES];
        [tmpLabel addSubview:tmpImageView];//Must be added as first subview!
        [resizeImageViewArray addObject:tmpImageView];
        
        
        UIButton *tmpButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, smallButtonSize, smallButtonSize)];
        [tmpButton setImage:[UIImage imageNamed:INVISIBLEIMAGENAME] forState:UIControlStateNormal];
        [tmpButton addTarget:self action:@selector(labelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tmpButton setTag:((i+1)*10+1)];
        [tmpLabel addSubview:tmpButton];//Must be added as second subview!
        [tmpLabel setUserInteractionEnabled:YES];
        [tmpButton setHidden:YES];
        [tmpButton setShowsTouchWhenHighlighted:YES];
        [invisibleButtonAray addObject:tmpButton];
        
    }

    [editResetButton setHidden:YES];
    [self loadLabelPositionsFromMemory];
    
}




-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    NSLog(@"shouldAutorotateToInterfaceOrientation called.");
    if(editMode){
        return (editOrientation==interfaceOrientation);
    }else{
        NSLog(@"New Interfacorientation should be: %ld", (long)interfaceOrientation);
        if((UIDeviceOrientationIsPortrait((UIDeviceOrientation)interfaceOrientation))||(UIDeviceOrientationIsLandscape((UIDeviceOrientation)interfaceOrientation))){
            
        return YES;
        } else {return NO;}
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

-(IBAction)changeEditMode:(id)sender{
    
    if (editMode==YES) {
        [self hideEditControls];
        editMode=NO;
    }else{
        [self showEditControls];
        editMode=YES;
    }
    NSLog(@"EditMode changed");
    
}

-(void)showEditControls{
    editOrientation=(UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    for(int i=0;i<4;i++){
        [[resizeImageViewArray objectAtIndex:i] setHidden:NO];
        [[invisibleButtonAray objectAtIndex:i]setHidden:NO];
    }
    
    
    
    timeLabel.layer.borderColor=[UIColor redColor].CGColor;
    timeLabel.layer.borderWidth=EDITRECTBORDERSIZE;
    
    secondsLabel.layer.borderColor=[UIColor redColor].CGColor;
    secondsLabel.layer.borderWidth=EDITRECTBORDERSIZE;
    
    dateLabel.layer.borderColor=[UIColor redColor].CGColor;
    dateLabel.layer.borderWidth=EDITRECTBORDERSIZE;
    
    weekLabel.layer.borderColor=[UIColor redColor].CGColor;
    weekLabel.layer.borderWidth=EDITRECTBORDERSIZE;
    
    [editResetButton setHidden:NO];
    [infoButton setHidden:YES];
    
}

-(void)hideEditControls{
    for(int i=0;i<4;i++){
        [[resizeImageViewArray objectAtIndex:i] setHidden:YES];
        [[invisibleButtonAray objectAtIndex:i] setHidden:YES];
    }
    
    timeLabel.layer.borderWidth=0;
    
    secondsLabel.layer.borderWidth=0;
    dateLabel.layer.borderWidth=0;
    weekLabel.layer.borderWidth=0;
    [editResetButton setHidden:YES];
    
    if(UIDeviceOrientationIsLandscape(CurrentOrientation)){
    [infoButton setHidden:YES];
    }else{
    [infoButton setHidden:NO];
    }
    [self saveLabelPositionsToMemory];
    
}

-(IBAction)labelButtonPressed:(id)sender{
    NSLog(@"labelButtonPressed called");
    UILabel *tmpLabel;
    BOOL invisible=NO;
    switch ([sender tag]) {
        case 12:
            //ResizeButton of TimeLabel pressed
            NSLog(@"ResizeButton of timelabel pressed");
            break;
        case 11:
            //InvisibleButton of TimeLabel pressed
            NSLog(@"Timelabel invisiblebutton pressed.");
            tmpLabel=timeLabel;
            invisible=YES;
            break;
        case 21:
            //InvisibleButton of SecondsLabel pressed
            NSLog(@"Secondslabel invisiblebutton pressed.");
            tmpLabel=secondsLabel;
            invisible=YES;
            break;
        case 31:
            //InvisibleButton of DateLabel pressed
            NSLog(@"Datelabel invisiblebutton pressed.");
            tmpLabel=dateLabel;
            invisible=YES;
            break;
        case 41:
            //InvisibleButton of WeekLabel pressed
            NSLog(@"Weeklabel invisiblebutton pressed.");
            tmpLabel=weekLabel;
            invisible=YES;
            break;
        default:
            break;
    }
    
    int i=(int)[labelArray indexOfObject:tmpLabel];
    if((tmpLabel!=nil)&&(invisible==YES)){
        if([tmpLabel textColor]==[UIColor clearColor]){
            [tmpLabel setTextColor:[UIColor whiteColor]];
                if(UIDeviceOrientationIsLandscape((UIDeviceOrientation)editOrientation)){
                    [labelsHiddenArrayLandscape replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                }   else{
                    [labelsHiddenArrayPortrait replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                    }
        }else{
            [tmpLabel setTextColor:[UIColor clearColor]];
            if(UIDeviceOrientationIsLandscape((UIDeviceOrientation)editOrientation)){
                [labelsHiddenArrayLandscape replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
            }   else{
                [labelsHiddenArrayPortrait replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
            }        }
    }
    
}
-(IBAction)touchStart:(id)sender{
    NSLog(@"Touch starts");
}

-(IBAction)touchDrag:(id)sender{
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(editMode==YES){
        //NSLog(@"dragging");
        UITouch *myTouch=[touches anyObject];
        CGPoint touchLocation=[myTouch locationInView:[self view]];
        
        for(int i=0;i<4;i++){
            if(CGRectContainsPoint([[labelArray objectAtIndex:i] frame] , touchLocation)){
                activeLabel=[labelArray objectAtIndex:i];
                NSLog(@"selected Label Nr. %u", i);
                subLocation=[myTouch locationInView:activeLabel];
                if (CGRectContainsPoint([[resizeImageViewArray objectAtIndex:i] frame], subLocation)) {
                    NSLog(@"Resizing activated");
                    resizeMode=YES;
                }
            }
        }
        
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    activeLabel=NULL;
    if(resizeMode==YES){
        resizeMode=NO;
        NSLog(@"Resizing deactivated");}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if((editMode==YES)&&(activeLabel!=NULL)){
    UITouch *myTouch=[touches anyObject];
    CGPoint touchLocation=[myTouch locationInView:[self view]];
        if(resizeMode==NO){
            [[self activeLabel] setFrame:CGRectMake(touchLocation.x-subLocation.x, touchLocation.y-subLocation.y, [self activeLabel].frame.size.width, [self activeLabel].frame.size.height)];
            
        }else if (editMode==YES){
            [[self activeLabel]setFrame:CGRectMake(activeLabel.frame.origin.x, activeLabel.frame.origin.y, MAX(touchLocation.x-activeLabel.frame.origin.x,MINLABELSIZE),MAX(touchLocation.y-activeLabel.frame.origin.y,MINLABELSIZE))];
            [[[activeLabel subviews]objectAtIndex:0] setFrame:CGRectMake(activeLabel.frame.size.width-smallButtonSize, activeLabel.frame.size.height-smallButtonSize, smallButtonSize, smallButtonSize)];
            
            }
    
    }
    
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"Motion ended");
}

-(IBAction)enableResizeMode:(id)sender{
    NSLog(@"Resizeing enabled");
    resizeMode=YES;
}
-(IBAction)disableResizeMode:(id)sender{
    NSLog(@"Resizing disabled");
    resizeMode=NO;
}

-(IBAction)infoButtonPressed:(id)sender{
    NSLog(@"Infobutton pressed, showing Info-Website");
    
    if([webView isHidden]&&infoWebSiteAvailable){
    [webView setHidden:NO];
    }else{
        [webView setHidden:YES];
        [self resetInfoWebView];
    }
    
}

-(IBAction)editResetButtonPressed:(id)sender{
    NSLog(@"EditResetButton pressed");
    [self resetLabelsToDefaultPositions];
}

#pragma mark - check if internet connection is available
-(BOOL)networkIsReachable:(id)sender
{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            return FALSE;
            break;
        }
            
        case ReachableViaWWAN:
        {
            return FALSE;
            break;
        }
        case ReachableViaWiFi:
        {
            return TRUE;
            break;
        }
    }
    return TRUE;
}

-(void)resetInfoWebView{

    NSString *helpText = [NSString stringWithFormat: @"%@%@%@", @"<html><head><meta content='text/html; charset=ISO-8859-1'http-equiv='content-type'></head><body><h2>21 - The Big Clock</h2><br>You can configure the Clock in<br>portrait and landscape mode as <br>you like.<br><br>As simple as useful.<br><br>For more information,<br>hit the info-button when <br>you have wifi-connection<br><a href='", INFOWEBSITEADDRESS, @"'> or visit the project on github.</a></body></html>"];
    
    if ([self networkIsReachable:self]){
        NSURL *previewURL=[NSURL URLWithString:INFOWEBSITEADDRESS];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:previewURL];
        
        //Load the request in the UIWebView.
        
        [webView loadRequest:requestObj];
        
        infoWebSiteAvailable=YES;
        
        
    }else{
        [webView loadHTMLString:helpText baseURL:nil];
        
        infoWebSiteAvailable=YES;
        }
}

@end



