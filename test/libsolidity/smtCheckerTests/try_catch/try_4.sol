abstract contract D {
	function d() external virtual;
}

contract C {

	int x;
	D d;

	function set(int n) public {
		x = n;
	}

	function f() public {
		x = 0;
		try d.d() {
			assert(x == 0); // should fail, x can be anything here
		} catch {
			assert(x == 0); // should hold, all changes to x has been reverted
			assert(x == 1); // should fail
		}
	}
}
// ====
// SMTEngine: all
// SMTIgnoreCex: yes
// ----
// Warning 1218: (178-192): CHC: Error trying to invoke SMT solver.
// Warning 6328: (178-192): CHC: Assertion violation might happen here.
// Warning 6328: (318-332): CHC: Assertion violation happens here.
// Warning 4661: (178-192): BMC: Assertion violation happens here.
