require "test/unit"
require 'test/unit/ui/console/testrunner'
require_relative "calc.tab.rb"

class MacroParserTest < Test::Unit::TestCase
	
	def test_no_para
		parser = MacroParser.new
		parser.parse("define A (((1+1)+2)+3)/2*2")
		ret = parser.exe("A")
		assert_equal(ret, 6)
		
		parser.parse("define A 1+2*3+(20+15)/5 -1")
		ret = parser.exe("A")
		assert_equal(ret, 13)	
		
	end
	
	def test_hex_numer
		parser = MacroParser.new
		parser.parse("define A (0x11+0x1+10)*0x2")
		parser.parse("define B(x0)  A+0x0*0x2+0x2*x0")
		ret = parser.exe("A")
		assert_equal(ret, 56)
		ret = parser.exe("B((0x1+0x5)/2)")
		assert_equal(ret, 62)
	end
	
	def test_1_para
		parser = MacroParser.new
		parser.parse("define A(x) 3*((x+1)/2)*x*x")
		ret = parser.exe("A(4)")
		assert_equal(ret, 96)
		
		parser.parse("define B(x) A(x)+(A(4)/4)+1")
		ret = parser.exe("B(4)")
		assert_equal(ret, 121)

		parser.split_parse("define A(x) x*2;define B(a1) a1+4;define C(_x) A(B(_x)+B(1)+1)+1")
		ret = parser.exe("C(2)")
		assert_equal(ret, 25)
	end
	
	def test_deep_call
		parser = MacroParser.new
		parser.split_parse("define A(x) x+1;define B(b) b+1;define C(a) a+1;define D(mmmm) mmmm+1;
					   define E(av) av+1;define H(ca0) ca0+1;define I(_1a) _1a+1;define Z(z) I(H(E(D(C(A(1+B(z)+1))))))")			   
		ret = parser.exe("Z(2)")
		assert_equal(ret, 11)
	end	
	
end
Test::Unit::UI::Console::TestRunner.run(MacroParserTest)

