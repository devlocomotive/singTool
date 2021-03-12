// test for script-devlocomotive_singletonTools
//

#region test controller
	
	//
	show_debug_message("\n\tTester\n");
	
	//
	var test =
		{ addition : 0
		, main : 1
		, current : undefined
		, nothing : -1
		}
	
	//
	test.current = test.main;
	
#endregion

#region test tools

	//
	function log() {
		var str = "\t", i = 0;
		repeat argument_count
			str += string_replace_all(string_replace_all(argument[i++], "\n", "\\n"), "\t", "\\t") + (i < argument_count ? " " : "");
		show_debug_message(str);
	}
	
	//
	global._ = self;
	function gl() {
		return global._;
	}
	
	//
	function find(search) {
		var names = variable_struct_get_names(global._), i = 0;
		repeat array_length(names)
			if (variable_struct_get(global._, names[i++]) == search) return true;
		return false;
	}
	
	//
	groupMarkirator({});
	function groupMarkirator(stc) {
		static name = "__wow_marker_wow__";
		static stack = [];
		var main = (array_length(stack) == 0), i = 0, val, names = variable_struct_get_names(stc);
		if main and is_snGroup(stc) {
			if !variable_struct_exists(stc, name) {
				variable_struct_set(stc, name, undefined);
				array_push(stack, stc);
			}
		}
		repeat array_length(names) {
			val = variable_struct_get(stc, names[i++]);
			if is_snGroup(val) and !variable_struct_exists(val, name) {
				variable_struct_set(val, name, undefined);
				array_push(stack, val);
				groupMarkirator(val);
			}
		}
		if main {
			i = 0;
			repeat array_length(stack) variable_struct_remove(stack[i++], name);
			val = stack;
			stack = [];
			return val;
		}
	}
	
	//
	function groupDontHaveKeys(stcm, keys) {
		if !is_array(keys) keys = [keys];
		var marking = groupMarkirator(stcm), i = 0, j, stc;
		repeat array_length(marking) {
			stc = marking[i++];
			j = 0;
			repeat array_length(keys) {
				if variable_struct_exists(stc, keys[j++]) return false;
			}
		}
		return true;
	}
	
	//
	function thrower(func, argm) {
		var _err = false;
		try {
			if !is_array(argm) argm = [argm];
			script_execute_ext(func, argm);
			_err = true;
		} catch (e) {
			if argument_count > 2 and (e != argument[2]) _err = true;
		}
		if _err throw "thrower error";
	}
	
	//
	function unthrower(func, argm) {
		try {
			if !is_array(argm) argm = [argm];
			script_execute_ext(func, argm);
		} catch (e) {
			throw "thrower error: " + e;
		}
	}
	
	//
	global.__ = false;
	function bomb() {
		global.__ = true;
	}
	
	function bomb_demine() {
		if global.__ 
			global.__ = false;
		else
			throw "bomb empty";
	}
	
	//
	function eqSpace(a, b) {
		var _a, _b;
		with a _a = self;
		with b _b = self;
		return _a == _b;
	}
	
#endregion

//
if (test.current == test.nothing) exit;

