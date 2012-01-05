require 'spec_helper'
require 'all_wired_up_2'
require 'pp'

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
      "              N------------|\n"
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
      "ON\n",
      "\n",
      "                           0\n",
      "                           |\n",
      "                           X------------@\n",
      "                           |\n",
      "                           0\n"
    ]

    simple_level_3 = [
      "ON\n",
      "\n",
      "                           0------------@\n",
    ]

    @o.get_rid_of_wires(simple_level_3).should == [
      "ON\n",
      "\n",
      "OFF\n",
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
      "ON\n",
      "\n",
      "                           0\n",
      "                           |\n",
      "                           X------------@\n",
      "                           |\n",
      "                           0\n"
    ]

    @o.get_rid_of_gates(level_1).should == [
      "ON\n",
      "\n",
      "                           0------------@\n"
    ]

  end

  it "should process a circuit file" do
    @o.process.should == ["ON\n", "OFF\n"]
    x = AllWiredUp2.new(File.expand_path(File.dirname(__FILE__)) + '/fixtures/complex_circuits.txt')
    x.process.should == ["ON\n","ON\n","ON\n","OFF\n","OFF\n","ON\n","ON\n","OFF\n"]
  end


end