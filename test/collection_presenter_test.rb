require 'helper'
require 'neo/rails/presenter'
require 'neo/rails/collection_presenter'

class CollectionPresenterTest < NeoRailsCase
  describe 'sample presenter' do
    let(:entries)   { [Profile.new, Profile.new] }
    let(:presenter) { ProfileCollectionPresenter.new(entries) }

    it 'initializes' do
      presenter = ProfileCollectionPresenter.new([])

      assert presenter.is_a?(ProfileCollectionPresenter)
    end

    it 'gets item by index' do
      presenter = ProfileCollectionPresenter.new([1, 2])

      assert_equal 1, presenter.get_by_index(0)
      assert_equal 2, presenter.get_by_index(1)
    end

    describe 'delegations' do
      let(:presenter) { ProfileCollectionPresenter.new([1, 2]) }
      let(:entries)   { presenter.entries }

      it 'delegates last' do
        assert_equal entries.last, presenter.last
      end

      it 'delegates size' do
        assert_equal entries.size, presenter.size
      end

      it 'delegates each' do
        assert_equal entries.each.to_a, presenter.each.to_a
      end
    end

    test 'builds entries of presenters' do
      collection_presenter = ProfileCollectionPresenter.build(entries)

      assert_equal 2, collection_presenter.size

      collection_presenter.each do | presenter|
        assert presenter.is_a?(ProfilePresenter)
      end
    end
  end

  private

  class ProfileCollectionPresenter
    include Neo::Rails::CollectionPresenter
  end

  class ProfilePresenter
    include Neo::Rails::Presenter

    def initialize(profile)
      @profile = profile
    end
  end

  class Profile
  end
end
