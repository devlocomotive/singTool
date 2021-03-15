// test for extension-extension_devlocomotive_singletonTools_101
// (copy of tests)

#region test-adaptive
	
	// adaptive
	function install(fn, a) {
		switch array_length(a) {
			case 0:
				return fn();
				break;
			case 1:
				return fn(a[0]);
				break;
			case 2:
				return fn(a[0], a[1]);
				break;
			case 3:
				return fn(a[0], a[1], a[2]);
				break;
			case 4:
				return fn(a[0], a[1], a[2], a[3]);
				break;
			case 5:
				return fn(a[0], a[1], a[2], a[3], a[4]);
				break;
			case 6:
				return fn(a[0], a[1], a[2], a[3], a[4], a[5]);
				break;
		}
	}
	
	//
	var normalList = 
		[ snGroup
	    , is_snGroup
	    , snRunner
	    , snCleaner
	    , snRunAccess
	    , snRunDefault
	    , snRunMarker
	    , snRunCoder
	    , snRunCoder_field
	    , snCodAccess
	    , snCodMarkerGet
	    , snAftRemove
	    ]
	
	// adaptive 'snGroup'
	function adapt_snGroup() {
		if(false)snGroup();
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 0:
				return snGroup();
				break;
			case 1:
				return snGroup(a[0]);
				break;
			case 2:
				return snGroup(a[0], a[1]);
				break;
		}
		log("............................................");
	}
	
	// adaptive 'is_snGroup'
	function adapt_is_snGroup() {
		if(false)is_snGroup(0);
		return is_snGroup(argument0);
	}
	
	// adaptive 'snRunner'
	function adapt_snRunner() {
		if(false)snRunner(false,-1,"");
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 2:
				return snRunner(a[0], a[1]);
				break;
			case 3:
				return snRunner(a[0], a[1], a[2]);
				break;
		}
		log("............................................");
	}
	
	// adaptive 'snCleaner'
	function adapt_snCleaner() {
		if(false)snCleaner();
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 0:
				return snCleaner();
				break;
		}
		log("............................................");
	}
	
	// adaptive 'snRunAccess'
	function adapt_snRunAccess() {
		if(false)snRunAccess(-1,-1);
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 0:
				return snRunAccess();
				break;
			case 1:
				return snRunAccess(a[0]);
				break;
			case 2:
				return snRunAccess(a[0], a[1]);
				break;
		}
		log("............................................");
	}
	
	// adaptive 'snRunDefault'
	function adapt_snRunDefault() {
		if(false)snRunDefault("",0);
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 0:
				return snRunDefault();
				break;
			case 1:
				return snRunDefault(a[0]);
				break;
			case 2:
				return snRunDefault(a[0], a[1]);
				break;
		}
		log("............................................");
	}
	
	// adaptive 'snRunMarker'
	function adapt_snRunMarker() {
		if(false)snRunMarker("");
		return snRunMarker(argument0);
	}
	
	// adaptive 'snRunCoder'
	function adapt_snRunCoder() {
		if(false)snRunCoder(0,"",-1,undefined);
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 3:
				return snRunCoder(a[0], a[1], a[2]);
				break;
			case 4:
				return snRunCoder(a[0], a[1], a[2], a[3]);
				break;
			default: return snRunCoder(0, "-", log, "");
		}
		log("............................................");
	}
	
	// adaptive 'snRunCoder_field'
	function adapt_snRunCoder_field() {
		if(false)snRunCoder_field("","");
		return snRunCoder_field(argument0, argument1);
	}
	
	// adaptive 'snCodAccess'
	function adapt_snCodAccess() {
		if(false)snCodAccess(-1);
		var a=[],i=0;repeat(argument_count)array_push(a,argument[i++]);
		switch array_length(a) {
			case 0:
				return snCodAccess();
				break;
			case 1:
				return snCodAccess(a[0]);
				break;
			default: return snCodAccess();
		}
		log("............................................");
	}
	
	// adaptive 'snCodMarkerGet'
	function adapt_snCodMarkerGet() {
		if(false)snCodMarkerGet("");
		return snCodMarkerGet(argument0);
	}
	
	// adaptive 'snAftRemove'
	function adapt_snAftRemove() {
		if(false)snAftRemove("");
		return snAftRemove(argument0);
	}
	
#endregion

