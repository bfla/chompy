//
//  CYCreateViewController.m
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import "CYCreateViewController.h"
#import "CYChomp.h"
#import "CYChompStore.h"

@interface CYCreateViewController ()

@property (nonatomic, weak) IBOutlet UITextField *calField;
@property (nonatomic, weak) IBOutlet UISwitch *burnedField;
@property (nonatomic, weak) IBOutlet UITextView *note;
@property (nonatomic, weak) IBOutlet UILabel * exampleLabel1;
@property (nonatomic, weak) IBOutlet UILabel * exampleLabel2;
@property (nonatomic, weak) IBOutlet UILabel * exampleLabel3;

@end

@implementation CYCreateViewController

#pragma mark - VC Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.calField.delegate = self;
    self.note.delegate = self;
    
    [self setDefaults];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.calField becomeFirstResponder];
    self.navigationController.navigationBarHidden = YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View


#pragma mark - Actions
- (BOOL)textFieldShouldReturn:(UITextField *)textField
// When the user taps "Done" on the textField...
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.exampleLabel1.hidden = YES;
    self.exampleLabel2.hidden = YES;
    self.exampleLabel3.hidden = YES;
}

- (IBAction)backgroundTapped:(id)sender {
    if (self.calField.isFirstResponder) {
        [self.calField resignFirstResponder];
    } else if (self.note.isFirstResponder) {
        [self.note resignFirstResponder];
    }
}


- (IBAction)tappedToAddNote:(id)sender
{
    [self.note becomeFirstResponder];
}

- (IBAction)editedBurnedSelector
{
    // Change the calorie field color depending on whether Burned is true
    if (self.burnedField.on) {
        self.calField.textColor = [[UIColor alloc] initWithRed:0.0 green:0.5664 blue:0.6602 alpha:1.0];
    } else {
        self.calField.textColor = [[UIColor alloc] initWithRed:1.0 green:.45 blue:0.0 alpha:1.0];
    }
}

#warning time interface incomplete
- (IBAction)editTime:(id)sender
{
    
}

#warning photo interface incomplete
- (IBAction)addPhoto:(id)sender
{
    // Add photo stuff here
}

- (IBAction)tappedDone:(id)sender
{
    [self saveData];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)tappedCancel:(id)sender
{
    NSLog(@"Did not add object. There are still %d chomps", [[[CYChompStore sharedStore] allChomps] count]);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Data handlers
- (void)setItem:(CYChomp *)chomp
{
    _chomp = chomp;
}

- (void)saveData
{
    CYChomp *chomp = [[CYChompStore sharedStore] createChomp];
    if (self.calField.hasText) {
        chomp.calories = [self.calField.text intValue];
    } else {
        chomp.calories = 0;
    }
    chomp.burned = self.burnedField.on;
    if (self.note.hasText) {
        chomp.note = self.note.text;
    } else {
        chomp.note = nil;
    }
    
    NSLog(@"Created new Chomp with %d calories. Burned boolean set to %d. Note says... %@", chomp.calories, chomp.burned, chomp.note);
}

- (void)setDefaults
{
    // Defaults for data
    self.chomp.calories = 0;
    self.chomp.note = nil;
    
    // Defaults for UI objects
    self.calField.returnKeyType = UIReturnKeyDone;
}


@end
