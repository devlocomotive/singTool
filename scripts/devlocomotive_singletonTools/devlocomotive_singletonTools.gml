
/* info
    name            \\ singletonTools
    version         \\ 100
    autor           \\ devlocomotive
    data-create     \\ 02.03.21
    data-updata     \\ 07.03.21
*/

/* link
    git-hub         \\ https://github.com/devlocomotive/singTool
*/

/* description
	design tool for writing singletons
	this tool hides some things, and does some routine (rather specific)
	there is nothing new and special here
*/

///**************************************************************************///
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* */

// throw format "\n\tsingletonTools:\n\t" + message + "\n\n"

/// @function snGroup([key], [(snRunner)-hook]);
/// @description just:snGroup() -> creates an empty group (a regular structure created by another constructor)
//				 just:snGroup("key") -> creates an empty group and sets it to the current structure with the key "key"
//				 -- used <sn-interface> --
//				 snGroup() -> snGroup()
//				 snGroup("key") -> just:snGroup("key") -> generates access to groups above and inheritance of fields
//				 snGroup("key", true) -> just:snGroup("key") -> the access field <hook> refers to the new group
/// @param [key]             {string}
/// @param [(snRunner)-hook] {bool}
function snGroup() {
	static __devlocomotive_singletonTools_snHidden_f_construct = method_get_index(function() constructor {
		static toString = function() {
    		return "<snGroup>";
    	}
	});
	if (argument_count == 0)
		return new __devlocomotive_singletonTools_snHidden_f_construct(); // [arg 0] just return new group
	else {
		var key = argument[0];
		if !is_string(key) or (key == "") throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	}
	var target = self;
    if variable_struct_exists(target, key) throw "\n\tsingletonTools:\n\tkey is busy\n\n"; // check argument {key} is no busy
    var news = new __devlocomotive_singletonTools_snHidden_f_construct();
    if is_snGroup(target) and variable_struct_exists(target, "__devlocomotive_singletonTools_snHidden_accs_") { // if used <sn-interface> -> create access
    	var defs_loc = target.__devlocomotive_singletonTools_snHidden_accs_.defs;
    	var names = variable_struct_get_names(defs_loc), i = 0, defs_new = {}, defs_key, val;
    	repeat array_length(names) { // used <snRunDefault> mechanism
    		defs_key = names[i++];
    		if (string_pos("__devlocomotive_singletonTools_snHidden_", defs_key) == 1) continue; // exeption keys
    		val = variable_struct_get(defs_loc, defs_key);
    		variable_struct_set(news, defs_key, val);
	    	variable_struct_set(defs_new, defs_key, val);
    	}
    	var root = target.__devlocomotive_singletonTools_snHidden_accs_.root;
    	news.__devlocomotive_singletonTools_snHidden_accs_ = // access create
    		{ prev : target
    		, root : root
    		, hook : (argument_count > 1 ? argument[1] : false) ? news : target.__devlocomotive_singletonTools_snHidden_accs_.hook
    		, defs : defs_new // new default for independent inheritance
    		}
    	var access_clear = new __devlocomotive_singletonTools_snHidden_f_construct();
    	access_clear.__devlocomotive_singletonTools_snHidden_type_ = "temp-push";
    	access_clear.id = root.__devlocomotive_singletonTools_snHidden_accs_.id;
    	access_clear.group = news;
    	snCleaner(access_clear); // access-clear memory
    }
    variable_struct_set(target, key, news); // set a key in current struct
    return news; // return new group
}

/// @function is_snGroup(value);
/// @description is_snGroup(value) -> will return true if the value is a group
/// @param value {any}
function is_snGroup() {
	static __devlocomotive_singletonTools_snHidden_d_instance = instanceof(snGroup());
    return is_struct(argument0) and (instanceof(argument0) == __devlocomotive_singletonTools_snHidden_d_instance); // check hidden instanceof
}

/// @function snRunner(sn-interface, runner, [cleaner]);
/// @description snRunner -> will run the code in the new group and return it
//				 snRunner(false, runner) -> will run the {runner} script, without the <sn-interface> interface
//				 snRunner(true, runner) -> will run the {runner} script from the <sn-interface> interface
//				 -- additional argument --
//				 snRunner(sn-interface, runner, "field") -> add to the global delete stack, a link to the specified "field"
//				 snRunner(sn-interface, runner, method/function) -> will add to the global stack delete, the method referring to the singleton
/// @param sn-interface {bool}
/// @param runner       {method}
/// @param cleaner      {method/string}
function snRunner() {
	static __devlocomotive_singletonTools_snHidden_f_typeSet = method_get_index(function(type, data) {
		if !is_snGroup(data) {
			var read = data;
			data = snGroup();
			if is_struct(read) {
				var names = variable_struct_get_names(read), i = 0, key;
				repeat array_length(names) {
					key = names[i++];
					variable_struct_set(data, key, variable_struct_get(read, key));
				}
			}
		}
		data.__devlocomotive_singletonTools_snHidden_type_ = type;
		return snCleaner(data);
	});
	var struct = snGroup(), cleaner = argument_count > 2 ? argument[2] : undefined;
    if is_method(cleaner)
    	__devlocomotive_singletonTools_snHidden_f_typeSet("cleaner", {run : method(struct, cleaner)}); // method cleaner
    else if is_string(cleaner) and (cleaner != "")
	    __devlocomotive_singletonTools_snHidden_f_typeSet("cleaner", {struct : struct, name : cleaner}); // field cleaner
    if argument[0] {
	    var current = snGroup();
	    current.id = __devlocomotive_singletonTools_snHidden_f_typeSet("temp-id");
	    current.group = struct;
	    __devlocomotive_singletonTools_snHidden_f_typeSet("temp-push", current); // open access memory
		struct.__devlocomotive_singletonTools_snHidden_accs_ = // open access work
			{ id : current.id
			, prev : undefined
			, root : struct
			, hook : struct
			, defs : {}
			}
		method(struct, argument[1])(); // run {runner} with <sn-interface>
		__devlocomotive_singletonTools_snHidden_f_typeSet("temp-clear", current); // close access
    } else method(struct, argument[1])(); // run {runner} without <sn-interface>
	return struct; // new singleton
}