#region test tools
	
	//
	function mc() {
		show_message("mark");
	}
	
	//
	function log() {
		var str = "\t", i = 0;
		repeat argument_count
			str += string_replace_all(string_replace_all(string(argument[i++]), "\n", "\\n"), "\t", "\\t") + (i < argument_count ? " " : "");
		show_debug_message(str);
	}
	
	//
	global._ = self;
	function gl() {
		return global._;
	}
	
	//
	function find(search) {
		var names = variable_struct_get_names(global._), i = 0;
		repeat array_length(names)
			if (variable_struct_get(global._, names[i++]) == search) return true;
		return false;
	}
	
	//
	groupMarkirator({});
	function groupMarkirator(stc) {
		static name = "__wow_marker_wow__";
		static stack = [];
		var main = (array_length(stack) == 0), i = 0, val, names = variable_struct_get_names(stc);
		if main and adapt_is_snGroup(stc) {
			if !variable_struct_exists(stc, name) {
				variable_struct_set(stc, name, undefined);
				array_push(stack, stc);
			}
		}
		repeat array_length(names) {
			val = variable_struct_get(stc, names[i++]);
			if adapt_is_snGroup(val) and !variable_struct_exists(val, name) {
				variable_struct_set(val, name, undefined);
				array_push(stack, val);
				groupMarkirator(val);
			}
		}
		if main {
			i = 0;
			repeat array_length(stack) variable_struct_remove(stack[i++], name);
			val = stack;
			stack = [];
			return val;
		}
	}
	
	//
	function groupKeys_number(stcm, keys) {
		if !is_array(keys) keys = [keys];
		var marking = groupMarkirator(stcm), i = 0, j, stc, ind = 0;
		repeat array_length(marking) {
			stc = marking[i++];
			j = 0;
			repeat array_length(keys) {
				if variable_struct_exists(stc, keys[j++]) ind++;
			}
		}
		return ind;
	}
	
	//
	function groupKeys_is(stcm, keys) {
		return groupKeys_number(stcm, keys) > 0;
	}
	
	//
	function thrower(func, argm) {
		var _err = false;
		try {
			if !is_array(argm) argm = [argm];
			script_execute_ext(func, argm);
			_err = true;
		} catch (e) {
			if argument_count > 2 and (e != argument[2]) _err = true;
		}
		if _err throw "thrower error";
	}
	
	//
	function unthrower(func, argm) {
		try {
			if !is_array(argm) argm = [argm];
			script_execute_ext(func, argm);
		} catch (e) {
			throw "thrower error: " + e;
		}
	}
	
	//
	global.__ = false;
	function bomb() {
		global.__ = true;
	}
	
	function bomb_demine() {
		if global.__ 
			global.__ = false;
		else
			throw "bomb empty";
	}
	
	//
	function eqSpace(a, b) {
		var _a, _b;
		with a _a = self;
		with b _b = self;
		return _a == _b;
	}
	
	//
	function poster(func, argm) {
		if !is_array(argm) argm = [argm];
		try {
			script_execute_ext(func, argm);
			return undefined;
		} catch (e) {
			return e;
		}
	}
	
	//
	function gpush(n) {
		if (n == global.___)
			global.___ += 1;
		else
			throw "gpush error: at " + string(global.___) + " by " + string(n);
	}
	
	function gclear() {
		global.___ = 0;
	}
	
#endregion

