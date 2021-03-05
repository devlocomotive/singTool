
//
var group = snGroup();
assert_is_struct(group);
assert(is_snGroup(group));
assert_equal(variable_struct_names_count(group), 0);
assert_equal(string(group), "<snGroup>");

//
global.__gl = self;
function find(search) {
	var names = variable_struct_get_names(global.__gl), i = 0;
	repeat array_length(names)
		if (variable_struct_get(global.__gl, names[i++]) == search) return true;
	return false;
}

//
assert_fail(find(group));
self.__ = group;
assert(find(group));

//
variable_struct_remove(self, "__");

//
assert_fail(find(group));

//
var _1 = {};
with _1 {
	var _0 = snGroup("main");
	assert_has_key(self, "main");
	assert_is_struct(main);
	assert(is_snGroup(main));
	assert_equal(variable_struct_names_count(main), 0);
	assert_equal(string(main), "<snGroup>");
}

//
assert_fail(find(_1));
assert_fail(find(_0));

//
assert_throws([snGroup, 0], "\n\tthe key must be a string and contain at least one character\n\n");
assert_throws([snGroup, undefined], "\n\tthe key must be a string and contain at least one character\n\n");
assert_throws([snAutoAccess, undefined], "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n");
assert_throws([snDefault, "key", "value"], "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n");

//
var _2 = {};
with _2 {
	try {
		snGroup();
	} catch(e) {
		throw "error";
	}
	try {
		snGroup("hello");
	} catch(e) {
		throw "error";
	}
	assert_has_key(self, "hello");
	assert_throws([snGroup, "hello"], "\n\tkey is busy\n\n");
}

//
var struct = snRunner(function() {
	list = ds_list_create();
	assert(ds_exists(list, ds_type_list));
	clear = function() {
		ds_list_destroy(list);
	}
}, "clear");

//
snCleaner();

//
assert_fail(ds_exists(struct.list, ds_type_list));

//
show_message("all okey");

/*
//
var struct = snRunner(function(root) {
	assert(self == root);
	assert(is_snGroup(self));
	assert_has_key(self, "__devlocomotive_singletonTools_snHide_prev_");
	assert_has_key(self, "__devlocomotive_singletonTools_snHide_root_");
	assert_has_key(self, "__devlocomotive_singletonTools_snHide_hook_");
	assert(__devlocomotive_singletonTools_snHide_prev_ == self);
	assert(__devlocomotive_singletonTools_snHide_root_ == self);
	assert(__devlocomotive_singletonTools_snHide_hook_ == self);
	with snGroup("next") {
		assert(root == other);
		assert(__devlocomotive_singletonTools_snHide_prev_ == root);
		assert(__devlocomotive_singletonTools_snHide_root_ == root);
		assert(__devlocomotive_singletonTools_snHide_hook_ == root);
		var mark = self;
		with snGroup("to") {
			assert(other == mark);
			assert(other == mark);
			assert(__devlocomotive_singletonTools_snHide_prev_ == other);
			assert(__devlocomotive_singletonTools_snHide_root_ == root);
			assert(__devlocomotive_singletonTools_snHide_hook_ == root);
			assert(snAccess(-1) == __devlocomotive_singletonTools_snHide_prev_);
			assert(snAccess(0) == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess(1) == __devlocomotive_singletonTools_snHide_hook_);
			assert(snAccess("p") == __devlocomotive_singletonTools_snHide_prev_);
			assert(snAccess("r") == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess("h") == __devlocomotive_singletonTools_snHide_hook_);
			assert(snAccess("prev-234") == __devlocomotive_singletonTools_snHide_prev_);
			assert(snAccess("root-2-342341") == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess("hooksdf2-") == __devlocomotive_singletonTools_snHide_hook_);
			assert(snAccess("z") == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess(100) == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess(undefined) == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess([]) == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess({}) == __devlocomotive_singletonTools_snHide_root_);
			assert(snAccess() == __devlocomotive_singletonTools_snHide_root_);
			with snGroup("keys", true) {
				var keys = self;
				assert(__devlocomotive_singletonTools_snHide_prev_ == other);
				assert(__devlocomotive_singletonTools_snHide_root_ == root);
				assert(__devlocomotive_singletonTools_snHide_hook_ == self);
				assert(mark == __devlocomotive_singletonTools_snHide_prev_.__devlocomotive_singletonTools_snHide_prev_);
				with snGroup("next") {
					assert(__devlocomotive_singletonTools_snHide_prev_ == other);
					assert(__devlocomotive_singletonTools_snHide_root_ == root);
					assert(__devlocomotive_singletonTools_snHide_hook_ == keys);
					assert(__devlocomotive_singletonTools_snHide_hook_ == __devlocomotive_singletonTools_snHide_prev_);
					assert(snAccess(-1) == __devlocomotive_singletonTools_snHide_prev_);
					assert(snAccess(0) == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess(1) == __devlocomotive_singletonTools_snHide_hook_);
					assert(snAccess("p") == __devlocomotive_singletonTools_snHide_prev_);
					assert(snAccess("r") == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess("h") == __devlocomotive_singletonTools_snHide_hook_);
					assert(snAccess("prev-234") == __devlocomotive_singletonTools_snHide_prev_);
					assert(snAccess("root-2-342341") == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess("hooksdf2-") == __devlocomotive_singletonTools_snHide_hook_);
					assert(snAccess("z") == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess(100) == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess(undefined) == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess([]) == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess({}) == __devlocomotive_singletonTools_snHide_root_);
					assert(snAccess() == __devlocomotive_singletonTools_snHide_root_);
					assert(mark == __devlocomotive_singletonTools_snHide_prev_.__devlocomotive_singletonTools_snHide_prev_.__devlocomotive_singletonTools_snHide_prev_);
				}
			}
		}
	}
	with snGroupRunnerDisableInterface("keys") {
		var lows = self;
		assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_prev_");
		assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_root_");
		assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_hook_");
		with snGroup("next") {
			assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_prev_");
			assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_root_");
			assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_hook_");
			assert(other == lows);
		}
	}
	assert(mark == snGroup("next"));
	assert(lows == snGroup("keys"));
	assert(mark == snGroupRunnerDisableInterface("next"));
	assert(lows == snGroupRunnerDisableInterface("keys"));
	var count = variable_struct_names_count(self);
	snGroup();
	snGroup("next");
	snGroup("keys");
	snGroupRunnerDisableInterface("next");
	snGroupRunnerDisableInterface("keys");
	assert(variable_struct_names_count(self) == count);
});

//
var emptyc = function(marker, recursion) {
	variable_struct_set(marker, self.snGroupId, undefined);
	assert_doesnt_have_key(self, "__devlocomotive_singletonTools_snHide_prev_");
	var i = 0, names = variable_struct_get_names(self), val;
	repeat array_length(names) {
		val = variable_struct_get(self, names[i++]);
		if is_snGroup(val) and !variable_struct_exists(marker, val.snGroupId)
			method(val, recursion)(marker, recursion);
	}
}
method(struct, emptyc)({}, emptyc);


//
show_message("all okey");