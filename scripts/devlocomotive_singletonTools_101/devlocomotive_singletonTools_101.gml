
/* info
	autor           \\ devlocomotive
    name            \\ singletonTools
    version         \\ 101
    data-create     \\ 02.03.21
    data-updata     \\ 14.03.21
*/

/* link
    git-hub         \\ https://github.com/devlocomotive/singTool
*/

/* description
	----
	design tool for writing singletons
	this tool hides some things, and does some routine (rather specific)
	there is nothing new and special here
	----
	this thing is designed with a "wanna try to do this" effect, so it's probably completely useless
	however, I still decided to bring it to mind
*/

///**************************************************************************///
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// throw format "\n\tsingletonTools:\n\t" + message + "\n\n"

/// @function snGroup([key], [(snRunner)-hook]);
/// @description just:snGroup() -> creates an empty group (a regular structure created by another constructor)
//				 just:snGroup("key") -> creates an empty group and sets it to the current structure with the key "key"
//				 -- used <interface-sn-run> --
//				 snGroup() -> snGroup()
//				 snGroup("key") -> just:snGroup("key") -> generates access to groups above and inheritance of fields
//				 snGroup("key", true) -> just:snGroup("key") -> the access field <hook> refers to the new group
/// @param [key]             {string} - check
/// @param [(snRunner)-hook] {bool}
/// @returns {snGroup}
function snGroup() {
	static ___devlocomotive_singletonTools_snHidden_f_construct = method_get_index(function() constructor {
		static toString = function() {
    		return "<snGroup>";
    	}
	});
	if (argument_count == 0)
		return new ___devlocomotive_singletonTools_snHidden_f_construct(); // just return new group
	else {
		var _key = argument[0];
		if !is_string(_key) or !string_length(_key)
			throw "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n"; // check argument {key} is correct
	}
    if variable_struct_exists(self, _key) 
    	throw "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n"; // check argument {key} is no busy
    var _group_new = new ___devlocomotive_singletonTools_snHidden_f_construct();
    if is_snGroup(self) and variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") { // if used <sn-interface> -> create access
    	var _target = self, _target_interface = _target.___devlocomotive_singletonTools_snHidden_accs_;
    	var _dlocal = _target_interface._defs, _defs_new = {};
    	if variable_struct_names_count(_dlocal) {
    		var _dnames = variable_struct_get_names(_dlocal), _size = array_length(_dnames);
    		var _i = -1, _value, _dkey;
    		while (++_i < _size) {
    			_dkey = _dnames[_i];
    			_value = variable_struct_get(_dlocal, _dkey);
    			variable_struct_set(_group_new, _dkey, _value);
    			variable_struct_set(_defs_new, _dkey, _value);
    		}
    	}
    	var _main_interface = _target_interface._temp;
    	_group_new.___devlocomotive_singletonTools_snHidden_accs_ =
    		{ _id : [_target_interface._id[0] + 1, _target_interface._count_gid++]
    		, _count_gid : 0
    		, _ccth : false
    		, _prev : _target
    		, _hook : (argument_count > 1 ? argument[1] : false) ? _group_new : _target_interface._hook
    		, _defs : _defs_new // new default for independent inheritance
    		, _rmmv : {} //
    		, _temp : _main_interface
    		}
    	array_push(_main_interface._stck, _group_new); // access-clear memory
    }
    variable_struct_set(self, _key, _group_new); // set a key in current struct
    return _group_new; // return new group
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
//				 snRunner(sn-interface, runner, method) -> will add to the global stack delete, the method referring to the singleton
/// @param sn-interface {bool}
/// @param runner       {method/function}
/// @param [cleaner]    {method/function/string}
/// @returns {snGroup}
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
	if is_string(_cleaner) {
		if string_length(_cleaner) 
			_cleaner_data.___devlocomotive_singletonTools_snHidden_type_ = 
				{ _singleton : _singleton
				, _name : _cleaner
				} // field cleaner
	} else {
		if is_method(_cleaner) _cleaner = method_get_index(_cleaner);
		if is_numeric(_cleaner) and script_exists(_cleaner) {
			_cleaner_data.___devlocomotive_singletonTools_snHidden_type_ = 
				{ _run : method(_singleton, _cleaner)
				} // method cleaner
		}
	}
	var _run_singleton = argument[1];
	if is_method(_run_singleton) _run_singleton = method_get_index(_run_singleton);
	if !is_numeric(_run_singleton) or !script_exists(_run_singleton)
		throw "\n\tsingletonTools:\n\tthe {runner} must be an existing function\n\n"; //
	if variable_struct_names_count(_cleaner_data) snCleaner(_cleaner_data);
    if argument[0] {
    	var _temp_stack = [_singleton];
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
			// , _super : // for the future (?)
			// 	{ _sppc : _tempSingleton._sppc
			// 	}
			} // data general for <interface-sn-code>
		_singleton.___devlocomotive_singletonTools_snHidden_accs_ =
			{ _id : [0, 0]					// unique id : [did, gid] - [did - depthIndex, gid - groupIndex]
			, _count_gid : 0				// counter - groupIndex
			, _ccth : false         		// snRunCoder - state
			, _prev : undefined 			// snRunAccess - previous
			, _hook : _singleton			// snRunAccess - hook
			, _defs : {}					// snRunDefault
			, _rmmv : {}					// snAftRemove
			, _temp : _tempSingleton		// 
			} // data unique + open interface
		with _singleton with _singleton _run_singleton(); // run {runner} with <interface-sn-run>
		var _i, _size, _value;
		// stage 0
		_size = array_length(_temp_stack);
		if _size {
			_i = -1;
			while (++_i < _size) {
				_value = _temp_stack[_i].___devlocomotive_singletonTools_snHidden_accs_;
				if _value._ccth {
					_temp_stack[_i].___devlocomotive_singletonTools_snHidden_code_ =
						{ _spac : undefined
						, _rmmv : _value._rmmv
						, _temp : _tempCoder
						}
					array_push(_temp_stack_code, _temp_stack[_i]);
				}
				_temp_stack[_i] =
					{ _self : _temp_stack[_i]
					, _rmmv : _value._rmmv
					}
				variable_struct_remove(_temp_stack[_i]._self, "___devlocomotive_singletonTools_snHidden_accs_");
			}
		}
		// stage 1
		_size = array_length(_temp_stack_ccid);
		if _size {
			_i = -1;
			array_sort(_temp_stack_ccid, ___devlocomotive_singletonTools_snHidden_f_sorting);
			var _target_interface, _ccid_pack, _run_method;
			while (++_i < _size) {
				_ccid_pack = _temp_stack_ccid[_i];
				_target_interface = variable_struct_get(_ccid_pack._data_grp, "___devlocomotive_singletonTools_snHidden_code_");
				_target_interface._spac = _ccid_pack._data_spc;
				_run_method = _ccid_pack._data_cod;
				with _ccid_pack._data_spc with _ccid_pack._data_grp _run_method(_ccid_pack._data_arg);
				_target_interface._spac = undefined; // adherence to design
			}
			_size = array_length(_temp_stack_code); _i = -1;
			while (++_i < _size) variable_struct_remove(_temp_stack_code[_i], "___devlocomotive_singletonTools_snHidden_code_");
		}
		// stage 2
		_size = array_length(_temp_stack);
		if _size {
			_i = -1;
			var _j, _temp_stack_rmmv, _subsize, _key;
			while (++_i < _size) {
				_value = _temp_stack[_i];
				// snAftRemove
				_temp_stack_rmmv = variable_struct_get_names(_value._rmmv);
				_subsize = array_length(_temp_stack_rmmv);
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
    } else with _singleton with _singleton _run_singleton(); // run {runner} without <interface-sn-run>
	return _singleton; // new singleton
}

