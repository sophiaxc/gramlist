require 'spec_helper'

describe "Grampost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "grampost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a grampost" do
        expect { click_button "Post" }.should_not change(Grampost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before do
        fill_in 'grampost_title', with: "Grampost Title"
        fill_in 'grampost_description', with: "Lorem ipsum"
      end

      it "should create a grampost" do
        expect { click_button "Post" }.should change(Grampost, :count).by(1)
      end
    end
  end

  describe "grampost destruction" do
    before { FactoryGirl.create(:grampost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a grampost" do
        expect { click_link "delete" }.should change(Grampost, :count).by(-1)
      end
    end
  end
end