
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
    if is_struct(self) and variable_struct_exists(self, key) {
    	var type = variable_struct_get(self, key);
    	if is_snGroup(type) return type;
    	throw "\n\tthe key is busy with the wrong types\n\n";
    }
    var news = new constr();
    if is_snGroup(self) and variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_inhr_") {
    	var names = variable_struct_get_names(self.__devlocomotive_singletonTools_snHide_inhr_), i = 0, inhr = {}, key;
    	repeat array_length(names) {
    		key = names[i++];
    		if (string_pos("__devlocomotive_singletonTools_snHide_", key) == 1) or (key == "") continue;
    		variable_struct_set(news, key, variable_struct_get(self, key));
    		variable_struct_set(inhr, key, undefined);
    	}
    	news.__devlocomotive_singletonTools_snHide_inhr_ = inhr;
    	news.__devlocomotive_singletonTools_snHide_accs_ = 
    		{ root : self.__devlocomotive_singletonTools_snHide_accs_.root
    		, hook : (argument_count > 1 ? argument[1] : false) ? news : self.__devlocomotive_singletonTools_snHide_accs_.hook
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
		variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_inhr_");
		variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_accs_");
		var i = 0, names = variable_struct_get_names(self), val;
		repeat array_length(names) {
			val = variable_struct_get(self, names[i++]);
			if is_snGroup(val) and variable_struct_exists(val, "__devlocomotive_singletonTools_snHide_inhr_")
				method(val, recursion)(recursion);
		}
	});
	var runner = argument[0];
var cleaner = argument_count > 1 ? argument[1] : undefined;
    if is_method(cleaner)
        snCleaner(method(struct, cleaner));
    else if is_string(cleaner) {
        var group = snGroup();
        group.__devlocomotive_singletonTools_snHide_auto_ = undefined;
        group.struct = struct;
        group.name = cleaner;
        snCleaner(group);
    }
    struct = snGroup();
	struct.__devlocomotive_singletonTools_snHide_inhr_ = {};
	struct.__devlocomotive_singletonTools_snHide_accs_ =
		{ root : struct
		, hook : struct
		}
	method(struct, runner)();
	method(struct, snAccessClear)(snAccessClear);
    return struct;
}

/// @function snCleaner([push]);
/// @description
/// @param [push] {method}
function snCleaner() {
    static stack = [];
    if (argument_count == 0) {
    	if is_undefined(stack) throw "\n\tthe application is assumed to be complete. (you may have accidentally used <snCleaner> with no arguments)\n\n";
        var i = 0, val;
        repeat array_length(stack) {
            val = stack[i++];
            if is_struct(val) {
            	if !variable_struct_exists(val.struct, val.name) throw ("\n\tthere is no name in the group <" + val.name + ">\n\n");
            	var get = variable_struct_get(val.struct, val.name);
            	if !is_undefined(get) with val get();
            } else if is_method(val) val();
        }
        stack = undefined;
    } else {
		if is_method(argument[0]) 
			array_push(stack, argument[0]);
		else if (is_snGroup(argument[0]) and variable_struct_exists(argument[0], "__devlocomotive_singletonTools_snHide_auto_")) {
			variable_struct_remove(argument[0], "__devlocomotive_singletonTools_snHide_auto_");
			array_push(stack, argument[0]);
		}
    }
}

/// @function snAutoAccess([-1#previous;1#hook;default#root]);
/// @description
/// @param [-1#previous;1#hook;0|default#root] {number}
function snAutoAccess() {
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_inhr_") 
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) {
			if string_length(argument[0]) {
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

function snInher() {
	
}

/* replacer
	__devlocomotive_singletonTools_snHide_:
		__devlocomotive_singletonTools_snHide_auto_
		__devlocomotive_singletonTools_snHide_inhr_
		__devlocomotive_singletonTools_snHide_accs_
*/

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