/// @function snCleaner();
/// @description snCleaner() -> will run methods and methods from fields (from ends work singleton's)
/// @param <void> {void}
/// @returns {void }
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
        	if !is_undefined(_field_run) with _run._singleton _field_run();
    	}
    }
	___devlocomotive_singletonTools_snHidden_d_stackCleaner = undefined; // clear 'stackCleaner'
}

/// @function snRunAccess([-1#previous;1#hook;default#root], [<previous>-depth]);
/// @description gets the specified group
//				 -- <interface-sn-run> --
//				 snRunAccess(1) -> 'hook'
//				 snRunAccess("h" + "..any..") -> 'hook'
//				 snRunAccess(-1) -> 'previous'.depth[1] (other)
//				 snRunAccess(-1, n < 1) -> 'previous'.depth[0] (self)
//				 snRunAccess(-1, n > 1) -> 'previous'.depth[n]
//  			 snRunAccess("p" + "..any..") -> 'previous'.depth[1] (other)
//				 snRunAccess("p" + "..any..", n < 1) -> 'previous'.depth[0] (self)
//				 snRunAccess("p" + "..any..", n > 1) -> 'previous'.depth[n]
//				 () -> 'root'
//				 -- other interface --
//				 () -> error
/// @param [-1#previous;1#hook;default#root] {number/string}
/// @param [<previous>-depth]				 {number}
/// @returns {snGroup}
function snRunAccess() {
	static ___devlocomotive_singletonTools_snHidden_f_getPrevious = method_get_index(function(_count) { // previous-depth get
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
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // checks that the current interface is <interface-sn-run>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if string_length(argument[0]) {
				argument[0] = string_char_at(argument[0], 1);
				if (argument[0] == "p") return ___devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 depth
				if (argument[0] == "h") return self.___devlocomotive_singletonTools_snHidden_accs_._hook;
			}
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]);
		    if (argument[0] == -1) return ___devlocomotive_singletonTools_snHidden_f_getPrevious(argument_count > 1 ? argument[1] : 1); // default 1 depth
		    if (argument[0] == 1)  return self.___devlocomotive_singletonTools_snHidden_accs_._hook;
		}
	}
    return self.___devlocomotive_singletonTools_snHidden_accs_._temp._root; // or root
}

