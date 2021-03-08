
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
	static ___devlocomotive_singletonTools_snHidden_f_construct = method_get_index(function() constructor {
		static toString = function() {
    		return "<snGroup>";
    	}
	});
	if (argument_count == 0)
		return new ___devlocomotive_singletonTools_snHidden_f_construct(); // [arg 0] just return new group
	else {
		var _key = argument[0];
		if !is_string(_key) or (_key == "") throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	}
	var _target = self;
    if variable_struct_exists(_target, _key) throw "\n\tsingletonTools:\n\tkey is busy\n\n"; // check argument {key} is no busy
    var _new_group = new ___devlocomotive_singletonTools_snHidden_f_construct();
    if is_snGroup(_target) and variable_struct_exists(_target, "___devlocomotive_singletonTools_snHidden_accs_") { // if used <sn-interface> -> create access
    	var _defs_loc = _target.___devlocomotive_singletonTools_snHidden_accs_.defs, _defs_new = {}, _defs_key;
    	var _names = variable_struct_get_names(_defs_loc), i = 0, _val;
    	repeat array_length(_names) { // used <snRunDefault> mechanism
    		_defs_key = _names[i++];
    		if (string_pos("___devlocomotive_singletonTools_snHidden_", _defs_key) == 1) continue; // exeption keys
    		_val = variable_struct_get(_defs_loc, _defs_key);
    		variable_struct_set(_new_group, _defs_key, _val);
	    	variable_struct_set(_defs_new, _defs_key, _val);
    	}
    	var _root = _target.___devlocomotive_singletonTools_snHidden_accs_.root;
    	_new_group.___devlocomotive_singletonTools_snHidden_accs_ = // access create
    		{ prev : _target
    		, root : _root
    		, hook : (argument_count > 1 ? argument[1] : false) ? _new_group : _target.___devlocomotive_singletonTools_snHidden_accs_.hook
    		, defs : _defs_new // new default for independent inheritance
    		}
    	var _access_clear = new ___devlocomotive_singletonTools_snHidden_f_construct();
    	_access_clear.___devlocomotive_singletonTools_snHidden_type_ = "temp-push";
    	_access_clear.id = _root.___devlocomotive_singletonTools_snHidden_accs_.id;
    	_access_clear.group = _new_group;
    	snCleaner(_access_clear); // access-clear memory
    }
    variable_struct_set(_target, _key, _new_group); // set a key in current struct
    return _new_group; // return new group
}

/// @function is_snGroup(value);
/// @description is_snGroup(value) -> will return true if the value is a group
/// @param value {any}
function is_snGroup() {
	static ___devlocomotive_singletonTools_snHidden_d_instance = instanceof(snGroup());
    return is_struct(argument0) and (instanceof(argument0) == ___devlocomotive_singletonTools_snHidden_d_instance); // check hidden instanceof
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
	static ___devlocomotive_singletonTools_snHidden_f_typeSet = method_get_index(function(_type, _data) {
		if !is_snGroup(_data) {
			var _read = _data;
			_data = snGroup();
			if is_struct(_read) {
				var _names = variable_struct_get_names(_read), i = 0, _key;
				repeat array_length(_names) {
					_key = _names[i++];
					variable_struct_set(_data, _key, variable_struct_get(_read, _key));
				}
			}
		}
		_data.___devlocomotive_singletonTools_snHidden_type_ = _type;
		return snCleaner(_data);
	});
	var _struct = snGroup(), _cleaner = argument_count > 2 ? argument[2] : undefined;
    if is_method(_cleaner)
    	___devlocomotive_singletonTools_snHidden_f_typeSet("cleaner", {run : method(_struct, _cleaner)}); // method cleaner
    else if is_string(_cleaner) and (_cleaner != "")
	    ___devlocomotive_singletonTools_snHidden_f_typeSet("cleaner", {struct : _struct, name : _cleaner}); // field cleaner
    if argument[0] {
	    var _current = snGroup();
	    _current.id = ___devlocomotive_singletonTools_snHidden_f_typeSet("temp-id");
	    _current.group = _struct;
	    ___devlocomotive_singletonTools_snHidden_f_typeSet("temp-push", _current); // open access memory
		_struct.___devlocomotive_singletonTools_snHidden_accs_ = // open access work
			{ id : _current.id
			, prev : undefined
			, root : _struct
			, hook : _struct
			, defs : {}
			}
		method(_struct, argument[1])(); // run {runner} with <sn-interface>
		___devlocomotive_singletonTools_snHidden_f_typeSet("temp-clear", _current); // close access
    } else method(_struct, argument[1])(); // run {runner} without <sn-interface>
	return _struct; // new singleton
}

