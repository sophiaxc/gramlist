# == Schema Information
#
# Table name: gramposts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Grampost do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong!
    @grampost = user.gramposts.build(title: "Test Title", description: "Lorem ipsum")
  end

  subject { @grampost }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @grampost.user_id = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow accss to user_id" do
      expect do
        Grampost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with blank title" do
    before { @grampost.title = " " }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @grampost.title = "a" * 141 }
    it { should_not be_valid }
  end

  describe "from_users_followed_by" do

    let(:user)       { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:third_user) { FactoryGirl.create(:user) }

    before { user.follow!(other_user) }

    let(:own_post)        {       user.gramposts.create!(title: "foo") }
    let(:followed_post)   { other_user.gramposts.create!(title: "bar") }
    let(:unfollowed_post) { third_user.gramposts.create!(title: "baz") }

    subject { Grampost.from_users_followed_by(user) }

    it { should include(own_post) }
    it { should include(followed_post) }
    it { should_not include(unfollowed_post) }
  end
end