/// @function snRunDefault([key], [value]);
/// @description sets the value to all subsequent groups
//				 inheritance is regulated before the creation of the group, 
//				 and does not depend on the created groups and subgroups
//				 -- <interface-sn-run> --
//				 snRunDefault("key", value) -> set inheritance
//				 snRunDefault("key") -> remove inheritance
//				 () -> remove all inheritance
//				 -- other interface --
//				 () -> error
/// @param [key]   {string} - at least one character and no use prefix '___devlocomotive_singletonTools_snHidden_'
/// @param [value] {any}
/// @returns {void }
function snRunDefault() {
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // checks that the current interface is <interface-sn-run>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
	if (argument_count == 0) {
		self.___devlocomotive_singletonTools_snHidden_accs_._defs = {}; // remove all value-default
		exit;
	}
	if !is_string(argument[0]) or !string_length(argument[0])
		throw "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n"; // checks that the {key} has at least one character
	if (string_pos("___devlocomotive_singletonTools_snHidden_", argument[0]) == 1) 
		throw "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n"; // checks that the prefix '___devlocomotive_singletonTools_snHidden_' is not used in the {key}
	if (argument_count > 1)
		variable_struct_set(self.___devlocomotive_singletonTools_snHidden_accs_._defs, argument[0], argument[1]); // set value-default
	else {
		var _defs = self.___devlocomotive_singletonTools_snHidden_accs_._defs;
		if variable_struct_exists(_defs, argument[0]) variable_struct_remove(_defs, argument[0]); // remove value-default
	}
}

/// @function snRunMarker(key);
/// @description marks the current group by giving it a quick name
//				 will return either a method that generates an error, or a method that returns a group
//				 -- <interface-sn-run> --
//  			 -- group1 --
//					-- no mark key in group1 --
//					snRunMarker("key") -> mark key -> return method-error
//					-- mark key in group1 --
//					snRunMarker("key") -> return method-error
//				 -- group2 --
//					-- mark key in other group --
//					snRunMarker("key") -> return method-getter
//				 -- other interface --
//				 () -> error
/// @param key {string} - at least one character
/// @returns {method}
function snRunMarker() {
	static ___devlocomotive_singletonTools_snHidden_df_bunger = {
		_bung : method_get_index(function() {
			return self._value;
		}),
		_error : method(undefined, function() {
			throw "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n";
		}),
	}
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // checks that the current interface is <interface-sn-run>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
	if !is_string(argument0) or !string_length(argument0)
		throw "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n"; // checks that the {key} has at least one character
	var _mark = self.___devlocomotive_singletonTools_snHidden_accs_._temp._mark;
	if variable_struct_exists(_mark, argument0) {
		var _bung = variable_struct_get(_mark, argument0);
		if (self == _bung) return ___devlocomotive_singletonTools_snHidden_df_bunger._error; // design error
		return method({_value : _bung}, ___devlocomotive_singletonTools_snHidden_df_bunger._bung);
	} else {
		variable_struct_set(_mark, argument0, self);
		return ___devlocomotive_singletonTools_snHidden_df_bunger._error; // design error
	}
}