#region test
	
	//
	log("test: main");
	
	#region 0 adapt_snGroup, adapt_is_snGroup - basic
		
		//
		log("section: 0-0");
		
		//
		var _index = variable_struct_names_count(self);
		
		// super basic
		var group = adapt_snGroup();
		assert_is_struct(group);
		assert_equal(string(group), "<snGroup>");
		assert(adapt_is_snGroup(group));
		assert_fail(adapt_is_snGroup({}));
		assert_fail(adapt_is_snGroup(undefined));
		assert_fail(adapt_is_snGroup(0));
		assert_fail(adapt_is_snGroup(""));
		assert_fail(adapt_is_snGroup([]));
		assert(adapt_is_snGroup(adapt_snGroup()));
		assert(adapt_is_snGroup(adapt_snGroup()));
		
		// izol
		assert_equal(variable_struct_names_count(self), _index);
		assert_fail(find(group));
		
		// izol 2
		assert_doesnt_have_key(self, "group");
		self.group = group;
		assert(find(group));
		assert_has_key(self, "group");
		variable_struct_remove(self, "group");
		assert_fail(find(group));
		assert(self == gl());
		assert_doesnt_have_key(self, "group");
		
		// key inhr
		adapt_snGroup("yes");
		assert_has_key(self, "yes");
		assert_is_struct(self.yes);
		assert_equal(string(self.yes), "<snGroup>");
		assert(adapt_is_snGroup(self.yes));
		variable_struct_remove(self, "yes");
		assert_doesnt_have_key(self, "yes");
		
	#endregion
	
	#region 1 throw - basic
		
		//
		log("section: 0-1");
		
		// adapt_snGroup
		thrower(adapt_snGroup, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
		thrower(adapt_snGroup, "");
		unthrower(thrower, [adapt_snGroup, ""]);
		
		try {
			unthrower(adapt_snGroup, "");
		} catch (e) {
			log("-ignore un");
			bomb();
		}
		
		bomb_demine();
		
		try {
			thrower(adapt_snGroup, "yes");
		} catch (e) {
			log("-ignore tr");
			assert_has_key(self, "yes");
			variable_struct_remove(self, "yes");
			assert_doesnt_have_key(self, "yes");
			bomb();
		}
		
		bomb_demine();
		
		//
		try {
			bomb_demine();
		} catch (e) {
			log("bomb is work: " + e);
		}
		
		//
		unthrower(adapt_snGroup, "k");
		thrower(adapt_snGroup, "k");
		thrower(adapt_snGroup, "k", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
		thrower(adapt_snGroup, "k", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
		
		// runInterface
		var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
		var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
		thrower(adapt_snRunAccess, [], runInterface);
		thrower(adapt_snRunDefault, [], runInterface);
		thrower(adapt_snRunCoder, [], runInterface);
		thrower(adapt_snRunMarker, [], runInterface);
		thrower(adapt_snRunCoder_field, [], runInterface);
		thrower(adapt_snCodAccess, [], codInterface);
		thrower(adapt_snCodMarkerGet, [], codInterface);
		thrower(adapt_snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
		
		//
		assert_has_key(self, "k");
		variable_struct_remove(self, "k");
		assert_doesnt_have_key(self, "k");
		
	#endregion
	
	#region 2 intermediate
		
		//
		log("section: 0-2");
		
		//
		stc = adapt_snRunner(false, function() {
			
			//
			var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
			var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
			thrower(adapt_snRunAccess, [], runInterface);
			thrower(adapt_snRunDefault, [], runInterface);
			thrower(adapt_snRunCoder, [], runInterface);
			thrower(adapt_snRunMarker, [], runInterface);
			thrower(adapt_snRunCoder_field, [], runInterface);
			thrower(adapt_snCodAccess, [], codInterface);
			thrower(adapt_snCodMarkerGet, [], codInterface);
			thrower(adapt_snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			
			//
			other.hi = "hello";
			assert_has_key(self, "hi");
			assert(adapt_is_snGroup(self));
			assert(eqSpace(self, other));
			assert(eqSpace(self, self));
			assert(eqSpace(other, other));
			assert_fail(eqSpace(self, {}));
			assert_fail(eqSpace({}, {}));
		});
		
		//
		assert_has_key(self, "stc");
		assert_is_struct(self.stc);
		assert_equal(string(self.stc), "<snGroup>");
		assert(adapt_is_snGroup(self.stc));
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 3 adapt_snGroup-interface, adapt_snRunAccess, adapt_snRunDefault + thrower
		
		//
		log("section: 0-3");
		
		//
		stc = adapt_snRunner(true, function() {
			
			//
			var _root = self;
			
			//
			assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
			assert(eqSpace(self, other));
			assert(adapt_is_snGroup(self));
			
			//
			assert(self == _root);
			assert(self == adapt_snRunAccess());
			assert(self == adapt_snRunAccess("root"));
			assert(self == adapt_snRunAccess("r"));
			assert(self == adapt_snRunAccess("rasdfsdf2"));
			assert(self == adapt_snRunAccess("r3634t"));
			assert(self == adapt_snRunAccess(0));
			assert(self == adapt_snRunAccess(undefined));
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == undefined);
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == self);
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == self);
			assert(undefined == adapt_snRunAccess(-1));
			assert(undefined == adapt_snRunAccess(-1, 1));
			assert(self == adapt_snRunAccess(-1, 0));
			assert(undefined == adapt_snRunAccess("p"));
			assert(undefined == adapt_snRunAccess("p", 1));
			assert(self == adapt_snRunAccess("p", 0));
			assert(undefined == adapt_snRunAccess("pasdf"));
			assert(undefined == adapt_snRunAccess("p23fqf", 1));
			assert(self == adapt_snRunAccess("psf2", 0));
			assert(self == adapt_snRunAccess(1));
			assert(self == adapt_snRunAccess("hook"));
			assert(self == adapt_snRunAccess("h"));
			assert(self == adapt_snRunAccess("h23ffe23"));
			assert(self == adapt_snRunAccess("h23t223"));
			assert(self == adapt_snRunAccess(""));
			assert(self == adapt_snRunAccess(-1, -1));
			assert(self == adapt_snRunAccess(-1, -2));
			assert(self == adapt_snRunAccess(-1, -3));
			
			//
			thrower(adapt_snRunAccess, [-1, 2], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			thrower(adapt_snRunAccess, [-1, 3], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			thrower(adapt_snRunAccess, [-1, 4], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			
			//
			with adapt_snGroup("next") {
				
				//
				assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
				assert(adapt_is_snGroup(self));
				
				//
				assert(other == _root);
				assert(other == adapt_snRunAccess());
				assert(other == adapt_snRunAccess("root"));
				assert(other == adapt_snRunAccess("r"));
				assert(other == adapt_snRunAccess("rasdfsdf2"));
				assert(other == adapt_snRunAccess("r3634t"));
				assert(other == adapt_snRunAccess(0));
				assert(other == adapt_snRunAccess(undefined));
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == other);
				assert(other == adapt_snRunAccess(-1));
				assert(other == adapt_snRunAccess(-1, 1));
				assert(self == adapt_snRunAccess(-1, 0));
				assert(other == adapt_snRunAccess("p"));
				assert(other == adapt_snRunAccess("p", 1));
				assert(self == adapt_snRunAccess("p", 0));
				assert(other == adapt_snRunAccess("pasdf"));
				assert(other == adapt_snRunAccess("p23fqf", 1));
				assert(self == adapt_snRunAccess("psf2", 0));
				assert(other == adapt_snRunAccess(1));
				assert(other == adapt_snRunAccess("hook"));
				assert(other == adapt_snRunAccess("h"));
				assert(other == adapt_snRunAccess("h23ffe23"));
				assert(other == adapt_snRunAccess("h23t223"));
				assert(other == adapt_snRunAccess(""));
				assert(self == adapt_snRunAccess(-1, -1));
				assert(self == adapt_snRunAccess(-1, -2));
				assert(self == adapt_snRunAccess(-1, -3));
				assert_equal(variable_struct_names_count(self), 1);
			}
			
			//
			adapt_snRunDefault("_nx");
			adapt_snRunDefault("_nx");
			adapt_snRunDefault("_bx", 100);
			adapt_snRunDefault("_bx", 150);
			adapt_snRunDefault("_bx");
			adapt_snRunDefault("_dx", 100);
			adapt_snRunDefault("_dx", 150);
			
			//
			var _c2 = self;
			
			//
			with adapt_snGroup("next2") {
				
				//
				var _level_2_1 = self;
				
				//
				assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
				assert(adapt_is_snGroup(self));
				
				//
				assert(other == _root);
				assert(other == adapt_snRunAccess());
				assert(other == adapt_snRunAccess("root"));
				assert(other == adapt_snRunAccess("r"));
				assert(other == adapt_snRunAccess("rasdfsdf2"));
				assert(other == adapt_snRunAccess("r3634t"));
				assert(other == adapt_snRunAccess(0));
				assert(other == adapt_snRunAccess(undefined));
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == other);
				assert(other == adapt_snRunAccess(-1));
				assert(other == adapt_snRunAccess(-1, 1));
				assert(self == adapt_snRunAccess(-1, 0));
				assert(other == adapt_snRunAccess("p"));
				assert(other == adapt_snRunAccess("p", 1));
				assert(self == adapt_snRunAccess("p", 0));
				assert(other == adapt_snRunAccess("pasdf"));
				assert(other == adapt_snRunAccess("p23fqf", 1));
				assert(self == adapt_snRunAccess("psf2", 0));
				assert(other == adapt_snRunAccess(1));
				assert(other == adapt_snRunAccess("hook"));
				assert(other == adapt_snRunAccess("h"));
				assert(other == adapt_snRunAccess("h23ffe23"));
				assert(other == adapt_snRunAccess("h23t223"));
				assert(other == adapt_snRunAccess(""));
				assert(self == adapt_snRunAccess(-1, -1));
				assert(self == adapt_snRunAccess(-1, -2));
				assert(self == adapt_snRunAccess(-1, -3));
				assert_equal(variable_struct_names_count(self), 2);
				
				//
				assert_has_key(self, "_dx");
				assert_equal(self._dx, 150);
				
				//
				var _c1 = self;
				
				//
				with adapt_snGroup("next") {
					
					//
					assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
					assert(adapt_is_snGroup(self));
					
					//
					assert(_root == adapt_snRunAccess());
					assert(_root == adapt_snRunAccess("root"));
					assert(_root == adapt_snRunAccess("r"));
					assert(_root == adapt_snRunAccess("rasdfsdf2"));
					assert(_root == adapt_snRunAccess("r3634t"));
					assert(_root == adapt_snRunAccess(0));
					assert(_root == adapt_snRunAccess(undefined));
					assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
					assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == _root);
					assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == _root);
					assert(other == adapt_snRunAccess(-1));
					assert(other == adapt_snRunAccess(-1, 1));
					assert(self == adapt_snRunAccess(-1, 0));
					assert(other == adapt_snRunAccess("p"));
					assert(other == adapt_snRunAccess("p", 1));
					assert(self == adapt_snRunAccess("p", 0));
					assert(other == adapt_snRunAccess("pasdf"));
					assert(other == adapt_snRunAccess("p23fqf", 1));
					assert(self == adapt_snRunAccess("psf2", 0));
					assert(_root == adapt_snRunAccess(1));
					assert(_root == adapt_snRunAccess("hook"));
					assert(_root == adapt_snRunAccess("h"));
					assert(_root == adapt_snRunAccess("h23ffe23"));
					assert(_root == adapt_snRunAccess("h23t223"));
					assert(_root == adapt_snRunAccess(""));
					assert(self == adapt_snRunAccess(-1, -1));
					assert(self == adapt_snRunAccess(-1, -2));
					assert(self == adapt_snRunAccess(-1, -3));
					assert_equal(variable_struct_names_count(self), 2);
					
					//
					assert(_root == adapt_snRunAccess(-1, 2));
					assert(undefined == adapt_snRunAccess(-1, 3));
					
					//
					assert_has_key(self, "_dx");
					assert_equal(self._dx, 150);
					
					with adapt_snGroup("next") {
						
						//
						adapt_snRunDefault("_dx", 200);
						
						//
						assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
						assert(adapt_is_snGroup(self));
						
						//
						assert(_root == adapt_snRunAccess());
						assert(_root == adapt_snRunAccess("root"));
						assert(_root == adapt_snRunAccess("r"));
						assert(_root == adapt_snRunAccess("rasdfsdf2"));
						assert(_root == adapt_snRunAccess("r3634t"));
						assert(_root == adapt_snRunAccess(0));
						assert(_root == adapt_snRunAccess(undefined));
						assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
						assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == _root);
						assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == _root);
						assert(other == adapt_snRunAccess(-1));
						assert(other == adapt_snRunAccess(-1, 1));
						assert(self == adapt_snRunAccess(-1, 0));
						assert(other == adapt_snRunAccess("p"));
						assert(other == adapt_snRunAccess("p", 1));
						assert(self == adapt_snRunAccess("p", 0));
						assert(other == adapt_snRunAccess("pasdf"));
						assert(other == adapt_snRunAccess("p23fqf", 1));
						assert(self == adapt_snRunAccess("psf2", 0));
						assert(_root == adapt_snRunAccess(1));
						assert(_root == adapt_snRunAccess("hook"));
						assert(_root == adapt_snRunAccess("h"));
						assert(_root == adapt_snRunAccess("h23ffe23"));
						assert(_root == adapt_snRunAccess("h23t223"));
						assert(_root == adapt_snRunAccess(""));
						assert(self == adapt_snRunAccess(-1, -1));
						assert(self == adapt_snRunAccess(-1, -2));
						assert(self == adapt_snRunAccess(-1, -3));
						assert_equal(variable_struct_names_count(self), 2);
						
						//
						assert_has_key(self, "_dx");
						assert_equal(self._dx, 150);
						
						//
						with adapt_snGroup("next") {
							
							//
							assert_has_key(self, "_dx");
							assert_equal(self._dx, 200);
						}
					}
					
					//
					assert(_c1 == adapt_snRunAccess(-1, 1));
					assert(_c2 == adapt_snRunAccess(-1, 2));
					assert(undefined == adapt_snRunAccess(-1, 3));
					
					//
					var _c0 = self;
					
					//
					with adapt_snGroup("next2") {
						
						//
						assert_has_key(self, "_dx");
						assert_equal(self._dx, 150);
						
						//
						adapt_snRunDefault("_dx");
						assert(_c0 == adapt_snRunAccess(-1, 1));
						assert(_c1 == adapt_snRunAccess(-1, 2));
						assert(undefined == adapt_snRunAccess(-1, 4));
						
						//
						with adapt_snGroup("next") {
							
							//
							assert_doesnt_have_key(self, "_dx");
							assert(_c0 == adapt_snRunAccess("p", 2));
							assert(other == adapt_snRunAccess("p", 1));
							assert(_c0 == adapt_snRunAccess(-1, 2));
							assert(_c1 == adapt_snRunAccess(-1, 3));
							assert(_c2 == adapt_snRunAccess(-1, 4));
							assert(_c2 == _root);
							assert(_root == adapt_snRunAccess(-1, 4));
							assert(undefined == adapt_snRunAccess(-1, 5));
						}
					}
					
					//
					with adapt_snGroup("next3") {
						
						//
						assert_has_key(self, "_dx");
						assert_equal(self._dx, 150);
						
						//
						assert(_c0 == adapt_snRunAccess(-1, 1));
					}
					
					//
					adapt_snRunDefault();
					
					//
					with adapt_snGroup("next4") {
						
						//
						assert_doesnt_have_key(self, "_dx");
						
						//
						assert(_c0 == adapt_snRunAccess(-1, 1));
					}
				}
			}
			
			//
			adapt_snGroup("a");
			assert_has_key(self, "next");
			assert_has_key(self, "next2");
			assert_has_key(self, "a");
			assert_has_key(self.a, "_dx");
			assert_equal(self.a._dx, 150);
			
			//
			var _count = variable_struct_names_count(self);
			var emp = adapt_snGroup();
			with emp {
				
				//
				var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
				var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
				thrower(adapt_snRunAccess, [], runInterface);
				thrower(adapt_snRunDefault, [], runInterface);
				thrower(adapt_snRunCoder, [], runInterface);
				thrower(adapt_snRunMarker, [], runInterface);
				thrower(adapt_snRunCoder_field, [], runInterface);
				thrower(adapt_snCodAccess, [], codInterface);
				thrower(adapt_snCodMarkerGet, [], codInterface);
				thrower(adapt_snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			}
			var emp = {};
			with emp {
				
				//
				var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
				var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
				thrower(adapt_snRunAccess, [], runInterface);
				thrower(adapt_snRunDefault, [], runInterface);
				thrower(adapt_snRunCoder, [], runInterface);
				thrower(adapt_snRunMarker, [], runInterface);
				thrower(adapt_snRunCoder_field, [], runInterface);
				thrower(adapt_snCodAccess, [], codInterface);
				thrower(adapt_snCodMarkerGet, [], codInterface);
				thrower(adapt_snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			}
			
			//
			assert_equal(_count, variable_struct_names_count(self));
			
			//
			thrower(adapt_snGroup, "a", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
			thrower(adapt_snGroup, "a", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
			thrower(adapt_snGroup, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snGroup, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snGroup, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			
			//
			with adapt_snGroup("b") {
				
				//
				assert(other == adapt_snRunAccess("p"));
				assert(_root == adapt_snRunAccess("h"));
				
				// 
				assert_has_key(self, "_dx");
				assert_equal(_dx, 150);
				
				//
				adapt_snRunDefault();
				
				//
				with adapt_snGroup("hook", true) {
					
					//
					var _hook = self;
					
					//
					assert_doesnt_have_key(self, "_dx");
					adapt_snRunDefault("test", "yes!");
					
					//
					assert(other == adapt_snRunAccess("p"));
					assert(self == adapt_snRunAccess("h"));
					
					//
					with adapt_snGroup("next") {
						
						//
						assert_has_key(self, "test");
						assert_doesnt_have_key(self, "_dx");
						assert_equal(test, "yes!");
						
						//
						assert(other == adapt_snRunAccess("p"));
						assert(other == adapt_snRunAccess("h"));
						assert(_hook == adapt_snRunAccess("h"));
						
						//
						with adapt_snGroup("next") {
							
							//
							assert(other == adapt_snRunAccess("p"));
							assert(_hook == adapt_snRunAccess("h"));
							
							//
							assert_has_key(self, "test");
							assert_doesnt_have_key(self, "_dx");
							assert_equal(test, "yes!");
							
							//
							with adapt_snGroup("next", true) {
								
								//
								var _hook2 = self;
								
								//
								assert(other == adapt_snRunAccess("p"));
								assert(self == adapt_snRunAccess("h"));
								
								//
								assert_has_key(self, "test");
								assert_doesnt_have_key(self, "_dx");
								assert_equal(test, "yes!");
								
								//
								with adapt_snGroup("next") {
									
									//
									assert(other == adapt_snRunAccess("p"));
									assert(other == adapt_snRunAccess("h"));
									assert(_hook2 == adapt_snRunAccess("h"));
									
									//
									assert_has_key(self, "test");
									assert_doesnt_have_key(self, "_dx");
									assert_equal(test, "yes!");
									
									//
									with adapt_snGroup("next") {
										
										//
										assert(other == adapt_snRunAccess("p"));
										assert(_hook2 == adapt_snRunAccess("h"));
										
										//
										assert_has_key(self, "test");
										assert_doesnt_have_key(self, "_dx");
										assert_equal(test, "yes!");
										
										//
										assert(_root == adapt_snRunAccess("r"));
										assert(_root == adapt_snRunAccess("p", 7));
										assert(undefined == adapt_snRunAccess("p", 8));
										
										//
										thrower(adapt_snRunAccess, [-1, 9], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
										thrower(adapt_snRunAccess, [-1, 10], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
									}
								}
								
								//
								assert(self == adapt_snRunAccess("h"));
							}
							
							//
							assert(_hook == adapt_snRunAccess("h"));
							
							//
							with adapt_snGroup("next2") {
								
								//
								assert(_root == adapt_snRunAccess("r"));
								assert(other == adapt_snRunAccess("p"));
								assert(_hook == adapt_snRunAccess("h"));
								
								//
								assert_has_key(self, "test");
								assert_doesnt_have_key(self, "_dx");
								assert_equal(test, "yes!");
								
								//
								assert(_root == adapt_snRunAccess("p", 5));
								assert(undefined == adapt_snRunAccess("p", 6));
								
								//
								thrower(adapt_snRunAccess, [-1, 7], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
								thrower(adapt_snRunAccess, [-1, 8], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
							}
						}
					}
				}
			}
			
			//
			thrower(adapt_snRunDefault, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snRunDefault, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snRunDefault, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snRunDefault, "___devlocomotive_singletonTools_snHidden_asdfsd", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
			thrower(adapt_snRunDefault, "___devlocomotive_singletonTools_snHidden_2323f2d32", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
		});
		
		//
		assert_has_key(self, "stc");
		assert_is_struct(self.stc);
		assert_equal(string(self.stc), "<snGroup>");
		assert(adapt_is_snGroup(self.stc));
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		assert_equal(groupKeys_number(self.stc, "_dx"), 8);
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 4 adapt_snGroup-interface, adapt_snRunMarker + thrower
		
		//
		log("section: 0-4");
		
		//
		stc = adapt_snRunner(true, function() {
			
			//
			log(" >> 1");
			thrower(adapt_snRunMarker, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snRunMarker, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			
			//
			log(" >> 2");
			unthrower(adapt_snRunMarker, "root");
			unthrower(adapt_snRunMarker, "root");
			
			//
			log(" >> 3");
			assert(adapt_snRunMarker("root") == adapt_snRunMarker("root"));
			
			//
			log(" >> 3.1");
			thrower(adapt_snRunMarker("root"), []);
			thrower(adapt_snRunMarker("root"), []);
			log("'", poster(adapt_snRunMarker("root"), []).message, "'", "-> thrower is need modify");
			thrower(method_get_index(adapt_snRunMarker("root")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			thrower(method_get_index(adapt_snRunMarker("root")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			thrower(method_get_index(adapt_snRunMarker("news")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			
			//
			log(" >> 4");
			
			//
			with adapt_snGroup("next") {
				
				//
				assert(other == adapt_snRunMarker("root")());
				assert(other == adapt_snRunMarker("news")());
				
				//
				thrower(method_get_index(adapt_snRunMarker("a")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
				thrower(method_get_index(adapt_snRunMarker("a")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
				thrower(method_get_index(adapt_snRunMarker("b")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
				thrower(method_get_index(adapt_snRunMarker("b")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			}
			
			//
			assert(self.next == adapt_snRunMarker("a")());
			assert(self.next == adapt_snRunMarker("b")());
		});
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 5 adapt_snGroup-interface, adapt_snRunCoder, adapt_snCodAccess, (adapt_snRunMarker + adapt_snCodMarkerGet) + thrower (basic)
	
		//
		log("section: 0-5");
		
		//
		gclear();
		
		//
		stc = adapt_snRunner(true, function() {
			
			//
			global._root = self;
			
			//
			log(" >> 1");
			thrower(adapt_snRunCoder, ["", "", ""], "\n\tsingletonTools:\n\tthe{level} must be a number\n\n");
			thrower(adapt_snRunCoder, [undefined, "", ""], "\n\tsingletonTools:\n\tthe{level} must be a number\n\n");
			thrower(adapt_snRunCoder, [0, "", ""], "\n\tsingletonTools:\n\tthe {spacename} must be a string and contain at least one character\n\n");
			thrower(adapt_snRunCoder, [0, undefined, ""], "\n\tsingletonTools:\n\tthe {spacename} must be a string and contain at least one character\n\n");
			thrower(adapt_snRunCoder, [0, "space", ""], "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n");
			thrower(adapt_snRunCoder, [0, "space", -1], "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n");
			thrower(adapt_snRunCoder, [0, "space", method(undefined, -1)], "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n");
			
			//
			adapt_snRunMarker("root");
			
			//
			log(" >> 2");
			adapt_snRunCoder(0, "space", function() {
				
				//
				log("code-2-1");
				gpush(0);
				
				//
				assert_equal(argument0, "auto");
				assert(eqSpace(other, adapt_snCodAccess("s")));
				assert(eqSpace(other, adapt_snCodAccess(1)));
				self.hook = "hello yes";
				other.hookOther = "invoke cast";
				assert(adapt_snCodAccess(0) == global._root);
				assert(adapt_snCodAccess() == global._root);
				assert(adapt_snCodAccess(undefined) == global._root);
				assert(adapt_snCodAccess("") == global._root);
				
				//
				unthrower(adapt_snCodMarkerGet, "next");
				assert(adapt_snCodMarkerGet("next") == global._next);
			}, "auto");
			adapt_snRunCoder(0, "space", function() {
				
				//
				log("code-2-2");
				gpush(1);
				
				//
				assert_equal(argument0, "small");
				assert_has_key(self, "hook");
				assert_has_key(other, "hookOther");
				assert_equal(self.hook, "hello yes");
				assert_equal(other.hookOther, "invoke cast");
				assert(eqSpace(other, adapt_snCodAccess(1)));
				assert(adapt_snCodAccess(0) == global._root);
				assert(adapt_snCodAccess() == global._root);
				assert(adapt_snCodAccess(undefined) == global._root);
				assert(adapt_snCodAccess("") == global._root);
				
				//
				thrower(adapt_snCodMarkerGet, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
				thrower(adapt_snCodMarkerGet, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
				thrower(adapt_snCodMarkerGet, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
				thrower(adapt_snCodMarkerGet, "gt", "\n\tsingletonTools:\n\tthis {key} is not marked\n\n");
				
				//
				unthrower(adapt_snCodMarkerGet, "root");
				assert(adapt_snCodMarkerGet("root") == global._root);
			}, "small");
			
			//
			log(" << 2");
			log(" >> 3 - thrower");
			
			//
			thrower(adapt_snCodAccess, [], "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n");
			thrower(adapt_snCodMarkerGet, [], "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n");
			
			//
			with adapt_snGroup("next") {
				
				//
				global._next = self;
				assert(adapt_snRunMarker("root")() == other);
				adapt_snRunMarker("next");
			}
			
			//
			log("code is");
		});
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
		//
		gclear();
		thrower(gpush, 1);
		
	#endregion
	
	#region 6 adapt_snGroup-interface, adapt_snRunCoder, (adapt_snRunMarker + adapt_snCodMarkerGet) + thrower
		
		//
		log("section: 0-6");
		
		//
		gclear();
		
		//
		global._read = {};
		stc = adapt_snRunner(true, function() {
			
			// levels: 20, -55, -1000, 0, -300 -> [-1000, -300, -55, 0, 20]
			// count gpush 24 - [ -300,-55,20,-55,-55,-1000,20,20,20,0,-1000,-1000,-1000,-300,-55,0,-55,0,-55,0,-300,-55,-55,-1000 ]
			// 0-4   -> 5-7  -> 8-15 -> 16-19 -> 20-23 -> 24-
			// -1000 -> -300 -> -55  -> 0     -> 20    -> >20
			
			// >>>
			// var list = [];
			// repeat 24 array_push(list, choose(20, -55, -1000, 0, -300));
			// show_debug_message(list);
			// throw "check point";
			// <<<
			
			//
			adapt_snRunCoder(1, "test", function() {
				
				//
				assert_has_key(other, "hook");
				assert_equal(other.hook, "need more test");
				
				//
				var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
				thrower(adapt_snRunAccess, [], runInterface);
				thrower(adapt_snRunDefault, [], runInterface);
				thrower(adapt_snRunCoder, [], runInterface);
				thrower(adapt_snRunMarker, [], runInterface);
				thrower(adapt_snRunCoder_field, [], runInterface);
			});
			
			//
			adapt_snRunCoder(0, "test", function() {
				
				//
				var _get;
				
				//
				_get = adapt_snCodMarkerGet("root");
				assert(_get == global._read.root);
				assert(_get.mark == "root");
				
				//
				_get = adapt_snCodMarkerGet("mark_one");
				assert(_get == global._read.mark_one);
				assert(_get.mark == "mark_one");
				
				//
				_get = adapt_snCodMarkerGet("mark_two");
				assert(_get == global._read.mark_two);
				assert(_get.mark == "mark_two");
				
				//
				_get = adapt_snCodMarkerGet("mark_three");
				assert(_get == global._read.mark_three);
				assert(_get.mark == "mark_three");
				
				//
				_get = adapt_snCodMarkerGet("mark_four");
				assert(_get == global._read.mark_four);
				assert(_get.mark == "mark_four");
				
				//
				_get = adapt_snCodMarkerGet("mark_five");
				assert(_get == global._read.mark_five);
				assert(_get.mark == "mark_five");
				
				//
				other.hook = "need more test";
			});
			
			//
			self.mark = "root";
			global._read.root = self;
			adapt_snRunMarker("root");
			
			//
			adapt_snRunCoder(-300, "test", gpush, 5);
			
			//
			adapt_snRunCoder(5000, "test", function() {
				assert_has_key(other, "space");
				assert_equal(other.space, "this is test");
				self.space = other;
			});
					
			//
			with adapt_snGroup("depth1_0") {
				
				//
				adapt_snRunCoder(-55, "test", gpush, 10);
				
				//
				with adapt_snGroup("depth2_0") {
					
					//
					with adapt_snGroup("depth3_0") {
						
						//
						adapt_snRunCoder(20, "test", gpush, 22);
						adapt_snRunCoder(-55, "test", gpush, 14);
						
						//
						adapt_snRunCoder(-5000, "test", function() {
							other.space = "this is test";
						});
					}
				}
				
				//
				with adapt_snGroup("depth2_1") {
					
					//
					with adapt_snGroup("depth3_0") {
						
						//
						adapt_snRunCoder(-55, "test", gpush, 15);
					}
					
					//
					self.mark = "mark_one";
					global._read.mark_one = self;
					adapt_snRunMarker("mark_one");
				}
				
				//
				adapt_snRunCoder(-1000, "test", gpush, 1);
			}
			
			//
			with adapt_snGroup("depth1_1") {
				
				//
				with adapt_snGroup("depth2_0") {
					
					//
					adapt_snRunCoder(20, "test", gpush, 21);
				}
				
				//
				adapt_snRunCoder(20, "test", gpush, 20);
				
				//
				with adapt_snGroup("depth2_1") {
					
					//
					with adapt_snGroup("depth3_0") {
						
						//
						self.mark = "mark_two";
						global._read.mark_two = self;
						adapt_snRunMarker("mark_two");
						
						//
						with adapt_snGroup("depth4_0") {
							
							//
							with adapt_snGroup("depth5_0") {
								
								//
								adapt_snRunCoder(20, "test", gpush, 23);
								
								//
								with adapt_snRunAccess("root") {
									
									//
									adapt_snRunCoder(0, "test", gpush, 16);
								}
								
								//
								adapt_snRunCoder(-1000, "test", gpush, 4);
								
								//
								self.mark = "mark_four";
								global._read.mark_four = self;
								adapt_snRunMarker("mark_four");
							}
						}
						
						//
						adapt_snRunCoder(-1000, "test", gpush, 3);
					}
				}
			}
			
			//
			with adapt_snGroup("depth1_2") {
				
				//
				with adapt_snGroup("depth2_0") {
					
					//
					adapt_snRunCoder(-1000, "test", gpush, 2);
				}
				
				//
				with adapt_snGroup("depth2_1") {
					
					//
					with adapt_snGroup("depth3_0") {
						
						//
						adapt_snRunCoder(-300, "test", gpush, 6);
					}
				}
				
				//
				adapt_snRunCoder(-55, "test", gpush, 12);
			}
			
			//
			with depth1_2 {
				
				//
				adapt_snRunCoder(0, "test", gpush, 18);
				
				//
				self.mark = "mark_three";
				global._read.mark_three = self;
				adapt_snRunMarker("mark_three");
			}
			
			//
			with depth1_0 {
				
				//
				adapt_snRunCoder(-55, "test", gpush, 11);
				
				//
				with depth2_1.depth3_0 {
					
					//
					adapt_snRunCoder(0, "test", gpush, 19);
				}
				
				//
				with adapt_snRunAccess("root") {
					
					//
					adapt_snRunCoder(-55, "test", gpush, 8);
				}
				
				//
				adapt_snRunCoder(0, "test", gpush, 17);
			}
			
			//
			with depth1_1 {
				
				//
				with depth2_1.depth3_0.depth4_0 {
					
					//
					adapt_snRunCoder(-300, "test", gpush, 7);
				}
				
				//
				with depth2_0 {
					
					//
					adapt_snRunCoder(-55, "test", gpush, 13);
					
					//
					self.mark = "mark_five";
					global._read.mark_five = self;
					adapt_snRunMarker("mark_five");
				}
			}
			
			//
			adapt_snRunCoder(-55, "test", gpush, 9);
			adapt_snRunCoder(-1000, "test", gpush, 0);
			
		});
		
		//
		assert_has_key(self.stc, "space");
		assert_equal(self.stc.space.hook, "need more test");
		assert_equal(self.stc.space.space, "this is test");
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 7 adapt_snGroup-interface, adapt_snAftRemove, (adapt_snRunCoder_field + (adapt_snRunMarker + adapt_snCodMarkerGet)) + thrower
		
		//
		log("section: 0-7");
		
		//
		stc = adapt_snRunner(true, function() {
			
			//	
			adapt_snAftRemove("hello");
			adapt_snAftRemove("empty");
			adapt_snAftRemove("_before");
			adapt_snAftRemove("_after");
			
			//
			self.hello = "it is hello";
			
			//
			adapt_snRunCoder_field("next", "key");
			adapt_snRunCoder_field("next", [["fld_0", "fld0"], ["fld_1", "fld1"], ["fld_2", "fld2"]]);
			
			//
			with adapt_snGroup("next") {
				
				//
				with adapt_snGroup("next") {
					
					//
					adapt_snRunMarker("next");
					
					//
					self.key = 156;
					
					//
					self.fld_0 = 0;
					self.fld_1 = 1;
					self.fld_2 = 2;
					
					//
					adapt_snAftRemove("fld_2");
				}
				
				//
				adapt_snRunMarker("last");
			}
			
			//
			adapt_snRunCoder(0, "test", function() {
				
				//
				self._after = "delete";
				
				//
				adapt_snAftRemove("_del");
			});
			
			//
			self._del = "cast";
			
			//
			with adapt_snGroup("cast") {
				
				//
				adapt_snRunCoder_field("last", [["next", "next"]]);
				
				//
				adapt_snRunCoder(0, "test", function() {
					
					//
					assert_has_key(self, "next");
					assert_equal(self.next.key, 156);
					assert_equal(self.next.fld_0, 0);
					assert_equal(self.next.fld_1, 1);
					assert_equal(self.next.fld_2, 2);
				});
			}
			
			//
			thrower(adapt_snAftRemove, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snAftRemove, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snAftRemove, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(adapt_snAftRemove, "___devlocomotive_singletonTools_snHidden_sfd2", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
			thrower(adapt_snAftRemove, "___devlocomotive_singletonTools_snHidden_34r5h56hg2", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
			
			// thrower super-test (I really don't want to write tests, so we run each line independently)
			// adapt_snRunCoder_field(""); // ->
			// adapt_snRunCoder_field(undefined); // ->
			// adapt_snRunCoder_field("last", ""); // ->
			// adapt_snRunCoder_field("last", undefined); // ->
			// adapt_snRunCoder_field("last", [["", "key"]]); // ->
			// adapt_snRunCoder_field("last", [[undefined, "key"]]); // ->
			// adapt_snRunCoder_field("last", [["hi", "key"]]); // ->
			// adapt_snRunCoder_field("last", [["next", ""]]); // ->
			// adapt_snRunCoder_field("last", [["next", undefined]]); // ->
		});
		
		//
		assert_doesnt_have_key(self.stc, "hello");
		assert_doesnt_have_key(self.stc.next.next, "fld_2");
		assert_has_key(self.stc, "key");
		assert_has_key(self.stc, "fld0");
		assert_has_key(self.stc, "fld1");
		assert_has_key(self.stc, "fld2");
		assert_equal(self.stc.key.key, 156);
		assert_equal(self.stc.fld0, 0);
		assert_equal(self.stc.fld1, 1);
		assert_equal(self.stc.fld2, 2);
		
		
		//
		assert_doesnt_have_key(self, "empty");
		assert_doesnt_have_key(self, "_before");
		assert_doesnt_have_key(self, "_after");
		assert_doesnt_have_key(self, "_del");
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
    
	//
	log();
	log(">> end");
	
#endregion
