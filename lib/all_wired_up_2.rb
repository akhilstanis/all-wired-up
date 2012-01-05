class AllWiredUp2

  attr_accessor :circuit

  # if /\s*[01]-*@/ replace it with ! or *
  # /[01]-*|/ replace with operand above operator

  # c[x][y] = index of /[01]/
  # while c[x][y] != " " or nil
  #   if c[x][y] =~ /[AOXN]/
  #     operator_index = y
  #   gates << c[x][y]
  #   c[x][y] = " "
  #   y++
  # end
  # c[x][opeartor_index] = out(gates)

  # delete empty lines

  def initialize path_to_circuit_file
    File.open path_to_circuit_file do |file|
      @circuit = file.readlines
    end
  end

  def get_rid_of_wires optional_circuit=nil
    circuit = optional_circuit || @circuit
    @circuit = circuit.collect do |line|
      bulb_match = line.match /\s*(?<operand>[01])-*[@]$/
      if bulb_match
        bulb_match['operand'] == "0" ? "OFF\n" : "ON\n"
      else
        match = line.match /\s*(?<operand>[01])-*[|]/
        if match
          line.sub /\s*[01]-*[|]/, " " * line.index('|') + match['operand']
        else
          line
        end
      end
    end
  end

  def gate_out stage
    stage.delete '|'
    case
    when stage.include?('O')
      stage.include?('1') ? '1' : '0'
    when stage.include?('A')
      stage.include?('0') ? '0' : '1'
    when stage.include?('N')
      stage.delete 'N'
      stage.first == '0' ? '1' : '0'
    when stage.include?('X')
      ones = stage.select { |input| input == '1' }
      ones.count % 2 == 0 ? '0' : '1'
    end
  end

  def get_rid_of_gates optional_circuit=nil
    circuit = optional_circuit || @circuit
    skip_rows = []
    circuit.each_index do |index|
      next if skip_rows.include? index
      operand_index = circuit[index].index /[01]\s/
      if operand_index && circuit[index+1][operand_index] =~ /[|XAON]/
        x =index
        row = index
        gate = []
        operator_row = nil
        until circuit[row].nil? || ([" ", nil].include? circuit[row][operand_index]) do
          if circuit[row][0...operand_index] =~ /[01]/
            ri = 1
            gate.reverse_each do |ip|
              circuit[row-ri][operand_index] = ip
              ri += 1
            end
            break
          end
          operator_row = row if circuit[row][operand_index] =~ /[XOAN]/
          gate.push circuit[row][operand_index]
          circuit[row][operand_index] = " "
          skip_rows << row
          row += 1
        end
        begin
          circuit[operator_row][operand_index] = gate_out(gate) if gate.count > 1
        rescue
          next
        end
      end
    end
    @circuit = circuit
    circuit.delete_if { |line| line =~ /^[\s]+\n$/ }
  end

  def any_more_bulbs?
    ret = false
    circuit = @circuit
    circuit.each do |line|
      ret = true if line =~ /-*@$/
    end
    ret
  end

  def process
    while any_more_bulbs? do
      get_rid_of_wires
      get_rid_of_gates
    end
    @circuit.delete_if do |line|
      puts line.chomp unless line.chomp.empty?
      line =~ /^[\s]+$/
    end
  end

end