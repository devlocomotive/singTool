
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
assert_throws([snGroup, 0], "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n");
assert_throws([snGroup, undefined], "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n");
assert_throws([snRunAccess, undefined], "\n\tsingletonTools:\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n");
assert_throws([snRunDefault, undefined], "\n\tsingletonTools:\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n");

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
	assert_throws([snGroup, "hello"], "\n\tsingletonTools:\n\tkey is busy\n\n");
}

//
var struct = snRunner(function() {
	list = ds_list_create();
	assert(ds_exists(list, ds_type_list));
	clear = function() {
		ds_list_destroy(list);
	}
	assert(is_snGroup(self));
	assert(self == snRunAccess());
	assert(self == snRunAccess("root"));
	assert(self == snRunAccess("r"));
	assert(self == snRunAccess(0));
	assert(self == snRunAccess(undefined));
	assert_has_key(self, "__devlocomotive_singletonTools_snHidden_accs_");
	assert(__devlocomotive_singletonTools_snHidden_accs_.prev == undefined);
	assert(__devlocomotive_singletonTools_snHidden_accs_.root == self);
	assert(__devlocomotive_singletonTools_snHidden_accs_.hook == self);
	assert(undefined == snRunAccess(-1));
	assert(undefined == snRunAccess(-1, 1));
	assert(self == snRunAccess(-1, 0));
	assert(self == snRunAccess(-1, -1));
	assert(self == snRunAccess(-1, -10));
	var _g1 = {};
	snRunDefault("base", _g1);
	var _g0 = __devlocomotive_singletonTools_snHidden_accs_.defs;
	var _i0 = self;
	with snGroup("next") {
		assert(is_snGroup(self));
		assert(other == snRunAccess("root"));
		assert(other == snRunAccess("r"));
		assert(other == snRunAccess(0));
		assert(other == snRunAccess(undefined));
		assert_has_key(self, "__devlocomotive_singletonTools_snHidden_accs_");
		assert_has_key(self, "base");
		assert(base == _g1);
		var _g2 = __devlocomotive_singletonTools_snHidden_accs_.defs;
		assert_fail(_g0 == _g2);
		assert_equal(_g0, _g2);
		assert(other == _i0);
		assert(snRunAccess("previous") == _i0);
		assert(other == snRunAccess("previous"));
		assert(other == snRunAccess("p"));
		assert(other == snRunAccess(-1));
		assert(other == snRunAccess(-1, 1));
		assert(other == snRunAccess("p", 1));
		assert(other == snRunAccess("previous", 1));
		assert(other == snRunAccess("hook"));
		assert(other == snRunAccess("h"));
		assert(other == snRunAccess(1));
		assert(undefined == snRunAccess(-1, 2));
		try {
			snRunAccess(-1, 3);
		} catch (e) {
			if (e != "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n")
				show_error("error", true);
		}
		snRunDefault("name", "NamedWow");
		snRunDefault("base");
		with snGroup("a") {
			assert_has_key(self, "name");
			assert(name == "NamedWow");
			assert_doesnt_have_key(self, "base");
			snRunDefault("name", "NamedNews");
			with snGroup("_a") {
				assert_doesnt_have_key(self, "base");
				assert_has_key(self, "name");
				assert(name == "NamedNews");
			}
			assert(name == "NamedWow");
		}
		with snGroup("b") {
			assert_has_key(self, "name");
			assert(name == "NamedWow");
			assert_doesnt_have_key(self, "base");
			snRunDefault();
			with snGroup("_b") {
				assert_doesnt_have_key(self, "base");
				assert_doesnt_have_key(self, "name");
			}
		}
		with snGroup("c") {
			assert_doesnt_have_key(self, "base");
			assert_has_key(self, "name");
			assert(name == "NamedWow");
		}
	}
}, undefined, "clear");

//
assert_fail(find(struct));
assert_fail(find(struct.next));
assert_doesnt_have_key(struct, "__devlocomotive_singletonTools_snHidden_accs_");
assert_doesnt_have_key(struct.next, "__devlocomotive_singletonTools_snHidden_accs_");

//
snCleaner();

//
assert_fail(ds_exists(struct.list, ds_type_list));

//
show_message("all okey");