require 'test_helper'

class ProfileViewsControllerTest < ActionController::TestCase
  setup do
    @profile_view = profile_views(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profile_views)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile_view" do
    assert_difference('ProfileView.count') do
      post :create, profile_view: { member_id: @profile_view.member_id, member_id: @profile_view.member_id, tally: @profile_view.tally }
    end

    assert_redirected_to profile_view_path(assigns(:profile_view))
  end

  test "should show profile_view" do
    get :show, id: @profile_view
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile_view
    assert_response :success
  end

  test "should update profile_view" do
    patch :update, id: @profile_view, profile_view: { member_id: @profile_view.member_id, member_id: @profile_view.member_id, tally: @profile_view.tally }
    assert_redirected_to profile_view_path(assigns(:profile_view))
  end

  test "should destroy profile_view" do
    assert_difference('ProfileView.count', -1) do
      delete :destroy, id: @profile_view
    end

    assert_redirected_to profile_views_path
  end
end
