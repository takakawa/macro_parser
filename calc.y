# $Id: calc.y,v 1.4 2005/11/20 13:29:32 aamine Exp $
#
# Very simple calculater.

class Calcp
  prechigh
    nonassoc UMINUS
    left '*' '/' '%' '^'
    left '+' '-'
    left '&' '|' '&&' '||' '~'
    left '<' '>'
  preclow
rule
  target: macro_def 
	{
		$iden.clear
	}
	| exp 
	{
		$iden.clear
	}
        | /* none */ { result = 0 }
	


macro_def : DEFINE NAME exp
	{
		result = [:def,val[1], [:arg],val[2]]
	
	}
	| DEFINE NAME '('  NAME')' exp
	{
		result = [:def, val[1], [:arg,val[3]],val[5]]
	}
	|DEFINE NAME '(' NAME ',' NAME')' exp
	{
		result = [:def, val[1], [:arg,val[3],val[5]], val[7]]
	}

	
  exp: exp '+' exp
	{
		result = [:add,val[0],val[2]]
	}
     | exp '-' exp 	
	{
		result = [:sub,val[0],val[2]]
	}
     | exp '*' exp 	
	{
		result = [:mul,val[0],val[2]]
	}
     | exp '/' exp 	
	{
		result = [:div,val[0],val[2]]
	}
     | exp '&' exp
	{
		result = [:bitand,val[0],val[2]]
	}
    | exp '|' exp
	{
		result = [:bitor, val[0],val[2]]
	}

     | '(' exp ')' 	
	{
		result = val[1]
	}
     | NUMBER
	{
		result = [:lit,val[0]]
	}
     |	NAME
	{

		if $iden[0..-3].include? [:NAME, val[0]]
			result = [:val,val[0]]
		else
			result = [:call, val[0],[:arg]]
		end

	}
    | NAME '(' exp')'
	{
		result = [:call , val[0], [:arg, val[2]]]
	}
    | NAME '(' exp ',' exp ')'
	{
		result = [:call, val[0], [:arg, val[2], val[4]]]
	}
     

	
     
end

---- header
# $Id: calc.y,v 1.4 2005/11/20 13:29:32 aamine Exp $
	$iden = []
---- inner

attr_accessor:q

  def parse(str)
    @q = []
    until str.empty?
      case str
	when /\A\s+/
	when /define/
		@q.push [:DEFINE,$&]
	when /\A[a-zA-Z_]+[a-zA-Z_0-9]*|\n/o
		s = $&
		@q.push [:NAME, s.to_sym]
	when /\A\d+/
		@q.push [:NUMBER, $&.to_i]
	when /\A./
		@q.push [$&,$&]
      end
      str = $'
    end
    @q.push [false, '$end']
    do_parse
  end

  def next_token
	tmp = @q.shift
	$iden<<tmp
	tmp
  end

---- footer

$funs = {}
$calls=[]
class Executer
	
	def initialize(call_def)
		@paras={}
		@call_def = call_def
		@fun_def =$funs[call_def[1]]
	
		args_name =@fun_def[2][1..-1]
		args_value = call_def[2][1..-1]
	
		return nil unless args_name.length == args_value.length

		args_name.each_index {|i| 
			@paras[args_name[i]] = eval(args_value[i])
		}
	end
	private
	def pre_process(arr)
			return nil unless Array === arr
			arr.each_index do |i|
				case arr[i]
					when :val
					@paras.each{|k,v| 
							if arr[i+1] == k
								arr[i] = :lit
								arr[i+1]=v
							end
						}
					break
					when Array
					pre_process(arr[i])
				end
			end
			
	end
	public	
	def eval(exp)
		return nil unless exp
		return nil unless Array === exp

		case exp[0]
			when :lit
				return exp[1]
			when :add
				return eval(exp[1]) + eval(exp[2])
			when :sub
				return  eval(exp[1]) -  eval(exp[2])
			when :mul
				return  eval(exp[1])  *  eval(exp[2]) 
			when :div 
				return  eval(exp[1])  *  eval(exp[2]) 
			when :bitand
				return  eval(exp[1])  &  eval(exp[2]) 
			when :bitor
				return  eval(exp[1])  |  eval(exp[2]) 
			when :call
				return  Executer.new(exp).exe
		end
		
	end
	public
	def exe

		tmp = Marshal.load(Marshal.dump(@fun_def))
		pre_process(tmp)
		
		return  eval(tmp[3])
	
	end
end

parser = Calcp.new
str =     "
define A 1;
define B 2*4;
define C(x) x;
define D(x) x+1;
define E(x) x+3+A;
define F(x) x+3+D(x);
define G(x) (D(x)+C(x))*2;
define H(x) A*B*C(x);
define I(x) D(C(A));
define J(x) D(A+B+C(x));
define JJ(x) D(A+B+C(1));
define J1    1;
define J1    2;
define K(x,y)    J1*B+C(x)+D(y);
define K1(x,y)   K(A,B);
define K2(x,y)   K(C(x),D(y));
define K3(x,y)   K(1+A,C(x+y)+1);
A;B;C(1);D(1);E(1);F(1);G(1);
H(1);G(1);J(1);JJ(1);J1;
K(1,2);K1(1,2);K2(1,2);K3(1,2);


"
 begin
	tmp = str.split ";"
	tmp.each do |i|
		tmp = parser.parse(i)
		case tmp[0]
			when :def
			$funs[tmp[1]] = tmp
			when :call
			$calls<<tmp
		end
		
	end
	
 rescue ParseError
    puts $!
 end

p $funs
p $calls


$calls.each do |i|
	p Executer.new(i).exe
end


	