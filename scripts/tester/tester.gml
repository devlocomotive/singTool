// test for script-devlocomotive_singletonTools_101
//

#region test controller
	
	//
	show_debug_message("\n\tTester\n");
	
	//
	var test =
		{ addition : 0
		, main : 1
		, current : undefined
		, nothing : -1
		}
	
	//
	test.current = test.main;
	
#endregion

#region test tools

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
		if main and is_snGroup(stc) {
			if !variable_struct_exists(stc, name) {
				variable_struct_set(stc, name, undefined);
				array_push(stack, stc);
			}
		}
		repeat array_length(names) {
			val = variable_struct_get(stc, names[i++]);
			if is_snGroup(val) and !variable_struct_exists(val, name) {
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

//
if (test.current == test.nothing) exit;

#region 0 test - main
if (test.current == test.main) {
	
	//
	log("test: main");
	
	#region 0 snGroup, is_snGroup - basic
		
		//
		log("section: 0-0");
		
		//
		var _index = variable_struct_names_count(self);
		
		// super basic
		var group = snGroup();
		assert_is_struct(group);
		assert_equal(string(group), "<snGroup>");
		assert(is_snGroup(group));
		assert_fail(is_snGroup({}));
		assert_fail(is_snGroup(undefined));
		assert_fail(is_snGroup(0));
		assert_fail(is_snGroup(""));
		assert_fail(is_snGroup([]));
		assert(is_snGroup(snGroup()));
		assert(is_snGroup(snGroup()));
		
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
		snGroup("yes");
		assert_has_key(self, "yes");
		assert_is_struct(self.yes);
		assert_equal(string(self.yes), "<snGroup>");
		assert(is_snGroup(self.yes));
		variable_struct_remove(self, "yes");
		assert_doesnt_have_key(self, "yes");
		
	#endregion
	
	#region 1 throw - basic
		
		//
		log("section: 0-1");
		
		// snGroup
		thrower(snGroup, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
		thrower(snGroup, "");
		unthrower(thrower, [snGroup, ""]);
		
		try {
			unthrower(snGroup, "");
		} catch (e) {
			log("-ignore un");
			bomb();
		}
		
		bomb_demine();
		
		try {
			thrower(snGroup, "yes");
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
		unthrower(snGroup, "k");
		thrower(snGroup, "k");
		thrower(snGroup, "k", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
		thrower(snGroup, "k", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
		
		// runInterface
		var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
		var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
		thrower(snRunAccess, [], runInterface);
		thrower(snRunDefault, [], runInterface);
		thrower(snRunCoder, [], runInterface);
		thrower(snRunMarker, [], runInterface);
		thrower(snRunCoder_field, [], runInterface);
		thrower(snCodAccess, [], codInterface);
		thrower(snCodMarkerGet, [], codInterface);
		thrower(snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
		
		//
		assert_has_key(self, "k");
		variable_struct_remove(self, "k");
		assert_doesnt_have_key(self, "k");
		
	#endregion
	
	#region 2 intermediate
		
		//
		log("section: 0-2");
		
		//
		stc = snRunner(false, function() {
			
			//
			var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
			var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
			thrower(snRunAccess, [], runInterface);
			thrower(snRunDefault, [], runInterface);
			thrower(snRunCoder, [], runInterface);
			thrower(snRunMarker, [], runInterface);
			thrower(snRunCoder_field, [], runInterface);
			thrower(snCodAccess, [], codInterface);
			thrower(snCodMarkerGet, [], codInterface);
			thrower(snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			
			//
			other.hi = "hello";
			assert_has_key(self, "hi");
			assert(is_snGroup(self));
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
		assert(is_snGroup(self.stc));
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 3 snGroup-interface, snRunAccess, snRunDefault + thrower
		
		//
		log("section: 0-3");
		
		//
		stc = snRunner(true, function() {
			
			//
			var _root = self;
			
			//
			assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
			assert(eqSpace(self, other));
			assert(is_snGroup(self));
			
			//
			assert(self == _root);
			assert(self == snRunAccess());
			assert(self == snRunAccess("root"));
			assert(self == snRunAccess("r"));
			assert(self == snRunAccess("rasdfsdf2"));
			assert(self == snRunAccess("r3634t"));
			assert(self == snRunAccess(0));
			assert(self == snRunAccess(undefined));
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == undefined);
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == self);
			assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == self);
			assert(undefined == snRunAccess(-1));
			assert(undefined == snRunAccess(-1, 1));
			assert(self == snRunAccess(-1, 0));
			assert(undefined == snRunAccess("p"));
			assert(undefined == snRunAccess("p", 1));
			assert(self == snRunAccess("p", 0));
			assert(undefined == snRunAccess("pasdf"));
			assert(undefined == snRunAccess("p23fqf", 1));
			assert(self == snRunAccess("psf2", 0));
			assert(self == snRunAccess(1));
			assert(self == snRunAccess("hook"));
			assert(self == snRunAccess("h"));
			assert(self == snRunAccess("h23ffe23"));
			assert(self == snRunAccess("h23t223"));
			assert(self == snRunAccess(""));
			assert(self == snRunAccess(-1, -1));
			assert(self == snRunAccess(-1, -2));
			assert(self == snRunAccess(-1, -3));
			
			//
			thrower(snRunAccess, [-1, 2], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			thrower(snRunAccess, [-1, 3], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			thrower(snRunAccess, [-1, 4], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
			
			//
			with snGroup("next") {
				
				//
				assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
				assert(is_snGroup(self));
				
				//
				assert(other == _root);
				assert(other == snRunAccess());
				assert(other == snRunAccess("root"));
				assert(other == snRunAccess("r"));
				assert(other == snRunAccess("rasdfsdf2"));
				assert(other == snRunAccess("r3634t"));
				assert(other == snRunAccess(0));
				assert(other == snRunAccess(undefined));
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == other);
				assert(other == snRunAccess(-1));
				assert(other == snRunAccess(-1, 1));
				assert(self == snRunAccess(-1, 0));
				assert(other == snRunAccess("p"));
				assert(other == snRunAccess("p", 1));
				assert(self == snRunAccess("p", 0));
				assert(other == snRunAccess("pasdf"));
				assert(other == snRunAccess("p23fqf", 1));
				assert(self == snRunAccess("psf2", 0));
				assert(other == snRunAccess(1));
				assert(other == snRunAccess("hook"));
				assert(other == snRunAccess("h"));
				assert(other == snRunAccess("h23ffe23"));
				assert(other == snRunAccess("h23t223"));
				assert(other == snRunAccess(""));
				assert(self == snRunAccess(-1, -1));
				assert(self == snRunAccess(-1, -2));
				assert(self == snRunAccess(-1, -3));
				assert_equal(variable_struct_names_count(self), 1);
			}
			
			//
			snRunDefault("_nx");
			snRunDefault("_nx");
			snRunDefault("_bx", 100);
			snRunDefault("_bx", 150);
			snRunDefault("_bx");
			snRunDefault("_dx", 100);
			snRunDefault("_dx", 150);
			
			//
			var _c2 = self;
			
			//
			with snGroup("next2") {
				
				//
				var _level_2_1 = self;
				
				//
				assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
				assert(is_snGroup(self));
				
				//
				assert(other == _root);
				assert(other == snRunAccess());
				assert(other == snRunAccess("root"));
				assert(other == snRunAccess("r"));
				assert(other == snRunAccess("rasdfsdf2"));
				assert(other == snRunAccess("r3634t"));
				assert(other == snRunAccess(0));
				assert(other == snRunAccess(undefined));
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == other);
				assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == other);
				assert(other == snRunAccess(-1));
				assert(other == snRunAccess(-1, 1));
				assert(self == snRunAccess(-1, 0));
				assert(other == snRunAccess("p"));
				assert(other == snRunAccess("p", 1));
				assert(self == snRunAccess("p", 0));
				assert(other == snRunAccess("pasdf"));
				assert(other == snRunAccess("p23fqf", 1));
				assert(self == snRunAccess("psf2", 0));
				assert(other == snRunAccess(1));
				assert(other == snRunAccess("hook"));
				assert(other == snRunAccess("h"));
				assert(other == snRunAccess("h23ffe23"));
				assert(other == snRunAccess("h23t223"));
				assert(other == snRunAccess(""));
				assert(self == snRunAccess(-1, -1));
				assert(self == snRunAccess(-1, -2));
				assert(self == snRunAccess(-1, -3));
				assert_equal(variable_struct_names_count(self), 2);
				
				//
				assert_has_key(self, "_dx");
				assert_equal(self._dx, 150);
				
				//
				var _c1 = self;
				
				//
				with snGroup("next") {
					
					//
					assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
					assert(is_snGroup(self));
					
					//
					assert(_root == snRunAccess());
					assert(_root == snRunAccess("root"));
					assert(_root == snRunAccess("r"));
					assert(_root == snRunAccess("rasdfsdf2"));
					assert(_root == snRunAccess("r3634t"));
					assert(_root == snRunAccess(0));
					assert(_root == snRunAccess(undefined));
					assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
					assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == _root);
					assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == _root);
					assert(other == snRunAccess(-1));
					assert(other == snRunAccess(-1, 1));
					assert(self == snRunAccess(-1, 0));
					assert(other == snRunAccess("p"));
					assert(other == snRunAccess("p", 1));
					assert(self == snRunAccess("p", 0));
					assert(other == snRunAccess("pasdf"));
					assert(other == snRunAccess("p23fqf", 1));
					assert(self == snRunAccess("psf2", 0));
					assert(_root == snRunAccess(1));
					assert(_root == snRunAccess("hook"));
					assert(_root == snRunAccess("h"));
					assert(_root == snRunAccess("h23ffe23"));
					assert(_root == snRunAccess("h23t223"));
					assert(_root == snRunAccess(""));
					assert(self == snRunAccess(-1, -1));
					assert(self == snRunAccess(-1, -2));
					assert(self == snRunAccess(-1, -3));
					assert_equal(variable_struct_names_count(self), 2);
					
					//
					assert(_root == snRunAccess(-1, 2));
					assert(undefined == snRunAccess(-1, 3));
					
					//
					assert_has_key(self, "_dx");
					assert_equal(self._dx, 150);
					
					with snGroup("next") {
						
						//
						snRunDefault("_dx", 200);
						
						//
						assert_has_key(self, "___devlocomotive_singletonTools_snHidden_accs_");
						assert(is_snGroup(self));
						
						//
						assert(_root == snRunAccess());
						assert(_root == snRunAccess("root"));
						assert(_root == snRunAccess("r"));
						assert(_root == snRunAccess("rasdfsdf2"));
						assert(_root == snRunAccess("r3634t"));
						assert(_root == snRunAccess(0));
						assert(_root == snRunAccess(undefined));
						assert(self.___devlocomotive_singletonTools_snHidden_accs_._prev == other);
						assert(self.___devlocomotive_singletonTools_snHidden_accs_._temp._root == _root);
						assert(self.___devlocomotive_singletonTools_snHidden_accs_._hook == _root);
						assert(other == snRunAccess(-1));
						assert(other == snRunAccess(-1, 1));
						assert(self == snRunAccess(-1, 0));
						assert(other == snRunAccess("p"));
						assert(other == snRunAccess("p", 1));
						assert(self == snRunAccess("p", 0));
						assert(other == snRunAccess("pasdf"));
						assert(other == snRunAccess("p23fqf", 1));
						assert(self == snRunAccess("psf2", 0));
						assert(_root == snRunAccess(1));
						assert(_root == snRunAccess("hook"));
						assert(_root == snRunAccess("h"));
						assert(_root == snRunAccess("h23ffe23"));
						assert(_root == snRunAccess("h23t223"));
						assert(_root == snRunAccess(""));
						assert(self == snRunAccess(-1, -1));
						assert(self == snRunAccess(-1, -2));
						assert(self == snRunAccess(-1, -3));
						assert_equal(variable_struct_names_count(self), 2);
						
						//
						assert_has_key(self, "_dx");
						assert_equal(self._dx, 150);
						
						//
						with snGroup("next") {
							
							//
							assert_has_key(self, "_dx");
							assert_equal(self._dx, 200);
						}
					}
					
					//
					assert(_c1 == snRunAccess(-1, 1));
					assert(_c2 == snRunAccess(-1, 2));
					assert(undefined == snRunAccess(-1, 3));
					
					//
					var _c0 = self;
					
					//
					with snGroup("next2") {
						
						//
						assert_has_key(self, "_dx");
						assert_equal(self._dx, 150);
						
						//
						snRunDefault("_dx");
						assert(_c0 == snRunAccess(-1, 1));
						assert(_c1 == snRunAccess(-1, 2));
						assert(undefined == snRunAccess(-1, 4));
						
						//
						with snGroup("next") {
							
							//
							assert_doesnt_have_key(self, "_dx");
							assert(_c0 == snRunAccess("p", 2));
							assert(other == snRunAccess("p", 1));
							assert(_c0 == snRunAccess(-1, 2));
							assert(_c1 == snRunAccess(-1, 3));
							assert(_c2 == snRunAccess(-1, 4));
							assert(_c2 == _root);
							assert(_root == snRunAccess(-1, 4));
							assert(undefined == snRunAccess(-1, 5));
						}
					}
					
					//
					with snGroup("next3") {
						
						//
						assert_has_key(self, "_dx");
						assert_equal(self._dx, 150);
						
						//
						assert(_c0 == snRunAccess(-1, 1));
					}
					
					//
					snRunDefault();
					
					//
					with snGroup("next4") {
						
						//
						assert_doesnt_have_key(self, "_dx");
						
						//
						assert(_c0 == snRunAccess(-1, 1));
					}
				}
			}
			
			//
			snGroup("a");
			assert_has_key(self, "next");
			assert_has_key(self, "next2");
			assert_has_key(self, "a");
			assert_has_key(self.a, "_dx");
			assert_equal(self.a._dx, 150);
			
			//
			var _count = variable_struct_names_count(self);
			var emp = snGroup();
			with emp {
				
				//
				var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
				var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
				thrower(snRunAccess, [], runInterface);
				thrower(snRunDefault, [], runInterface);
				thrower(snRunCoder, [], runInterface);
				thrower(snRunMarker, [], runInterface);
				thrower(snRunCoder_field, [], runInterface);
				thrower(snCodAccess, [], codInterface);
				thrower(snCodMarkerGet, [], codInterface);
				thrower(snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			}
			var emp = {};
			with emp {
				
				//
				var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
				var codInterface = "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n";
				thrower(snRunAccess, [], runInterface);
				thrower(snRunDefault, [], runInterface);
				thrower(snRunCoder, [], runInterface);
				thrower(snRunMarker, [], runInterface);
				thrower(snRunCoder_field, [], runInterface);
				thrower(snCodAccess, [], codInterface);
				thrower(snCodMarkerGet, [], codInterface);
				thrower(snAftRemove, [], "\n\tsingletonTools:\n\tinterface <interface-sn-run> or interface <interface-sn-code> is not used\n\n");
			}
			
			//
			assert_equal(_count, variable_struct_names_count(self));
			
			//
			thrower(snGroup, "a", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
			thrower(snGroup, "a", "\n\tsingletonTools:\n\tthe {key} is busy in current group\n\n");
			thrower(snGroup, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snGroup, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snGroup, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			
			//
			with snGroup("b") {
				
				//
				assert(other == snRunAccess("p"));
				assert(_root == snRunAccess("h"));
				
				// 
				assert_has_key(self, "_dx");
				assert_equal(_dx, 150);
				
				//
				snRunDefault();
				
				//
				with snGroup("hook", true) {
					
					//
					var _hook = self;
					
					//
					assert_doesnt_have_key(self, "_dx");
					snRunDefault("test", "yes!");
					
					//
					assert(other == snRunAccess("p"));
					assert(self == snRunAccess("h"));
					
					//
					with snGroup("next") {
						
						//
						assert_has_key(self, "test");
						assert_doesnt_have_key(self, "_dx");
						assert_equal(test, "yes!");
						
						//
						assert(other == snRunAccess("p"));
						assert(other == snRunAccess("h"));
						assert(_hook == snRunAccess("h"));
						
						//
						with snGroup("next") {
							
							//
							assert(other == snRunAccess("p"));
							assert(_hook == snRunAccess("h"));
							
							//
							assert_has_key(self, "test");
							assert_doesnt_have_key(self, "_dx");
							assert_equal(test, "yes!");
							
							//
							with snGroup("next", true) {
								
								//
								var _hook2 = self;
								
								//
								assert(other == snRunAccess("p"));
								assert(self == snRunAccess("h"));
								
								//
								assert_has_key(self, "test");
								assert_doesnt_have_key(self, "_dx");
								assert_equal(test, "yes!");
								
								//
								with snGroup("next") {
									
									//
									assert(other == snRunAccess("p"));
									assert(other == snRunAccess("h"));
									assert(_hook2 == snRunAccess("h"));
									
									//
									assert_has_key(self, "test");
									assert_doesnt_have_key(self, "_dx");
									assert_equal(test, "yes!");
									
									//
									with snGroup("next") {
										
										//
										assert(other == snRunAccess("p"));
										assert(_hook2 == snRunAccess("h"));
										
										//
										assert_has_key(self, "test");
										assert_doesnt_have_key(self, "_dx");
										assert_equal(test, "yes!");
										
										//
										assert(_root == snRunAccess("r"));
										assert(_root == snRunAccess("p", 7));
										assert(undefined == snRunAccess("p", 8));
										
										//
										thrower(snRunAccess, [-1, 9], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
										thrower(snRunAccess, [-1, 10], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
									}
								}
								
								//
								assert(self == snRunAccess("h"));
							}
							
							//
							assert(_hook == snRunAccess("h"));
							
							//
							with snGroup("next2") {
								
								//
								assert(_root == snRunAccess("r"));
								assert(other == snRunAccess("p"));
								assert(_hook == snRunAccess("h"));
								
								//
								assert_has_key(self, "test");
								assert_doesnt_have_key(self, "_dx");
								assert_equal(test, "yes!");
								
								//
								assert(_root == snRunAccess("p", 5));
								assert(undefined == snRunAccess("p", 6));
								
								//
								thrower(snRunAccess, [-1, 7], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
								thrower(snRunAccess, [-1, 8], "\n\tsingletonTools:\n\tcannot rise higher than the root group\n\n");
							}
						}
					}
				}
			}
			
			//
			thrower(snRunDefault, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snRunDefault, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snRunDefault, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snRunDefault, "___devlocomotive_singletonTools_snHidden_asdfsd", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
			thrower(snRunDefault, "___devlocomotive_singletonTools_snHidden_2323f2d32", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
		});
		
		//
		assert_has_key(self, "stc");
		assert_is_struct(self.stc);
		assert_equal(string(self.stc), "<snGroup>");
		assert(is_snGroup(self.stc));
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		assert_equal(groupKeys_number(self.stc, "_dx"), 8);
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 4 snGroup-interface, snRunMarker + thrower
		
		//
		log("section: 0-4");
		
		//
		stc = snRunner(true, function() {
			
			//
			log(" >> 1");
			thrower(snRunMarker, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snRunMarker, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			
			//
			log(" >> 2");
			unthrower(snRunMarker, "root");
			unthrower(snRunMarker, "root");
			
			//
			log(" >> 3");
			assert(snRunMarker("root") == snRunMarker("root"));
			
			//
			log(" >> 3.1");
			thrower(snRunMarker("root"), []);
			thrower(snRunMarker("root"), []);
			log("'", poster(snRunMarker("root"), []).message, "'", "-> thrower is need modify");
			thrower(method_get_index(snRunMarker("root")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			thrower(method_get_index(snRunMarker("root")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			thrower(method_get_index(snRunMarker("news")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			
			//
			log(" >> 4");
			
			//
			with snGroup("next") {
				
				//
				assert(other == snRunMarker("root")());
				assert(other == snRunMarker("news")());
				
				//
				thrower(method_get_index(snRunMarker("a")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
				thrower(method_get_index(snRunMarker("a")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
				thrower(method_get_index(snRunMarker("b")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
				thrower(method_get_index(snRunMarker("b")), [], "\n\tsingletonTools:\n\tthe call, in this case, sets the value, not read it\n\n");
			}
			
			//
			assert(self.next == snRunMarker("a")());
			assert(self.next == snRunMarker("b")());
		});
		
		//
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_accs_"));
		assert_fail(groupKeys_is(self.stc, "___devlocomotive_singletonTools_snHidden_code_"));
		
		//
		variable_struct_remove(self, "stc");
		assert_doesnt_have_key(self, "stc");
		
	#endregion
	
	#region 5 snGroup-interface, snRunCoder, snCodAccess, (snRunMarker + snCodMarkerGet) + thrower (basic)
	
		//
		log("section: 0-5");
		
		//
		gclear();
		
		//
		stc = snRunner(true, function() {
			
			//
			global._root = self;
			
			//
			log(" >> 1");
			thrower(snRunCoder, ["", "", ""], "\n\tsingletonTools:\n\tthe{level} must be a number\n\n");
			thrower(snRunCoder, [undefined, "", ""], "\n\tsingletonTools:\n\tthe{level} must be a number\n\n");
			thrower(snRunCoder, [0, "", ""], "\n\tsingletonTools:\n\tthe {spacename} must be a string and contain at least one character\n\n");
			thrower(snRunCoder, [0, undefined, ""], "\n\tsingletonTools:\n\tthe {spacename} must be a string and contain at least one character\n\n");
			thrower(snRunCoder, [0, "space", ""], "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n");
			thrower(snRunCoder, [0, "space", -1], "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n");
			thrower(snRunCoder, [0, "space", method(undefined, -1)], "\n\tsingletonTools:\n\tthe {methOrFunct} must be an existing function\n\n");
			
			//
			snRunMarker("root");
			
			//
			log(" >> 2");
			snRunCoder(0, "space", function() {
				
				//
				log("code-2-1");
				gpush(0);
				
				//
				assert_equal(argument0, "auto");
				assert(eqSpace(other, snCodAccess("s")));
				assert(eqSpace(other, snCodAccess(1)));
				self.hook = "hello yes";
				other.hookOther = "invoke cast";
				assert(snCodAccess(0) == global._root);
				assert(snCodAccess() == global._root);
				assert(snCodAccess(undefined) == global._root);
				assert(snCodAccess("") == global._root);
				
				//
				unthrower(snCodMarkerGet, "next");
				assert(snCodMarkerGet("next") == global._next);
			}, "auto");
			snRunCoder(0, "space", function() {
				
				//
				log("code-2-2");
				gpush(1);
				
				//
				assert_equal(argument0, "small");
				assert_has_key(self, "hook");
				assert_has_key(other, "hookOther");
				assert_equal(self.hook, "hello yes");
				assert_equal(other.hookOther, "invoke cast");
				assert(eqSpace(other, snCodAccess(1)));
				assert(snCodAccess(0) == global._root);
				assert(snCodAccess() == global._root);
				assert(snCodAccess(undefined) == global._root);
				assert(snCodAccess("") == global._root);
				
				//
				thrower(snCodMarkerGet, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
				thrower(snCodMarkerGet, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
				thrower(snCodMarkerGet, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
				thrower(snCodMarkerGet, "gt", "\n\tsingletonTools:\n\tthis {key} is not marked\n\n");
				
				//
				unthrower(snCodMarkerGet, "root");
				assert(snCodMarkerGet("root") == global._root);
			}, "small");
			
			//
			log(" << 2");
			log(" >> 3 - thrower");
			
			//
			thrower(snCodAccess, [], "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n");
			thrower(snCodMarkerGet, [], "\n\tsingletonTools:\n\tthe <interface-sn-code> interface is not used\n\n");
			
			//
			with snGroup("next") {
				
				//
				global._next = self;
				assert(snRunMarker("root")() == other);
				snRunMarker("next");
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
	
	#region 6 snGroup-interface, snRunCoder, (snRunMarker + snCodMarkerGet) + thrower
		
		//
		log("section: 0-6");
		
		//
		gclear();
		
		//
		global._read = {};
		stc = snRunner(true, function() {
			
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
			snRunCoder(1, "test", function() {
				
				//
				assert_has_key(other, "hook");
				assert_equal(other.hook, "need more test");
				
				//
				var runInterface = "\n\tsingletonTools:\n\tthe <interface-sn-run> interface is not used\n\n";
				thrower(snRunAccess, [], runInterface);
				thrower(snRunDefault, [], runInterface);
				thrower(snRunCoder, [], runInterface);
				thrower(snRunMarker, [], runInterface);
				thrower(snRunCoder_field, [], runInterface);
			});
			
			//
			snRunCoder(0, "test", function() {
				
				//
				var _get;
				
				//
				_get = snCodMarkerGet("root");
				assert(_get == global._read.root);
				assert(_get.mark == "root");
				
				//
				_get = snCodMarkerGet("mark_one");
				assert(_get == global._read.mark_one);
				assert(_get.mark == "mark_one");
				
				//
				_get = snCodMarkerGet("mark_two");
				assert(_get == global._read.mark_two);
				assert(_get.mark == "mark_two");
				
				//
				_get = snCodMarkerGet("mark_three");
				assert(_get == global._read.mark_three);
				assert(_get.mark == "mark_three");
				
				//
				_get = snCodMarkerGet("mark_four");
				assert(_get == global._read.mark_four);
				assert(_get.mark == "mark_four");
				
				//
				_get = snCodMarkerGet("mark_five");
				assert(_get == global._read.mark_five);
				assert(_get.mark == "mark_five");
				
				//
				other.hook = "need more test";
			});
			
			//
			self.mark = "root";
			global._read.root = self;
			snRunMarker("root");
			
			//
			snRunCoder(-300, "test", gpush, 5);
			
			//
			snRunCoder(5000, "test", function() {
				assert_has_key(other, "space");
				assert_equal(other.space, "this is test");
				self.space = other;
			});
					
			//
			with snGroup("depth1_0") {
				
				//
				snRunCoder(-55, "test", gpush, 10);
				
				//
				with snGroup("depth2_0") {
					
					//
					with snGroup("depth3_0") {
						
						//
						snRunCoder(20, "test", gpush, 22);
						snRunCoder(-55, "test", gpush, 14);
						
						//
						snRunCoder(-5000, "test", function() {
							other.space = "this is test";
						});
					}
				}
				
				//
				with snGroup("depth2_1") {
					
					//
					with snGroup("depth3_0") {
						
						//
						snRunCoder(-55, "test", gpush, 15);
					}
					
					//
					self.mark = "mark_one";
					global._read.mark_one = self;
					snRunMarker("mark_one");
				}
				
				//
				snRunCoder(-1000, "test", gpush, 1);
			}
			
			//
			with snGroup("depth1_1") {
				
				//
				with snGroup("depth2_0") {
					
					//
					snRunCoder(20, "test", gpush, 21);
				}
				
				//
				snRunCoder(20, "test", gpush, 20);
				
				//
				with snGroup("depth2_1") {
					
					//
					with snGroup("depth3_0") {
						
						//
						self.mark = "mark_two";
						global._read.mark_two = self;
						snRunMarker("mark_two");
						
						//
						with snGroup("depth4_0") {
							
							//
							with snGroup("depth5_0") {
								
								//
								snRunCoder(20, "test", gpush, 23);
								
								//
								with snRunAccess("root") {
									
									//
									snRunCoder(0, "test", gpush, 16);
								}
								
								//
								snRunCoder(-1000, "test", gpush, 4);
								
								//
								self.mark = "mark_four";
								global._read.mark_four = self;
								snRunMarker("mark_four");
							}
						}
						
						//
						snRunCoder(-1000, "test", gpush, 3);
					}
				}
			}
			
			//
			with snGroup("depth1_2") {
				
				//
				with snGroup("depth2_0") {
					
					//
					snRunCoder(-1000, "test", gpush, 2);
				}
				
				//
				with snGroup("depth2_1") {
					
					//
					with snGroup("depth3_0") {
						
						//
						snRunCoder(-300, "test", gpush, 6);
					}
				}
				
				//
				snRunCoder(-55, "test", gpush, 12);
			}
			
			//
			with depth1_2 {
				
				//
				snRunCoder(0, "test", gpush, 18);
				
				//
				self.mark = "mark_three";
				global._read.mark_three = self;
				snRunMarker("mark_three");
			}
			
			//
			with depth1_0 {
				
				//
				snRunCoder(-55, "test", gpush, 11);
				
				//
				with depth2_1.depth3_0 {
					
					//
					snRunCoder(0, "test", gpush, 19);
				}
				
				//
				with snRunAccess("root") {
					
					//
					snRunCoder(-55, "test", gpush, 8);
				}
				
				//
				snRunCoder(0, "test", gpush, 17);
			}
			
			//
			with depth1_1 {
				
				//
				with depth2_1.depth3_0.depth4_0 {
					
					//
					snRunCoder(-300, "test", gpush, 7);
				}
				
				//
				with depth2_0 {
					
					//
					snRunCoder(-55, "test", gpush, 13);
					
					//
					self.mark = "mark_five";
					global._read.mark_five = self;
					snRunMarker("mark_five");
				}
			}
			
			//
			snRunCoder(-55, "test", gpush, 9);
			snRunCoder(-1000, "test", gpush, 0);
			
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
	
	#region 7 snGroup-interface, snAftRemove, (snRunCoder_field + (snRunMarker + snCodMarkerGet)) + thrower
		
		//
		log("section: 0-7");
		
		//
		stc = snRunner(true, function() {
			
			//	
			snAftRemove("hello");
			snAftRemove("empty");
			snAftRemove("_before");
			snAftRemove("_after");
			
			//
			self.hello = "it is hello";
			
			//
			snRunCoder_field("next", "key");
			snRunCoder_field("next", [["fld_0", "fld0"], ["fld_1", "fld1"], ["fld_2", "fld2"]]);
			
			//
			with snGroup("next") {
				
				//
				with snGroup("next") {
					
					//
					snRunMarker("next");
					
					//
					self.key = 156;
					
					//
					self.fld_0 = 0;
					self.fld_1 = 1;
					self.fld_2 = 2;
					
					//
					snAftRemove("fld_2");
				}
				
				//
				snRunMarker("last");
			}
			
			//
			snRunCoder(0, "test", function() {
				
				//
				self._after = "delete";
				
				//
				snAftRemove("_del");
			});
			
			//
			self._del = "cast";
			
			//
			with snGroup("cast") {
				
				//
				snRunCoder_field("last", [["next", "next"]]);
				
				//
				snRunCoder(0, "test", function() {
					
					//
					assert_has_key(self, "next");
					assert_equal(self.next.key, 156);
					assert_equal(self.next.fld_0, 0);
					assert_equal(self.next.fld_1, 1);
					assert_equal(self.next.fld_2, 2);
				});
			}
			
			//
			thrower(snAftRemove, "", "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snAftRemove, undefined, "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snAftRemove, [[]], "\n\tsingletonTools:\n\tthe {key} must be a string and contain at least one character\n\n");
			thrower(snAftRemove, "___devlocomotive_singletonTools_snHidden_sfd2", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
			thrower(snAftRemove, "___devlocomotive_singletonTools_snHidden_34r5h56hg2", "\n\tthe {key} should not use the prefix '___devlocomotive_singletonTools_snHidden_'\n\n");
			
			// thrower super-test (I really don't want to write tests, so we run each line independently)
			// snRunCoder_field(""); // ->
			// snRunCoder_field(undefined); // ->
			// snRunCoder_field("last", ""); // ->
			// snRunCoder_field("last", undefined); // ->
			// snRunCoder_field("last", [["", "key"]]); // ->
			// snRunCoder_field("last", [[undefined, "key"]]); // ->
			// snRunCoder_field("last", [["hi", "key"]]); // ->
			// snRunCoder_field("last", [["next", ""]]); // ->
			// snRunCoder_field("last", [["next", undefined]]); // ->
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
	
	#region 8 snCleaner
		
		//
		log("section: 0-8");
		
		//
		gclear();
		
		//
		snRunner(false, function() {
			
			//
			self.clear = function() {
				log("--clear0");
				gpush(0);
			}
		}, "clear");
		
		//
		snRunner(false, function() {
			
			//
			self.clear = function() {
				log("--clear1");
				gpush(1);
			}
		}, "clear");
		
		//
		snRunner(false, method_get_index(function() {
			
			//
			self.clr = function() {
				log("--clear2");
				gpush(2);
			}
		}), "clr");
		
		//
		snRunner(false, function() {
		}, function() {
			log("--clear3");
			gpush(3);
		});
		
		//
		snRunner(false, function() {
		}, method_get_index(function() {
			log("--clear4");
			gpush(4);
		}));
		
		//
		snCleaner();
		gpush(5);
		
		//
		thrower(snCleaner, [], "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n");
		thrower(snCleaner, [], "\n\tsingletonTools:\n\tthe application is assumed to be complete\n\n");
		
	#endregion
	
}
#endregion

#region 1 test - addition
if (test.current == test.addition) {
	
	//
	log("test: addition");
	
	//
	snRunner(false, function() {}, "clear");
	thrower(snCleaner, [], "\n\tsingletonTools:\n\tthere is no key '" + "clear" + "' in the group\n\n");
}
#endregion
