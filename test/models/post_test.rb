require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not allow post by banned member" do
    p = Post.new({
      member: members(:banned_member),
      parent: posts(:thread_one),
      body: 'Lorem ipsum dolor'
      })

    assert_not p.save
  end 

  test "should allow post by unbanned member" do 
    p = Post.new({
      member: members(:beth),
      parent: posts(:thread_one),
      body: 'Lorem ipsum dolor'
      })

    assert p.save
  end 

  test "should not allow post by inactive member" do
    p = Post.new({
      member: members(:inactive_member),
      parent: posts(:thread_one),
      body: 'Lorem ipsum dolor'
      })

    assert_not p.save
  end 

  test "should allow post by active member" do 
    p = Post.new({
      member: Member.where(active: true).first,
      parent: posts(:thread_one),
      body: 'Lorem ipsum dolor'
      })

    assert p.save
  end 

  test "should not allow non-mod to create thread in the mod forum" do
    p = Post.new({
      member: members(:carrie),
      body: 'Lorem ipsum dolor',
      subject: 'This is the subject',
      forums: [forums(:mod_forum)]
      })
    assert_not p.save
  end

  test "should allow non-mod to reply to thread that exists in mod AND non-mod forums" do 
    p = Post.new({
      member: members(:carrie),
      body: 'Lorem ipsum dolor',
      parent: posts(:mod_and_public_forum_thread)
      })
    assert p.save
  end 

  test "should not allow non-mod to reply to thread that only exists in mod forum" do 
    p = Post.new({
      member: members(:carrie),
      body: 'Lorem ipsum dolor',
      parent: posts(:mod_forum_thread)
      })
    assert_not p.save
  end 

  test "shouldn't allow non-parent post to have forums association" do
    p = Post.new({
      member: members(:manny_moderator),
      parent: posts(:thread_one),
      body: 'Lorem ipsum dolor',
      forums: [forums(:public_forum)]
      })

    assert_not p.save, "that's just weird..."
  end

  test "should allow mod to post to the mod forum" do
    p = Post.new({
      member: members(:manny_moderator),
      body: 'Lorem ipsum dolor',
      subject: 'This is the subject',
      forums: [forums(:mod_forum)]
      })
    assert p.save
  end  

  test "post should create tags correctly" do
    
    p = Post.new({
      member: members(:manny_moderator),
      body: 'Lorem ipsum dolor #aaaa #bbbb #cccc',
      subject: 'This is the subject',
      forums: [forums(:mod_forum)]
      })
    assert p.save

    assert PostTag.where(post: p).count == 3

  end 

  test "post should not create too many tags in the case of tag spam" do
    p = Post.new({
      member: members(:manny_moderator),
      body: 'Lorem ipsum dolor #aaaa #bbbb #cccc #wvsd #fvsdf #vdfs #vsdfvdsfvdsfv #sdfv #dsfv #sdfvsvjknreuyvn #5enavs #cvag983g #avnfkjn  #vdfkv #dofgbnonbg #b53b3b #gbgny #vdfvbs #rbsb #srbtvdv #drhfsd #dfvsdfs #dfvs #sfdvd #qqq #www #eee #rrr #ttt #yyy #uuu #iii #ooo #pppp #aaa #ss #ddd #fff #ggg #hhh #jjj',
      subject: 'This is the subject',
      forums: [forums(:mod_forum)]
      })
    assert p.save

    assert PostTag.where(post: p).count <= MAX_TAGS_PER_POST, "Created too many tags - #{PostTag.where(post: p).count} instead of the max of #{MAX_TAGS_PER_POST}"

  end 

  test "post should not allow unpaid member to post to the paid forum" do 
  end 

  test "post should allow paid member to post to the paid forum" do
  end

end
