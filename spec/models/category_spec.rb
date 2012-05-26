# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Category do
  let(:category) do
    Category.create(name: "Awesome Cheese Graters")
  end
  let(:grampost) { FactoryGirl.create(:grampost) }

  subject { category }

  it { should be_valid }

  describe "when title is empty" do
    before { category.name = nil }
    it { should_not be_valid }
  end

  describe "grampost associations" do
    before do
      grampost.category_id = category.id
      grampost.save
    end

    it "should have the right gramposts" do
      category.gramposts.should == [grampost]
    end
  end
end
