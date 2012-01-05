require 'spec_helper'
require 'all_wired_up_2'
require 'pp'

  # Basic Logic

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

describe AllWiredUp2 do

  before :each do
    @o = AllWiredUp2.new(File.expand_path(File.dirname(__FILE__)) + '/fixtures/simple_circuits.txt')
  end

  it "should get rid of wires" do

    @o.get_rid_of_wires.should == [
      "              0\n",
      "              |\n",
      "              O-----------@\n",
      "              1\n",
      "\n",
      "              0\n",
      "              A------------|\n",
      "              1            |\n",
      "                           X------------@\n",
      "              1            |\n",
      "              N------------|\n",
      "\n",
      "              0\n",
      "              O------------|\n",
      "              1            |\n",
      "                           X------------@\n",
      "              1            |\n",
      "              X------------|\n",
      "              1"
    ]

    simple_level_2 = [
      "              1-----------@\n",
      "\n",
      "              0------------|\n",
      "                           |\n",
      "                           X------------@\n",
      "                           |\n",
      "              0------------|\n"
    ]

    @o.get_rid_of_wires(simple_level_2).should == [
      "on\n",
      "\n",
      "                           0\n",
      "                           |\n",
      "                           X------------@\n",
      "                           |\n",
      "                           0\n"
    ]

    simple_level_3 = [
      "on\n",
      "\n",
      "                           0------------@\n",
    ]

    @o.get_rid_of_wires(simple_level_3).should == [
      "on\n",
      "\n",
      "off\n",
    ]

  end

  it "should get rid of gates" do

    level_0 = [
      "              0\n",
      "              |\n",
      "              O-----------@\n",
      "              1\n",
      "\n",
      "              0\n",
      "              A------------|\n",
      "              1            |\n",
      "                           X------------@\n",
      "              1            |\n",
      "              N------------|\n"
    ]

    @o.get_rid_of_gates(level_0).should == [
      "              1-----------@\n",
      "\n",
      "              0------------|\n",
      "                           |\n",
      "                           X------------@\n",
      "                           |\n",
      "              0------------|\n"
    ]

    level_1 = [
      "on\n",
      "\n",
      "                           0\n",
      "                           |\n",
      "                           X------------@\n",
      "                           |\n",
      "                           0\n"
    ]

    @o.get_rid_of_gates(level_1).should == [
      "on\n",
      "\n",
      "                           0------------@\n"
    ]

  end

  it "should process a circuit file" do

    puts "\nProcessing simple_circuits.txt"
    @o.process.should == ["on\n", "off\n","on\n"]

    x = AllWiredUp2.new(File.expand_path(File.dirname(__FILE__)) + '/fixtures/complex_circuits.txt')
    puts "\nProcessing complex_circuits.txt"
    x.process.should == ["on\n","on\n","on\n","off\n","off\n","on\n","on\n","off\n"]

end


end