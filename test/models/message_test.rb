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
    messages = Message.conversations_for_member members(:beth), {conversations_per_page: 9999, include_deleted: false}
    messages.each { |message|
      assert_not_equal message, messages(:message_deleted_by_sender), "Deleted message shouldn't show up in Beth's conversations"
    }
  end 

  test "should not return message deleted by recip when recip retrieves it" do 
    messages = Message.conversations_for_member members(:edgar), {conversations_per_page: 9999, include_deleted: false}
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

  test "non-mod shouldn't be able to send message in moderator voice" do 
    m = Message.new({
      member_from: members(:frida),
      member_to: members(:edgar),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message),
      moderator_voice: true
    })
    assert m.invalid?, "Non-mod shouldn't be allowed to send mod voice message"
  end 

  test "mod should be able to send message in moderator voice" do 
    m = Message.new({
      member_from: members(:manny_moderator),
      member_to: members(:edgar),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message),
      moderator_voice: true
    })
    assert m.valid?, "Mod should be allowed to send mod voice message"
  end 

  test "banned member shouldn't be able to send message" do 
    m = Message.new({
      member_from: members(:banned_member),
      member_to: members(:edgar),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Banned member shouldn't be able to send a message, yo"
  end 

  test "banned moderator shouldn't be able to send message" do
    m = Message.new({
      member_from: members(:banned_moderator),
      member_to: members(:edgar),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Banned moderator shouldn't be able to send a message"
  end     

  test "paid, inactive member shouldn't be able to send message" do 
    m = Message.new({
      member_from: members(:paid_inactive_chick),
      member_to: members(:edgar),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Paid, inactive member shouldn't be able to send a message"
  end 

  test "unpaid member shouldn't be able to message mod that didn't mod-voice them" do 
    m = Message.new({
      member_from: members(:unpaid_guy),
      member_to: members(:mindy_moderator),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Unpaid member shouldn't be able to message mod that didn't mod-voice them"
  end 

  test "unpaid member should be able to sent mod that sent them mod message" do 
    m = Message.new({
      member_from: members(:unpaid_guy),
      member_to: members(:manny_moderator),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.valid?, "Unpaid member should be able to message mod that mod-voiced them"
  end 

  test "paid member shouldn't be able to message self" do 
    m = Message.new({
      member_from: members(:frida),
      member_to: members(:frida),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Paid member shouldn't be able to message self"
  end 

  test "paid member shouldn't be able to send message to nil user" do 
    m = Message.new({
      member_from: members(:frida),
      body: 'Blah blah blah blah blah',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Paid member shouldn't be able to message nil user"
  end 

  test "paid member shouldn't be able to send blank message" do 
    m = Message.new({
      member_from: members(:frida),
      member_to: members(:gerta),
      body: '    ',
      message_type: message_types(:private_message)
    })
    assert m.invalid?, "Paid member shouldn't be able to send blank message"
  end  
end
