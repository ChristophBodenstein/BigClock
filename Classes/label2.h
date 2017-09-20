//
//  label2.h
//  BigClockWithSeconds
//
//  Created by Christoph Bodenstein on 30.08.12.
// (c) 2009 Ivan Misuno, www.cuberoom.biz
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface label2 : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

