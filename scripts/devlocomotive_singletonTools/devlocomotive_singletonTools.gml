
/* info
    name            \\ singletonTools
    version         \\ 100 (from )
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
	static counterId = method_get_index(function() {
		static counter = -1073741824;
		return string(counter++);
	});
    static constr = method_get_index(function(id) constructor {
    	self.snGroupId = id;
        static toString = function() {
            return "snGroup " + snGroupId;
        }
    });
	if (argument_count == 0)
		return new constr(counterId());
	else {
		var key = argument[0];
		if !is_string(key) or (key == "") throw "\n\tthe key must be a string and contain at least one character\n\n";
	}
    if is_struct(self) and variable_struct_exists(self, key) return variable_struct_get(self, key);
    var news = new constr(counterId());
    if is_snGroup(self) and variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_prev_") {
        news.__devlocomotive_singletonTools_snHide_prev_ = self;
    	news.__devlocomotive_singletonTools_snHide_root_ = self.__devlocomotive_singletonTools_snHide_root_;
		news.__devlocomotive_singletonTools_snHide_hook_ = (argument_count > 1 ? argument[1] : false) ? news : self.__devlocomotive_singletonTools_snHide_hook_;
    }
    variable_struct_set(self, key, news);
    return news;
}

/// @function snGroupDisableAutoAccess(key);
/// @description
/// @param key {string}
function snGroupDisableAutoAccess() {
	if !is_string(argument0) or (argument0 == "") throw "\n\tthe key must be a string and contain at least one character\n\n";
	if is_struct(self) and variable_struct_exists(self, argument0) return variable_struct_get(self, argument0);
	var group = snGroup();
	variable_struct_set(self, argument0, group);
	return group;
}

/// @function is_snGroup(group);
/// @description
/// @param group {snGroup}
function is_snGroup() {
    static instance = instanceof(snGroup());
    return is_struct(argument0) and (instanceof(argument0) == instance);
}

/// @function snRunner(autoAccess, runner, [cleaner]);
/// @description
/// @param autoAccess {bool}
/// @param runner     {method}
/// @param cleaner    {method/string}
function snRunner() {
	static snAccessClear = method_get_index(function(marker, recursion) {
		variable_struct_set(marker, self.snGroupId, undefined);
		if variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_prev_") {
			variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_prev_");
			variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_root_");
			variable_struct_remove(self, "__devlocomotive_singletonTools_snHide_hook_");
			var i = 0, names = variable_struct_get_names(self), val;
			repeat array_length(names) {
				val = variable_struct_get(self, names[i++]);
				if is_snGroup(val) and !variable_struct_exists(marker, val.snGroupId)
					method(val, recursion)(marker, recursion);
			}
		}
	});
	var access = argument0, runner = argument1;
	var cleaner = argument_count > 0 ? argument[0] : undefined;
    if is_method(cleaner)
        snCleaner(method(struct, cleaner));
    else if is_string(cleaner) {
        var group = snGroup();
        group.__devlocomotive_singletonTools_snHide_auto_ = undefined;
        group.struct = struct;
        group.name = cleaner;
        snCleaner(group);
    }
    if !access
    	method(struct, runner)(struct);
    else {
    	struct.__devlocomotive_singletonTools_snHide_prev_ = struct;
		struct.__devlocomotive_singletonTools_snHide_root_ = struct;
		struct.__devlocomotive_singletonTools_snHide_hook_ = struct;
		method(struct, runner)(struct);
		method(struct, snAccessClear)({}, snAccessClear);
    }
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

/// @function snAccess([-1#previous;1#hook;0|default#root]);
/// @description
/// @param [-1#previous;1#hook;0|default#root] {number}
function snAccess() {
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHide_prev_") return other;
	if (argument_count > 0) {
		if is_string(argument[0]) {
			if string_length(argument[0]) {
				var char = string_char_at(argument[0], 1);
				if (char == "p") return self.__devlocomotive_singletonTools_snHide_prev_;
				if (char == "h") return self.__devlocomotive_singletonTools_snHide_hook_;
			}
			return self.__devlocomotive_singletonTools_snHide_root_;
		} else if is_numeric(argument[0]) {
		    if (argument[0] == -1) return self.__devlocomotive_singletonTools_snHide_prev_;
		    if (argument[0] == 1)  return self.__devlocomotive_singletonTools_snHide_hook_;
		}
	}
    return self.__devlocomotive_singletonTools_snHide_root_;
}

/* replacer
	__devlocomotive_singletonTools_snHide_auto_
	__devlocomotive_singletonTools_snHide_prev_
	__devlocomotive_singletonTools_snHide_root_
	__devlocomotive_singletonTools_snHide_hook_
*/

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
