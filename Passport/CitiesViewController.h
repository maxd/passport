#import <UIKit/UIKit.h>

@protocol CitiesViewControllerDelegate

- (void)didSelectCity:(NSString *)city;

@end

@interface CitiesViewController : UITableViewController

@property (weak) id<CitiesViewControllerDelegate> delegate;
@property (strong) NSString *state;
@property (strong) NSString *city;

@end
