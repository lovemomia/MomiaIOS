//
//  SGBaseMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-18.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGActionView.h"

//#define BaseMenuBackgroundColor(style)  (style == SGActionViewStyleLight ? [UIColor colorWithWhite:1.0 alpha:1.0] : [UIColor colorWithWhite:0.2 alpha:1.0])
//#define BaseMenuTextColor(style)        (style == SGActionViewStyleLight ? [UIColor darkTextColor] : [UIColor lightTextColor])
//#define BaseMenuActionTextColor(style)  ([UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0])

#define BaseMenuBackgroundColor(style)  MO_APP_VCBackgroundColor
#define BaseMenuTextColor(style)        MO_APP_TextColor_gray
#define BaseMenuActionTextColor(style)  MO_APP_ThemeColor

@interface SGButton : UIButton
@end

@interface SGBaseMenu : UIView{
    SGActionViewStyle _style;
}

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) SGActionViewStyle style;

@end