/// @function snCleaner();
/// @description snCleaner() -> will run methods and methods from fields
/// @param <none> {none}
function snCleaner() {
    static ___devlocomotive_singletonTools_snHidden_d_stackCleaner = [];
    static ___devlocomotive_singletonTools_snHidden_d_stackTemp = {};
    if argument_count {
    	if is_snGroup(argument[0]) and variable_struct_exists(argument[0], "___devlocomotive_singletonTools_snHidden_type_") { // hide - push to 'stackCleaner'
    		switch variable_struct_get(argument[0], "___devlocomotive_singletonTools_snHidden_type_") {
    			case "cleaner": // cleaner memory
    				variable_struct_remove(argument[0], "___devlocomotive_singletonTools_snHidden_type_");
    				array_push(___devlocomotive_singletonTools_snHidden_d_stackCleaner, argument[0]);
    				break;
    			case "temp-id":
    				var _new_id = string(variable_struct_names_count(___devlocomotive_singletonTools_snHidden_d_stackTemp));
    				variable_struct_set(___devlocomotive_singletonTools_snHidden_d_stackTemp, _new_id, []);
    				return _new_id;
    				break;
    			case "temp-push":
    				array_push(variable_struct_get(___devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id), argument[0].group);
    				break;
    			case "temp-clear":
    				var _stack_group = variable_struct_get(___devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id), i = 0;
    				repeat array_length(_stack_group) variable_struct_remove(_stack_group[i++], "___devlocomotive_singletonTools_snHidden_accs_");
    				variable_struct_remove(___devlocomotive_singletonTools_snHidden_d_stackTemp, argument[0].id);
    				break;
    		}
    		exit;
    	}
    }
    if is_undefined(___devlocomotive_singletonTools_snHidden_d_stackCleaner) throw "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n"; // if the 'stackCleaner' has already been used
    var i = 0, _run;
    repeat array_length(___devlocomotive_singletonTools_snHidden_d_stackCleaner) {
    	_run = ___devlocomotive_singletonTools_snHidden_d_stackCleaner[i++];
    	if variable_struct_exists(_run, "run")
    		_run.run(); // used method
    	else { // used field struct
    		if !variable_struct_exists(_run.struct, _run.name) throw ("\n\tsingletonTools:\n\tthere is no key '" + _run.name + "' in the group\n\n"); // if field not exists
        	var _field_run = variable_struct_get(_run.struct, _run.name);
        	if !is_undefined(_field_run) with _run _field_run();
    	}
    }
	___devlocomotive_singletonTools_snHidden_d_stackCleaner = undefined; // clear 'stackCleaner'
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
	static ___devlocomotive_singletonTools_snHidden_f_getPrevious = method_get_index(function(_count) { // previous-level get
		if (_count >= 1) {
			var _root = self.___devlocomotive_singletonTools_snHidden_accs_.prev;
			repeat (_count - 1) {
				if is_undefined(_root) throw "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n"; // if current group is root
				_root = _root.___devlocomotive_singletonTools_snHidden_accs_.prev;
			}
			return _root;
		}
		return self;
	});
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // used only when using <sn-interface>
		throw "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if (argument[0] != "") {
				argument[0] = string_char_at(argument[0], 1);
				if (argument[0] == "p") return ___devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
				if (argument[0] == "h") return self.___devlocomotive_singletonTools_snHidden_accs_.hook;
			}
			return self.___devlocomotive_singletonTools_snHidden_accs_.root; // or root
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]);
		    if (argument[0] == -1) return ___devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
		    if (argument[0] == 1)  return self.___devlocomotive_singletonTools_snHidden_accs_.hook;
		}
	}
    return self.___devlocomotive_singletonTools_snHidden_accs_.root; // or root
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
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // used only when using <sn-interface>
		throw "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n";
	if (argument_count == 0) {
		self.___devlocomotive_singletonTools_snHidden_accs_.defs = {}; // remove all value-default
		exit;
	}
	if !is_string(argument[0]) or (argument[0] == "") throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	if (argument_count > 1)
		variable_struct_set(self.___devlocomotive_singletonTools_snHidden_accs_.defs, argument[0], argument[1]); // set value-default
	else {
		// remove value-default
		var _defs = self.___devlocomotive_singletonTools_snHidden_accs_.defs;
		if variable_struct_exists(_defs, argument[0]) variable_struct_remove(_defs, argument[0]);
	}
}

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
///**************************************************************************///

/* for replacer
	___devlocomotive_singletonTools_snHidden_:
		data ->
		___devlocomotive_singletonTools_snHidden_type_ - super-hidden
		___devlocomotive_singletonTools_snHidden_accs_ - temp-hidden
		static ->
		___devlocomotive_singletonTools_snHidden_f_construct
		___devlocomotive_singletonTools_snHidden_d_instance
		___devlocomotive_singletonTools_snHidden_f_typeSet
		___devlocomotive_singletonTools_snHidden_d_stackCleaner
		___devlocomotive_singletonTools_snHidden_d_stackTemp
		___devlocomotive_singletonTools_snHidden_f_getPrevious
*/
