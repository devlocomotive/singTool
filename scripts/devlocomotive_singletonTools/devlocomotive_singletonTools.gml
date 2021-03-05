
/* info
    name            \\ singletonTools
    version         \\ 100 (from 04.03.21)
    autor           \\ devlocomotive
    data            \\ 02.03.21
*/

/* link
    git-hub         \\ 
    marketplace     \\ 
    itch            \\ 
*/

/* description
    
*/

//****************************************************************************//
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/// @function snGroup([key], [<runner>-hook]);
/// @description
/// @param [key]           {string}
/// @param [<runner>-hook] {bool}
function snGroup() {
    static constr = method_get_index(function() constructor {
    	static toString = function() {
    		return "<snGroup>";
    	}
    });
	if (argument_count == 0)
		return new constr(); // [arg 0] just return new group
	else {
		var key = argument[0];
		if !is_string(key) or (key == "") throw "\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	}
    if variable_struct_exists(self, key) throw "\n\tkey is busy\n\n"; // check argument {key} is no busy
    var news = new constr();
    if is_snGroup(self) and variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_accs_") { // if used <snRunner> -> create access
    	var defs_loc = self.__devlocomotive_singletonTools_snHide_accs_.defs;
    	var names = variable_struct_get_names(defs_loc), i = 0, defs_new = {}, key, val;
    	repeat array_length(names) { // used <snDefault> mechanism
    		key = names[i++];
    		if (string_pos("__devlocomotive_singletonTools_snHide_", key) == 1) continue; // exeption (+ ``)
    		val = variable_struct_get(defs_loc, key);
    		variable_struct_set(news, key, val);
	    	variable_struct_set(defs_new, key, val);
    	}
    	news.__devlocomotive_singletonTools_snHide_accs_ = // access
    		{ prev : self
    		, root : self.__devlocomotive_singletonTools_snHide_accs_.root
    		, hook : (argument_count > 1 ? argument[1] : false) ? news : self.__devlocomotive_singletonTools_snHide_accs_.hook // "fresh meat"
    		, defs : defs_new // new default for independent inheritance
    		}
    }
    variable_struct_set(self, key, news); // set a key in current struct
    return news; // return new group
}

/// @function is_snGroup(group);
/// @description
/// @param group {snGroup}
function is_snGroup() {
    static instance = instanceof(snGroup());
    return is_struct(argument0) and (instanceof(argument0) == instance); // check hidden instanceof
}

/// @function snRunner(runner, [cleaner]);
/// @description
/// @param runner  {method}
/// @param cleaner {method/string}
function snRunner() {
	static snAccessClear = method_get_index(function(recursion) { // remove access
		variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_accs_");
		var i = 0, names = variable_struct_get_names(self), val;
		repeat array_length(names) {
			val = variable_struct_get(self, names[i++]);
			if is_snGroup(val) and variable_struct_exists(val, "__devlocomotive_singletonTools_snHide_accs_")
				method(val, recursion)(recursion);
		}
	});
	var cleaner = argument_count > 1 ? argument[1] : undefined; // cleaner
    var struct = snGroup();
    if is_method(cleaner) { // used method
    	var group = snGroup();
    	group.__devlocomotive_singletonTools_snHide_auto_ = undefined;
    	group.run = method(struct, cleaner);
        snCleaner(group);
    } else if is_string(cleaner) and (cleaner != "") { // used field struct
        var group = snGroup();
        group.__devlocomotive_singletonTools_snHide_auto_ = undefined;
        group.struct = struct;
        group.name = cleaner;
        snCleaner(group);
    }
	struct.__devlocomotive_singletonTools_snHide_accs_ = // open access
		{ prev : undefined
		, root : struct
		, hook : struct
		, defs : {}
		}
	method(struct, argument[0])(); // run {runner}
	method(struct, snAccessClear)(snAccessClear); // close access
    return struct; // new singleton
}

/// @function snCleaner();
/// @description
function snCleaner() {
    static stack = [];
    if argument_count {
    	if is_snGroup(argument[0]) and variable_struct_exists(argument[0], "__devlocomotive_singletonTools_snHide_auto_") { // hide - push to stack-cleaner
    		variable_struct_remove(argument[0], "__devlocomotive_singletonTools_snHide_auto_");
    		array_push(stack, argument[0]);
    		exit;
    	}
    }
    if is_undefined(stack) throw "\n\tthe application is assumed to be complete\n\n"; // if the stack has already been used
    var i = 0, run;
    repeat array_length(stack) {
    	run = stack[i++];
    	if variable_struct_exists(run, "run")
    		run.run(); // used method
    	else { // used field struct
    		if !variable_struct_exists(run.struct, run.name) throw ("\n\tthere is no key <" + run.name + "> in the group\n\n"); // if field not exists
        	var get = variable_struct_get(run.struct, run.name);
        	if !is_undefined(get) with run get();
    	}
    }
    stack = undefined; // clear stack
}

/// @function snAutoAccess([-1#previous;1#hook;default#root], [<previous>-level]);
/// @description
/// @param [-1#previous;1#hook;0|default#root] {number/string}
/// @param [<previous>-level]				   {count}
function snAutoAccess() {
	static getPrevious = method_get_index(function(count) { // previous-level get
		if (count >= 1) {
			var root = self.__devlocomotive_singletonTools_snHide_accs_.prev;
			repeat (count - 1) {
				if is_undefined(root) throw "\n\tcannot rise higher than the root group\n\n"; // if current group is root
				root = root.__devlocomotive_singletonTools_snHide_accs_.prev;
			}
			return root;
		}
		return self;
	});
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_accs_") // used only when using <snRunner>
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if (argument[0] != "") {
				argument[0] = string_char_at(argument[0], 1);
				if (argument[0] == "p") return getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
				if (argument[0] == "h") return self.__devlocomotive_singletonTools_snHide_accs_.hook;
			}
			return self.__devlocomotive_singletonTools_snHide_accs_.root; // or root
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]);
		    if (argument[0] == -1) return getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
		    if (argument[0] == 1)  return self.__devlocomotive_singletonTools_snHide_accs_.hook;
		}
	}
    return self.__devlocomotive_singletonTools_snHide_accs_.root; // or root
}

/// @function snDefault(key, [value]);
/// @description
/// @param key   {string}
/// @param value {any}
function snDefault() {
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_accs_") // used only when using <snRunner>
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if !is_string(argument[0]) or (argument[0] == "") throw "\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	if (argument_count > 1)
		variable_struct_set(self.__devlocomotive_singletonTools_snHide_accs_.defs, argument[0], argument[1]); // set value-default
	else {
		if (argument_count > 0) { // remove value-default
			var defs = self.__devlocomotive_singletonTools_snHide_accs_.defs;
			if variable_struct_exists(defs, argument[0]) variable_struct_remove(defs, argument[0]);
		} else self.__devlocomotive_singletonTools_snHide_accs_.defs = {}; // remove all value-default
	}
}

/* for replacer
	__devlocomotive_singletonTools_snHide_:
		__devlocomotive_singletonTools_snHide_auto_
		__devlocomotive_singletonTools_snHide_accs_
*/

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
