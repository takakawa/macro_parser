# $Id: calc.y,v 1.4 2005/11/20 13:29:32 aamine Exp $
#
# Very simple calculater.

class Calcp
 
  prechigh
  
    left LEFT_PAREN RIGHT_PAREN
    left '*' '/' '%' '~' '!' UMINUS
    left '+' '-'
    left LEFT_SHIFT RIGHT_SHIFT
    left '<' '>'  GREATEQ LESSEQ 
    left  EQUA  NO_EQ
    left '&' 
    left '|' 
    left LOGIC_AND
    left LOGIC_OR
    left ':' '?'

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
        | /* none */ 
	{ 
		result = 0 
	}
	


macro_def : DEFINE  NAME exp
	{
		result = [:def,val[1], [:arg],val[2]]
	
	}
	| DEFINE NAME LEFT_PAREN  NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3]],val[5]]
	}
	|DEFINE NAME LEFT_PAREN NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5]], val[7]]
	}
	|DEFINE NAME LEFT_PAREN NAME ',' NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7]],val[9]]
	}
	|DEFINE NAME LEFT_PAREN NAME ',' NAME ',' NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9]],val[11]]
	}
	|DEFINE NAME LEFT_PAREN NAME ',' NAME ','NAME ',' NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9],val[11]],val[13]]
	}	
	|DEFINE NAME LEFT_PAREN NAME ',' NAME ','NAME ',' NAME ',' NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9],val[11],val[13]],val[15]]
	}	
	|DEFINE NAME LEFT_PAREN NAME ',' NAME ','NAME ',' NAME ',' NAME ',' NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9],val[11],val[13],val[15]],val[17]]
	}	
	|DEFINE NAME LEFT_PAREN NAME ',' NAME ','NAME ',' NAME ',' NAME ',' NAME ',' NAME ',' NAME RIGHT_PAREN exp
	{
		result = [:def, val[1], [:arg,val[3],val[5], val[7],val[9],val[11],val[13],val[15],val[17]],val[19]]
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
     | exp '%' exp
	{
		result = [:mod,val[0],val[2]]
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
     | '-' exp =UMINUS
	{
		result = [:UMINUS,val[1]]
	}
     | '~' exp
	{
		result = [:REVERSE,val[1]]
	}
     | '!' exp
	{
		result = [:NOT,val[1]]
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
    | exp NO_EQ exp
	{
		result = [:no_eq,val[0],val[2]]
	}
    | exp LEFT_SHIFT exp
	{
		result = [:LEFT_SHIFT,val[0],val[2]]
	}
    | exp RIGHT_SHIFT exp
	{
		result = [:RIGHT_SHIFT,val[0],val[2]]
	}
    | exp '|' exp
	{
		result = [:bitor, val[0],val[2]]
	}
    | exp LOGIC_AND exp
	{
		result = [:logic_and,val[0],val[2]]
	}
    | exp LOGIC_OR exp
	{
		result = [:logic_or,val[0],val[2]]
	}
    | exp '?' exp ':' exp
	{
		result = [:orand3,val[0],val[2],val[4]]
	}
    | LEFT_PAREN exp RIGHT_PAREN 	
	{
		result = val[1]
	}
    | NUMBER
	{
		result = [:lit,val[0]]
	}
    |	NAME
	{
			if @cmd_arg.include? val[0].to_s
				result = [:val,val[0]]
			else
				result = [:call,val[0],[:arg]]
			end
	}
    | NAME LEFT_PAREN exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2]]]
	}
    | NAME LEFT_PAREN exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4]]]
	}
   | NAME LEFT_PAREN exp ',' exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6]]]
	}
   | NAME LEFT_PAREN exp ',' exp ',' exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8]]]
	}
   | NAME LEFT_PAREN exp ',' exp ',' exp ',' exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8],val[10]]]
	}
   | NAME LEFT_PAREN exp ',' exp ',' exp ',' exp ',' exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8],val[10],val[12]]]
	}	
   | NAME LEFT_PAREN exp ',' exp ',' exp ',' exp ',' exp ',' exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8],val[10],val[12],val[14]]]
	}
   | NAME LEFT_PAREN exp ',' exp ',' exp ',' exp ',' exp ',' exp ',' exp ',' exp RIGHT_PAREN
	{
		result = [:call, val[0], [:arg, val[2], val[4],val[6],val[8],val[10],val[12],val[14],val[16]]]
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
    @cmd_arg=[]
    flag = true
    until str.empty?
      case str
	when /\A\s+/
	when /\Adefine/
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
	when /\A!=/
		@q.push [:NO_EQ,$&]
	when /\A<</
		@q.push [:LEFT_SHIFT,$&]
	when /\A>>/
		@q.push [:RIGHT_SHIFT,$&]
	when /\A&&/
		@q.push [:LOGIC_AND,$&]
	when /\A\|\|/
		@q.push [:LOGIC_OR,$&]
	when /\A\(/
		@q.push [:LEFT_PAREN,$&]
	when /\A\)/
		@q.push [:RIGHT_PAREN,$&]
	when /\A./
		@q.push [$&,$&]
	end

	if flag
		if $& == "("
			cmd_arg_start = true
		elsif $& == ")"
			cmd_arg_start = false
			flag = false
		end
		
		if cmd_arg_start
			if ["+","-","*","/","%","&&","&","==","|","||",">",">=","<","<=",":","?"].include? $&
				@cmd_arg = []
				flag = false
			elsif ($& == "("  and @cmd_arg.include? "(")
				@cmd_arg = []
				flag = false
			else
				@cmd_arg << $&
			end
		end
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
	
		raise "#{call_def[1]} Not Found!" unless @fun_def
		
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
			when :mod
				return eval(exp[1]) % eval(exp[2])
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
			when :no_eq
				return (eval(exp[1]) != eval(exp[2])) 
			when :logic_and
				return  eval(exp[1]) && eval(exp[2])
			when :logic_or
				return  eval(exp[1]) || eval(exp[2])
			when :LEFT_SHIFT
				return eval(exp[1]) << eval(exp[2])
			when :RIGHT_SHIFT
				return eval(exp[1]) >> eval(exp[2])
			when :NOT
				val = eval(exp[1])
				case val
					when Fixnum,Bignum
						return (val==0) ? true : false
					when true,false
						return !val
				end
			when :REVERSE
				return ~eval(exp[1])
			when :UMINUS
				return  -eval(exp[1])
			when :orand3
				val = eval(exp[1])
				case val
					when Fixnum,Bignum
						return  (val == 0) ? eval(exp[3]) : eval(exp[2])
					when true,false
						return  val  ? eval(exp[2])  : eval(exp[3])
				end
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
		case str_exp
			when  /\A\s*define\s+([a-zA-Z_]+\w*)\s+\(([a-zA-Z_]+\w*)\)\s*\Z/
				@parser.funs[$1.to_sym] =  [:def, $1.to_sym, [:arg],[:call,$2.to_sym,[:arg]]]
			else
				@parser.parse(str_exp)
		end

	end
	
	def split_parse(str,splitter=";")
		str.split(splitter).each do |i|
			unless str =~/\A[\s\n]*\Z/
			begin
				parse(i)
			rescue => info
				p info
			end
			end
		end
	end
	
	def exe(str_exe)
		fun_def = @parser.parse(str_exe)
		$funs = @parser.funs
		Executer.new(fun_def).exe
	end
	
	def show
		@parser.funs.each do |i|
			p i
		end
	end
end

