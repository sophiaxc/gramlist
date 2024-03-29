require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Gramlist') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user, zipcode: "94114") }
      before do
        FactoryGirl.create(:grampost, user: user, title: "Lorem ipsum",
                                      zipcode: "94114")
        FactoryGirl.create(:grampost, user: user, title: "Dolor sit amet",
                                      zipcode: "94114")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("div##{item.id}")
        end
      end

      describe "showing only local items" do
        let (:non_local_item) { FactoryGirl.create(:grampost, user: user,
                                                   title: "Lorem ipsum",
                                                   zipcode: "90210") }
        before { visit root_path }
        it "should not render non local items" do
          page.should_not have_selector("div##{non_local_item.id}")
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
end
