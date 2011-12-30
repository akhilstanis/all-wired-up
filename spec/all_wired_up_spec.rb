require 'spec_helper'
require 'all_wired_up'
require 'pp'

describe AllWiredUp do

  before :each do
    @o = AllWiredUp.new
  end

  circuitfile = File.open(File.expand_path(File.dirname(__FILE__)) + '/fixtures/simple_circuits.txt').readlines
  circuits = []
  tmp = []
  circuitfile.each do |line|
    if line == "\n"
      circuits << tmp
      tmp = []
    else
      tmp << line
    end
  end
  unless tmp.empty?
    circuits << tmp
    tmp = []
  end

  it "should get rid of wires" do

    expected0 = [
      "0\n",
      "|\n",
      "O-----------@\n",
      "1\n"
    ]

    expected1 = [
      "0\n",
      "A------------|\n",
      "1            |\n",
      "             X------------@\n",
      "1            |\n",
      "N------------|\n"
    ]

    expected2 = [
      "0\n",
      "O------------|\n",
      "1            |\n",
      "             X------------@\n",
      "1            |\n",
      "X------------|\n",
      "1"
    ]

    expected = [
      "0\n",
      "|\n",
      "O-----------@\n",
      "1\n",
      "\n",
      "0\n",
      "A------------|\n",
      "1            |\n",
      "             X------------@\n",
      "1            |\n",
      "N------------|\n",
      "\n",
      "0\n",
      "O------------|\n",
      "1            |\n",
      "             X------------@\n",
      "1            |\n",
      "X------------|\n",
      "1"
    ]

    @o.get_rid_of_wires(circuits[0]).should == expected0
    @o.get_rid_of_wires(circuits[1]).should == expected1
    @o.get_rid_of_wires(circuits[2]).should == expected2
    @o.get_rid_of_wires(circuitfile).should == expected
  end

  it "should find gate outputs" do
    @o.gate_out(['0','|','O','1']).should == '1'
    @o.gate_out(['0','A','1']).should == '0'
    @o.gate_out(['1','N']).should == '0'
    @o.gate_out(['1','X','1']).should == '0'
  end

  it "should get the reduction hash" do
    circuit_level_zero_0 = @o.get_rid_of_wires(circuits[0]).collect { |line| line[0] }
    circuit_level_zero_1 = @o.get_rid_of_wires(circuits[1]).collect { |line| line[0] }
    circuit_level_zero_2 = @o.get_rid_of_wires(circuits[2]).collect { |line| line[0] }
    circuit_level_zero = @o.get_rid_of_wires(circuitfile).collect { |line| line[0] }

    @o.reduction_hash(circuit_level_zero_0).should == { 2 => %w(0 | O 1) }
    @o.reduction_hash(circuit_level_zero_1).should == { 1 => %w(0 A 1), 5 => %w(1 N) }
    @o.reduction_hash(circuit_level_zero_2).should == { 1 => %w(0 O 1), 5 => %w(1 X 1) }
    @o.reduction_hash(circuit_level_zero).should == { 2 => %w(0 | O 1), 6 => %w(0 A 1), 10 => %w(1 N), 13 => %w(0 O 1), 17 => %w(1 X 1) }
  end

  # it "should find output for a gate stage with its output" do

  #   circuit1 = [
  #     '0',
  #     '|',
  #     'O-----------@',
  #     '1'
  #   ]

  #   expected1 = [
  #     ' ',
  #     ' ',
  #     '1-----------@',
  #     ' '
  #   ]

  #   circuit2 = [
  #     '0',
  #     'A------------|',
  #     '1            |',
  #     '             X------------@',
  #     '1            |',
  #     'N------------|'
  #   ]

  #   expected2 = [
  #     ' ',
  #     '0------------|',
  #     '             |',
  #     '             X------------@',
  #     '             |',
  #     '0------------|'
  #   ]


  #   circuit3 = [
  #     '0',
  #     'O------------|',
  #     '1            |',
  #     '             X------------@',
  #     '1            |',
  #     'X------------|',
  #     '1'
  #   ]

  #   expected3 = [
  #     ' ',
  #     '1------------|',
  #     '             |',
  #     '             X------------@',
  #     '             |',
  #     '0------------|',
  #     ' '
  #   ]

  #   circuit4 = [
  #     '0',
  #     'A------------|',
  #     '1            |',
  #     '             X------------@',
  #     '1            |',
  #     'N------------|',
  #     '',
  #     '0',
  #     'O------------|',
  #     '1            |',
  #     '             X------------@',
  #     '1            |',
  #     'X------------|',
  #     '1'
  #   ]

  #   expected4 = [
  #     ' ',
  #     '0------------|',
  #     '             |',
  #     '             X------------@',
  #     '             |',
  #     '0------------|',
  #     ' ',
  #     ' ',
  #     '1------------|',
  #     '             |',
  #     '             X------------@',
  #     '             |',
  #     '0------------|',
  #     ' '
  #   ]

  #   @o.replace_level_zero_gate(circuit1).should == expected1
  #   @o.replace_level_zero_gate(circuit2).should == expected2
  #   @o.replace_level_zero_gate(circuit3).should == expected3
  #   @o.replace_level_zero_gate(circuit4).should == expected4

  # end

  # it "shoudl reduce circuit level by level" do

  #   circuit3 = [
  #     '0-------------|',
  #     '              O------------|',
  #     '1-------------|            |',
  #     '                           X------------@',
  #     '1-------------|            |',
  #     '              X------------|',
  #     '1-------------|'
  #   ]

  #   x = @o.get_rid_of_wires(circuit3)
  #   x = @o.replace_level_zero_gate(x)

  #   x.delete_if do |x|
  #     x =~ /^\s*$/
  #   end

  #   x = @o.get_rid_of_wires(x)
  #   x = @o.replace_level_zero_gate(x)

  #   x.delete_if do |x|
  #     x =~ /^\s*$/
  #   end

  #   x.should == ["1------------@"]

  # end

end
