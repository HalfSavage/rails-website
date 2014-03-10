require 'test_helper'

class DiscussionViewsControllerTest < ActionController::TestCase
  setup do
    @discussion_view = discussion_views(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discussion_views)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discussion_view" do
    assert_difference('DiscussionView.count') do
      post :create, discussion_view: { member_id: @discussion_view.member_id, post_id: @discussion_view.post_id, tally: @discussion_view.tally }
    end

    assert_redirected_to discussion_view_path(assigns(:discussion_view))
  end

  test "should show discussion_view" do
    get :show, id: @discussion_view
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discussion_view
    assert_response :success
  end

  test "should update discussion_view" do
    patch :update, id: @discussion_view, discussion_view: { member_id: @discussion_view.member_id, post_id: @discussion_view.post_id, tally: @discussion_view.tally }
    assert_redirected_to discussion_view_path(assigns(:discussion_view))
  end

  test "should destroy discussion_view" do
    assert_difference('DiscussionView.count', -1) do
      delete :destroy, id: @discussion_view
    end

    assert_redirected_to discussion_views_path
  end
end