#region 0 test - main
if (test.current == test.main) {
	
	//
	log("test: main");
	
	#region 0 snGroup, is_snGroup - basic
		
		//
		log("section: 0-0");
		
		//
		var _index = variable_struct_names_count(self);
		
		// super basic
		var group = snGroup();
		assert_is_struct(group);
		assert_equal(string(group), "<snGroup>");
		assert(is_snGroup(group));
		assert_fail(is_snGroup({}));
		assert_fail(is_snGroup(undefined));
		assert_fail(is_snGroup(0));
		assert_fail(is_snGroup(""));
		assert_fail(is_snGroup([]));
		assert(is_snGroup(snGroup()));
		assert(is_snGroup(snGroup()));
		
		// izol
		assert_equal(variable_struct_names_count(self), _index);
		assert_fail(find(group));
		
		// izol 2
		assert_doesnt_have_key(self, "group");
		self.group = group;
		assert(find(group));
		assert_has_key(self, "group");
		variable_struct_remove(self, "group");
		assert_fail(find(group));
		assert(self == gl());
		assert_doesnt_have_key(self, "group");
		
		// key inhr
		snGroup("yes");
		assert_has_key(self, "yes");
		assert_is_struct(self.yes);
		assert_equal(string(self.yes), "<snGroup>");
		assert(is_snGroup(self.yes));
		variable_struct_remove(self, "yes");
		assert_doesnt_have_key(self, "yes");
		
	#endregion
	
	#region 1 throw - basic
		
		//
		log("section: 0-1");
		
		// snGroup
		thrower(snGroup, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
		thrower(snGroup, "");
		unthrower(thrower, [snGroup, ""]);
		
		try {
			unthrower(snGroup, "");
		} catch (e) {
			log("-ignore un");
			bomb();
		}
		
		bomb_demine();
		
		try {
			thrower(snGroup, "yes");
		} catch (e) {
			log("-ignore tr");
			assert_has_key(self, "yes");
			variable_struct_remove(self, "yes");
			assert_doesnt_have_key(self, "yes");
			bomb();
		}
		
		bomb_demine();
		
		//
		try {
			bomb_demine();
		} catch (e) {
			log("bomb is work: " + e);
		}
		
		//
		unthrower(snGroup, "k");
		thrower(snGroup, "k");
		thrower(snGroup, "k", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
		
		// runInterface
		var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
		var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
		thrower(snRunAccess, [], runInterface);
		thrower(snRunDefault, [], runInterface);
		thrower(snRunCoder, [], runInterface);
		thrower(snRunMarker, [], runInterface);
		thrower(snRunField_postMarker, [], runInterface);
		thrower(snCodAccess, [], codInterface);
		thrower(snCodMarkerGet, [], codInterface);
		thrower(snRCRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
		
		//
		assert_has_key(self, "k");
		variable_struct_remove(self, "k");
		assert_doesnt_have_key(self, "k");
		
	#endregion
	
	#region 2 intermediate
		
		//
		log("section: 0-2");
		
		//
		stc = snRunner(false, function() {
			
			//
			var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
			var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
			thrower(snRunAccess, [], runInterface);
			thrower(snRunDefault, [], runInterface);
			thrower(snRunCoder, [], runInterface);
			thrower(snRunMarker, [], runInterface);
			thrower(snRunField_postMarker, [], runInterface);
			thrower(snCodAccess, [], codInterface);
			thrower(snCodMarkerGet, [], codInterface);
			thrower(snRCRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			
			//
			other.hi = "hello";
			assert_has_key(self, "hi");
			assert(is_snGroup(self));
			assert(eqSpace(self, other));
			assert(eqSpace(self, self));
			assert(eqSpace(other, other));
			assert_fail(eqSpace(self, {}));
			assert_fail(eqSpace({}, {}));
		});
		
		//
		assert_has_key(self, "stc");
		assert_is_struct(self.stc);
		assert_equal(string(self.stc), "<snGroup>");
		assert(is_snGroup(self.stc));
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 3 snGroup-interface, snRunAccess, snRunDefault + thrower
		
		//
		log("section: 0-3");
		
		//
		stc = snRunner(true, function() {
			
			//
			assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
			assert(eqSpace(self, other));
			assert(is_snGroup(self));
			
			//
			assert(self == snRunAccess());
			assert(self == snRunAccess("root"));
			assert(self == snRunAccess("r"));
			assert(self == snRunAccess("rasdfsdf2"));
			assert(self == snRunAccess("r3634t"));
			assert(self == snRunAccess(0));
			assert(self == snRunAccess(undefined));
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == undefined);
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == self);
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == self);
			assert(undefined == snRunAccess(-1));
			assert(undefined == snRunAccess(-1, 1));
			assert(self == snRunAccess(-1, 0));
			assert(undefined == snRunAccess("p"));
			assert(undefined == snRunAccess("p", 1));
			assert(self == snRunAccess("p", 0));
			assert(undefined == snRunAccess("pasdf"));
			assert(undefined == snRunAccess("p23fqf", 1));
			assert(self == snRunAccess("psf2", 0));
			assert(self == snRunAccess(1));
			assert(self == snRunAccess("hook"));
			assert(self == snRunAccess("h"));
			assert(self == snRunAccess("h23ffe23"));
			assert(self == snRunAccess("h23t223"));
			assert(self == snRunAccess(""));
			assert(self == snRunAccess(-1, -1));
			assert(self == snRunAccess(-1, -2));
			assert(self == snRunAccess(-1, -3));
			
			//
			thrower(snRunAccess, [-1, 2], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			thrower(snRunAccess, [-1, 3], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			thrower(snRunAccess, [-1, 4], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			
			//
			
		});
		
		//
		assert_has_key(self, "stc");
		assert_is_struct(self.stc);
		assert_equal(string(self.stc), "<snGroup>");
		assert(is_snGroup(self.stc));
		
		//
		
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
}
#endregion

/*
//
show_message(method_get_index(method(undefined, 10))())

//
show_debug_message("\n\tTester\n");

//
groupMarkirator({});

//
if (test.current == test.nothing) exit;

//
if (test.current == test.addition) {
	var value = "error";
	var str = snRunner(false, function() {
	}, value);
	assert_throws([snCleaner, undefined], "\n\tsingletonTools:\n\tthere is no key '" + value + "' in the group\n\n");
	show_message("all okey");
	exit;
}

//
function log() {
	var str = "\t", i = 0;
	repeat argument_count
		str += string_replace_all(string_replace_all(argument[i++], "\n", "\\n"), "\t", "\\t") + (i < argument_count ? " " : "");
	show_debug_message(str);
}

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
assert_throws([snRunAccess, undefined], "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n");
assert_throws([snRunDefault, undefined], "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n");

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
var struct = snRunner(true, function() {
	list = ds_list_create();
	assert(ds_exists(list, ds_type_list));
	clear = function() {
		ds_list_destroy(list);
		log("ds_list destroy", list);
	}
	var out = snGroup();
	assert_equal(variable_struct_names_count(out), 0);
	assert(is_snGroup(self));
	assert(self == snRunAccess());
	assert(self == snRunAccess("root"));
	assert(self == snRunAccess("r"));
	assert(self == snRunAccess(0));
	assert(self == snRunAccess(undefined));
	assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
	assert(___devlocomotive_singletonTools_snHidden_accs_._prev == undefined);
	assert(___devlocomotive_singletonTools_snHidden_accs_._root == self);
	assert(___devlocomotive_singletonTools_snHidden_accs_._hook == self);
	assert(undefined == snRunAccess(-1));
	assert(undefined == snRunAccess(-1, 1));
	assert(self == snRunAccess(-1, 0));
	assert(self == snRunAccess(-1, -1));
	assert(self == snRunAccess(-1, -10));
	var _g1 = {};
	snRunDefault("base", _g1);
	var _g0 = ___devlocomotive_singletonTools_snHidden_accs_._defs;
	var _i0 = self;
	with snGroup("next") {
		assert(is_snGroup(self));
		assert(other == snRunAccess("root"));
		assert(other == snRunAccess("r"));
		assert(other == snRunAccess(0));
		assert(other == snRunAccess(undefined));
		assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
		assert_has_key(self, "base");
		assert(base == _g1);
		var _g2 = ___devlocomotive_singletonTools_snHidden_accs_._defs;
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
		var _i1 = self;
		with snGroup("a") {
			assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
			assert(other == _i1);
			assert(other == snRunAccess("previous"));
			assert(other == snRunAccess("p"));
			assert(other == snRunAccess(-1));
			assert(other == snRunAccess(-1, 1));
			assert(other == snRunAccess("p", 1));
			assert(other == snRunAccess("previous", 1));
			assert(_i0 == snRunAccess("hook"));
			assert(_i0 == snRunAccess("h"));
			assert(_i0 == snRunAccess(1));
			assert(_i0 == snRunAccess());
			assert(_i0 == snRunAccess(0));
			assert(_i0 == snRunAccess("root"));
			assert(_i0 == snRunAccess("r"));
			assert(_i0 == snRunAccess(undefined));
			assert_has_key(self, "name");
			assert(name == "NamedWow");
			assert_doesnt_have_key(self, "base");
			snRunDefault("name", "NamedNews");
			with snGroup("_a") {
				assert_doesnt_have_key(self, "base");
				assert_has_key(self, "name");
				assert(name == "NamedNews");
				assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
			}
			assert(name == "NamedWow");
		}
		with snGroup("b") {
			assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
			assert(other == _i1);
			assert(other == snRunAccess("previous"));
			assert(other == snRunAccess("p"));
			assert(other == snRunAccess(-1));
			assert(other == snRunAccess(-1, 1));
			assert(other == snRunAccess("p", 1));
			assert(other == snRunAccess("previous", 1));
			assert(_i0 == snRunAccess("hook"));
			assert(_i0 == snRunAccess("h"));
			assert(_i0 == snRunAccess(1));
			assert(_i0 == snRunAccess());
			assert(_i0 == snRunAccess(0));
			assert(_i0 == snRunAccess("root"));
			assert(_i0 == snRunAccess("r"));
			assert(_i0 == snRunAccess(undefined));
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
			assert(other == _i1);
			assert(other == snRunAccess("previous"));
			assert(other == snRunAccess("p"));
			assert(other == snRunAccess(-1));
			assert(other == snRunAccess(-1, 1));
			assert(other == snRunAccess("p", 1));
			assert(other == snRunAccess("previous", 1));
			assert(_i0 == snRunAccess("hook"));
			assert(_i0 == snRunAccess("h"));
			assert(_i0 == snRunAccess(1));
			assert(_i0 == snRunAccess());
			assert(_i0 == snRunAccess(0));
			assert(_i0 == snRunAccess("root"));
			assert(_i0 == snRunAccess("r"));
			assert(_i0 == snRunAccess(undefined));
			assert_doesnt_have_key(self, "base");
			assert_has_key(self, "name");
			assert(name == "NamedWow");
		}
		with snGroup("d", true) {
			assert(other == _i1);
			assert(other == snRunAccess("previous"));
			assert(other == snRunAccess("p"));
			assert(other == snRunAccess(-1));
			assert(other == snRunAccess(-1, 1));
			assert(other == snRunAccess("p", 1));
			assert(other == snRunAccess("previous", 1));
			assert(self == snRunAccess("hook"));
			assert(self == snRunAccess("h"));
			assert(self == snRunAccess(1));
			assert(_i0 == snRunAccess());
			assert(_i0 == snRunAccess(0));
			assert(_i0 == snRunAccess("root"));
			assert(_i0 == snRunAccess("r"));
			assert(_i0 == snRunAccess(undefined));
			assert_doesnt_have_key(self, "base");
			assert_has_key(self, "name");
			assert(name == "NamedWow");
			var _i00 = self;
			has = "mark";
			with snGroup("a") {
				with snGroup("a", true) {
					var _i01 = self;
					with snGroup("a") {
						assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
						assert_has_key(self, "name");
						assert(name == "NamedWow");
						assert(_i01 == other);
						assert(other == snRunAccess("previous"));
						assert(other == snRunAccess("p"));
						assert(other == snRunAccess(-1));
						assert(other == snRunAccess(-1, 1));
						assert(other == snRunAccess("p", 1));
						assert(other == snRunAccess("previous", 1));
						assert(_i01 == snRunAccess("hook"));
						assert(_i01 == snRunAccess("h"));
						assert(_i01 == snRunAccess(1));
						assert(_i0 == snRunAccess());
						assert(_i0 == snRunAccess(0));
						assert(_i0 == snRunAccess("root"));
						assert(_i0 == snRunAccess("r"));
						assert(_i0 == snRunAccess(undefined));
						assert_has_key(snRunAccess(-1, 3), "has");
						assert_equal(snRunAccess(-1, 3).has, "mark");
						assert(snRunAccess(-1, 5) == snRunAccess("root"));
						assert(snRunAccess(-1, 5) == _i0);
						assert(snRunAccess(-1, 6) == undefined);
						try {
							snRunAccess(-1, 7);
						} catch (e) {
							if (e != "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n")
								show_error("error", true);
						}try {
							snRunAccess(-1, 8);
						} catch (e) {
							if (e != "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n")
								show_error("error", true);
						}
						assert(self == snRunAccess(-1, 0));
						assert(self == snRunAccess(-1, -1));
						assert(self == snRunAccess(-1, -100));
					}
				}
			}
		}
	}
}, "clear");

//
var struct2 = snRunner(false, function() {
	grid = ds_grid_create(1, 1);
	assert(ds_exists(grid, ds_type_grid));
	clear = function() {
		ds_grid_destroy(grid);
		log("ds_grid destroy", grid);
	}
	assert_throws([snRunAccess, undefined], "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n");
	assert_throws([snRunDefault, undefined], "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n");
}, "clear");

//
snRunner(false, function() {
	name = "superman - vinai";
}, function() {
	log("test cleaner:", name);
});

//
snRunner(false, function() {
	log("no cleaner");
});

//
var struct3 = snRunner(true, function() {
	snRunCoder(10, function(){show_message("3")});
	snRunCoder(10, function(){show_message("1")});
	snRunCoder(10, function(){show_message("2")});
	snRunCoder(-100, function(){show_message("-100")});
	out = snGroup();
	out.___devlocomotive_singletonTools_snHidden_accs_ = "test";
	assert_throws([snRunDefault, ""], "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n");
	assert_throws([snRunDefault, undefined], "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n");
	assert_throws([snRunDefault, "___devlocomotive_singletonTools_snHidden_test"], "\n\tyou cannot use the '___devlocomotive_singletonTools_snHidden_' prefix in the field name\n\n");
});

//
function groupMarkirator(struct) {
	static name = "__wow_marker_wow__";
	static stack = [];
	var main = (array_length(stack) == 0), i = 0, val, names = variable_struct_get_names(struct);
	if main and is_snGroup(struct) {
		if !variable_struct_exists(struct, name) {
			variable_struct_set(struct, name, undefined);
			array_push(stack, struct);
		}
	}
	repeat array_length(names) {
		val = variable_struct_get(struct, names[i++]);
		if is_snGroup(val) and !variable_struct_exists(val, name) {
			variable_struct_set(val, name, undefined);
			array_push(stack, val);
			groupMarkirator(val);
		}
	}
	if main {
		i = 0;
		repeat array_length(stack) variable_struct_remove(stack[i++], name);
		val = stack;
		stack = [];
		return val;
	}
}

//
function groupDontHaveKeys(struct, keys) {
	if !is_array(keys) keys = [keys];
	var marking = groupMarkirator(struct), i = 0, j, stc;
	repeat array_length(marking) {
		stc = marking[i++];
		j = 0;
		repeat array_length(keys) {
			if variable_struct_exists(stc, keys[j++]) return false;
		}
	}
	return true;
}

//
assert(groupDontHaveKeys(struct, "___devlocomotive_singletonTools_snHidden_accs_"));
struct.next.a._a.___devlocomotive_singletonTools_snHidden_accs_ = "test";
assert_fail(groupDontHaveKeys(struct, "___devlocomotive_singletonTools_snHidden_accs_"));

//
assert(groupDontHaveKeys(struct2, "___devlocomotive_singletonTools_snHidden_accs_"));
assert_doesnt_have_key(struct2, "___devlocomotive_singletonTools_snHidden_accs_");

//
assert_fail(groupDontHaveKeys(struct3, "___devlocomotive_singletonTools_snHidden_accs_"));

//
assert_fail(find(struct));
assert_fail(find(struct.next));
assert_doesnt_have_key(struct, "___devlocomotive_singletonTools_snHidden_accs_");
assert_doesnt_have_key(struct.next, "___devlocomotive_singletonTools_snHidden_accs_");

//
snCleaner();

//
assert_throws([snCleaner, undefined], "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n");

//
assert_fail(ds_exists(struct.list, ds_type_list));
assert_fail(ds_exists(struct2.grid, ds_type_grid));

//
show_message("all okey");