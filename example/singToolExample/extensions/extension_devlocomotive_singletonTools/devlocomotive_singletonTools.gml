
/* info
    name            \\ singletonTools
    version         \\ 100
    autor           \\ devlocomotive
    data-create     \\ 02.03.21
    data-updata     \\ 08.03.21
*/

/* link
    git-hub         \\ https://github.com/devlocomotive/singTool
*/

/* description
	design tool for writing singletons
	this tool hides some things, and does some routine (rather specific)
	there is nothing new and special here
*/

#define snGroup
{
	static __devlocomotive_singletonTools_snHidden_f_construct = method_get_index(function() constructor {
		static toString = function() {
    		return "<snGroup>";
    	}
	});
	if (argument_count == 0)
		return new __devlocomotive_singletonTools_snHidden_f_construct(); // [arg 0] just return new group
	else {
		var __key = argument[0];
		if !is_string(__key) or (__key == "") throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	}
	var __target = self;
    if variable_struct_exists(__target, __key) throw "\n\tsingletonTools:\n\tkey is busy\n\n"; // check argument {key} is no busy
    var __new_group = new __devlocomotive_singletonTools_snHidden_f_construct();
    if is_snGroup(__target) and variable_struct_exists(__target, "__devlocomotive_singletonTools_snHidden_accs_") { // if used <sn-interface> -> create access
    	var __defs_loc = __target.__devlocomotive_singletonTools_snHidden_accs_.defs, __defs_new = {}, __defs_key;
    	var __names = variable_struct_get_names(__defs_loc), i = 0, __val;
    	repeat array_length(__names) { // used <snRunDefault> mechanism
    		__defs_key = __names[i++];
    		if (string_pos("__devlocomotive_singletonTools_snHidden_", __defs_key) == 1) continue; // exeption keys
    		__val = variable_struct_get(__defs_loc, __defs_key);
    		variable_struct_set(__new_group, __defs_key, __val);
	    	variable_struct_set(__defs_new, __defs_key, __val);
    	}
    	var __root = __target.__devlocomotive_singletonTools_snHidden_accs_.root;
    	__new_group.__devlocomotive_singletonTools_snHidden_accs_ = // access create
    		{ prev : __target
    		, root : __root
    		, hook : (argument_count > 1 ? argument[1] : false) ? __new_group : __target.__devlocomotive_singletonTools_snHidden_accs_.hook
    		, defs : __defs_new // new default for independent inheritance
    		}
    	var __access_clear = new __devlocomotive_singletonTools_snHidden_f_construct();
    	__access_clear.__devlocomotive_singletonTools_snHidden_type_ = "temp-push";
    	__access_clear.id = __root.__devlocomotive_singletonTools_snHidden_accs_.id;
    	__access_clear.group = __new_group;
    	snCleaner(__access_clear); // access-clear memory
    }
    variable_struct_set(__target, __key, __new_group); // set a key in current struct
    return __new_group; // return new group
}

#define is_snGroup
{
	static __devlocomotive_singletonTools_snHidden_d_instance = instanceof(snGroup());
    return is_struct(argument0) and (instanceof(argument0) == __devlocomotive_singletonTools_snHidden_d_instance); // check hidden instanceof
}

#define snRunner
{
	static __devlocomotive_singletonTools_snHidden_f_typeSet = method_get_index(function(__type, __data) {
		if !is_snGroup(__data) {
			var __read = __data;
			__data = snGroup();
			if is_struct(__read) {
				var __names = variable_struct_get_names(__read), i = 0, __key;
				repeat array_length(__names) {
					__key = __names[i++];
					variable_struct_set(__data, __key, variable_struct_get(__read, __key));
				}
			}
		}
		__data.__devlocomotive_singletonTools_snHidden_type_ = __type;
		return snCleaner(__data);
	});
	var __struct = snGroup(), __cleaner = argument_count > 2 ? argument[2] : undefined;
    if is_method(__cleaner)
    	__devlocomotive_singletonTools_snHidden_f_typeSet("cleaner", {run : method(__struct, __cleaner)}); // method cleaner
    else if is_string(__cleaner) and (__cleaner != "")
	    __devlocomotive_singletonTools_snHidden_f_typeSet("cleaner", {struct : __struct, name : __cleaner}); // field cleaner
    if argument[0] {
	    var __current = snGroup();
	    __current.id = __devlocomotive_singletonTools_snHidden_f_typeSet("temp-id");
	    __current.group = __struct;
	    __devlocomotive_singletonTools_snHidden_f_typeSet("temp-push", __current); // open access memory
		__struct.__devlocomotive_singletonTools_snHidden_accs_ = // open access work
			{ id : __current.id
			, prev : undefined
			, root : __struct
			, hook : __struct
			, defs : {}
			}
		method(__struct, argument[1])(); // run {runner} with <sn-interface>
		__devlocomotive_singletonTools_snHidden_f_typeSet("temp-clear", __current); // close access
    } else method(__struct, argument[1])(); // run {runner} without <sn-interface>
	return __struct; // new singleton
}

