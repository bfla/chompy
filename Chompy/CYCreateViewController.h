//
//  CYCreateViewController.h
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYChomp;

@interface CYCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) CYChomp *chomp;


@end
