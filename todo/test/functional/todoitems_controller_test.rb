require 'test_helper'

class TodoitemsControllerTest < ActionController::TestCase
  setup do
    @todoitem = todoitems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:todoitems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create todoitem" do
    assert_difference('Todoitem.count') do
      post :create, todoitem: @todoitem.attributes
    end

    assert_redirected_to todoitem_path(assigns(:todoitem))
  end

  test "should show todoitem" do
    get :show, id: @todoitem.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @todoitem.to_param
    assert_response :success
  end

  test "should update todoitem" do
    put :update, id: @todoitem.to_param, todoitem: @todoitem.attributes
    assert_redirected_to todoitem_path(assigns(:todoitem))
  end

  test "should destroy todoitem" do
    assert_difference('Todoitem.count', -1) do
      delete :destroy, id: @todoitem.to_param
    end

    assert_redirected_to todoitems_path
  end
end
