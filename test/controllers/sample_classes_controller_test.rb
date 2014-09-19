require 'test_helper'

class SampleClassesControllerTest < ActionController::TestCase
  setup do
    @sample_class = sample_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sample_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sample_class" do
    assert_difference('SampleClass.count') do
      post :create, sample_class: { description: @sample_class.description, number_of_bloits: @sample_class.number_of_bloits }
    end

    assert_redirected_to sample_class_path(assigns(:sample_class))
  end

  test "should show sample_class" do
    get :show, id: @sample_class
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sample_class
    assert_response :success
  end

  test "should update sample_class" do
    patch :update, id: @sample_class, sample_class: { description: @sample_class.description, number_of_bloits: @sample_class.number_of_bloits }
    assert_redirected_to sample_class_path(assigns(:sample_class))
  end

  test "should destroy sample_class" do
    assert_difference('SampleClass.count', -1) do
      delete :destroy, id: @sample_class
    end

    assert_redirected_to sample_classes_path
  end
end
