//
//  AddFeedViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "AddFeedContentCell.h"
#import "TopicListViewController.h"
#import "TagListViewController.h"

@interface AddFeedViewController : MOGroupStyleTableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, FeedPhotoPickDelegate, UIActionSheetDelegate, TopicChooseDelegate, TagChooseDelegate>

@end
