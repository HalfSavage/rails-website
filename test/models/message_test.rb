require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should return messages for user, grouped by conversation" do 
    messages = Message.conversations_for_member(members(:albert).id)
    assert_equal messages.count, 6, "Wrong number of convos! Is #{messages.count}, should be 6"
  end 

  test "should not return message deleted by sender when sender retrieves it" do 
    messages = Message.conversations_for_member(members(:beth)) 
    messages.each { |message|
      assert_not_equal message, messages(:message_deleted_by_sender), "Deleted message shouldn't show up in Beth's conversations"
    }
  end 

  test "should not return message deleted by recip when recip retrieves it" do 
    messages = Message.conversations_for_member(members(:edgar)) 
    messages.each { |message|
      assert_not_equal message, messages(:message_deleted_by_recipient), "Deleted message shouldn't show up in Edgar's conversations"
    }
  end 

  test "should return a specific message for the sender" do
    assert Message.find_for_member(members(:carrie), messages(:ten)).present?, "Couldn't find Carrie->Albert msg for Carrie"
  end 

  test "should return a specific message for the recipient" do 
    assert Message.find_for_member(members(:albert), messages(:ten)).present?, "Couldn't find Carrie->Albert msg for Albert"
  end 

  test "should not return a specific message for a user that is neither sender nor recipient" do 
    assert Message.find_for_member(members(:frida), messages(:ten)).empty?, "Couldn't find Carrie->Albert msg for Albert"
  end 

  test "unpaid member's messages should be obscured, unless they're from in moderator voice" do
    messages = Message.conversations_for_member(members(:unpaid_guy))
    ug = members(:unpaid_guy)
    puts "unpaid_guy: obscure? #{ug.message_content_should_be_obscured?} paid? #{ug.paid?}"
    messages.each do |message| 
      if (!message.moderator_voice?) 
        assert message.obscure_content?, "Content should've been obscured"
      end 
      if message.moderator_voice?
        assert_not message.obscure_content?, "Content shouldn't have been obscured, it's mod voice" 
      end 
    end      
    
  end

  test "paid member's messages should not be obscured" do 
    messages.each do |message| 
      assert_not message.obscure_content?, "Content shouldn't have been obscured, viewing member is paid" 
    end   

  end 

  test "unpaid member shouldn't be able to read message unless it's a moderator voice message" do  
  end

  test "non-mod shouldn't be able to send message in moderator voice" do 
  end 

  test "mod should be able to send message in moderator voice" do 
  end 

  test "banned member shouldn't be able to send message" do 
  end 

  test "banned moderator shouldn't be able to send message" do 
  end     

  test "paid member shouldn't be able to message self" do 
  end 

  test "paid member shouldn't be able to send message to nil user" do 
  end 
end
