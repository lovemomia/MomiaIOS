//
//  SuggestSubmitViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "SugSubmitProductContentCell.h"
#import "SuggestTagsViewController.h"

@interface SuggestSubmitViewController : MOGroupStyleTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProductPhotoPickDelegate, UIActionSheetDelegate, SuggestTagsChooseDelegate>

@end
