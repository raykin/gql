require "test_helper"

class CoreExtTest < Minitest::Test

  def test_users_plural?
    assert "users".plural?
  end
end
