# frozen_string_literal: true

shared_examples "has attribute" do |name, value|
  it "contains '#{name}' attribute" do
    attribute = node.attribute(name)

    expect(attribute).not_to be_nil
    expect(attribute.value).to eq value
  end
end

shared_examples "hasn't attribute" do |name|
  it "doens't contain '#{name}' attribute" do
    attribute = node.attribute(name)

    expect(attribute).to be_nil
  end
end
