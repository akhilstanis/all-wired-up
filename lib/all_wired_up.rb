class AllWiredUp

  def get_rid_of_wires circuit
    i = 0
    limit = nil
    while limit.nil?
      limit  = circuit[i].index '|'
      i += 1
    end
    circuit.collect do |line|
      if ["ON\n","OFF\n"].include? line
        line
      else
        if ' ' == line[0]
          wire_or_space = line[0...limit]
        else
          wire_or_space = line[1..limit]
        end
        if line.empty?
          ''
        else
          line.sub wire_or_space, ''
        end
      end
    end
  end

  def find_and_replace_bulbs_in_level circuit
    circuit.collect do |line|
      if line =~ /^[01]-*@\n$/
        line[0] == "1" ? "ON\n" : "OFF\n"
      else
        line
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

  def reduction_hash level_zero
    gates = {}
    inputs = []
    output_index = 0
    level_zero.each_index do |index|
      current_input = level_zero[index]
      if current_input =~ /[XAON]/
        output_index = index
        inputs << current_input
      elsif current_input == ' ' or current_input.nil? or current_input == "\n"
        gates[output_index] = inputs
        inputs = []
      else
        inputs << current_input
      end
    end
    unless inputs.empty?
      gates[output_index] = inputs
      inputs = []
    end
    gates
  end

  def replace_level_zero_gate circuit
    level_zero = circuit.collect do |line|
      line[0]
    end
    gates = reduction_hash level_zero
    circuit.each_index do |index|
      if gates[index]
        circuit[index][0] = gate_out(gates[index])
      else
        circuit[index][0] = " " unless circuit[index][0] == "\n"
      end
    end
  end

  def any_more_bulbs? circuit
    ret = false
    circuit.each do |line|
      ret = true if line =~ /-*@$/
    end
    ret
  end

  def process circuit
    while any_more_bulbs?(circuit) do
      circuit = get_rid_of_wires(circuit)
      circuit = replace_level_zero_gate(circuit)
      circuit = find_and_replace_bulbs_in_level(circuit)
      circuit.delete_if { |line| [" \n"," "].include? line }
    end
    circuit
  end

end
