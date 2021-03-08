
// 1
function __glStack() {
	static data = snRunner(false, function() {
		self.stack = [];
		self.last = undefined;
		self.push = function() {
			array_push(self.stack, self.last);
			self.last = {};
			return self;
		}
		self.pop = function() {
			self.last = array_pop(self.stack);
			return self;
		}
	});
	return data;
}

//
#macro glStack __glStack()

//
glStack.push().last.hi = 100;
/* 1 */
glStack.push().last.hi = 200;
/* 2 */
show_message(glStack.pop().last.hi);

// 2
function __glGrid() {
	static data = snRunner(true, function() {
		self.__grid = ds_grid_create(0, 0);
		self.__free = function() {
			ds_grid_destroy(self.__grid);
			show_message("free glGrid");
		}
		
		//
		snRunDefault("__grid", self.__grid);
		
		//
		with snGroup("get") {
			
			//
			self.w = function() {
				return ds_grid_width(self.__grid);
			}
			
			//
			self.h = function() {
				return ds_grid_width(self.__grid);
			}
			
			//
			with snGroup("disk") {
				
				//
				self.max = function(xm, ym, r) {
					return ds_grid_get_disk_max(self.__grid, xm, ym, r);
				}
				
				//
				self.mean = function(xm, ym, r) {
					return ds_grid_get_disk_mean(self.__grid, xm, ym, r);
				}
				
				//
				self.sum = function(xm, ym, r) {
					return ds_grid_get_disk_sum(self.__grid, xm, ym, r);
				}
				
				//
				self.min = function(xm, ym, r) {
					return ds_grid_get_disk_min(self.__grid, xm, ym, r);
				}
			}
			
			//
			self.val = function(x, y) {
				return ds_grid_get(self.__grid, x, y);
			}
		}
		
		//
		with snGroup("set") {
			
			//
			self.w = function(w) {
				ds_grid_resize(self.__grid, w, ds_grid_height(self.__grid));
				return self;
			}
			
			//
			self.h = function(h) {
				ds_grid_resize(self.__grid, ds_grid_width(self.__grid), h);
				return self;
			}
			
			//
			self.val = function(x, y, value) {
				return ds_grid_set(self.__grid, x, y, value);
			}
			
			//
			self.add = function(x, y, value) {
				return ds_grid_add(self.__grid, x, y, value);
			}
		}
		
	}, "__free");
	return data;
}

//
#macro glGrid __glGrid()

//
glGrid.set.w(10).h(10).add(9, 9, 100);
show_message(glGrid.get.val(9, 9));

// 3
function __glInterface() {
	static data = snRunner(true, function() {
		with snGroup("a") {
			with snGroup("a") {
				with snGroup("a", true) {
					self.hook = "yes";
					with snGroup("a") {
						with snGroup("a") {
							with snGroup("a") {
								self.hook = snRunAccess("hook");
								show_message(self.hook.hook);
							}
						}
					}
				}
			}
		}
	}, function() {
		show_message("the end");
	});
}

//
__glInterface();