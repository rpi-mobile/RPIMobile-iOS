//
//  CampusMapListViewControllerTableViewController.m
//  RPIMobile
//
//  Created by Stephen on 3/25/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "CampusMapViewController.h"
#import "CampusMapListTableViewController.h"

@interface CampusMapListTableViewController () {
    NSMutableIndexSet *expandedSections;
    NSArray *mapObjects;
}

@end

@implementation CampusMapListTableViewController
@synthesize mapView, mapMarkers;

- (id)initWithStyle:(UITableViewStyle)style mapViewController:(CampusMapViewController *)mapViewController andMapObjects:(NSMutableArray *) objects
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (NSArray *) readMapDataFromJson {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"map_data" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    for(NSArray *mapObject in jsonObject) {
        [objects addObject:mapObject];
    }
    
    NSArray *returnArray = [objects sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *building1 = [obj1 firstObject];
        NSString *building2 = [obj2 firstObject];
        return [(NSString *)building1 compare:(NSString *)building2 options:NSNumericSearch];
       }];
    
    return returnArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    mapObjects = [self readMapDataFromJson];
    mapMarkers = mapView.markers;
    
    expandedSections = [[NSMutableIndexSet alloc] init];

    [self.tableView reloadData];
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
    return mapObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([expandedSections containsIndex:section])
    {
        return 5; // return rows when expanded
    }
    
    return 1; // only top row showing
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mapObjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // Reset cell information
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
    cell.indentationLevel = 0;
    if (!indexPath.row) {
        
        NSArray *mapObject = [mapObjects objectAtIndex:indexPath.section];
        cell.textLabel.text = [mapObject firstObject];

        switch ([[mapObject lastObject] intValue]) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"mm_student_housing.png"];
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"mm_student_life.png"];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"mm_administration.png"];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"mm_academic.png"];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 1:
                // Building Hours
                cell.textLabel.text = @"10am - 5pm";
                cell.detailTextLabel.text = @"Building Hours";
                break;
            case 2:
                // Address
                cell.textLabel.text = @"110 8th Street";
                cell.detailTextLabel.text = @"Address";
                break;
            case 3:
                // Map
                cell.textLabel.text = @"View on map";
                cell.detailTextLabel.text = @"Highlight pin on Campus Map";
                break;
            case 4:
                // Directions
                cell.textLabel.text = @"Hightlight directions";
                cell.detailTextLabel.text = @"Draws walking path on map";
            default:
                break;
        }
        
        cell.indentationLevel = 1;
        cell.indentationWidth = 10.0f;
        cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *mapObject = [mapObjects objectAtIndex:indexPath.section];
    
    if (!indexPath.row) {
        
        NSInteger section = indexPath.section;
        BOOL currentlyExpanded = [expandedSections containsIndex:section];
        NSInteger rows;
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if (currentlyExpanded) {
            rows = [self tableView:tableView numberOfRowsInSection:section];
            [expandedSections removeIndex:section];
            
        } else {
            [expandedSections addIndex:section];
            rows = [self tableView:tableView numberOfRowsInSection:section];
        }
        
        for (int i=1; i<rows; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                           inSection:section];
            [tmpArray addObject:tmpIndexPath];
        }
        
        if (currentlyExpanded) {
            [tableView deleteRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [tableView insertRowsAtIndexPaths:tmpArray
                             withRowAnimation:UITableViewRowAnimationTop];
            
        }
    } else {
        switch (indexPath.row) {
            case 3:
                // Highlight Pin
                if([mapView selectPinWithTitle:[[mapObjects objectAtIndex:indexPath.section] firstObject]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                break;
            case 4:
                // Draw walking path
                [mapView getDirectionsToMarker:[mapMarkers objectForKey:[mapObject firstObject]]];
                [self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                break;
        }
    }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Something tapped!");
    
}


@end
