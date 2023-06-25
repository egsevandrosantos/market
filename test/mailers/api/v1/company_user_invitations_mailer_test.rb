# typed: ignore
require "test_helper"

class Api::V1::CompanyUserInvitationsMailerTest < ActionMailer::TestCase
  test "invite_user" do
    mail = Api::V1::CompanyUserInvitationsMailer.invite_user
    assert_equal "Invite user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