#define snCleaner
{
    static __devlocomotive_singletonTools_snHidden_d_stackCleaner = [];
    static __devlocomotive_singletonTools_snHidden_d_stackTemp = {};
    if argument_count {
    	if is_snGroup(argument[0]) and variable_struct_exists(argument[0], "__devlocomotive_singletonTools_snHidden_type_") { // hide - push to 'stackCleaner'
    		switch variable_struct_get(argument[0], "__devlocomotive_singletonTools_snHidden_type_") {
    			case "cleaner": // cleaner memory
    				variable_struct_remove(argument[0], "__devlocomotive_singletonTools_snHidden_type_");
    				array_push(__devlocomotive_singletonTools_snHidden_d_stackCleaner, argument[0]);
    				break;
    			case "temp-id":
    				var __new_id = string(variable_struct_names_count(__devlocomotive_singletonTools_snHidden_d_stackTemp));
    				variable_struct_set(__devlocomotive_singletonTools_snHidden_d_stackTemp, __new_id, []);
    				return __new_id;
    				break;
    			case "temp-push":
    				array_push(variable_struct_get(__devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id), argument[0].group);
    				break;
    			case "temp-clear":
    				var __stack_group = variable_struct_get(__devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id), i = 0;
    				repeat array_length(__stack_group) variable_struct_remove(__stack_group[i++], "__devlocomotive_singletonTools_snHidden_accs_");
    				variable_struct_remove(__devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id);
    				break;
    		}
    		exit;
    	}
    }
    if is_undefined(__devlocomotive_singletonTools_snHidden_d_stackCleaner) throw "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n"; // if the 'stackCleaner' has already been used
    var i = 0, __run;
    repeat array_length(__devlocomotive_singletonTools_snHidden_d_stackCleaner) {
    	__run = __devlocomotive_singletonTools_snHidden_d_stackCleaner[i++];
    	if variable_struct_exists(__run, "run")
    		__run.run(); // used method
    	else { // used field struct
    		if !variable_struct_exists(__run.struct, __run.name) throw ("\n\tsingletonTools:\n\tthere is no key '" + __run.name + "' in the group\n\n"); // if field not exists
        	var __field_run = variable_struct_get(__run.struct, __run.name);
        	if !is_undefined(__field_run) with __run __field_run();
    	}
    }
	__devlocomotive_singletonTools_snHidden_d_stackCleaner = undefined; // clear 'stackCleaner'
}

#define snRunAccess
{
	static __devlocomotive_singletonTools_snHidden_f_getPrevious = method_get_index(function(__count) { // previous-level get
		if (__count >= 1) {
			var __root = self.__devlocomotive_singletonTools_snHidden_accs_.prev;
			repeat (__count - 1) {
				if is_undefined(__root) throw "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n"; // if current group is root
				__root = __root.__devlocomotive_singletonTools_snHidden_accs_.prev;
			}
			return __root;
		}
		return self;
	});
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHidden_accs_") // used only when using <sn-interface>
		throw "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if (argument[0] != "") {
				argument[0] = string_char_at(argument[0], 1);
				if (argument[0] == "p") return __devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
				if (argument[0] == "h") return self.__devlocomotive_singletonTools_snHidden_accs_.hook;
			}
			return self.__devlocomotive_singletonTools_snHidden_accs_.root; // or root
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]);
		    if (argument[0] == -1) return __devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
		    if (argument[0] == 1)  return self.__devlocomotive_singletonTools_snHidden_accs_.hook;
		}
	}
    return self.__devlocomotive_singletonTools_snHidden_accs_.root; // or root
}

#define snRunDefault
{
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHidden_accs_") // used only when using <sn-interface>
		throw "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n";
	if (argument_count == 0) {
		self.__devlocomotive_singletonTools_snHidden_accs_.defs = {}; // remove all value-default
		exit;
	}
	if !is_string(argument[0]) or (argument[0] == "") throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	if (argument_count > 1)
		variable_struct_set(self.__devlocomotive_singletonTools_snHidden_accs_.defs, argument[0], argument[1]); // set value-default
	else {
		// remove value-default
		var __defs = self.__devlocomotive_singletonTools_snHidden_accs_.defs;
		if variable_struct_exists(__defs, argument[0]) variable_struct_remove(__defs, argument[0]);
	}
}
