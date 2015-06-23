require 'test_helper'

class BaseServiceTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, BaseService
  end
end