/// @function snCleaner();
/// @description snCleaner() -> will run methods and methods from fields
/// @param <none> {none}
function snCleaner() {
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
    				var new_id = string(variable_struct_names_count(__devlocomotive_singletonTools_snHidden_d_stackTemp));
    				variable_struct_set(__devlocomotive_singletonTools_snHidden_d_stackTemp, new_id, []);
    				return new_id;
    				break;
    			case "temp-push":
    				array_push(variable_struct_get(__devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id), argument[0].group);
    				break;
    			case "temp-clear":
    				var stack_group = variable_struct_get(__devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id), i = 0;
    				repeat array_length(stack_group) variable_struct_remove(stack_group[i++], "__devlocomotive_singletonTools_snHidden_accs_");
    				variable_struct_remove(__devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id);
    				break;
    		}
    		exit;
    	}
    }
    if is_undefined(__devlocomotive_singletonTools_snHidden_d_stackCleaner) throw "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n"; // if the 'stackCleaner' has already been used
    var i = 0, run;
    repeat array_length(__devlocomotive_singletonTools_snHidden_d_stackCleaner) {
    	run = __devlocomotive_singletonTools_snHidden_d_stackCleaner[i++];
    	if variable_struct_exists(run, "run")
    		run.run(); // used method
    	else { // used field struct
    		if !variable_struct_exists(run.struct, run.name) throw ("\n\tsingletonTools:\n\tthere is no key '" + run.name + "' in the group\n\n"); // if field not exists
        	var get = variable_struct_get(run.struct, run.name);
        	if !is_undefined(get) with run get();
    	}
    }
	__devlocomotive_singletonTools_snHidden_d_stackCleaner = undefined; // clear 'stackCleaner'
}

/// @function snRunAccess([-1#previous;1#hook;default#root], [<previous>-level]);
/// @description -- used <sn-interface> --
//				 snRunAccess(1) -> <hook>
//				 snRunAccess("h" + "..any..") -> <hook>
//				 snRunAccess(-1) -> <previous>-1.level
//				 snRunAccess(-1, n < 1) -> <previous>-0.level (self)
//				 snRunAccess(-1, n > 1) -> <previous>-n.level
//  			 snRunAccess("p" + "..any..") -> <previous>-1.level
//				 snRunAccess("p" + "..any..", n < 1) -> <previous>-0.level (self)
//				 snRunAccess("p" + "..any..", n > 1) -> <previous>-n.level
//				 other -> <root>
/// @param [-1#previous;1#hook;0|default#root] {number/string}
/// @param [<previous>-level]				   {count}
function snRunAccess() {
	static __devlocomotive_singletonTools_snHidden_f_getPrevious = method_get_index(function(count) { // previous-level get
		if (count >= 1) {
			var root = self.__devlocomotive_singletonTools_snHidden_accs_.prev;
			repeat (count - 1) {
				if is_undefined(root) throw "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n"; // if current group is root
				root = root.__devlocomotive_singletonTools_snHidden_accs_.prev;
			}
			return root;
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

/// @function snRunDefault([key], [value]);
/// @description independent for each group
//			     -- used <sn-interface> --
//				 snRunDefault("key", value) -> set inheritance
//				 snRunDefault("key") -> remove inheritance
//				 snRunDefault() -> remove all inheritance
/// @param [key]   {string}
/// @param [value] {any}
function snRunDefault() {
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
		var defs = self.__devlocomotive_singletonTools_snHidden_accs_.defs;
		if variable_struct_exists(defs, argument[0]) variable_struct_remove(defs, argument[0]);
	}
}

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
///**************************************************************************///

/* for replacer
	__devlocomotive_singletonTools_snHidden_:
		data ->
		__devlocomotive_singletonTools_snHidden_type_ - super-hidden
		__devlocomotive_singletonTools_snHidden_accs_ - temp-hidden
		static ->
		__devlocomotive_singletonTools_snHidden_f_construct
		__devlocomotive_singletonTools_snHidden_d_instance
		__devlocomotive_singletonTools_snHidden_f_typeSet
		__devlocomotive_singletonTools_snHidden_d_stackCleaner
		__devlocomotive_singletonTools_snHidden_d_stackTemp
		__devlocomotive_singletonTools_snHidden_f_getPrevious
*/
