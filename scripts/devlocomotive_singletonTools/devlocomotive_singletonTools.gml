
/* info
    name            \\ singletonTools
    version         \\ 101
    autor           \\ devlocomotive
    data-create     \\ 02.03.21
    data-updata     \\ 11.03.21
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
/// @param [key]             {string} - check
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
		if !is_string(_key) or (_key == "") 
			throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	}
    if variable_struct_exists(self, _key) throw "\n\tsingletonTools:\n\tkey is busy\n\n"; // check argument {key} is no busy
    var _new_group = new ___devlocomotive_singletonTools_snHidden_f_construct();
    if is_snGroup(self) and variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") { // if used <sn-interface> -> create access
    	var _target = self, _target_access = _target.___devlocomotive_singletonTools_snHidden_accs_;
    	var _defs_new = {}, _dlocal = _target_access._defs, _ckey, _val, _i = 0, _names = variable_struct_get_names(_dlocal);
    	repeat array_length(_names) { // used <snRunDefault> mechanism
    		_ckey = _names[_i++];
    		_val = variable_struct_get(_dlocal, _ckey);
    		variable_struct_set(_new_group, _ckey, _val);
	    	variable_struct_set(_defs_new, _ckey, _val);
    	}
    	var _root = _target_access._root;
    	_new_group.___devlocomotive_singletonTools_snHidden_accs_ = // access create
    		{ _id : [_target_access._id[0] + 1, _target_access._count_gid++]
    		, _count_gid : 0
    		, _prev : _target
    		, _root : _root
    		, _hook : (argument_count > 1 ? argument[1] : false) ? _new_group : _target_access._hook
    		, _defs : _defs_new // new default for independent inheritance
    		, _rmmv : {} //
    		, _ccth : false
    		}
    	array_push(_root.___devlocomotive_singletonTools_snHidden_accs_._stck, _new_group); // access-clear memory
    }
    variable_struct_set(self, _key, _new_group); // set a key in current struct
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
	static ___devlocomotive_singletonTools_snHidden_f_sorting = method(undefined, function(_ccid0, _ccid1) {
		if (_ccid0._lid == _ccid1._lid) {
			if (_ccid0._did == _ccid1._did) {
				if (_ccid0._gid == _ccid1._gid) {
					return _ccid0._cid - _ccid1._cid;
				}
				return _ccid0._gid - _ccid1._gid;
			}
			return _ccid0._did - _ccid1._did;
		}
		return _ccid0._lid - _ccid1._lid;
	});
	var _singleton = snGroup();
	var _cleaner = argument_count > 2 ? argument[2] : undefined, _cleaner_data = snGroup();
    if is_method(_cleaner)
    	_cleaner_data.___devlocomotive_singletonTools_snHidden_type_ = {_run : method(_singleton, _cleaner)}; // method cleaner
    else if is_string(_cleaner) and (_cleaner != "")
	    _cleaner_data.___devlocomotive_singletonTools_snHidden_type_ = {_singleton : _singleton, _name : _cleaner}; // field cleaner
	if variable_struct_names_count(_cleaner_data) snCleaner(_cleaner_data);
    if argument[0] {
    	var _temp_stack = [];
    	var _temp_stack_ccid = [];
    	var _temp_stack_code = [];
	    var _tempSingleton =			
	    	{ _count_cid : 0				// 
	    	, _root : _singleton			// 
	    	, _stck : _temp_stack			// 
	    	, _ccid : _temp_stack_ccid		// 
	    	, _mark : {}					// 
	    	, _sppc : {}					//
	    	} // data general for <interface-sn-run>
	   	var _tempCoder =
			{ _root : _singleton			//
			, _mark : _tempSingleton._mark	//
			} // data general for <interface-sn-code>
		_singleton.___devlocomotive_singletonTools_snHidden_accs_ =
			{ _id : [0, 0]					// unique id : [did, gid] - [did - depthIndex, gid - groupIndex]
			, _count_gid : 0				// counter - groupIndex
			, _ccth : false         		// 
			, _prev : undefined 			// snRunAccess - previous
			, _hook : _singleton			// snRunAccess - hook
			, _defs : {}					// snRunDefault
			, _rmmv : {}					// snRCRemove
			, _temp : _tempSingleton		// 
			} // data union + open interface
		if (is_numeric(argument[1]) and !script_exists(argument[1])) or !is_method(argument[1]) or !script_exists(method_get_index(argument[1]))
			throw "\n\tsingletonTools:\n\tthe {runner} must be an existing function\n\n"; //
		with _singleton method(_singleton, argument[1])(); // run {runner} with <sn-interface>
		var _i, _size, _value;
		//
		_size = array_length(_temp_stack);
		if _size {
			_i = -1;
			while (++_i < _size) {
				_value = _temp_stack[_i].___devlocomotive_singletonTools_snHidden_accs_;
				if _value._ccth {
					_temp_stack[_i].___devlocomotive_singletonTools_snHidden_code_ =
						{ _enable : false
						, _rmmv : _value._rmmv
						, _temp : _tempCoder
						}
					array_push(_temp_stack_code, _temp_stack[_i]);
				}
				_temp_stack[_i] =
					{ _self : _temp_stack[_i]
					, _rmmv : _value._rmmv
					}
				variable_struct_remove(_temp_stack[_i]._self, "___devlocomotive_singletonTools_snHidden_accs_"); // close access
			}
		}
		//
		_size = array_length(_temp_stack_ccid);
		if _size {
			_i = -1;
			array_sort(_temp_stack_ccid, ___devlocomotive_singletonTools_snHidden_f_sorting); // sorting <snRunCoder>
			var _interface, _ccid_pack;
			while (++_i < _size) {
				_ccid_pack = _temp_stack_ccid[_i];
				_interface = variable_struct_get(_ccid_pack.data_grp, "___devlocomotive_singletonTools_snHidden_code_");
				_interface._enable = true;
				with _ccid_pack._data_spc method(_ccid_pack.data_grp, _ccid_pack._data_cod)(); // run <snRunCoder>
				_interface._enable = false;
			}
			_size = array_length(_temp_stack_code); _i = -1;
			while (++_i < _size) variable_struct_remove(_temp_stack_code[_i], "___devlocomotive_singletonTools_snHidden_code_");
		}
		//
		_size = array_length(_temp_stack);
		if _size {
			_i = -1;
			var _j, _temp_stack_rmmv, _subsize, _key;
			while (++_i < _size) {
				_value = _temp_stack[_i];
				_temp_stack_rmmv = variable_struct_get_names(_value._rmmv);
				_subsize = array_length(_subsize);
				if _subsize {
					_j = -1;
					_value = _value._self;
					while (++_j < _subsize) {
						_key = _temp_stack_rmmv[_j];
						if variable_struct_exists(_value, _key) variable_struct_remove(_value, _key);
					}
				}
			}
		}
    } else with _singleton method(_singleton, argument[1])(); // run {runner} without <sn-interface>
	return _singleton; // new singleton
}

/// @function snCleaner();
/// @description snCleaner() -> will run methods and methods from fields
/// @param <none> {none}
function snCleaner() {
    static ___devlocomotive_singletonTools_snHidden_d_stackCleaner = [];
    if is_undefined(___devlocomotive_singletonTools_snHidden_d_stackCleaner) 
    	throw "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n"; // if the 'stackCleaner' has already been used
    if argument_count {
    	if is_snGroup(argument[0]) and variable_struct_exists(argument[0], "___devlocomotive_singletonTools_snHidden_type_") { // hide - push to 'stackCleaner'
    		array_push(___devlocomotive_singletonTools_snHidden_d_stackCleaner, argument[0].___devlocomotive_singletonTools_snHidden_type_);
    		exit;
    	}
    }
    var _i = 0, _run;
    repeat array_length(___devlocomotive_singletonTools_snHidden_d_stackCleaner) {
    	_run = ___devlocomotive_singletonTools_snHidden_d_stackCleaner[_i++];
    	if variable_struct_exists(_run, "_run")
    		_run._run(); // used method
    	else { // used field struct
    		if !variable_struct_exists(_run._singleton, _run._name) 
    			throw ("\n\tsingletonTools:\n\tthere is no key '" + _run._name + "' in the group\n\n"); // if field not exists
        	var _field_run = variable_struct_get(_run._singleton, _run._name);
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
/// @param [-1#previous;1#hook;default#root] {number/string}
/// @param [<previous>-level]				   {count}
function snRunAccess() {
	static ___devlocomotive_singletonTools_snHidden_f_getPrevious = method_get_index(function(_count) { // previous-level get
		if (_count >= 1) {
			var _root_read = self.___devlocomotive_singletonTools_snHidden_accs_._prev;
			repeat (_count - 1) {
				if is_undefined(_root_read) throw "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n"; // if current group is root
				_root_read = _root_read.___devlocomotive_singletonTools_snHidden_accs_._prev;
			}
			return _root_read;
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
				if (argument[0] == "h") return self.___devlocomotive_singletonTools_snHidden_accs_._hook;
			}
			return self.___devlocomotive_singletonTools_snHidden_accs_._root; // or root
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]);
		    if (argument[0] == -1) return ___devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 level
		    if (argument[0] == 1)  return self.___devlocomotive_singletonTools_snHidden_accs_._hook;
		}
	}
    return self.___devlocomotive_singletonTools_snHidden_accs_._root; // or root
}

/// @function snRunDefault([key], [value]);
/// @description independent for each group
//			     -- used <sn-interface> --
//				 snRunDefault("key", value) -> set inheritance
//				 snRunDefault("key") -> remove inheritance
//				 snRunDefault() -> remove all inheritance
/// @param [key]   {string} - check
/// @param [value] {any}
function snRunDefault() {
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // used only when using <sn-interface>
		throw "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n";
	if (argument_count == 0) {
		self.___devlocomotive_singletonTools_snHidden_accs_._defs = {}; // remove all value-default
		exit;
	}
	if !is_string(argument[0]) or (argument[0] == "")
		throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	if (string_pos("___devlocomotive_singletonTools_snHidden_", argument[0]) == 1) 
		throw "\n\tyou cannot use the '___devlocomotive_singletonTools_snHidden_' prefix in the field name\n\n"; // check exeption prefix '___devlocomotive_singletonTools_snHidden_'
	if (argument_count > 1)
		variable_struct_set(self.___devlocomotive_singletonTools_snHidden_accs_._defs, argument[0], argument[1]); // set value-default
	else {
		var _defs = self.___devlocomotive_singletonTools_snHidden_accs_._defs;
		if variable_struct_exists(_defs, argument[0]) variable_struct_remove(_defs, argument[0]); // remove value-default
	}
}

/// @function snRunMarker(key);
/// @description marks the current group by giving it a quick name
//  			 -- group1 --
//					-- no mark key --
//					snRunMarker("key") -> mark key and get method -> error
//					-- mark key --
//					snRunMarker("key") -> get method -> error
//				 -- group2 --
//					-- mark key --
//					snRunMarker("key") -> get method -> getter mark value
/// @param key {string} - check
function snRunMarker() {
	static ___devlocomotive_singletonTools_snHidden_df_bunger = {
		_bung : method_get_index(function() {
			return self._value;	
		}),
		_error : method(undefined, function() {
			throw "\n\tthe call, in this case, sets the value, not read it\n\n";	
		}),
	}
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // used only when using <sn-interface>
		throw "\n\tsingletonTools:\n\tinterface <sn-interface> is not available\n\n";
	if !is_string(argument0) or (argument0 == "")
		throw "\n\tsingletonTools:\n\tthe key must be a string and contain at least one character\n\n"; // check argument {key} is correct
	var _root_mark = self.___devlocomotive_singletonTools_snHidden_accs_._root.___devlocomotive_singletonTools_snHidden_accs_._mark;
	if variable_struct_exists(_root_mark, argument0) {
		var _bung = variable_struct_get(_root_mark, argument0);
		if (self == _bung) return ___devlocomotive_singletonTools_snHidden_df_bunger._error; // design error
		return method({_value : _bung}, ___devlocomotive_singletonTools_snHidden_df_bunger._bung);
	} else {
		variable_struct_set(_root_mark, argument0, self);
		return ___devlocomotive_singletonTools_snHidden_df_bunger._error; // design error
	}
}
// TODO
/// @function snRunCoder(level, spacename, methOrFunct);
/// @description 
//				 -- <interface-sn-run> --
// stage - 9
/// @param level       {number} - should be a number
/// @param spacename   {string} - must have at least one character
/// @param methOrFunct {method/function} - an existing function is required
/// @returns {void }
function snRunCoder() {
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // checks that the current interface is <interface-sn-run>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
	if !is_numeric(argument0)
		throw "\n\tsingletonTools:\n\tthe{level} must be a number\n\n"; // check if the level is a number
	if !is_string(argument1) or (argument1 == "")
		throw "\n\tsingletonTools:\n\tthe {spacename} must be a string and contain at least one character\n\n"; // checks that the {spacename} has at least one character
	if (is_numeric(argument2) and !script_exists(argument2)) or !is_method(argument2) or !script_exists(method_get_index(argument2)) // addition - script_exists(method_get_index(argument2)) - yes it's fantastic
		throw "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n"; // check if the function exists
	var _access_id = self.___devlocomotive_singletonTools_snHidden_accs_, _root_access = _access_id._root.___devlocomotive_singletonTools_snHidden_accs_; 
	_access_id._ccth = true;
	_access_id = _access_id._id; // access
	var _space = _root_access._sppc, _key = string(argument0);
	if variable_struct_exists(_space, _key)
		_space = variable_struct_get(_space, _key); // get the existing space
	else {
		var _temp = _space; _space = snGroup();
		variable_struct_set(_temp, _key, _space); // creating a new space
	}
	var _target = self;
	var _ccid =
		{ _lid : argument0                  		// level-id
		, _did : _access_id[0]						// depth-id
		, _gid : _access_id[1]						// group-id
		, _cid : _root_access._count_cid++  		// queue-id
		, _data_spc : _space						// space - {spacename}
		, _data_grp : _target						// group - 'self'
		, _data_cod : method_get_index(argument2)	// code - {methOrFunct}
		}
	array_push(_root_access._ccid, _ccid); // add to the 'snRunCoder'.stack
}

/// @function snCodAccess([1#current;default#root]);
/// @description gets the specified group
//				 -- <interface-sn-code> --
//				 snCodAccess(1) -> 'space'
//				 snCodAccess("c" + "..any..") -> 'space'
//				 () -> 'root'
//				 -- other interface --
//				 () -> error
/// @param [1#current;default#root] {number/string}
/// @returns {snGroup}
function snCodAccess() {
	var _interface = undefined;
	if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_code_") {
		_interface = self.___devlocomotive_singletonTools_snHidden_code_;
		if !_interface._enable _interface = undefined;
	}
	if is_undefined(_interface) // checks that the current interface is <interface-sn-code>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if (argument[0] != "") {
				argument[0] = string_char_at(argument[0], 1); // char-code
				if (argument[0] == "c") return _interface._spac; // return 'space'
			}
			return _interface._root; // default return 'root'
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]); // number-code
		    if (argument[0] == 1)  return _interface._spac; // return 'space'
		}
	}
    return _interface._root; // default return 'root'
}

/// @function snRCRemove(key);
/// @description marks fields in the current group for deletion
//               removal occurs at the very last stage of 'snRunner' execution
//				 not inherited by other groups (nested)
//				 -- <interface-sn-run> or <interface-sn-code> --
//			    	snRCRemove("key") -> mark key
//				 -- other interface --
//				 () -> error
// stage - 10
/// @param key {string} - at least one character and no use prefix '___devlocomotive_singletonTools_snHidden_'
/// @returns {void }
function snRCRemove() {
	var _interface = undefined;
	if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_")
		_interface = self.___devlocomotive_singletonTools_snHidden_accs_;
	else if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_code_") {
		_interface = self.___devlocomotive_singletonTools_snHidden_code_;
		if !_interface._enable _interface = undefined;
	}
	if is_undefined(_interface)
		throw "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n"; // checks that the current interface is <interface-sn-run> or <interface-sn-code>
	if !is_string(argument[0]) or (argument[0] == "")
		throw "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n"; // checks that the {key} has at least one character
	if (string_pos("___devlocomotive_singletonTools_snHidden_", argument[0]) == 1)
		throw "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n"; // checks that the prefix '___devlocomotive_singletonTools_snHidden_' is not used in the {key}
	variable_struct_set(_interface._rmmv, argument[0], undefined); // marks the key
}

//////////////////////////////////////////////////////////////////////////////*/
////////////////////////////////////////////////////////////////////////////////
///**************************************************************************///

/* for replacer
	___devlocomotive_singletonTools_snHidden_:
		data ->
		___devlocomotive_singletonTools_snHidden_type_ - super-hidden
		___devlocomotive_singletonTools_snHidden_accs_ - temp-hidden
		___devlocomotive_singletonTools_snHidden_code_ - temp-hidden
		static ->
		___devlocomotive_singletonTools_snHidden_f_construct
		___devlocomotive_singletonTools_snHidden_d_instance
		___devlocomotive_singletonTools_snHidden_d_stackCleaner
		___devlocomotive_singletonTools_snHidden_f_getPrevious
		___devlocomotive_singletonTools_snHidden_df_bunger
		___devlocomotive_singletonTools_snHidden_f_sorting
*/
