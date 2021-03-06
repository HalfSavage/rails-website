require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  include HalfSavageExceptions

  test "banned member shouldn't see forum" do
    assert_raise(MustNotBeBannedException) do
      Forum.first.active_discussions_for_member(Member.where(banned: true).first)  
    end
  end 

  test "banned member shouldn't see special forum" do 
    assert_raise(MustNotBeBannedException) do
      Forum.where(special: true).first.active_discussions_for_member(Member.where(banned: true).first)  
    end
  end 

  test "moderator should see mod-only forum" do 
    assert_nothing_raised do
      mod = Member.where(moderator: true).first
      mod.paid = true
      Forum.where(moderator_only: true).first.active_discussions_for_member(mod)  
    end
  end 

  test "non-mod shouldn't see mod-only forum" do 
    assert_raise(MustBeModeratorException) do
      Forum.where(moderator_only: true).first.active_discussions_for_member(Member.where(moderator: false, banned: false).first)  
    end
  end 

  test "paid member should see paid-only forum" do
    assert_nothing_raised do
      mem = Member.where(banned: false, active:true, paid:true).first
      Forum.where(name: 'PaidForum').first.active_discussions_for_member(mem)  
    end
  end 

  test "unpaid member shouldn't see paid-only forum" do 
    assert_raise(MustBePaidException) do
      mem = Member.where(banned: false, active:true, paid:false).first
      mem.paid = false
      Forum.where(name: 'PaidForum').first.active_discussions_for_member(mem)  
    end
  end 

  test "nil (public) member shouldn't see member-only forum" do 
    assert_raise(MustBeAuthenticatedException) do
      Forum.where(name: 'Members Only Forum').first.active_discussions_for_member(nil)  
    end
  end 

  test "nil (public) member shouldn't see paid-only forum" do 
    assert_raise(MustBeAuthenticatedException) do
      Forum.where(name: 'PaidForum').first.active_discussions_for_member(nil)  
    end
  end 

  test "nil (public) member shouldn't see mod-only forum" do 
    assert_raise(MustBeAuthenticatedException, MustBeModeratorException) do
      Forum.where(name: 'ModForum').first.active_discussions_for_member(nil)  
    end
  end  

  test "active, unpaid member should see member-only but unpaid forum" do 
    assert_nothing_raised do
      mem = Member.where(banned: false, active:true).first
      mem.paid = false
      Forum.where(paid_member_only: false, visible_to_public: false, active: true, moderator_only: false).first.active_discussions_for_member(mem)  
    end
  end 

  test "non-mod member shouldn't see inactive forum" do 
    assert_raise(MustBeModeratorException) do
      mem = Member.where(banned: false, active:true, moderator: false).first
      mem.paid = false
      Forum.where(active: false).first.active_discussions_for_member(mem)  
    end
  end 

  test "mod should see inactive forum" do 
    assert_nothing_raised do
      mem = Member.where(moderator: true).first
      Forum.where(active: false).first.active_discussions_for_member(mem)  
    end
  end 


end
