class AllWiredUp

  def get_rid_of_wires circuit
    limit  = circuit[0].index '|'
    circuit.collect do |line|
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

  def replace_level_zero_gate circuit

  end

end
