
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
		return new constr();
	else {
		var key = argument[0];
		if !is_string(key) or (key == "") throw "\n\tthe key must be a string and contain at least one character\n\n";
	}
    if variable_struct_exists(self, key) throw "key is busy";
    var news = new constr();
    if is_snGroup(self) and variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_accs_") {
    	var defs_loc = self.__devlocomotive_singletonTools_snHide_accs_.defs;
    	var names = variable_struct_get_names(defs_loc), i = 0, defs_new = {}, key, val;
    	repeat array_length(names) {
    		key = names[i++];
    		if (string_pos("__devlocomotive_singletonTools_snHide_", key) == 1) continue;
    		val = variable_struct_get(defs_loc, key);
    		variable_struct_set(news, key, val);
	    	variable_struct_set(defs_new, key, val);
    	}
    	news.__devlocomotive_singletonTools_snHide_accs_ = 
    		{ root : self.__devlocomotive_singletonTools_snHide_accs_.root
    		, hook : (argument_count > 1 ? argument[1] : false) ? news : self.__devlocomotive_singletonTools_snHide_accs_.hook
    		, defs : defs_new
    		}
    }
    variable_struct_set(self, key, news);
    return news;
}

/// @function is_snGroup(group);
/// @description
/// @param group {snGroup}
function is_snGroup() {
    static instance = instanceof(snGroup());
    return is_struct(argument0) and (instanceof(argument0) == instance);
}

/// @function snRunner(runner, [cleaner]);
/// @description
/// @param runner  {method}
/// @param cleaner {method/string}
function snRunner() {
	static snAccessClear = method_get_index(function(recursion) {
		variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_accs_");
		var i = 0, names = variable_struct_get_names(self), val;
		repeat array_length(names) {
			val = variable_struct_get(self, names[i++]);
			if is_snGroup(val) and variable_struct_exists(val, "__devlocomotive_singletonTools_snHide_accs_")
				method(val, recursion)(recursion);
		}
	});
	var runner = argument[0];
var cleaner = argument_count > 1 ? argument[1] : undefined;
    if is_method(cleaner) {
    	var group = snGroup();
    	group.__devlocomotive_singletonTools_snHide_auto_ = undefined;
    	group.run = method(struct, cleaner);
        snCleaner(group);
    } else if is_string(cleaner) and (cleaner != "") {
        var group = snGroup();
        group.__devlocomotive_singletonTools_snHide_auto_ = undefined;
        group.struct = struct;
        group.name = cleaner;
        snCleaner(group);
    }
    struct = snGroup();
	struct.__devlocomotive_singletonTools_snHide_accs_ =
		{ root : struct
		, hook : struct
		, defs : {}
		}
	method(struct, runner)();
	method(struct, snAccessClear)(snAccessClear);
    return struct;
}

/// @function snCleaner();
/// @description
function snCleaner() {
    static stack = [];
    if argument_count {
    	var push = argument[0];
    	if is_snGroup(push) and variable_struct_exists(push, "__devlocomotive_singletonTools_snHide_auto_") {
    		variable_struct_remove(push, "__devlocomotive_singletonTools_snHide_auto_");
    		array_push(stack, push);
    		exit;
    	}
    }
    if is_undefined(stack) throw "\n\tthe application is assumed to be complete. (you may have accidentally used <snCleaner> with no arguments)\n\n";
    var i = 0, run;
    repeat array_length(stack) {
    	run = stack[i++];
    	if variable_struct_exists(run, "run")
    		run.run();
    	else {
    		if !variable_struct_exists(val.struct, val.name) throw ("\n\tthere is no value in the group <" + val.name + ">\n\n");
        	var get = variable_struct_get(val.struct, val.name);
        	if !is_undefined(get) with val get();
    	}
    }
    stack = undefined;
}

/// @function snAutoAccess([-1#previous;1#hook;default#root]);
/// @description
/// @param [-1#previous;1#hook;0|default#root] {number/string}
function snAutoAccess() {
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_accs_") 
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) {
			if (argument[0] != "") {
				var char = string_char_at(argument[0], 1);
				if (char == "p") return other;
				if (char == "h") return self.__devlocomotive_singletonTools_snHide_accs_.hook;
			}
			return self.__devlocomotive_singletonTools_snHide_accs_.root;
		} else if is_numeric(argument[0]) {
		    if (argument[0] == -1) return other;
		    if (argument[0] == 1)  return self.__devlocomotive_singletonTools_snHide_accs_.hook;
		}
	}
    return self.__devlocomotive_singletonTools_snHide_accs_.root;
}

/// @function snDefault(key, [value]);
/// @description
/// @param key   {string}
/// @param value {any}
function snDefault() {
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_accs_") 
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if !is_string(argument[0]) or (argument[0] == "") throw "\n\tthe key must be a string and contain at least one character\n\n";
	if (argument_count > 1)
		variable_struct_set(self.__devlocomotive_singletonTools_snHide_accs_.defs, argument[0], argument[1]);
	else {
		var defs = self.__devlocomotive_singletonTools_snHide_accs_.defs;
		if variable_struct_exists(defs, argument[0]) variable_struct_remove(defs, argument[0]);
	}
}

/* replacer
	__devlocomotive_singletonTools_snHide_:
		__devlocomotive_singletonTools_snHide_auto_
		__devlocomotive_singletonTools_snHide_accs_
*/

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
