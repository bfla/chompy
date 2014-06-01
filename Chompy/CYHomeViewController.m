//
//  CYHomeViewController.m
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import "CYHomeViewController.h"
#import "CYChomp.h"
#import "CYChompStore.h"
#import "CYCreateViewController.h"

@interface CYHomeViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation CYHomeViewController

#pragma mark - Controller Lifecycle
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load the NIB file for custom table cells
    // UINib *nib = [UINib nibWithNibName:@"CYChompCell" bundle:nil];
    // Register this NIB, which contains the cell
    //[self.tableView registerNib:nib
    //forCellReuseIdentifier:@"BNRItemCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // Update data
    self.chompsToday = [[CYChompStore sharedStore] allChomps];
    NSLog(@"Initializing HomeVC with %d chomps", [self.chompsToday count]);
    [self.tableView reloadData];
    for (CYChomp *chomp in self.chompsToday) {
        NSLog(@"Chomp with %d calories", chomp.calories);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.chompsToday count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get data
    CYChomp *chomp = self.chompsToday[indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%d", chomp.calories];
    if (chomp.burned) {
        cell.textLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:0.5664 blue:0.6602 alpha:1.0];
    } else {
        cell.textLabel.textColor = [[UIColor alloc] initWithRed:1.0 green:.45 blue:0.0 alpha:1.0];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    NSString *timeString = [dateFormatter stringFromDate:chomp.dateCreated];
    cell.detailTextLabel.text = timeString;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

# pragma mark - Actions
- (IBAction)addNewItem:(id)sender
{
    CYCreateViewController *cvc = [[CYCreateViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
    
    //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    //nc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //[self presentViewController:nc animated:YES completion:nil];
}

# pragma mark - View customization
- (UIView *)headerView
{
    // If you haven't loaded the headerView yet...
    if (!_headerView) {
        // Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

@end
