//
//  SuggestSubmitViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"
#import "SugSubmitProductContentCell.h"
#import "SuggestTagsViewController.h"

@interface SuggestSubmitViewController : MOTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProductPhotoPickDelegate, UIActionSheetDelegate, SuggestTagsChooseDelegate>

@end