/// @function snRunCoder(level, spacename, methOrFunct, [argument]);
/// @description adds the following script to the stack for later execution
//				 -- <interface-sn-run> --
//				 snRunCoder(level, "spacename", function or method, ?argument) -> push to 'snRunCoder'.stack
//				 -- other interface --
//				 () -> error
//		---------
//		there are 4 levels of code stack sorting
//		level -> depth -> group -> queue
//		level - the level is determined by the argument
//		depth - nesting depth of groups in each other
//		group - subgroup numbers in the group (the sequence in which they were created)
//		queue - moment adding to the stack
//		spacename - provides access to a common empty group (generated automatically)
//			allows you to combine code calls into a single structure (without manual intervention)
//		argument - in addition, you can pass an argument to the function (I recommend not to use it, as this thing violates the design)
//		---------
// stage 1
/// @param level       {number} - should be a number
/// @param spacename   {string} - must have at least one character
/// @param methOrFunct {method/function} - an existing function is required
/// @param [argument]  {any}
/// @returns {void }
function snRunCoder() {
	if !variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_") // checks that the current interface is <interface-sn-run>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
	if !is_numeric(argument[0])
		throw "\n\tsingletonTools:\n\tthe{level} must be a number\n\n"; // check if the level is a number
	if !is_string(argument[1]) or !string_length(argument[1])
		throw "\n\tsingletonTools:\n\tthe {spacename} must be a string and contain at least one character\n\n"; // checks that the {spacename} has at least one character
	if is_method(argument[2]) argument[2] = method_get_index(argument[2]);
	if !is_numeric(argument[2]) or !script_exists(argument[2])
		throw "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n"; // check if the function exists
	var _target = self, _target_interface = _target.___devlocomotive_singletonTools_snHidden_accs_, _main_interface = _target_interface._temp; 
	var _spacename = _main_interface._sppc, _id = string(argument[1]);
	if variable_struct_exists(_spacename, _id)
		_spacename = variable_struct_get(_spacename, _id); // get the existing space
	else {
		var _temp = _spacename; _spacename = snGroup();
		variable_struct_set(_temp, _id, _spacename); // creating a new space
	}
	_id = _target_interface._id;
	_target_interface._ccth = true;
	var _ccid =
		{ _lid : argument[0]                  						// level-id
		, _did : _id[0]												// depth-id
		, _gid : _id[1]												// group-id
		, _cid : _main_interface._count_cid++  						// queue-id
		, _data_spc : _spacename									// spacename - {spacename}
		, _data_grp : _target										// group - 'self'
		, _data_cod : argument[2]									// code - {methOrFunct}
		, _data_arg : argument_count > 3 ? argument[3] : undefined	// argument (it is bad)
		}
	array_push(_main_interface._ccid, _ccid); // add to the 'snRunCoder'.stack
}

/// @function snRunCoder_field(key, newkey|[[fieldkey;newkey]...]);
/// @description copy fields (level -1) - used snRunCoder
//				 -- <interface-sn-run> --
//				 snRunCoder_field("key", "newkey") -> will launch snCodMarkerGet("key") and install the result with the "newkey" key
//				 snRunCoder_field("key", [["fieldkey", "newkey"]...]) -> will launch snCodMarkerGet("key") and will set fields with the "newkey" key by getting them using the "fieldkey" key
//				 -- other interface --
//				 () -> error
//		---------
//		all keys must have at least one character - [key, newkey, fieldkey]
//		keys [key, fieldkey] must exist in the appropriate structures
//		the "newkey" key can be overwritten
//		---------
//  stage 1 - level -1
/// @param key {string}
/// @param newkey|[[fieldkey;newkey]...]
/// @returns {void }
function snRunCoder_field() {
	static ___devlocomotive_singletonTools_snHidden_f_field = method_get_index(function(_reader) {
		var _group = snCodMarkerGet(_reader._key);
		_reader = _reader._data;
		if is_array(_reader) { // mode filed-set
			var _size = array_length(_reader);
			if _size {
				var _i = -1, _value;
				while (++_i < _size) {
					_value = _reader[_i];
					if !is_string(_value[0]) or !string_length(_value[0])
						throw "\n\tsingletonTools:\n\tthe {fieldkey} must be a string and contain at least one character\n\n"; // checks that the {fieldkey} has at least one character
					if !variable_struct_exists(_group, _value[0])
						throw "\n\tsingletonTools:\n\tkey {fieldkey} does not exist in the group\n\n"; // check the existence of a {fieldkey} in the group - {key}
					if !is_string(_value[1]) or !string_length(_value[1])
						throw "\n\tsingletonTools:\n\tthe {newkey} must be a string and contain at least one character\n\n"; // checks that the {newkey} has at least one character
					variable_struct_set(self, _value[1], variable_struct_get(_group, _value[0])); // set field from group - {key}
				}
			}
		} else { // mode group-set
			if !is_string(_reader) or !string_length(_reader)
				throw "\n\tsingletonTools:\n\tthe {newkey} must be a string and contain at least one character\n\n"; // checks that the {newkey} has at least one character
			variable_struct_set(self, _reader, _group); // set field with group
		}
	});
	snRunCoder(-1, "___devlocomotive_singletonTools_snHidden_system", ___devlocomotive_singletonTools_snHidden_f_field, {_key : argument0, _data : argument1}); // push stack code
}

