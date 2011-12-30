require 'spec_helper'
require 'all_wired_up'

describe AllWiredUp do

  before :each do
    @o = AllWiredUp.new
  end

  it "should get rid of wires" do

    circuit = [
      '0-------------|',
      '              |',
      '              O-----------@',
      '1-------------|'
    ]

    expected = [
      '0',
      '|',
      'O-----------@',
      '1'
    ]

    circuit2 = [
      '0-------------|',
      '              A------------|',
      '1-------------|            |',
      '                           X------------@',
      '1-------------|            |',
      '              N------------|'
    ]

    expected2 = [
      '0',
      'A------------|',
      '1            |',
      '             X------------@',
      '1            |',
      'N------------|'
    ]


    circuit3 = [
      '0-------------|',
      '              O------------|',
      '1-------------|            |',
      '                           X------------@',
      '1-------------|            |',
      '              X------------|',
      '1-------------|'
    ]

    expected3 = [
      '0',
      'O------------|',
      '1            |',
      '             X------------@',
      '1            |',
      'X------------|',
      '1'
    ]

    ###############3
    circuit4 = [
      '0-------------|',
      '              A------------|',
      '1-------------|            |',
      '                           X------------@',
      '1-------------|            |',
      '              N------------|',
      '',
      '0-------------|',
      '              O------------|',
      '1-------------|            |',
      '                           X------------@',
      '1-------------|            |',
      '              X------------|',
      '1-------------|'
    ]

    expected4 = [
      '0',
      'A------------|',
      '1            |',
      '             X------------@',
      '1            |',
      'N------------|',
      '',
      '0',
      'O------------|',
      '1            |',
      '             X------------@',
      '1            |',
      'X------------|',
      '1'
    ]


    @o.get_rid_of_wires(circuit).should == expected
    @o.get_rid_of_wires(circuit2).should == expected2
    @o.get_rid_of_wires(circuit3).should == expected3
    @o.get_rid_of_wires(circuit4).should == expected4

  end

  it "should find gate outputs" do
    @o.gate_out(['0','|','O','1']).should == '1'
    @o.gate_out(['0','A','1']).should == '0'
    @o.gate_out(['1','N']).should == '0'
    @o.gate_out(['1','X','1']).should == '0'
  end

  it "should find output for a gate stage with its output" do

    circuit1 = [
      '0',
      '|',
      'O-----------@',
      '1'
    ]

    expected1 = [
      ' ',
      ' ',
      '1-----------@',
      ' '
    ]

    circuit2 = [
      '0',
      'A------------|',
      '1            |',
      '             X------------@',
      '1            |',
      'N------------|'
    ]

    expected2 = [
      ' ',
      '0------------|',
      '             |',
      '             X------------@',
      '             |',
      '0------------|'
    ]

    @o.replace_level_zero_gate(circuit1).should == expected1
    @o.replace_level_zero_gate(circuit2).should == expected2

  end

end
