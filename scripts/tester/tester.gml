
//
var gl_empty = string(self);

//
var group = snGroup();
assert(is_struct(group));
assert(is_snGroup(group));
assert(string(self) == gl_empty);
assert_has_key(group, "snGroupId");
var group_id = group.snGroupId;

//
with {} {
	group = snGroupRunnerDisableInterface("value");
	assert(is_struct(group));
	assert(is_snGroup(group));
	assert_has_key(self, "value");
	assert_has_key(group, "snGroupId");
	assert_fail(group_id == group.snGroupId);
}

//
assert_doesnt_have_key(self, "value");

//
assert_throws([snGroup, 0], "\n\tthe key must be a string and contain at least one character\n\n");
assert_throws([snGroupRunnerDisableInterface, 0], "\n\tthe key must be a string and contain at least one character\n\n");

//
with {} {
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
	try {
		snGroupRunnerDisableInterface();
	} catch(e) {}
	try {
		snGroupRunnerDisableInterface("hello2");
	} catch(e) {
		throw "error";
	}
	assert_has_key(self, "hello");
	assert_has_key(self, "hello2");
}

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