/// @function snCodAccess([1#space;default#root]);
/// @description gets the specified group
//				 -- <interface-sn-code> --
//				 snCodAccess(1) -> 'space'
//				 snCodAccess("s" + "..any..") -> 'space'
//				 () -> 'root'
//				 -- other interface --
//				 () -> error
/// @param [1#space;default#root] {number/string}
/// @returns {snGroup}
function snCodAccess() {
	var _target_interface = undefined;
	if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_code_") {
		_target_interface = self.___devlocomotive_singletonTools_snHidden_code_;
		if is_undefined(_target_interface._spac) _target_interface = undefined; // interface accessibility check (design adherence)
	}
	if is_undefined(_target_interface) // checks that the current interface is <interface-sn-code>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
	if (argument_count > 0) {
		if is_string(argument[0]) { // mode string
			if string_length(argument[0]) {
				argument[0] = string_char_at(argument[0], 1); // char-code
				if (argument[0] == "s") return _target_interface._spac; // return 'space'
			}
		} else if is_numeric(argument[0]) { // mode number
			argument[0] = sign(argument[0]); // number-code
		    if (argument[0] == 1) return _target_interface._spac; // return 'space'
		}
	}
    return _target_interface._temp._root; // default return 'root'
}

/// @function snCodMarkerGet(key);
/// @description will return the marked group from 'snRunMarker'.map
//				 -- <interface-sn-code> --
//					-- no mark key in 'snRunMarker'.map --
//					() -> error
//					-- mark key in 'snRunMarker'.map --
//					snCodMarkerGet("key") -> get group from 'snRunMarker'.map
//				 -- other interface --
//				 () -> error
/// @param key {string} - at least one character
/// @returns {snGroup}
function snCodMarkerGet() {
	var _target_interface = undefined;
	if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_code_") {
		_target_interface = self.___devlocomotive_singletonTools_snHidden_code_;
		if is_undefined(_target_interface._spac) _target_interface = undefined; // interface accessibility check (design adherence)
	}
	if is_undefined(_target_interface) // checks that the current interface is <interface-sn-code>
		throw "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
	if !is_string(argument0) or !string_length(argument0)
		throw "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n"; // checks that the {key} has at least one character
	_target_interface = _target_interface._temp._mark;
	if !variable_struct_exists(_target_interface, argument0)
		throw "\n\tsingletonTools:\n\tthis {key} is not marked\n\n"; // check the existence of a {key} in the 'snRunMarker'.map
	return variable_struct_get(_target_interface, argument0); // get group from 'snRunMarker'.map
}

/// @function snAftRemove(key);
/// @description marks fields in the current group for deletion
//               removal occurs at the very last stage of 'snRunner' execution
//				 not inherited by other groups (nested)
//				 -- <interface-sn-run> or <interface-sn-code> --
//			    	snAftRemove("key") -> mark key
//				 -- other interface --
//				 () -> error
//	stage 2
/// @param key {string} - at least one character and no use prefix '___devlocomotive_singletonTools_snHidden_'
/// @returns {void }
function snAftRemove() {
	var _target_interface = undefined;
	if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_accs_")
		_target_interface = self.___devlocomotive_singletonTools_snHidden_accs_;
	else if variable_struct_exists(self, "___devlocomotive_singletonTools_snHidden_code_") {
		_target_interface = self.___devlocomotive_singletonTools_snHidden_code_;
		if is_undefined(_target_interface._spac) _target_interface = undefined; // interface accessibility check (design adherence)
	}
	if is_undefined(_target_interface)
		throw "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n"; // checks that the current interface is <interface-sn-run> or <interface-sn-code>
	if !is_string(argument[0]) or !string_length(argument[0])
		throw "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n"; // checks that the {key} has at least one character
	if (string_pos("___devlocomotive_singletonTools_snHidden_", argument[0]) == 1)
		throw "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n"; // checks that the prefix '___devlocomotive_singletonTools_snHidden_' is not used in the {key}
	variable_struct_set(_target_interface._rmmv, argument[0], undefined); // marks this key
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
