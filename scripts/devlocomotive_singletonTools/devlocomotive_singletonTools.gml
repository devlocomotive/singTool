
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
    if is_snGroup(self) and variable_struct_exists(self, "__devlocomotive_singletonTools_snHidden_accs_") { // if used <snRunner> -> create access
    	var defs_loc = self.__devlocomotive_singletonTools_snHidden_accs_.defs;
    	var names = variable_struct_get_names(defs_loc), i = 0, defs_new = {}, defs_key, val;
    	repeat array_length(names) { // used <snRunDefault> mechanism
    		defs_key = names[i++];
    		if (string_pos("__devlocomotive_singletonTools_snHidden_", defs_key) == 1) continue; // exeption (+ ``)
    		val = variable_struct_get(defs_loc, defs_key);
    		variable_struct_set(news, defs_key, val);
	    	variable_struct_set(defs_new, defs_key, val);
    	}
    	var curr = self, root = self.__devlocomotive_singletonTools_snHidden_accs_.root;
    	news.__devlocomotive_singletonTools_snHidden_accs_ = // access create
    		{ prev : curr
    		, root : root
    		, hook : (argument_count > 1 ? argument[1] : false) ? news : curr.__devlocomotive_singletonTools_snHidden_accs_.hook
    		, defs : defs_new // new default for independent inheritance
    		}
    	var access_clear = snGroup();
    	access_clear.__devlocomotive_singletonTools_snHidden_type_ = "temp-push";
    	access_clear.id = root.__devlocomotive_singletonTools_snHidden_accs_.id
    	access_clear.group = news;
    	snCleaner(access_clear);
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

/// @function snRunner(runner, argument, [cleaner]);
/// @description
/// @param runner   {method}
/// @param argument {any}
/// @param cleaner  {method/string}
function snRunner() {
	static typeSet = method_get_index(function(type, data) {
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
	var cleaner = argument_count > 2 ? argument[2] : undefined; // cleaner
    var struct = snGroup();
    if is_method(cleaner)
    	typeSet("cleaner", {run : method(struct, cleaner)});
    else if is_string(cleaner) and (cleaner != "")
	    typeSet("cleaner", {struct : struct, name : cleaner});
    var current = snGroup();
    current.id = typeSet("temp-id");
    current.group = struct;
    typeSet("temp-push", current);
	struct.__devlocomotive_singletonTools_snHidden_accs_ = // open access
		{ id : current.id
		, prev : undefined
		, root : struct
		, hook : struct
		, defs : {}
		}
	method(struct, argument[0])(argument[1]); // run {runner}
	typeSet("temp-clear", current);
    return struct; // new singleton
}

/// @function snCleaner();
/// @description
function snCleaner() {
    static stackCleaner = [];
    static stackTemp = {};
    if argument_count {
    	if is_snGroup(argument[0]) and variable_struct_exists(argument[0], "__devlocomotive_singletonTools_snHidden_type_") { // hide - push to stackCleaner
    		switch variable_struct_get(argument[0], "__devlocomotive_singletonTools_snHidden_type_") {
    			case "cleaner": // cleaner memory
    				variable_struct_remove(argument[0], "__devlocomotive_singletonTools_snHidden_type_");
    				array_push(stackCleaner, argument[0]);
    				break;
    			case "temp-id":
    				var new_id = string(variable_struct_names_count(stackTemp));
    				variable_struct_set(stackTemp, new_id, []);
    				return new_id;
    				break;
    			case "temp-push":
    				array_push(variable_struct_get(stackTemp, argument[0].id), argument[0].group);
    				break;
    			case "temp-clear":
    				var stack_group = variable_struct_get(stackTemp, argument[0].id), i = 0;
    				repeat array_length(stack_group) variable_struct_remove(stack_group[i++], "__devlocomotive_singletonTools_snHidden_accs_");
    				variable_struct_remove(stackTemp, argument[0].id);
    				break;
    		}
    		exit;
    	}
    }
    if is_undefined(stackCleaner) throw "\n\tthe application is assumed to be complete\n\n"; // if the stackCleaner has already been used
    var i = 0, run;
    repeat array_length(stackCleaner) {
    	run = stackCleaner[i++];
    	if variable_struct_exists(run, "run")
    		run.run(); // used method
    	else { // used field struct
    		if !variable_struct_exists(run.struct, run.name) throw ("\n\tthere is no key <" + run.name + "> in the group\n\n"); // if field not exists
        	var get = variable_struct_get(run.struct, run.name);
        	if !is_undefined(get) with run get();
    	}
    }
    stackCleaner = undefined; // clear stackCleaner
}

/// @function snRunAccess([-1#previous;1#hook;default#root], [<previous>-level]);
/// @description
/// @param [-1#previous;1#hook;0|default#root] {number/string}
/// @param [<previous>-level]				   {count}
function snRunAccess() {
	static getPrevious = method_get_index(function(count) { // previous-level get
		if (count >= 1) {
			var root = self.__devlocomotive_singletonTools_snHidden_accs_.prev;
			repeat (count - 1) {
				if is_undefined(root) throw "\n\tcannot rise higher than the root group\n\n"; // if current group is root
				root = root.__devlocomotive_singletonTools_snHidden_accs_.prev;
			}
			return root;
		}
		return self;
	});
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHidden_accs_") // used only when using <snRunner>
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if (argument[0] != "") {
				argument[0] = string_char_at(argument[0], 1);
				if (argument[0] == "p") return getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
				if (argument[0] == "h") return self.__devlocomotive_singletonTools_snHidden_accs_.hook;
			}
			return self.__devlocomotive_singletonTools_snHidden_accs_.root; // or root
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]);
		    if (argument[0] == -1) return getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
		    if (argument[0] == 1)  return self.__devlocomotive_singletonTools_snHidden_accs_.hook;
		}
	}
    return self.__devlocomotive_singletonTools_snHidden_accs_.root; // or root
}

/// @function snRunDefault(key, [value]);
/// @description
/// @param key   {string}
/// @param value {any}
function snRunDefault() {
	if !variable_struct_exists(self, "__devlocomotive_singletonTools_snHidden_accs_") // used only when using <snRunner>
		throw "\n\tno automatic access was granted. (auto access is provided by the <snRunner> function, only for the duration of this function)\n\n";
	if !is_string(argument[0]) or (argument[0] == "") throw "\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	if (argument_count > 1)
		variable_struct_set(self.__devlocomotive_singletonTools_snHidden_accs_.defs, argument[0], argument[1]); // set value-default
	else {
		if (argument_count > 0) { // remove value-default
			var defs = self.__devlocomotive_singletonTools_snHidden_accs_.defs;
			if variable_struct_exists(defs, argument[0]) variable_struct_remove(defs, argument[0]);
		} else self.__devlocomotive_singletonTools_snHidden_accs_.defs = {}; // remove all value-default
	}
}

/* for replacer
	__devlocomotive_singletonTools_snHidden_:
		__devlocomotive_singletonTools_snHidden_type_ - hidden
		__devlocomotive_singletonTools_snHidden_accs_ - main
*/

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
//****************************************************************************//
