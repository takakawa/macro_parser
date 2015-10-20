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
		
		parser.parse("define A 5%(2+1)")
		ret = parser.exe("A")
		assert_equal(ret,2)

		parser.parse("define A 2|1")
		ret = parser.exe("A")
		assert_equal(ret,3)

		parser.parse("define A 1&2")
		ret = parser.exe("A")
		assert_equal(ret,0)
		
		parser.parse("define A 1&&0")
		ret = parser.exe("A")
		assert_equal(ret,0)		
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
		
		parser.parse("define z(x) x")
		ret = parser.exe("z(4)")
		assert_equal(ret, 4)
		
		parser.parse("define B(x) A(x)+(A(4)/4)+1")
		ret = parser.exe("B(4)")
		assert_equal(ret, 121)

		parser.split_parse("define A(x) x*2;define B(a1) a1+4;define C(_x) A(B(_x)+B(1)+1)+1")
		ret = parser.exe("C(2)")
		assert_equal(ret, 25)
	end
	
	def test_logic_op
		parser = MacroParser.new
		parser.parse("define A(x,y) x>y")
		ret = parser.exe("A(4,5)")
		assert_equal(ret, false)
		ret = parser.exe("A(5,4)")
		assert_equal(ret, true)
		ret = parser.exe("A(4,4)")
		assert_equal(ret, false)

		parser.parse("define A(x,y) x>=y")
		ret = parser.exe("A(4,5)")
		assert_equal(ret, false)
		ret = parser.exe("A(5,4)")
		assert_equal(ret, true)
		ret = parser.exe("A(4,4)")
		assert_equal(ret, true)

		parser.parse("define A(x,y) x<y")
		ret = parser.exe("A(4,5)")
		assert_equal(ret, true)
		ret = parser.exe("A(5,4)")
		assert_equal(ret, false)
		ret = parser.exe("A(4,4)")
		assert_equal(ret, false)

		parser.parse("define A(x,y) x<=y")
		ret = parser.exe("A(4,5)")
		assert_equal(ret, true)
		ret = parser.exe("A(5,4)")
		assert_equal(ret, false)
		ret = parser.exe("A(4,4)")
		assert_equal(ret, true)

		parser.parse("define A(x,y) x==y")
		ret = parser.exe("A(4,5)")
		assert_equal(ret, false)
		ret = parser.exe("A(4,4)")
		assert_equal(ret, true)
	end
	
	def test_2_para
		parser = MacroParser.new
		parser.parse("define A(x,y) (x*x+y/y+1)")
		ret = parser.exe("A(4,(1+4))")
		assert_equal(ret, 18)
		
		parser.split_parse("define A1(x) x*x;define A2(x,y) 1*A1(x)+1*A1(y)+0/5*8")
		ret = parser.exe("A2(2,3)")
		assert_equal(ret, 13)

		parser.split_parse("define B1(x) x+1;define B2(x,y) x+y;define B3(x,y) B2(x,x)+B2(B1(x),B1(y+x)+1)")
		ret = parser.exe("B3(2,3)")
		assert_equal(ret, 14)
	end
	
	def test_3_para
		parser = MacroParser.new
		parser.parse("define A(x,y,z) (x+(y+z)*1)")
		ret = parser.exe("A(4,5,1)")
		assert_equal(ret, 10)
		
		parser.split_parse("define A1(x) x*x;define A2(x,y) x/y + x*y")
		parser.split_parse("define B(a,b,c) A2(a,b)+A1(c);define B2(x,a,b) B(a,b,x)")
		ret = parser.exe("B(1,2,3)")
		assert_equal(ret, 11)
		ret = parser.exe("B2(1,2,3)")
		assert_equal(ret, 7)
	end
	
	def test_4_para
		parser = MacroParser.new
		parser.parse("define A(x,y,z,m) x*y+z/m")
		ret = parser.exe("A(4,5,4,2)")
		assert_equal(ret, 22)
		
		parser.split_parse("define B(x) x;define C(x,y) x;define D(x,y,z) x;define AA(a,b,c,d) D(B(A(4,5,4,2)),C(b,c),1)+1+C(b,c)+D(a,b,c)")
		ret = parser.exe("AA(4,5,4,2)")
		assert_equal(ret, 22+1+5+4)
		
	end
	
	def test_5_para
		parser = MacroParser.new
		parser.parse("define A(x,y,z,m,kk) x*y+z/m+kk")
		ret = parser.exe("A(4,5,4,2,10)")
		assert_equal(ret, 32)
	end		
	
	def test_deep_call
		parser = MacroParser.new
		parser.split_parse("define A(x) x+1;define B(b) b+1;define C(a) a+1;define D(mmmm) mmmm+1;
					   define E(av) av+1;define H(ca0) ca0+1;define I(_1a) _1a+1;define Z(z) I(H(E(D(C(A(1+B(z)+1))))))")			   
		ret = parser.exe("Z(2)")
		assert_equal(ret, 11)
	end	
	
	def test_3operator
		parser = MacroParser.new	
		parser.split_parse("define A 1?0:2;define B 1>2 ? 100 : 1000")
		ret = parser.exe("A")
		assert_equal(ret, 0)
		ret = parser.exe("B")
		assert_equal(ret, 1000)
		
		parser.split_parse("define max(a,b) (a > b) ? a : b;define max3(a,b,c) max(max(a,b),c)")
		ret = parser.exe("max(2,5)")
		assert_equal(ret, 5)
		ret = parser.exe("max3(200,50,400)")
		assert_equal(ret, 400)		
		
	end

	def test_0
		parser = MacroParser.new	
		parser.split_parse("define A 1;define B ((A)+A)")
		ret = parser.exe("B")
		assert_equal(ret, 2)
	end
	
	def test_1
		parser = MacroParser.new	
		parser.split_parse("define A 1;define B (A);define C ((A)+B)")
		ret = parser.exe("B")
		assert_equal(ret, 1)
		
		ret = parser.exe("C")
		assert_equal(ret, 2)
	end
	
end
#Test::Unit::UI::Console::TestRunner.run(MacroParserTest)


