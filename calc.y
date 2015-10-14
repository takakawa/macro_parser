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
		@iden.clear
		append_fun_def(val[0])
	}
	| exp 
	{
		@iden.clear
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
	|DEFINE NAME '(' NAME ',' NAME ',' NAME ')' exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7]],val[9]]
	}
	|DEFINE NAME '(' NAME ',' NAME ',' NAME ',' NAME ')' exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9]],val[11]]
	}
	|DEFINE NAME '(' NAME ',' NAME ','NAME ',' NAME ',' NAME ')' exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9],val[11]],val[13]]
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
     | exp '>' exp
	{
		result = [:>,val[0],val[2]]
	}
     | exp '<' exp
	{
		result = [:<,val[0],val[2]]
	}
     | exp GREATEQ exp
	{
		result = [:ge,val[0],val[2]]
	}
     | exp LESSEQ exp
	{
		result = [:le,val[0],val[2]]
	}
     | exp EQUA exp
	{
		result = [:eq,val[0],val[2]]
	}
    | exp '|' exp
	{
		result = [:bitor, val[0],val[2]]
	}
    | exp '?' exp ':' exp
	{
		result = [:orand3,val[0],val[2],val[4]]
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
		if @iden[0..-3].include? [:NAME, val[0]]
			result = [:val,val[0]]
		else
			result = [:call, val[0],[:arg]]
		end
	}
    | NAME '(' exp')'
	{
		result = [:call, val[0], [:arg, val[2]]]
	}
    | NAME '(' exp ',' exp ')'
	{
		result = [:call, val[0], [:arg, val[2], val[4]]]
	}
   | NAME '(' exp ',' exp ',' exp ')'
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6]]]
	}
   | NAME '(' exp ',' exp ',' exp ',' exp ')'
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8]]]
	}
   | NAME '(' exp ',' exp ',' exp ',' exp ',' exp')'
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8],val[10]]]
	}
	
     
end

---- header
# $Id: calc.y,v 1.4 2005/11/20 13:29:32 aamine Exp $

---- inner

attr_accessor:q
attr_reader:funs

   def initialize
	@iden = []
	@funs = {}   
   end
   
   def append_fun_def(fun_def)
	@funs[fun_def[1]] = fun_def
   end
  
  def parse(str)
    @q = []
    until str.empty?
      case str
	when /\A\s+/
	when /define/
		@q.push [:DEFINE,$&]
	when /\A0[xX][a-fA-F0-9]+/
		@q.push [:NUMBER,$&.to_i(16)]
	when /\A[a-zA-Z_]+[a-zA-Z_0-9]*|\n/o
		s = $&
		@q.push [:NAME, s.to_sym]
	when /\A\d+/
		@q.push [:NUMBER, $&.to_i]
	when /\A>=/
		@q.push [:GREATEQ,$&]
	when /\A<=/
		@q.push [:LESSEQ,$&]
	when /\A==/
		@q.push [:EQUA,$&]
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
	@iden<<tmp
	tmp
  end

---- footer

$funs = {}
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
				return  eval(exp[1])  /  eval(exp[2]) 
			when :bitand
				return  eval(exp[1])  &  eval(exp[2]) 
			when :bitor
				return  eval(exp[1])  |  eval(exp[2]) 
			when :>
				return  (eval(exp[1])  >  eval(exp[2]))
			when :<
				return  (eval(exp[1])  <  eval(exp[2]))
			when :ge
				return  (eval(exp[1])  >=  eval(exp[2]))
			when :le
				return  (eval(exp[1])  <=  eval(exp[2])) 
			when :eq
				return  (eval(exp[1])  ==  eval(exp[2]))
			when :orand3
				return  (eval(exp[1])  ? eval(exp[2])  : eval(exp[3]))

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

class MacroParser
	def initialize
		@parser = Calcp.new
		$funs.clear
	end
	
	def parse(str_exp)
		@parser.parse(str_exp)

	end
	
	def split_parse(str,splitter=";")
		str.split(splitter).each do |i|
			@parser.parse(i)
		end
		
	end
	
	def exe(str_exe)
		fun_def = @parser.parse(str_exe)
		$funs = @parser.funs
		Executer.new(fun_def).exe
	end
	
	def show
		$funs.each do |i|
			p i
		end
	end
end

