#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.12
# from Racc grammer file "".
#

require 'racc/parser.rb'

# $Id: calc.y,v 1.4 2005/11/20 13:29:32 aamine Exp $

class Calcp < Racc::Parser

module_eval(<<'...end calc.y/module_eval...', 'calc.y', 103)

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

...end calc.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    11,    12,    11,    12,     9,    10,    13,    14,    11,    12,
    11,    12,     9,    10,    13,    14,    30,    31,     4,     7,
     5,    11,    12,     6,    37,     9,    10,    13,    14,    11,
    12,    36,    18,     9,    10,    13,    14,    27,    11,    12,
     8,    38,     9,    10,    13,    14,    11,    12,    17,    15,
     9,    10,    13,    14,    11,    12,   nil,   nil,     9,    10,
    13,    14,    11,    12,    11,    12,     9,    10,     9,    10,
     7,     5,     7,     5,     6,   nil,     6,     7,     5,     7,
    26,     6,   nil,     6,     7,     5,     7,     5,     6,   nil,
     6,     7,     5,     7,     5,     6,   nil,     6,     7,     5,
     7,     5,     6,   nil,     6,     7,     5,     7,     5,     6,
   nil,     6,    29,     5,   nil,   nil,     6,    17,    32,    33 ]

racc_action_check = [
    28,    28,    20,    20,    28,    28,    28,    28,    34,    34,
    19,    19,    34,    34,    34,    34,    28,    28,     0,     0,
     0,    16,    16,     0,    34,    16,    16,    16,    16,     3,
     3,    33,     8,     3,     3,     3,     3,    16,    35,    35,
     1,    36,    35,    35,    35,    35,    25,    25,     7,     4,
    25,    25,    25,    25,    39,    39,   nil,   nil,    39,    39,
    39,    39,    23,    23,    24,    24,    23,    23,    24,    24,
    12,    12,    13,    13,    12,   nil,    13,    14,    14,    15,
    15,    14,   nil,    15,    11,    11,    17,    17,    11,   nil,
    17,    10,    10,    38,    38,    10,   nil,    38,     9,     9,
    32,    32,     9,   nil,    32,    31,    31,     5,     5,    31,
   nil,     5,    26,    26,   nil,   nil,    26,    29,    29,    29 ]

racc_action_pointer = [
     2,    40,   nil,    26,    32,    90,   nil,    30,    32,    81,
    74,    67,    53,    55,    60,    62,    18,    69,   nil,     7,
    -1,   nil,   nil,    59,    61,    43,    95,   nil,    -3,    99,
   nil,    88,    83,    14,     5,    35,    22,   nil,    76,    51 ]

racc_action_default = [
    -3,   -18,    -1,    -2,   -18,   -18,   -14,   -15,   -18,   -18,
   -18,   -18,   -18,   -18,   -18,   -18,   -18,   -18,    40,    -7,
    -8,    -9,   -10,   -11,   -12,    -4,   -18,   -13,   -18,   -15,
   -16,   -18,   -18,   -18,   -18,    -5,   -18,   -17,   -18,    -6 ]

racc_goto_table = [
     3,     2,     1,   nil,   nil,   nil,   nil,   nil,   nil,    19,
    20,    21,    22,    23,    24,    25,   nil,    28,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    34,    35,   nil,   nil,   nil,   nil,   nil,    39 ]

racc_goto_check = [
     3,     2,     1,   nil,   nil,   nil,   nil,   nil,   nil,     3,
     3,     3,     3,     3,     3,     3,   nil,     3,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     3,     3,   nil,   nil,   nil,   nil,   nil,     3 ]

racc_goto_pointer = [
   nil,     2,     1,     0 ]

racc_goto_default = [
   nil,   nil,   nil,    16 ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 23, :_reduce_1,
  1, 23, :_reduce_2,
  0, 23, :_reduce_3,
  3, 24, :_reduce_4,
  6, 24, :_reduce_5,
  8, 24, :_reduce_6,
  3, 25, :_reduce_7,
  3, 25, :_reduce_8,
  3, 25, :_reduce_9,
  3, 25, :_reduce_10,
  3, 25, :_reduce_11,
  3, 25, :_reduce_12,
  3, 25, :_reduce_13,
  1, 25, :_reduce_14,
  1, 25, :_reduce_15,
  4, 25, :_reduce_16,
  6, 25, :_reduce_17 ]

racc_reduce_n = 18

racc_shift_n = 40

racc_token_table = {
  false => 0,
  :error => 1,
  :UMINUS => 2,
  "*" => 3,
  "/" => 4,
  "%" => 5,
  "^" => 6,
  "+" => 7,
  "-" => 8,
  "&" => 9,
  "|" => 10,
  "&&" => 11,
  "||" => 12,
  "~" => 13,
  "<" => 14,
  ">" => 15,
  :DEFINE => 16,
  :NAME => 17,
  "(" => 18,
  ")" => 19,
  "," => 20,
  :NUMBER => 21 }

racc_nt_base = 22

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "UMINUS",
  "\"*\"",
  "\"/\"",
  "\"%\"",
  "\"^\"",
  "\"+\"",
  "\"-\"",
  "\"&\"",
  "\"|\"",
  "\"&&\"",
  "\"||\"",
  "\"~\"",
  "\"<\"",
  "\">\"",
  "DEFINE",
  "NAME",
  "\"(\"",
  "\")\"",
  "\",\"",
  "NUMBER",
  "$start",
  "target",
  "macro_def",
  "exp" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'calc.y', 15)
  def _reduce_1(val, _values, result)
    		@iden.clear
		append_fun_def(val[0])
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 20)
  def _reduce_2(val, _values, result)
    		@iden.clear
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 22)
  def _reduce_3(val, _values, result)
     result = 0 
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 28)
  def _reduce_4(val, _values, result)
    		result = [:def,val[1], [:arg],val[2]]
	
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 33)
  def _reduce_5(val, _values, result)
    		result = [:def, val[1], [:arg,val[3]],val[5]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 37)
  def _reduce_6(val, _values, result)
    		result = [:def, val[1], [:arg,val[3],val[5]], val[7]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 43)
  def _reduce_7(val, _values, result)
    		result = [:add,val[0],val[2]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 47)
  def _reduce_8(val, _values, result)
    		result = [:sub,val[0],val[2]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 51)
  def _reduce_9(val, _values, result)
    		result = [:mul,val[0],val[2]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 55)
  def _reduce_10(val, _values, result)
    		result = [:div,val[0],val[2]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 59)
  def _reduce_11(val, _values, result)
    		result = [:bitand,val[0],val[2]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 63)
  def _reduce_12(val, _values, result)
    		result = [:bitor, val[0],val[2]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 68)
  def _reduce_13(val, _values, result)
    		result = val[1]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 72)
  def _reduce_14(val, _values, result)
    		result = [:lit,val[0]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 77)
  def _reduce_15(val, _values, result)
    		if @iden[0..-3].include? [:NAME, val[0]]
			result = [:val,val[0]]
		else
			result = [:call, val[0],[:arg]]
		end

	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 86)
  def _reduce_16(val, _values, result)
    		result = [:call , val[0], [:arg, val[2]]]
	
    result
  end
.,.,

module_eval(<<'.,.,', 'calc.y', 90)
  def _reduce_17(val, _values, result)
    		result = [:call, val[0], [:arg, val[2], val[4]]]
	
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Calcp


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
