//
//  ViewController.m
//  Breaking Bad Access
//
//  Created by Meet Gupta
//  Projective-C
//
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray  *foods;
    UITableView *table;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    foods = [[NSArray alloc] initWithObjects:@"Pizza",@"Pasta",@"Burgers",@"Wraps",@"Vegetable Rice",@"Bread Basket", nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:nil
     selector:@selector(methodWithValue:)
     name:@"editFood"
     object:nil];
    
    
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)method:(SEL)selector {
    [self performSelector:selector];
}

- (void)methodWithValue:(NSValue *)value {
    NSString *selector;
    
    if (strcmp([value objCType], @encode(SEL)) == 0) {
        [value getValue:&selector];
        
        [self method:NSSelectorFromString(selector)];
    }
}

- (void)delegateAction {
    SEL selector = @selector(editFood);
    NSValue *selectorAsValue = [NSValue valueWithBytes:&selector objCType:@encode(SEL)];
    [NSThread detachNewThreadSelector:@selector(methodWithValue:) toTarget:self withObject:selectorAsValue];
}

-(void)editFood {
    //Do Something
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return foods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"FoodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = foods[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editFood" object:self];
    [self delegateAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
