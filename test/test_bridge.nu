;; test_bridge.nu
;;  tests for the Nu bridge to Objective-C.
;;
;;  Copyright (c) 2007 Tim Burks, Neon Design Technology, Inc.

(class TestBridge is NuTestCase
       (if (eq (uname) "Darwin")
	   (- (id) testConstants is
	      (set floatTypeSignature (if (eq (Nu sizeOfPointer) 8) (then "d") (else "f")))
	      (assert_equal 0 (NuBridgedConstant constantWithName:"NSBlack" signature:floatTypeSignature))
	      (assert_equal 1 (NuBridgedConstant constantWithName:"NSWhite" signature:floatTypeSignature))
	      (assert_equal '(0 0 0 0) (NuBridgedConstant constantWithName:"NSZeroRect" signature:"{_NSRect}"))
	      (assert_equal (NSApplication sharedApplication) (NuBridgedConstant constantWithName:"NSApp" signature:"@"))))
       
       (- (id) testFunctions is
	  (set strcmp (NuBridgedFunction functionWithName:"strcmp" signature:"i**"))
	  (assert_less_than 0 (strcmp "a" "b"))
	  (assert_equal 0 (strcmp "b" "b"))
	  (assert_greater_than 0 (strcmp "c" "b"))
	  (set pow (NuBridgedFunction functionWithName:"pow" signature:"ddd"))
	  (assert_equal 8 (pow 2 3)))
       (- (id) testBlocks is
	  (load "cblocks")
	  (let ((num nil)
		(num-array (array 1 2)))
	    (set equals-num? (cblock BOOL ((id) obj (unsigned long) idx (void*) stop)
				      (if (== obj num) YES (else NO))))
	    (set num 2)
	    (assert_equal 1 (num-array indexOfObjectPassingTest:equals-num?))
	    (set num 3)
	    (assert_equal NSNotFound (num-array indexOfObjectPassingTest:equals-num?)))))

