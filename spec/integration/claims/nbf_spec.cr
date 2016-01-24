require "../../spec_helper"

describe "nbf claim" do
  context "nbf is in the future" do
    it "raises ImmatureSignatureError" do
      nbf = Time.now.epoch + 2
      payload = { "nbf" => nbf }
      token = JWT.encode(payload, "key", "HS256")
      expect_raises(JWT::ImmatureSignatureError, "Signature nbf has not been reached") do
        JWT.decode(token, "key", "HS256")
      end
    end
  end

  context "nbf is now" do
    it "accepts token" do
      nbf = Time.now.epoch
      payload = { "nbf" => nbf }
      token = JWT.encode(payload, "key", "HS256")
      payload, header = JWT.decode(token, "key", "HS256")
      payload.should eq({ "nbf" => nbf })
    end
  end

  context "nbf is in the past" do
    it "accepts token" do
      nbf = Time.now.epoch - 1
      payload = { "nbf" => nbf }
      token = JWT.encode(payload, "key", "HS256")
      payload, header = JWT.decode(token, "key", "HS256")
      payload.should eq({ "nbf" => nbf })
    end
  end
end
